describe Compactor do
  it 'compacts_a_nested_array' do
    result = Compactor.new.deep_compact([
      nil, nil,
      [nil, [:foo, :bar, nil],
       [[nil, 1]]]
    ])

    expect(result).to eq([[:foo, :bar], 1])
  end
end
