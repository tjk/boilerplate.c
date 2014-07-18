#!/usr/bin/env ruby

funcs = []
files = []
last_file = nil

ARGF.each_with_index do |line, i|
  if md = line.match(/File '([^']+)'/)
    files << {file: md[1], funcs: []}
  elsif md = line.match(/Function '([^']+)'/)
    funcs << {func: md[1]}
  elsif md = line.match(/Lines executed:([^%]+)% of (\d+)/)
    data = {pct: md[1].to_f, nlines: md[2].to_i}
    if funcs.last && !funcs.last[:data]
      funcs.last[:data] = data
    else
      files.last[:data] = data
    end
  elsif md = line.match(/No executable lines/)
    data = {pct: 0.0, nlines: -1}
    if funcs.last && !funcs.last[:data]
      funcs.last[:data] = data
    else
      files.last[:data] = data
    end
  end
end

# now we figure out which funcs lives in which file
# (because of order gcov outputs...)
funcs.each do |func|
  lines = `grep -lR #{func[:func]} src/*.h`.split("\n")
  if lines.first
    files.each do |f|
      if f[:file].end_with?(lines.first.gsub(/\.h/, '.c'))
        f[:funcs] << func
      end
    end
  end
end

files.each_with_index do |f,i|
  if f[:data][:pct] >= 80
    print "\e[32m"
  elsif f[:data][:pct] == 0
    print "\e[31m"
  else
    print "\e[33m"
  end
  puts "[%6.2f%% of %4d] #{f[:file]}\e[0m" % [f[:data][:pct], f[:data][:nlines]]
  if f[:data][:pct] < 80
    f[:funcs].each do |func|
      if func[:data][:nlines] >= 0
        puts " [%6.2f%% of %2d] #{func[:func]}\e[0m" % [func[:data][:pct], func[:data][:nlines]]
      end
    end
  end
end
