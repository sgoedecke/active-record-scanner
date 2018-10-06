require_relative '../src/active_record_scanner.rb'

def it_scans_successfully
  results = ActiveRecordScanner.new('./test/test_class.rb').scan
  raise "Unexpected result: #{results}" unless results.length == 1 
end

def it_ignores_empty_globs
  results = ActiveRecordScanner.new('').scan
  raise "Unexpected result: #{results}" unless results.length == 0
end

it_scans_successfully
it_ignores_empty_globs

puts "All tests passed!"

