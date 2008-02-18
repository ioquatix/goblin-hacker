#!/usr/bin/env ruby

ARGV.each do |f|
  puts "Fixing #{f}..."
  
  o = File.open(f, "r")
  buf = o.read
  o.close
  
  buf.gsub!(/\r\n/, "\n")
  
  File.open(f, "w") { |o| o.write(buf) }
end