require_relative './src/active_record_scanner'

ActiveRecordScanner.new(ARGV[0]).scan
