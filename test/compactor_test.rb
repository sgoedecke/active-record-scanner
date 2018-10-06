require_relative "../src/compactor.rb"

def it_compacts_a_nested_array 
  result = Compactor.new.deep_compact([
    nil, nil,
    [nil, [:foo, :bar, nil],
     [[nil, 1]]]
  ])

  raise "Unexpected result: #{result}" unless result == [[:foo, :bar], 1]
end

it_compacts_a_nested_array
puts "All tests passed!"
