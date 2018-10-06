require_relative '../src/active_record_scanner.rb'

describe 'active_record_scanner' do
  it 'scans_successfully' do
    results = ActiveRecordScanner.new('./spec/fixtures/test_class.rb').scan
    expect(results.length).to eq(1)
  end

  it 'ignores_empty_globs' do
    results = ActiveRecordScanner.new('').scan
    expect(results.length).to eq(0)
  end
end

