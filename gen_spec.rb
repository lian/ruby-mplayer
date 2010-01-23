require 'yaml'

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
  #res.delete('gui_[about|loadfile|loadsubtitle|play|playlist|preferences|skinbrowser|stop]')

  # convert 'baz_[a|n]' into own keys and delete the multi_key..
  #res.keys.select{|i| i[0] == '[' }.each { |multi_key|
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

parse_mplayer_slave_txt.each do |k,v|
  #p '-----------', k

  fun_t = <<-CODE
%s
def %s %s
  %s
end

  CODE

  #p v[:args].join(' ')
  _args = []
  v[:args].join(' ').scan(/(\<(.+?)\>|\[(.+?)\])/).map{|i| i.last ? [0, i.last ] : [1, i[1]] }.each do |e|
    e[1] = 'n' if !(e[1].to_i == 0) # '-100 -100'.to_i == -100 => name variable '_n' instead
    _k = '_' + e[1].gsub(' ','_') # set argument name

    if e[0] == 0 # <bb> vs [bb] optional args
      _args << _k + '=0'
    else
      _args << _k
    end
  end

  desc = v[:desc].split("\n").map{|i| "# #{i}" }.join("\n")
  args = _args.join ', '
  body = 'send_data(\'%s\')' % [ k ]

  print code = fun_t % [ desc, k, args, body ]
end

