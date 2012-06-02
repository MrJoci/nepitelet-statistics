class ListMaker
  def self.list(rows, columns)
    ret = ""
    ret << "<table border=1>"
    ret << "<tr>"
    for c in columns
      ret << "<td>"
      ret << c
      ret << "</td>"
    end
    ret << "</tr>"
    for row in rows
      ret << "<tr>"
      for key, value in row.attributes
        next unless columns.include? key 
        ret << "<td>"
        ret << value
        ret << "</td>"      
      end
      ret << "</tr>"
    end
    ret << "</table>"
    return ret    
  end
end