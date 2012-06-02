def self.add_create_block()
  
end


pattern = File.readlines("tables.sql")
command = "DROP DATABASE IF EXISTS `nepitelet`;\n"
command << "CREATE DATABASE `nepitelet` CHARACTER SET utf8;\n\n"
command << "USE `nepitelet`;\n"
i = 0
for row in pattern
  last = false
  last = true if pattern[pattern.index(row)+1].nil? or pattern[pattern.index(row)+1]=~/^\+/ or pattern[pattern.index(row)+1]=~/^ +/
  next if /^\#/.match row
  if /^\+(\w+)/.match row
    command << "\n\nDROP TABLE IF EXISTS `#{$1}`;\n"
    command << "CREATE TABLE `#{$1}` (\n"
    next
  elsif /^\t(\w+) \- (.*);/.match row
    command << "  `#{$1}` #{$2}"
    command << (last == true ? "\n)\nENGINE = InnoDB;\n" : ",\n")
  else
    
  end 
end

db_and_tables = File.new("database_and_tables.sql", "w")
db_and_tables << command
db_and_tables.close