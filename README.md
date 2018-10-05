# Rails ORM scanner

An attempt to write a scanner that detects known ORM performance issues with ActiveRecord (e.g. queries inside inner loops).

`test.rb` is an example of a bad file. `naive_block_scanner` just triggers on AR methods called inside blocks. `ripper_parser` is an attempt to track AR methods called inside _loops_.
