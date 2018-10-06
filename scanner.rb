#!/usr/bin/env ruby

require_relative './src/active_record_scanner'
require 'optionparser'

options = {}

option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby scanner.rb [options] [full-path]"
  opts.on("-s", "--silent", "Suppress dot reporting in output") do |_s|
    options[:silent] = true
  end
end
option_parser.parse!

if ARGV[0]
  results = ActiveRecordScanner.new(ARGV[0], options).scan
  puts "\r\n" unless options[:silent]
  puts results.join("\n")
else
  puts option_parser.help 
end
