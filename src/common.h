#pragma once

#include <stdio.h>
#include <stdlib.h>

#define GCC_VERSION (__GNUC__ * 10000 \
        + __GNUC_MINOR__ * 100 \
        + __GNUC_PATCHLEVEL__)

#define INLINE inline __attribute__((always_inline))
#define UNUSED __attribute__((__unused__)) __attribute__((deprecated))

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define ARRAY_SIZE(arr) (sizeof((arr))/sizeof((arr)[0]))

#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
