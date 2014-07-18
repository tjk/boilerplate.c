#!/usr/bin/env ruby

valgrind_lines = []

ARGF.each_with_index do |line, i|
  if line[0] == '=' && line[1] == '='
    valgrind_lines << line
  else
    puts line
  end
end

errors = 0
valgrind_lines.each do |line|
  errors += 1 if line.index('Invalid read of size')
  errors += 1 if line.index('are definitely lost in')
  errors += 1 if line.index('depends on uninitialised value(s)')
end

puts "\n#{valgrind_lines.join('')}"

puts "\e[31m#{errors} errors\e[0m" if errors > 0
exit errors > 0 ? 1 :0
