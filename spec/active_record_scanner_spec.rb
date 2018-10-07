describe ActiveRecordScanner do
  describe 'scan' do
    it 'scans successfully' do
      results = ActiveRecordScanner::Scanner.new('./spec/fixtures/test_class.rb').scan
      expect(results.length).to eq(1)
    end

    it 'ignores empty globs' do
      results = ActiveRecordScanner::Scanner.new('').scan
      expect(results.length).to eq(0)
    end
  end

  describe 'scan_file' do
    let(:scanner) { ActiveRecordScanner::Scanner.new('') }

    it 'catches a query inside a loop' do
      text = <<-TXT
        thing[:stuff].each { |stuff_key|
          ActiveRecordClass.destroy(stuff_key)
        }
      TXT
      results = scanner.scan_file(text)
      expect(results.length).to eq(1)
    end

    it 'ignores queries outside of loops' do
      text = 'ActiveRecordClass.destroy(stuff_key)'
      results = scanner.scan_file(text)
      expect(results.length).to eq(0)
    end

    it 'catches &: block syntax' do
      text = 'Class.each(&:destroy)'
      results = scanner.scan_file(text)
      expect(results.length).to eq(1)
    end
  end
end

