# boilerplate.c

This is my *current* C project boilerplate. I'm sharing it partly to
find ways to improve it. Please suggest improvements.

In this form, it supplies a few major build targets (code blocks lack
shell coloring):

## `make cov`

Builds the `bin/$(BINARY)_cov` and prints code coverage information. For example:

```
git submodule sync
git submodule init
git submodule update | cut -d\' -f2 | xargs -t -I{} rm -f /Users/tj/workspace/boilerplate.c/build/{} 2>&1
/Library/Developer/CommandLineTools/usr/bin/make -C /Users/tj/workspace/boilerplate.c/deps
#cd somedep && ./autogen.sh && ./configure --prefix=all && /Library/Developer/CommandLineTools/usr/bin/make && /Library/Developer/CommandLineTools/usr/bin/make install
mkdir -p /Users/tj/workspace/boilerplate.c/bin
clang -Wall -Wextra -Werror -Wshadow -Winline -D_GNU_SOURCE -std=c99 -g -O0 -DGITREV=HEAD -fno-omit-frame-pointer --coverage -o /Users/tj/workspace/boilerplate.c/bin/boilerplate_cov src/main_test.c src/placeholder.c src/placeholder_test.c -I/Users/tj/workspace/boilerplate.c -I/Users/tj/workspace/boilerplate.c/src
rm -rf *.gcda
/Users/tj/workspace/boilerplate.c/bin/boilerplate_cov

placeholder_test
 - the answer is 42

1 assertions, 0 failures, 0 pending

[100.00% of    1] src/placeholder.c
```

## `make test`

Builds the `bin/$(BINARY)_test` and checks for memory leaks. For example:

```
git submodule sync
git submodule init
git submodule update | cut -d\' -f2 | xargs -t -I{} rm -f /Users/tj/workspace/boilerplate.c/build/{} 2>&1
/Library/Developer/CommandLineTools/usr/bin/make -C /Users/tj/workspace/boilerplate.c/deps
#cd somedep && ./autogen.sh && ./configure --prefix=all && /Library/Developer/CommandLineTools/usr/bin/make && /Library/Developer/CommandLineTools/usr/bin/make install
mkdir -p /Users/tj/workspace/boilerplate.c/bin
clang -Wall -Wextra -Werror -Wshadow -Winline -D_GNU_SOURCE -std=c99 -g -O2 -DNDEBUG -fomit-frame-pointer -o /Users/tj/workspace/boilerplate.c/bin/boilerplate_test src/main_test.c src/placeholder.c src/placeholder_test.c -I/Users/tj/workspace/boilerplate.c -I/Users/tj/workspace/boilerplate.c/src
valgrind --leak-check=full --show-reachable=yes /Users/tj/workspace/boilerplate.c/bin/boilerplate_test \
    2>&1 | ruby /Users/tj/workspace/boilerplate.c/scripts/valgrind_pretty_print.rb

placeholder_test
 - the answer is 42


1 assertions, 0 failures, 0 pending

==47255== Memcheck, a memory error detector
==47255== Copyright (C) 2002-2013, and GNU GPL'd, by Julian Seward et al.
==47255== Using Valgrind-3.9.0 and LibVEX; rerun with -h for copyright info
==47255== Command: /Users/tj/workspace/boilerplate.c/bin/boilerplate_test
==47255==
==47255== WARNING: Support on MacOS 10.8/10.9 is experimental and mostly broken.
==47255== WARNING: Expect incorrect results, assertions and crashes.
==47255== WARNING: In particular, Memcheck on 32-bit programs will fail to
==47255== WARNING: detect any errors associated with heap-allocated data.
==47255==
==47255==
==47255== HEAP SUMMARY:
==47255==     in use at exit: 41,490 bytes in 376 blocks
==47255==   total heap usage: 453 allocs, 77 frees, 47,506 bytes allocated
==47255==
==47255== 16,384 bytes in 1 blocks are still reachable in loss record 77 of 77
==47255==    at 0x70DB: malloc (in /usr/local/Cellar/valgrind/3.9.0/lib/valgrind/vgpreload_memcheck-amd64-darwin.so)
==47255==    by 0x1818F5: __smakebuf (in /usr/lib/system/libsystem_c.dylib)
==47255==    by 0x1962B7: __swsetup (in /usr/lib/system/libsystem_c.dylib)
==47255==    by 0x1AF1F8: __v2printf (in /usr/lib/system/libsystem_c.dylib)
==47255==    by 0x1AF74F: __xvprintf (in /usr/lib/system/libsystem_c.dylib)
==47255==    by 0x186BC9: vfprintf_l (in /usr/lib/system/libsystem_c.dylib)
==47255==    by 0x17F72D: fprintf (in /usr/lib/system/libsystem_c.dylib)
==47255==    by 0x100000BD4: main (main_test.c:23)
==47255==
==47255== LEAK SUMMARY:
==47255==    definitely lost: 0 bytes in 0 blocks
==47255==    indirectly lost: 0 bytes in 0 blocks
==47255==      possibly lost: 0 bytes in 0 blocks
==47255==    still reachable: 16,384 bytes in 1 blocks
==47255==         suppressed: 25,106 bytes in 375 blocks
==47255==
==47255== For counts of detected and suppressed errors, rerun with: -v
==47255== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 151 from 50)
```

## `make` AND `make dist`

Builds `bin/$(BINARY)_debug` (test / debug build) and `bin/$(BINARY)` (release build) respectively.
