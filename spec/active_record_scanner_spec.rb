describe ActiveRecordScanner do
  it 'scans_successfully' do
    results = ActiveRecordScanner::Scanner.new('./spec/fixtures/test_class.rb').scan
    expect(results.length).to eq(1)
  end

  it 'ignores_empty_globs' do
    results = ActiveRecordScanner::Scanner.new('').scan
    expect(results.length).to eq(0)
  end
end

