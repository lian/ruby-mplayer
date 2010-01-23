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

class MPlayer < Term
  attr_accessor :buffer
  def initialize(session_id = Process.pid)
    super(session_id, MPLAYER_INIT_CMD)
    @buffer ||= []
  end

  def pop
    @buffer.shift
  end

  def on_chunk(chunk)
    @buffer << chunk
    #s = StringScanner.new(@buffer)
    #p '-------------------------------------------------'
    #p chunk
    #@buffer = ''
  rescue StringScanner::Error => ex
    #VER.error(ex)
  rescue => ex
    puts "#{ex.class}: #{ex}", *ex.backtrace
    @buffer = ''
    destroy
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
    @mp.buffer.size.should == 2

    @mp.pop.should.match /MPlayer (.+?) (.+?) MPlayer Team\r\n/
    @mp.pop.should.match /(.+?) audio & (.+?) video codecs\r\n/
    @mp.buffer.size.should == 0
  end

  it 'get_time_pos' do
    @mp << "get_time_pos\n";  wait 1
    @mp.buffer.pop.should == "get_time_pos\r\n"
    @mp.buffer.size.should == 0
  end

  it 'sets loop' do
    @mp << "loop 2\n";  wait 1
    @mp.buffer.pop.should == "loop 2\r\n"
    @mp.buffer.size.should == 0
  end

  it 'get_sub_visibility' do
    @mp << "get_sub_visibility\n";  wait 1
    @mp.buffer.pop.should == "get_sub_visibility\r\n"
    @mp.buffer.pop.should == nil  # !? should return 1 or 0
  end

  it 'sets/toggle framedrop' do
    @mp << "framedrop 0\n";  wait 1
    @mp.buffer.pop.should == "framedrop 0\r\n"

    @mp << "framedrop\n";  wait 1
    @mp.buffer.pop.should == "framedrop\r\n"

    @mp.buffer.size.should == 0
  end



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

  sleep 2

  it 'should exit' do
    @mp << "quit\n";  wait 1

    out = @mp.buffer[@mp.buffer.size-3..-1].join # last 2 lines (ugly)
    out.should.match /Exiting/
    out.should.match /quit/
    #@mp.buffer.size.should == 0
  end

  @mp.destroy
end

