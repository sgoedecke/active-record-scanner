require_relative './src/active_record_scanner'

results = ActiveRecordScanner.new(ARGV[0]).scan
puts "\r\n"
puts results.join("\n")
