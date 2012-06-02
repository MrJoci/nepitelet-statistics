fooldal = "fooldal.html"

def self.wget(link, filename)
  `wget #{link} -O #{filename}`
end


wget("http://nepitelet.hu/autok/", fooldal)
fooldal_sorai = File.readlines(fooldal)
marka_linkek = {}
threads = []

found_lista = false

for row  in fooldal_sorai
  found_lista = true if /table class="markalista"/.match row
  next unless found_lista
  marka_linkek[$1]=$2 if /href="(http:\/\/nepitelet.hu\/autok\/(\w+)\/)"/.match row
  break if /\/table/.match row
end

for link, marka in marka_linkek
  threads << Thread.new {
    wget(link, "#{marka}.html")
  }
end

threads.each {|t| t.join}