require_relative '../src/active_record_scanner.rb'

it 'scans_successfully' do
  results = ActiveRecordScanner.new('./test/fixtures/test_class.rb').scan
  assert_equal(results.length, 1)
end

it 'ignores_empty_globs' do
  results = ActiveRecordScanner.new('').scan
  assert_equal(results.length, 0)
end

