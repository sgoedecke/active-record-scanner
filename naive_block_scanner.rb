require 'ripper'

class BlockQueryScanner
  AR_METHODS = ['destroy', 'find', 'find_by', 'create']

  def initialize(glob)
    @glob = glob
    @results = []
  end

  def scan
    Dir.glob(@glob).each do |file|
      scan_file(file)
    end
    puts("\r\n")
    puts @results.join("\n")
  end

  private

  def scan_file(file)
    print '.' 
    @file = file
    raw = IO.binread(file)
    tree = Ripper.sexp(raw)
    traverse(tree)
  end

  def is_block?(node)
    [:brace_block, :do_block].include?(node[0])
  end

  def is_query?(node)
    node[0] == :@ident && AR_METHODS.include?(node[1])
  end

  def traverse(node, inside_block = false)
    if node.is_a?(Array) # don't traverse into raw values
      # check for nodes we care about
      inside_block = node if is_block?(node)

      if is_query?(node) && inside_block
        @results << "#{@file} -- found a db query in a block: #{node}"
      end

      # keep going
      node.each do |child|
        traverse(child, inside_block)
      end
    end
    return
  end
end


BlockQueryScanner.new(ARGV[0]).scan


