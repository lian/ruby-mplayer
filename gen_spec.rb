require 'yaml'

def parse_mplayer_slave_txt
  file, url = 'slave.txt', 'http://www.mplayerhq.hu/DOCS/tech/slave.txt'
  system('wget -O %s "%s"' % [file, url]) unless File.exists? file 

  doc = File.read('slave.txt').split("\n")[51..455]  # L472
  res, key = {}, nil

  doc.each_with_index do |l,idx|
    if l[0] == ' '
      if res[key]
        res[key][:desc] << l.strip << "\n"
      else
        raise key + ' not found! cant append desc!'
      end
    else
      key, *rest = l.split ' '
      res[key] = { args: rest, desc: '' }
    end
  end
  res.delete('gui_[about|loadfile|loadsubtitle|play|playlist|preferences|skinbrowser|stop]')

  `mplayer -input cmdlist`.split("\n").map{|i|i.split' '}.each do |e|
    if res[e[0]]
      res[e[0]][:arg_types] = e[1..-1]
    end
  end

  res
end

print parse_mplayer_slave_txt.to_yaml

