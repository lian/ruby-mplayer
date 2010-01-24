def parse_mplayer_slave_txt
  file, url = 'slave.txt', 'http://www.mplayerhq.hu/DOCS/tech/slave.txt'
  system('wget -O %s "%s"' % [file, url]) unless File.exists? file 

  doc = File.read('slave.txt').split("\n")[51..455]  # L472
  res, key = {}, nil

  #doc[0..5].each_with_index do |l,idx|
  doc.each_with_index do |l,idx|
    if l[0] == ' '
      if res[key]
        #res[key][:desc] << l.strip << "\n"
        #res[key][:desc] << l << "\n"
        res[key][:desc] << l[4..-1] << "\n"
      else
        raise key + ' not found! cant append desc!'
      end
    else
      key, *rest = l.split ' '
      res[key] = { args: rest, desc: '' }
    end
  end
  res.delete nil
  res.delete('panscan') # fix " 0.0 - 1.0".to_i issue later..

  # convert 'baz_[a|n]' into own keys and delete the multi_key..
  res.keys.select{|i| i[-1] == ']' }.each { |multi_key|
    i = multi_key.split("[")
    other_keys =  i.last[0...-1].split("|").map{|e| i[0].to_s + e if e != i[0] }
    other_keys.each { |_nk|
      res[_nk] = res[multi_key].dup
    }
    res.delete multi_key
  }

  `mplayer -input cmdlist`.split("\n").map{|i|i.split' '}.each do |e|
    if res[e[0]]
      res[e[0]][:arg_types] = e[1..-1]
    end
  end

  res
end


def gen_mplayer_command_methods
  parse_mplayer_slave_txt.map do |k,v|
    #p '-----------', k

    fun_t = <<-CODE
%s
  def %s %s
    %s
  end
    CODE

    #p v[:args].join(' ')
    _args = []
    _akeys = v[:args].join(' ').scan(/(\<(.+?)\>|\[(.+?)\])/).map{|i| i.last ? [0, i.last ] : [1, i[1]] }.map do |e|
      e[1] = 'n' if !(e[1].to_i == 0) # '-100 -100'.to_i == -100 => name variable '_n' instead
      _k = '_' + e[1].gsub(/ |\|/,'_') # set argument name

      if e[0] == 0 # <bb> vs [bb] optional args
        _args << _k + '=0'
      else
        _args << _k
      end
      _k
    end

    desc = v[:desc].split("\n").map{|i| "  # #{i}" }.join("\n")
    args = _args.join ', '

    body = if (_akeys.size == 0)
      'send_cmd("%s")' % [k]
    else
      'send_cmd("%s %s")' % [k, _akeys.map{|v| '#{%s}' % [v.to_s] }.join(' ') ]
    end

    fun_t % [ desc, k, args, body ]
  end
end


def gen_mplayer_commands_module(write_to=nil)
  module_fun_t = <<-CODE
module MPlayerCommands
 ##
 # the file was generated at: #{Time.now.to_s}
 # translation script author: Julian Langschaedel <meta.rb@gmail.com>
 # source docs: http://www.mplayerhq.hu/DOCS/tech/slave.txt
 ##

%s
end
  CODE
  res = module_fun_t % [ gen_mplayer_command_methods.join("\n") ]

  if write_to && !File.exists?(write_to)
    File.open(write_to,'w'){|f| f.print res }
  else
    print res
  end

  res
end


gen_mplayer_commands_module('mplayer_commands_module.rb')

