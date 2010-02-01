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


#MPLAYER_INIT_CMD = '/usr/bin/mplayer -ao alsa -nolirc -noconsolecontrols -slave -idle'
MPLAYER_INIT_CMD = '/usr/bin/mplayer -ao sdl -nolirc -noconsolecontrols -slave -idle'
require 'mplayer_commands_module.rb'

class MPlayer < Term
  attr_accessor :buffer, :player
  def initialize(session_id = Process.pid)
    super(session_id, MPLAYER_INIT_CMD)
    @buffer ||= []
    @cb_cmd = nil
    @player = PlayerMethods.new self
  end

  def pause; @player.pause; end
  def volume(level); @player.volume(level,1); end

  def quit
    @pty_queue << "quit\n";sleep 1; destroy
  end

  def read;buf = @buffer.dup; @buffer = []; buf;end

  # silly
  def handle_cb_cmd
    _cmd = @cb_cmd
    while @buffer.empty?
      # escape wait when cb_cmd changes
      if _cmd != @cb_cmd
        _cmd = @cb_cmd; @buffer << ''
      end
      sleep 0.5  # :.(
      # if each caller passes his callback
      # and end_string or line_size,
      # this method can finally be removed
    end

    cmd, *buf = @buffer.dup; @buffer = []

    (cmd == _cmd) ? buf : handle_cb_cmd
  end

  def send_cmd(cmd_stdin, _nodefer=true)
    @pty_queue << cmd_stdin + "\n"
    @cb_cmd = cmd_stdin
    _nodefer ? handle_cb_cmd : @pty_queue
  end

  STA_LINE = 'A:'
  STA_RETURN = "\r\n"
  STA_CR_LINE = "\e[J\r"
  # [mp3 @ 0xa160d70]overread, skip -4 enddists: -3 -3
  STA_EMP3 = "[m"

  def handle_position_state(line) # or skip.
    # "A:   0.0 (00.0) of 1.0 (01.0) ??,?% \e[J\rA:   0.1 (00.0) of 1.0 (01.0) ??,?% \e[J\r"
    #puts 'position_state input: %s' % [line.inspect]
  end

  def on_chunk(chunk)
    #p '------------', chunk

    chunk.split(STA_RETURN).each do |c|
      case c[0..1]
      when STA_LINE
        c.split(STA_CR_LINE).each { |cc|
          if cc[0..1] == STA_LINE
            #handle_position_state cc
            # skip A: stdout
          else
            @buffer << cc
          end
        }
      when STA_EMP3
        # skip [mp3.. stdout
      else
        @buffer << c
      end
    end
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


__END__
require 'bacon'
Bacon.summary_on_exit

describe 'MPlayer Pty' do
  @mp = MPlayer.new

  def wait(n=1,s=0.5);n.times{sleep s};end; wait;wait

  it 'should start' do
    @mp.buffer.should != []
    build_info, codec_info = @mp.read

    build_info.should.match /MPlayer (.+?) (.+?) MPlayer Team/
    codec_info.should.match /(.+?) audio & (.+?) video codecs/
  end

  it 'get_time_pos' do
    @mp.player.get_time_pos.should == []
  end

  it 'sets loop' do
    @mp.player.loop(2, 0).should == []
    @mp.player.loop(4, 1).should == []
  end

  it 'get_sub_visibility' do
    @mp.player.get_sub_visibility.should == []
  end

  it 'sets frame_drop' do
    @mp.player.frame_drop(0).should == []
    @mp.player.frame_drop.should == []
    @mp.buffer.size.should == 0
  end

  it 'should load files' do
    res = @mp.player.loadfile("test.mp3", 0)
    res.should == [
      "",
      "Playing test.mp3.",
      "Audio only file format detected.",
      "Clip info:",
      " Title: awwcrap",
      " Artist: ",
      " Album: ",
      " Year: ",
      " Comment: ",
      " Genre: Blues",
      "==========================================================================",
      "Opening audio decoder: [ffmpeg] FFmpeg/libavcodec audio decoders",
      "AUDIO: 44100 Hz, 1 ch, s16le, 64.0 kbit/9.07% (ratio: 8000->88200)",
      "Selected audio codec: [ffmp3] afm: ffmpeg (FFmpeg MPEG layer-3 audio)",
      "==========================================================================",
      "AO: [alsa] 48000Hz 1ch s16le (2 bytes per sample)", "Video: no video", "Starting playback..."
      #"AO: [oss] 44100Hz 1ch s16le (2 bytes per sample)", "Video: no video", "Starting playback..."
    ]
  end

  it 'sets loop' do
    @mp.player.loop(3).should == ["\e[A\r\e[KLoop: 2"]
  end

  it 'get_time_pos' do
    @mp.player.get_time_pos.first.should.match /ANS_TIME_POSITION\=(.+?)/
  end

  it 'pause' do
    @mp.player.pause.should == ["\e[A\r\e[K  =====  PAUSE  ====="]
  end

  it 'resume' do
    @mp.player.pause.should == ["\e[A\r\e[K"]
  end


  sleep 2

  it 'should exit' do
    @mp.player.quit.should == ['', 'Exiting... (Quit)']
  end

  @mp.destroy
end

