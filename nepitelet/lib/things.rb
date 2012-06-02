class Things

  def self.wget(link, filename)
    `wget #{link} -O #{filename} -q`
  end  

  # Things.download_nepitelet
  def self.download_nepitelet
    fooldal = "fooldal.html"
    threads = []

#    wget("http://nepitelet.hu/autok/", fooldal)
#    fooldal_sorai = File.readlines(fooldal)
#    `rm #{fooldal}`
#
#    Brand.delete_all
    Type.delete_all
    
#    found_lista = false
#    for row  in fooldal_sorai
#      found_lista = true if /table class="markalista"/.match row
#      next unless found_lista
#      Brand.create(:name => $2, :url => $1) if /href="(http:\/\/nepitelet.hu\/autok\/(\w+)\/)"/.match row
#      break if /\/table/.match row
#    end
    
    for brand_out in Brand.find(:all)
      threads << Thread.new(brand_out) {|brand|
        regex = "[\w\d \-\_\/\\\:\.\,]"
        brand_file_name = "#{brand.name}.html"
        wget(brand.url, brand_file_name)
        
        type_file = File.readlines(brand_file_name)
        for row in type_file
          if /var tipus_list = /.match row
            cars = row.split('},{')
            for car in cars
              if /"tipusnev":"(#{regex}*)","path":"(#{regex}*)","vege":"(#{regex}*)","img":"(#{regex}*)"/.match car
                Type.create(:brand_id => brand.id, :name => $1, :url => $2) 
              end  
            end
            break
          end
        end      
        `rm #{brand_file_name}`
     }
    end

    threads.each {|t| t.join}    
  end
end