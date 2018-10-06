@failures = []

def assert(predicate)
  @failures << "In #{@current_test}, expected predicate to be true" unless predicate
end

def assert_equal(a, b)
  @failures << "In #{@current_test}, expected #{a.inspect} to equal #{b.inspect}" unless a == b
end

def it(label)
  @current_test = label
  yield
end

Dir.glob('./test/**/*_test.rb').each do |file|
  require file
end

puts "\r\n"
puts "#{@failures.count} tests failed"
puts @failures.join("\n")

