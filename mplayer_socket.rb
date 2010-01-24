require 'thread'
require 'pty'

class Term
  Sessions = []
  attr_accessor :pty_queue, :thread
  def initialize(session_id = Process.pid, init_cmd=nil)
    @shell = init_cmd || ENV['SHELL'] || 'bash'
    @session_id = session_id; Sessions << self
    pty
  end

  def <<(stdin)
    @pty_queue << stdin
  end

  def bench(name, &block)
    require 'benchmark'
    p name => Benchmark.realtime(&block)
  end

  def destroy
    Process.kill(@term_pid) unless @term_pid == 0
    @thread.kill
  rescue Errno::EIO, PTY::ChildExited
  ensure
  end

  def pty
    @pty_queue = queue = Queue.new
    @term_pid  = _pid  = 0

    @thread = Thread.new do
      PTY.spawn(@shell) do |r_pty, w_pty, pid| _pid = pid
        Thread.new do
          while chunk = queue.shift
            w_pty.print chunk
            w_pty.flush
          end
        end

        begin
          loop do
            c = r_pty.sysread(1 << 15)
            on_chunk(c) if c
          end
        rescue Errno::EIO, PTY::ChildExited
          destroy
        end
      end
    end
  rescue Errno::EIO, PTY::ChildExited
    destroy
  end

  def on_chunk(chunk)
   p chunk
  rescue StringScanner::Error => ex
    puts "#{ex.class}: #{ex}", *ex.backtrace
  rescue => ex
    puts "#{ex.class}: #{ex}", *ex.backtrace
    @buffer = ''
    destroy
  end
end


MPLAYER_INIT_CMD = '/usr/bin/mplayer -nolirc -noconsolecontrols -slave -idle'
require 'mplayer_commands_module.rb'

class MPlayer < Term
  attr_accessor :buffer, :player
  def initialize(session_id = Process.pid)
    super(session_id, MPLAYER_INIT_CMD)
    @buffer ||= []
    @rx_bytes = 0
    @player = PlayerMethods.new self
  end

  def pop
    @buffer.shift
  end

  # TODO: use EM's buffer helper, make custom?
  def read
    buf = @buffer.join; @buffer = []
    @rx_bytes += buf.size

    buf.split("\r\n")
  end

  def send_cmd(cmd_stdin)
    @pty_queue << cmd_stdin + "\n"
  end

  def on_chunk(chunk)
    @buffer << chunk
    #p '------------', chunk
  rescue StringScanner::Error => ex
    #VER.error(ex)
  rescue => ex
    puts "#{ex.class}: #{ex}", *ex.backtrace
    @buffer = ''
    destroy
  end

  class PlayerMethods
    include MPlayerCommands
    def initialize(parent)@scope = parent;end
    def send_cmd(str);@scope.send_cmd(str);end
  end
end



require 'bacon'
Bacon.summary_on_exit

describe 'MPlayer Pty' do
  @mp = MPlayer.new
  #after { @mp.destroy }
  def wait(n=1)
    n.times { sleep 0.5 }
  end

  wait;wait

  it 'should start' do
    @mp.buffer.should != []
    build_info, codec_info = @mp.read

    build_info.should.match /MPlayer (.+?) (.+?) MPlayer Team/
    codec_info.should.match /(.+?) audio & (.+?) video codecs/
    @mp.buffer.size.should == 0
  end

  it 'get_time_pos' do
    @mp.player.get_time_pos;  wait 1

    res = @mp.read
    res.should == ["get_time_pos" ]
    @mp.buffer.size.should == 0
  end

  it 'sets loop' do
    @mp.player.loop(2, 0);  wait 1
    @mp.read.should == ["loop 2 0" ]

    @mp.player.loop(4, 1);  wait 1
    @mp.read.should == ["loop 4 1" ]

    @mp.buffer.size.should == 0
  end

  it 'get_sub_visibility' do
    @mp.player.get_sub_visibility;  wait 1
    @mp.read.should == [ 'get_sub_visibility' ]
  end

  it 'sets frame_drop' do
    @mp.player.frame_drop(0);  wait 1
    @mp.read.should == [ 'frame_drop 0' ]

    @mp.player.frame_drop;  wait 1
    @mp.read.should == [ 'frame_drop 0' ]

    @mp.buffer.size.should == 0
  end

=begin
  it 'should load files' do
    @mp << "loadfile test.mp3 0\n";  wait 1
    p @mp.buffer

    @mp.pop.should == "loadfile test.mp3 0\r\n"
    @mp.pop.should == "\r\nPlaying test.mp3.\r\n"
    @mp.pop.should == "Audio only file format detected.\r\nClip info:\r\n Title: awwcrap\r\n Artist: \r\n Album: \r\n Year: \r\n Comment: \r\n Genre: Blues\r\n==========================================================================\r\nOpening audio decoder: [ffmpeg] FFmpeg/libavcodec audio decoders\r\n"

    @mp.buffer.size.should != 0
  end

  it 'get_time_pos' do
    @mp.buffer.clear
    @mp << "get_time_pos\n";  wait 1

    #p @mp.buffer
    @mp.pop.should == "get_time_pos\r\n"
    @mp.pop.should.match(/ANS_TIME_POSITION\=(.+?)\r\n/)
    #@mp.buffer.size.should == 0
  end
=end

  sleep 1

  it 'should exit' do
    @mp.player.quit   ; wait 1

    res = @mp.read
    res.should == ["quit 0", "", "Exiting... (Quit)"]

    ['quit 0', 'Exiting... (Quit)'].each do |out|
      res.should.include? out
    end

    @mp.buffer.size.should == 0
  end

  @mp.destroy
end

