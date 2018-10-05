require 'ripper'

class HashProcessor
  def deep_compact(n)

    10.times do
      n = deep_compact_with_nesting(strip_nesting(n))
    end
    n
  end

  private
  
  def deep_compact_with_nesting(n)
    if n.respond_to? :compact
      n.compact.map{ |c| deep_compact_with_nesting(c) }
    else
      n
    end
  end

  def strip_nesting(n)
    if n.is_a?(Array)
      if n.length == 0
        return nil
      elsif n.length == 1
        return strip_nesting(n.first)
      else
        return n.map{ |n| strip_nesting(n) }
      end
    else
      return n
    end
  end
end

class QueryScanner
  AR_METHODS = ['destroy', 'find', 'find_by', 'create']
  LOOP_METHODS = ['map', 'each']

  def initialize(glob)
    @glob = glob
    @hash_processor = HashProcessor.new
    @results = []
  end

  def scan
    Dir.glob(@glob).each do |file|
      scan_file(file)
    end
    puts "\r\n"
    puts @results.join("\n")
  end

  private

  def scan_file(file)
    print "."
    @file = file
    raw = IO.binread(file)
    raw_tree = Ripper.sexp(raw)
    return unless raw_tree # if the file isn't valid ruby, ignore it
    filtered_tree = filter(raw_tree)
    compact_tree = @hash_processor.deep_compact(filtered_tree) 
    return unless compact_tree # if the file has no queries or loops, ignore it
    normalise!(compact_tree)
    traverse(compact_tree)
  end

  def is_block?(node)
    [:brace_block, :do_block].include?(node[0])
  end

  def is_query?(node)
    node[0] == :@ident && AR_METHODS.include?(node[1])
  end

  def is_loop?(node)
    node[0] == :@ident && LOOP_METHODS.include?(node[1])
  end

  def node_key(node)
    "key"
  end

  def filter(new_tree = [], tree)
    tree.map.with_index do |node, i|
      if node.is_a?(Array) # we only care about non-leaf nodes
        if is_loop?(node)
          [ :loop, node_key(node), nil ]
        elsif is_block?(node)
          [ :block, node_key(node), filter(node)]
        elsif is_query?(node)
          # if the current node is a query, return it
          [:query, node.to_s] 
        elsif node
          filter(node)
        end
      end
    end
  end

  def normalise!(tree)
    tree.each.with_index do |node, i|
      if node.is_a?(Array)
        if node.first == :loop
          tree[i+1][0] = :lblock if tree[i+1]
        end
        tree[i] = normalise!(node)
      end
    end
    tree
  end

  def traverse(node, inside_block = false)
    if node.is_a?(Array) # don't traverse into raw values
      # check for nodes we care about
      inside_block = node if node[0] == :lblock 

      if node[0] == :query && inside_block
        @results << "#{@file} -- found a db query in a loop: #{node}"
      end

      # keep going
      node.each do |child|
        traverse(child, inside_block)
      end
    end
    return
  end
end


QueryScanner.new(ARGV[0]).scan


