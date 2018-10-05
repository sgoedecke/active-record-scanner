require_relative '../src/active_record_scanner.rb'

def it_scans_successfully
  ActiveRecordScanner.new('./test/test_class.rb').scan
end

def it_ignores_empty_globs
  ActiveRecordScanner.new('').scan
end

it_scans_successfully
it_ignores_empty_globs

puts "All tests passed!"

