class Things

  def self.wget(link, filename)
    `wget #{link} -O #{filename} -q`
  end  

  # Things.download_nepitelet
  def self.download_nepitelet(brands=false, types=false, verdicts=true)
    require 'open-uri'
    
    fooldal = "fooldal.html"
    threads = []

    if brands
      fooldal_sorai = open("http://www.nepitelet.hu/autok/").read.split("\n")
      Brand.delete_all

      found_lista = false
      for row  in fooldal_sorai
        found_lista = true if /table class="markalista"/.match row
        next unless found_lista
        Brand.create(:name => $2, :url => $1) if /href="(http:\/\/nepitelet.hu\/autok\/(\w+)\/)"/.match row
        break if /\/table/.match row
      end
    end  
    
    if types or brands
      Type.delete_all
      for brand in Brand.find(:all)
#        threads << Thread.new(brand_out.id, brand_out.url) {|brand_id, brand_url|
          regex = '[\w\W]'
          type_file = open(brand.url).read.split("\n")
          for row in type_file
            if /var tipus_list = /.match row
              cars = row.split('},{')
              for car in cars
                if /"tipusnev":"(#{regex}*)","path":"(#{regex}*)","vege":"(#{regex}*)","img":"(#{regex}*)"/.match car
                  Type.create(:brand_id => brand.id || 0, :name => $1, :url => 'http://nepitelet.hu/autok/'+$2.gsub(/\\/,''))
                end  
              end
              break
            end
          end      
#      }
      end

 #     threads.each {|t| t.join}    
    end
    
    threads = []
    if types or brands or verdicts
      Verdict.delete_all
      i=0
      for type in Type.find(:all)
        i+=1
        p type.name
#        threads << Thread.new(type_out) {|type|
          regex = '[\w\W]'
#Things.download_nepitelet
          type_file = open(type.url).read.split("\n")
          for row in type_file
            if /var nepiteletek = /.match row
              vers = row.split('},{')
              j=0
              for ver in vers
                j+=1
                if /"cim":"(#{regex}*),"tipus_id":(#{regex}*),"path":(#{regex}*),"rating":(#{regex}*),"date":(#{regex}*),"tipus":(#{regex}*),"modell":(#{regex}*),"km":(#{regex}*),"hossz":(#{regex}*),"jolmegirt":(#{regex}*),"kepes":(#{regex}*),"evjarat":(#{regex}*),"ertekeles":(#{regex}*),"ertek":(#{regex}*)/.match ver
                new_verdict = Verdict.new(:type_id => type.id, :name => $1[0..99])
                url = $3
                written_at= $5
                new_verdict.url = 'http://nepitelet.hu/autok/'+url.gsub(/[\\\"]/,'')
                new_verdict.written_at = written_at.gsub(/\./, '-')
                new_verdict.save
                new_verdict.reload

                full_verdict = open(new_verdict.url).read.split("\n")
                found_lista = false
                for fver in full_verdict
                  found_lista = true if /table id="verdikt"/.match fver
                  next unless found_lista
                  if /<td class="tul">Átlagfogyasztás/.match fver
                    if />([\d\.]+) l</.match full_verdict[full_verdict.index(fver)+1]
                      new_verdict.consuption = $1
                    end
                  end
                  break if /\/table/.match row
                end           
                
                new_verdict.save
                else
                  puts "not: " + ver
                end  
              end
              break
            end
          end
  #    }
      end

#      threads.each {|t| t.join}
            
    end
    
  end
  
  #Things.verdict_down
  def self.verdict_down
    require 'open-uri'

    
    threads = []
#      Verdict.delete_all
      i=0
      for type in Type.find(:all, :conditions=>"brand_id>977")
        i+=1
        puts type.brand_id.to_s + ' - ' + type.name
#        threads << Thread.new(type_out) {|type|
          regex = '[\w\W]'
          begin
            type_file = open(type.url).read.split("\n")
            for row in type_file
              if /var nepiteletek = /.match row
                vers = row.split('},{')
                j=0
                for ver in vers
                  j+=1
                  if /"cim":"(#{regex}*),"tipus_id":(#{regex}*),"path":(#{regex}*),"rating":(#{regex}*),"date":(#{regex}*),"tipus":(#{regex}*),"modell":(#{regex}*),"km":(#{regex}*),"hossz":(#{regex}*),"jolmegirt":(#{regex}*),"kepes":(#{regex}*),"evjarat":(#{regex}*),"ertekeles":(#{regex}*),"ertek":(#{regex}*)/.match ver
                  Verdict.create(:type_id => type.id, :name => $1[0..99], :url => 'http://nepitelet.hu/autok/'+$3.gsub(/[\\\"]/,''))


                  else
                    puts "not: " + ver
                  end  
                end
                break
              end
            end
          rescue Exception => e
            puts "error"
          end  
  #    }
      end

#      threads.each {|t| t.join}
            
    
    
  end
  
  #Things.verdict_update
  def self.verdict_update
    require 'open-uri'

    verdict_ids = Verdict.find(:all, :conditions => "engine is null").map{|ver| ver.id}
    arr = []
    for verdict_id in verdict_ids
      arr << Thread.new(verdict_id) {|verid|
         v_down(verid)
      }
      if verdict_id % 10 == 0
        arr.each {|t| t.join}
        arr = []
      end
    end
  end
  
  def self.v_down(verdict_id, file=false)
    require 'open-uri'
    verdict = Verdict.find(verdict_id)
    next unless verdict.consuption.nil?
      full_verdict = []
    begin
      if file
        full_verdict = File.readlines("e:/nepitelet/#{verdict.id}.html")
      else
        full_verdict = open(verdict.url).read.split("\n")
      end  
      found_lista = false
      #        File.open("e:/nepitelet/#{verdict.id}.html", "r").each_line do |fver|
      for fver in full_verdict
        if /<h2>([\w\W]*)</.match fver
          verdict.name = $1
        end
        if /<h1>([\w\W]*)<span/.match fver
          verdict.engine = $1
        end
        found_lista = true if /table id="verdikt"/.match fver
        next unless found_lista
        if /<td class="tul">Évjárat</.match fver
          if />([\w\W]*)</.match full_verdict[full_verdict.index(fver)+1]
            verdict.year_of_build = $1.to_i
          end
        end
        if /<td class="tul">Használati időtartam</.match fver
          if />([\d]*) év</.match full_verdict[full_verdict.index(fver)+1]
            verdict.usage_time = $1.to_i
          end
        end
        if /<td class="tul">Km vásárláskor</.match fver
          if />([\w\W]*)</.match full_verdict[full_verdict.index(fver)+1]
            verdict.km_at_buy = $1.to_i
          end
        end
        if /<td class="tul">Vezetett km</.match fver
          if />([\w\W]*)</.match full_verdict[full_verdict.index(fver)+1]
            verdict.km_driven = $1.to_i
          end
        end
        if /<td class="tul">Átlagfogyasztás</.match fver
          if />([\d\.]*) l</.match full_verdict[full_verdict.index(fver)+1]
            verdict.consuption = $1.to_f
          end
        end     
        verdict.save   

        break if /\/table/.match fver

      end      
    rescue Exception => e
      p e
    end
  end
  
  def self.parse_content
    
  end
  
  def self.html
	f=File.new("all.html", 'w')
	for v in Verdict.find(:all)
		p v.id
		f << "<a href=#{v.url}>#{v.url}</a>\n"
	end
	f.close
  end

  #Things.dall()  
  def self.dall(id=0, end_id=60000)
    require 'open-uri'

    verdict_ids = Verdict.find(:all, :conditions=>"id > '#{id}' and id < '#{end_id}'").map{|ver| ver.id}
    arr = []
    for verdict_id in verdict_ids
      verdict = Verdict.find(verdict_id)
      p verdict_id
	  begin
	  full_verdict = open(verdict.url).read
	  f=File.new("e:/nepitelet2/#{verdict_id}.html", 'w')
	  f << full_verdict
	  f.close
	  rescue Exception =>e
	  end
    end
  end  
  
  #Things.load_from_files  
  def self.load_from_files
    verdict_ids = Verdict.find(:all, :conditions => "engine is null").map{|ver| ver.id}
    arr = []
    for verdict_id in verdict_ids
      puts verdict_id.to_s
      v_down(verdict_id,true)
    end
  end
  
  
end