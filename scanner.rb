#!/usr/bin/env ruby

require_relative './src/active_record_scanner'

if ARGV[0]
  results = ActiveRecordScanner.new(ARGV[0]).scan
  puts "\r\n"
  puts results.join("\n")
else
  puts "Usage -- scanner.rb '/path/to/file.rb'"
end
