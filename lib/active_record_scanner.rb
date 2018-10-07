require "active_record_scanner/version"
require "active_record_scanner/constants"
require "active_record_scanner/parser"

module ActiveRecordScanner
  class Scanner 
    def initialize(glob, options={})
      @glob = glob
      @options = options
      @results = []
    end

    def scan
      Dir.glob(@glob).each do |file|
        print "." unless @options[:silent]
        @file = file
        raw = IO.binread(file)
        scan_file(raw)
      end
      @results
    end

    def scan_file(raw)
      compact_tree = Parser.new(raw).parse
      scan_for_errors(compact_tree)
      @results
    end

    private

    def report_error(error)
      node = error.last
      @results << "#{@file} (line #{node[2][1]} column #{node[2][0]}) -- called query method '##{node[1]}' in a loop"
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

end
