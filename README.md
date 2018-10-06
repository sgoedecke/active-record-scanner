# Rails ORM scanner

An attempt to write a scanner that detects known ORM performance issues with ActiveRecord (e.g. queries inside inner loops).

## Usage

`ruby scanner.rb "/full/path/to/file/**/*.rb` will recursively scan a directory for ActiveRecord queries inside loops. Consider replacing with methods that operate on collections: for instance, replace `find_by` inside a loop with a `where` call.

Example:
```
sgoedecke:parser/ (master) $ ./scanner.rb
Usage: ruby scanner.rb [options] [full-path]
    -s, --silent                     Suppress dot reporting in output

sgoedecke:parser/ (master) $ ./scanner.rb ./spec/fixtures/test_class.rb
.
./spec/fixtures/test_class.rb -- found a db query in a loop: [:query, "[:@ident, \"destroy\", [4, 24]]"]
```

## Development

Run the tests with `rspec`. You'll need to `bundle` first.

## References

This program was inspired by this paper by Junwen Yang: https://newtraell.cs.uchicago.edu/files/ms_paper/junwen.pdf

Unlike the static analysis tools described in the paper, this is (a) written in Ruby and (b) not reliant on a series of regexes.

## Todo

* Improve sexp tree traversal (e.g. avoid mutating the tree in `normalize!`)
* Improve nested array compacting. Remove that awful loop
* Add checks for inefficiences other than queries inside loops

Contributions are welcome.

