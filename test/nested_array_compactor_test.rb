require_relative "../src/nested_array_compactor.rb"

def it_compacts_a_nested_array 
  result = NestedArrayCompactor.new.deep_compact([
    nil, nil,
    [nil, [:foo, :bar, nil],
     [[nil, 1]]]
  ])

  raise "Unexpected result: #{result}" unless result == [[:foo, :bar], 1]
end

it_compacts_a_nested_array
puts "All tests passed!"
