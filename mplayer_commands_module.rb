module MPlayerCommands
 ##
 # the file was generated at: 2010-01-24 02:37:20 +0100
 # translation script author: Julian Langschaedel <meta.rb@gmail.com>
 # source docs: http://www.mplayerhq.hu/DOCS/tech/slave.txt
 ##

  # Set/adjust the audio delay.
  # If [abs] is not given or is zero, adjust the delay by <value> seconds.
  # If [abs] is nonzero, set the delay to <value> seconds.
  def audio_delay _value, _abs=0
    send_cmd("audio_delay #{_value} #{_abs}")
  end

  # Change the position of the rectangle filter rectangle.
  #     <val1>
  #         Must be one of the following:
  #             0 = width
  #             1 = height
  #             2 = x position
  #             3 = y position
  #     <val2>
  #         If <val1> is 0 or 1:
  #             Integer amount to add/subtract from the width/height.
  #             Positive values add to width/height and negative values
  #             subtract from it.
  #         If <val1> is 2 or 3:
  #             Relative integer amount by which to move the upper left
  #             rectangle corner. Positive values move the rectangle
  #             right/down and negative values move the rectangle left/up.
  def change_rectangle _val1, _val2
    send_cmd("change_rectangle #{_val1} #{_val2}")
  end

  # Set DVB channel.
  def dvb_set_channel _channel_number, _card_number
    send_cmd("dvb_set_channel #{_channel_number} #{_card_number}")
  end

  # Press the given dvdnav button.
  #     up
  #     down
  #     left
  #     right
  #     menu
  #     select
  #     prev
  #     mouse
  def dvdnav _button_name
    send_cmd("dvdnav #{_button_name}")
  end

  # Write the current position into the EDL file.
  def edl_mark 
    send_cmd("edl_mark")
  end

  # Toggle/set frame dropping mode.
  def frame_drop _value=0
    send_cmd("frame_drop #{_value}")
  end

  # Print out the audio bitrate of the current file.
  def get_audio_bitrate 
    send_cmd("get_audio_bitrate")
  end

  # Print out the audio codec name of the current file.
  def get_audio_codec 
    send_cmd("get_audio_codec")
  end

  # Print out the audio frequency and number of channels of the current file.
  def get_audio_samples 
    send_cmd("get_audio_samples")
  end

  # Print out the name of the current file.
  def get_file_name 
    send_cmd("get_file_name")
  end

  # Print out the 'Album' metadata of the current file.
  def get_meta_album 
    send_cmd("get_meta_album")
  end

  # Print out the 'Artist' metadata of the current file.
  def get_meta_artist 
    send_cmd("get_meta_artist")
  end

  # Print out the 'Comment' metadata of the current file.
  def get_meta_comment 
    send_cmd("get_meta_comment")
  end

  # Print out the 'Genre' metadata of the current file.
  def get_meta_genre 
    send_cmd("get_meta_genre")
  end

  # Print out the 'Title' metadata of the current file.
  def get_meta_title 
    send_cmd("get_meta_title")
  end

  # Print out the 'Track Number' metadata of the current file.
  def get_meta_track 
    send_cmd("get_meta_track")
  end

  # Print out the 'Year' metadata of the current file.
  def get_meta_year 
    send_cmd("get_meta_year")
  end

  # Print out the current position in the file, as integer percentage [0-100).
  def get_percent_pos 
    send_cmd("get_percent_pos")
  end

  # Print out the current value of a property.
  def get_property _property
    send_cmd("get_property #{_property}")
  end

  # Print out subtitle visibility (1 == on, 0 == off).
  def get_sub_visibility 
    send_cmd("get_sub_visibility")
  end

  # Print out the length of the current file in seconds.
  def get_time_length 
    send_cmd("get_time_length")
  end

  # Print out the current position in the file in seconds, as float.
  def get_time_pos 
    send_cmd("get_time_pos")
  end

  # Print out fullscreen status (1 == fullscreened, 0 == windowed).
  def get_vo_fullscreen 
    send_cmd("get_vo_fullscreen")
  end

  # Print out the video bitrate of the current file.
  def get_video_bitrate 
    send_cmd("get_video_bitrate")
  end

  # Print out the video codec name of the current file.
  def get_video_codec 
    send_cmd("get_video_codec")
  end

  # Print out the video resolution of the current file.
  def get_video_resolution 
    send_cmd("get_video_resolution")
  end

  # Take a screenshot. Requires the screenshot filter to be loaded.
  #     0 Take a single screenshot.
  #     1 Start/stop taking screenshot of each frame.
  def screenshot _value
    send_cmd("screenshot #{_value}")
  end

  # Inject <value> key code event into MPlayer.
  def key_down_event _value
    send_cmd("key_down_event #{_value}")
  end

  # Load the given file/URL, stopping playback of the current file/URL.
  # If <append> is nonzero playback continues and the file/URL is
  # appended to the current playlist instead.
  def loadfile _file_url, _append
    send_cmd("loadfile #{_file_url} #{_append}")
  end

  # Load the given playlist file, stopping playback of the current file.
  # If <append> is nonzero playback continues and the playlist file is
  # appended to the current playlist instead.
  def loadlist _file, _append
    send_cmd("loadlist #{_file} #{_append}")
  end

  # Adjust/set how many times the movie should be looped. -1 means no loop,
  # and 0 forever.
  def loop _value, _abs=0
    send_cmd("loop #{_value} #{_abs}")
  end

  # Execute an OSD menu command.
  #     up     Move cursor up.
  #     down   Move cursor down.
  #     ok     Accept selection.
  #     cancel Cancel selection.
  #     hide   Hide the OSD menu.
  def menu _command
    send_cmd("menu #{_command}")
  end

  # Display the menu named <menu_name>.
  def set_menu _menu_name
    send_cmd("set_menu #{_menu_name}")
  end

  # Toggle sound output muting or set it to [value] when [value] >= 0
  # (1 == on, 0 == off).
  def mute _value=0
    send_cmd("mute #{_value}")
  end

  # Toggle OSD mode or set it to [level] when [level] >= 0.
  def osd _level=0
    send_cmd("osd #{_level}")
  end

  # Show an expanded property string on the OSD, see -playing-msg for a
  # description of the available expansions. If [duration] is >= 0 the text
  # is shown for [duration] ms. [level] sets the minimum OSD level needed
  # for the message to be visible (default: 0 - always show).
  def osd_show_property_text _string, _duration=0, _level=0
    send_cmd("osd_show_property_text #{_string} #{_duration} #{_level}")
  end

  # Show <string> on the OSD.
  def osd_show_text _string, _duration=0, _level=0
    send_cmd("osd_show_text #{_string} #{_duration} #{_level}")
  end

  # Pause/unpause the playback.
  def pause 
    send_cmd("pause")
  end

  # Play one frame, then pause again.
  def frame_step 
    send_cmd("frame_step")
  end

  # Go to the next/previous entry in the playtree. The sign of <value> tells
  # the direction.  If no entry is available in the given direction it will do
  # nothing unless [force] is non-zero.
  def pt_step _value, _force=0
    send_cmd("pt_step #{_value} #{_force}")
  end

  # Similar to pt_step but jumps to the next/previous entry in the parent list.
  # Useful to break out of the inner loop in the playtree.
  def pt_up_step _value, _force=0
    send_cmd("pt_up_step #{_value} #{_force}")
  end

  # Quit MPlayer. The optional integer [value] is used as the return code
  # for the mplayer process (default: 0).
  def quit _value=0
    send_cmd("quit #{_value}")
  end

  # Switch to <channel>. The 'channels' radio parameter needs to be set.
  def radio_set_channel _channel
    send_cmd("radio_set_channel #{_channel}")
  end

  # Set the radio tuner frequency.
  def radio_set_freq _frequency_in_MHz
    send_cmd("radio_set_freq #{_frequency_in_MHz}")
  end

  # Step forwards (1) or backwards (-1) in channel list. Works only when the
  # 'channels' radio parameter was set.
  def radio_step_channel _n
    send_cmd("radio_step_channel #{_n}")
  end

  # Tune frequency by the <value> (positive - up, negative - down).
  def radio_step_freq _value
    send_cmd("radio_step_freq #{_value}")
  end

  # Seek to some place in the movie.
  #     0 is a relative seek of +/- <value> seconds (default).
  #     1 is a seek to <value> % in the movie.
  #     2 is a seek to an absolute position of <value> seconds.
  def seek _value, _type=0
    send_cmd("seek #{_value} #{_type}")
  end

  # Seek to the start of a chapter.
  #     0 is a relative seek of +/- <value> chapters (default).
  #     1 is a seek to chapter <value>.
  def seek_chapter _value, _type=0
    send_cmd("seek_chapter #{_value} #{_type}")
  end

  # Switch to the DVD angle with the ID [value]. Cycle through the
  # available angles if [value] is omitted or negative.
  def switch_angle _value=0
    send_cmd("switch_angle #{_value}")
  end

  # Tells MPlayer the coordinates of the mouse in the window.
  # This command doesn't move the mouse!
  def set_mouse_pos _x, _y
    send_cmd("set_mouse_pos #{_x} #{_y}")
  end

  # Set a property.
  def set_property _property, _value
    send_cmd("set_property #{_property} #{_value}")
  end

  # Add <value> to the current playback speed.
  def speed_incr _value
    send_cmd("speed_incr #{_value}")
  end

  # Multiply the current speed by <value>.
  def speed_mult _value
    send_cmd("speed_mult #{_value}")
  end

  # Set the speed to <value>.
  def speed_set _value
    send_cmd("speed_set #{_value}")
  end

  # Change a property by value, or increase by a default if value is
  # not given or zero. The direction is reversed if direction is less
  # than zero.
  def step_property _property, _value=0, _direction=0
    send_cmd("step_property #{_property} #{_value} #{_direction}")
  end

  # Stop playback.
  def stop 
    send_cmd("stop")
  end

  # Toggle/set subtitle alignment.
  #     0 top alignment
  #     1 center alignment
  #     2 bottom alignment
  def sub_alignment _value=0
    send_cmd("sub_alignment #{_value}")
  end

  # Adjust the subtitle delay by +/- <value> seconds or set it to <value>
  # seconds when [abs] is nonzero.
  def sub_delay _value, _abs=0
    send_cmd("sub_delay #{_value} #{_abs}")
  end

  # Loads subtitles from <subtitle_file>.
  def sub_load _subtitle_file
    send_cmd("sub_load #{_subtitle_file}")
  end

  # Logs the current or last displayed subtitle together with filename
  # and time information to ~/.mplayer/subtitle_log. Intended purpose
  # is to allow convenient marking of bogus subtitles which need to be
  # fixed while watching the movie.
  def sub_log 
    send_cmd("sub_log")
  end

  # Adjust/set subtitle position.
  def sub_pos _value, _abs=0
    send_cmd("sub_pos #{_value} #{_abs}")
  end

  # If the [value] argument is present and non-negative, removes the subtitle
  # file with index [value]. If the argument is omitted or negative, removes
  # all subtitle files.
  def sub_remove _value=0
    send_cmd("sub_remove #{_value}")
  end

  # Display subtitle with index [value]. Turn subtitle display off if
  # [value] is -1 or greater than the highest available subtitle index.
  # Cycle through the available subtitles if [value] is omitted or less
  # than -1. Supported subtitle sources are -sub options on the command
  # line, VOBsubs, DVD subtitles, and Ogg and Matroska text streams.
  # This command is mainly for cycling all subtitles, if you want to set
  # a specific subtitle, use sub_file, sub_vob, or sub_demux.
  def sub_select _value=0
    send_cmd("sub_select #{_value}")
  end

  # Display first subtitle from [source]. Here [source] is an integer:
  # SUB_SOURCE_SUBS   (0) for file subs
  # SUB_SOURCE_VOBSUB (1) for VOBsub files
  # SUB_SOURCE_DEMUX  (2) for subtitle embedded in the media file or DVD subs.
  # If [source] is -1, will turn off subtitle display. If [source] less than -1,
  # will cycle between the first subtitle of each currently available sources.
  def sub_source _source=0
    send_cmd("sub_source #{_source}")
  end

  # Display subtitle specifid by [value] for file subs. The [value] is
  # corresponding to ID_FILE_SUB_ID values reported by '-identify'.
  # If [value] is -1, will turn off subtitle display. If [value] less than -1,
  # will cycle all file subs.
  def sub_file _value=0
    send_cmd("sub_file #{_value}")
  end

  # Display subtitle specifid by [value] for vobsubs. The [value] is
  # corresponding to ID_VOBSUB_ID values reported by '-identify'.
  # If [value] is -1, will turn off subtitle display. If [value] less than -1,
  # will cycle all vobsubs.
  def sub_vob _value=0
    send_cmd("sub_vob #{_value}")
  end

  # Display subtitle specifid by [value] for subtitles from DVD or embedded
  # in media file. The [value] is corresponding to ID_SUBTITLE_ID values
  # reported by '-identify'. If [value] is -1, will turn off subtitle display.
  # If [value] less than -1, will cycle all DVD subs or embedded subs.
  def sub_demux _value=0
    send_cmd("sub_demux #{_value}")
  end

  # Adjust the subtitle size by +/- <value> or set it to <value> when [abs]
  # is nonzero.
  def sub_scale _value, _abs=0
    send_cmd("sub_scale #{_value} #{_abs}")
  end

  # This is a stub linked to sub_select for backwards compatibility.
  def vobsub_lang 
    send_cmd("vobsub_lang")
  end

  # Step forward in the subtitle list by <value> steps or backwards if <value>
  # is negative.
  def sub_step _value
    send_cmd("sub_step #{_value}")
  end

  # Toggle/set subtitle visibility.
  def sub_visibility _value=0
    send_cmd("sub_visibility #{_value}")
  end

  # Toggle/set forced subtitles only.
  def forced_subs_only _value=0
    send_cmd("forced_subs_only #{_value}")
  end

  # Switch to the audio track with the ID [value]. Cycle through the
  # available tracks if [value] is omitted or negative.
  def switch_audio _value=0
    send_cmd("switch_audio #{_value}")
  end

  # Change aspect ratio at runtime. [value] is the new aspect ratio expressed
  # as a float (e.g. 1.77778 for 16/9).
  # There might be problems with some video filters.
  def switch_ratio _value=0
    send_cmd("switch_ratio #{_value}")
  end

  # Switch to the DVD title with the ID [value]. Cycle through the
  # available titles if [value] is omitted or negative.
  def switch_title _value=0
    send_cmd("switch_title #{_value}")
  end

  # Toggle vsync (1 == on, 0 == off). If [value] is not provided,
  # vsync status is inverted.
  def switch_vsync _value=0
    send_cmd("switch_vsync #{_value}")
  end

  # Enter/leave teletext page number editing mode and append given digit to
  # previously entered one.
  # 0..9 - Append apropriate digit. (Enables editing mode if called from normal
  #        mode, and switches to normal mode when third digit is entered.)
  # -    - Delete last digit from page number. (Backspace emulation, works only
  #        in page number editing mode.)
  def teletext_add_digit _value
    send_cmd("teletext_add_digit #{_value}")
  end

  # Follow given link on current teletext page.
  def teletext_go_link _n
    send_cmd("teletext_go_link #{_n}")
  end

  # Start automatic TV channel scanning.
  def tv_start_scan 
    send_cmd("tv_start_scan")
  end

  # Select next/previous TV channel.
  def tv_step_channel _channel
    send_cmd("tv_step_channel #{_channel}")
  end

  # Change TV norm.
  def tv_step_norm 
    send_cmd("tv_step_norm")
  end

  # Change channel list.
  def tv_step_chanlist 
    send_cmd("tv_step_chanlist")
  end

  # Set the current TV channel.
  def tv_set_channel _channel
    send_cmd("tv_set_channel #{_channel}")
  end

  # Set the current TV channel to the last one.
  def tv_last_channel 
    send_cmd("tv_last_channel")
  end

  # Set the TV tuner frequency.
  def tv_set_freq _frequency_in_MHz
    send_cmd("tv_set_freq #{_frequency_in_MHz}")
  end

  # Set the TV tuner frequency relative to current value.
  def tv_step_freq _frequency_offset_in_MHz
    send_cmd("tv_step_freq #{_frequency_offset_in_MHz}")
  end

  # Set the TV tuner norm (PAL, SECAM, NTSC, ...).
  def tv_set_norm _norm
    send_cmd("tv_set_norm #{_norm}")
  end

  # Set TV tuner brightness or adjust it if [abs] is set to 0.
  def tv_set_brightness _n, _abs=0
    send_cmd("tv_set_brightness #{_n} #{_abs}")
  end

  # Set TV tuner contrast or adjust it if [abs] is set to 0.
  def tv_set_contrast _n, _abs=0
    send_cmd("tv_set_contrast #{_n} #{_abs}")
  end

  # Set TV tuner hue or adjust it if [abs] is set to 0.
  def tv_set_hue _n, _abs=0
    send_cmd("tv_set_hue #{_n} #{_abs}")
  end

  # Set TV tuner saturation or adjust it if [abs] is set to 0.
  def tv_set_saturation _n, _abs=0
    send_cmd("tv_set_saturation #{_n} #{_abs}")
  end

  # Switch volume control between master and PCM.
  def use_master 
    send_cmd("use_master")
  end

  # Toggle/set borderless display.
  def vo_border _value=0
    send_cmd("vo_border #{_value}")
  end

  # Toggle/set fullscreen mode.
  def vo_fullscreen _value=0
    send_cmd("vo_fullscreen #{_value}")
  end

  # Toggle/set stay-on-top.
  def vo_ontop _value=0
    send_cmd("vo_ontop #{_value}")
  end

  # Toggle/set playback on the root window.
  def vo_rootwin _value=0
    send_cmd("vo_rootwin #{_value}")
  end

  # Increase/decrease volume or set it to <value> if [abs] is nonzero.
  def volume _value, _abs=0
    send_cmd("volume #{_value} #{_abs}")
  end

  # Set/adjust video parameters.
  # If [abs] is not given or is zero, modifies parameter by <value>.
  # If [abs] is non-zero, parameter is set to <value>.
  # <value> is in the range [-100, 100].
  def brightness _value, _abs=0
    send_cmd("brightness #{_value} #{_abs}")
  end

  # Set/adjust video parameters.
  # If [abs] is not given or is zero, modifies parameter by <value>.
  # If [abs] is non-zero, parameter is set to <value>.
  # <value> is in the range [-100, 100].
  def contrast _value, _abs=0
    send_cmd("contrast #{_value} #{_abs}")
  end

  # Set/adjust video parameters.
  # If [abs] is not given or is zero, modifies parameter by <value>.
  # If [abs] is non-zero, parameter is set to <value>.
  # <value> is in the range [-100, 100].
  def gamma _value, _abs=0
    send_cmd("gamma #{_value} #{_abs}")
  end

  # Set/adjust video parameters.
  # If [abs] is not given or is zero, modifies parameter by <value>.
  # If [abs] is non-zero, parameter is set to <value>.
  # <value> is in the range [-100, 100].
  def hue _value, _abs=0
    send_cmd("hue #{_value} #{_abs}")
  end

  # Set/adjust video parameters.
  # If [abs] is not given or is zero, modifies parameter by <value>.
  # If [abs] is non-zero, parameter is set to <value>.
  # <value> is in the range [-100, 100].
  def saturation _value, _abs=0
    send_cmd("saturation #{_value} #{_abs}")
  end

  # GUI actions
  def gui_about 
    send_cmd("gui_about")
  end

  # GUI actions
  def gui_loadfile 
    send_cmd("gui_loadfile")
  end

  # GUI actions
  def gui_loadsubtitle 
    send_cmd("gui_loadsubtitle")
  end

  # GUI actions
  def gui_play 
    send_cmd("gui_play")
  end

  # GUI actions
  def gui_playlist 
    send_cmd("gui_playlist")
  end

  # GUI actions
  def gui_preferences 
    send_cmd("gui_preferences")
  end

  # GUI actions
  def gui_skinbrowser 
    send_cmd("gui_skinbrowser")
  end

  # GUI actions
  def gui_stop 
    send_cmd("gui_stop")
  end

end
