class Things

  def self.wget(link, filename)
    `wget #{link} -O #{filename} -q`
  end  

  # Things.download_nepitelet
  def self.download_nepitelet(brands=false, types=false, verdicts=true)
    fooldal = "fooldal.html"
    threads = []

    if brands
      wget("http://nepitelet.hu/autok/", fooldal)
      fooldal_sorai = File.readlines(fooldal)
      `rm #{fooldal}`

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
      for brand_out in Brand.find(:all)
        threads << Thread.new(brand_out) {|brand|
          regex = '[\w\W]'
          brand_file_name = "#{brand.name+rand(10000).to_s}.html"
          wget(brand.url, brand_file_name)

          type_file = File.readlines(brand_file_name)
          `rm #{brand_file_name}`
          for row in type_file
            if /var tipus_list = /.match row
              cars = row.split('},{')
              for car in cars
                if /"tipusnev":"(#{regex}*)","path":"(#{regex}*)","vege":"(#{regex}*)","img":"(#{regex}*)"/.match car
                  Type.create(:brand_id => brand.id, :name => $1, :url => 'http://nepitelet.hu/autok/'+$2.gsub(/\\/,'')) 
                end  
              end
              break
            end
          end      
      }
      end

      threads.each {|t| t.join}    
    end
    
    threads = []
#    if types or brands or verdicts
#      Verdict.delete_all
#      i=0
#      for type in Type.find(:all)
#        i+=1
#        p type.name
##        threads << Thread.new(type_out) {|type|
#          regex = '[\w\W]'
#          type_file_name = "#{i}.html"
#          wget(type.url, type_file_name)
##Things.download_nepitelet
#          type_file = File.readlines(type_file_name)
#          for row in type_file
#            if /var nepiteletek = /.match row
#              vers = row.split('},{')
#              j=0
#              for ver in vers
#                j+=1
#                if /"cim":"(#{regex}*),"tipus_id":(#{regex}*),"path":(#{regex}*),"rating":(#{regex}*),"date":(#{regex}*),"tipus":(#{regex}*),"modell":(#{regex}*),"km":(#{regex}*),"hossz":(#{regex}*),"jolmegirt":(#{regex}*),"kepes":(#{regex}*),"evjarat":(#{regex}*),"ertekeles":(#{regex}*),"ertek":(#{regex}*)/.match ver
#                new_verdict = Verdict.new(:type_id => type.id, :name => $1[0..99])
#                url = $3
#                written_at= $5
#                new_verdict.url = 'http://nepitelet.hu/autok/'+url.gsub(/[\\\"]/,'')
#                new_verdict.written_at = written_at.gsub(/\./, '-')
#                new_verdict.save
#                new_verdict.reload
#                
#                wget(new_verdict.url, "#{new_verdict.id}.html")
#                full_verdict = File.readlines("#{new_verdict.id}.html")
#                `rm #{new_verdict.id}.html`    
#                found_lista = false
#                for fver in full_verdict
#                  found_lista = true if /table id="verdikt"/.match fver
#                  next unless found_lista
#                  if /<td class="tul">Átlagfogyasztás/.match fver
#                    if />([\d\.]+) l</.match full_verdict[full_verdict.index(fver)+1]
#                      new_verdict.consuption = $1
#                    end
#                  end
#                  break if /\/table/.match row
#                end           
#                
#                new_verdict.save
#                else
#                  puts "not: " + ver
#                end  
#              end
#              break
#            end
#          end
#          `rm #{type_file_name}`
#  #    }
#      end
#
#      threads.each {|t| t.join}
#            
#    end
    
  end
  
end