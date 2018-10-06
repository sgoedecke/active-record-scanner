require_relative "../src/parser.rb"

describe 'parser' do
  it 'filters the generated sexp tree' do
    text = <<-TXT
      class FooController
        def bad(thing)
          thing[:stuff].each { |stuff_key|
            ActiveRecordClass.destroy(stuff_key)
          }
        end
      end
    TXT
    result = Parser.new(text).parse

    expect(result.map(&:first)).to eq([:loop, :lblock])
  end

  it 'handles multiple loops' do
    text = <<-TXT
      10.times do
        thing[:stuff].each { |stuff_key|
          ActiveRecordClass.destroy(stuff_key)
        }
      end
    TXT
    result = Parser.new(text).parse

    expect(result.map(&:first)).to eq([:loop, :lblock])
  end

  it 'reports on queries, even outside loops' do
    text = <<-TXT
      ActiveRecordClass.destroy(stuff_key)
      ActiveRecordClass.destroy(stuff_key)
    TXT
    result = Parser.new(text).parse

    expect(result.map(&:first)).to eq([:query, :query])
  end
end
