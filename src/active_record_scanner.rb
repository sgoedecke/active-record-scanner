require_relative './constants'
require_relative './parser'

class ActiveRecordScanner 
  def initialize(glob)
    @glob = glob
    @results = []
  end

  def scan
    Dir.glob(@glob).each do |file|
      scan_file(file)
    end
    @results
  end

  private

  def scan_file(file)
    print "."
    @file = file
    raw = IO.binread(file)
    compact_tree = Parser.new(raw).parse
    scan_for_errors(compact_tree) if compact_tree
  end

  def report_error(node)
    @results << "#{@file} -- found a db query in a loop: #{node}"
  end

  def scan_for_errors(node, inside_loop = false)
    return unless node.is_a?(Array) # don't traverse into raw values

    # if there's a loop higher up in the tree, set the flag
    # TODO: turn this into a counter to flag queries inside inner loops as more serious
    inside_loop = true if node[0] == :lblock

    report_error(node) if node[0] == :query && inside_loop

    node.each do |child|
      scan_for_errors(child, inside_loop)
    end
  end
end

