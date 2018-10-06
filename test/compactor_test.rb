require_relative "../src/compactor.rb"

it 'compacts_a_nested_array' do
  result = Compactor.new.deep_compact([
    nil, nil,
    [nil, [:foo, :bar, nil],
     [[nil, 1]]]
  ])

  assert_equal(result, [[:foo, :bar], 1])
end
