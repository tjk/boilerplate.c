#!/bin/bash

valgrind_lines=()

while read line
do
  if [ "${line:0:2}" = "==" ]
  then
    valgrind_lines+=("$line")
  else
    echo "$line"
  fi
done

errors=0
for ((i = 0; i < ${#valgrind_lines[@]}; i++))
do
  line="${valgrind_lines[$i]}"
  if [[ "$line" == *"Invalid read of size"* ]] ||
     [[ "$line" == *"are definitely lost in"* ]] ||
     [[ "$line" == *"depends on uninitialised value(s)"* ]]
  then
    errors+=1
  fi
  echo "$line"
done

if [ "$errors" -gt 0 ]
then
  echo "\e[31m$errors errors\e[0m"
  exit 1
else
  exit 0
fi
