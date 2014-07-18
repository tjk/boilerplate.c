#pragma once
#pragma clang diagnostic ignored "-Wunused-function"

#include <stdarg.h>

#include "common.h"

extern int n_assertions, n_failures, n_pending;
extern int indent;

static void _test_print(const char *fmt, ...)
{
    for (int i = 0; i < indent; ++i)
        fprintf(stderr, " ");

    va_list ap;
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
}

#define ASSERT(msg, test) do { \
    ++n_assertions; \
    if (!(test)) { \
        _test_print(" - \e[31m%s\e[0m\n", msg); \
        ++n_failures; \
        return msg; \
    } \
    _test_print(" - \e[32m%s\e[0m\n", msg); \
} while (0)

#define PENDING() do { \
    ++n_pending; \
    _test_print(" - \e[33mPENDING\e[0m\n"); \
    return NULL; \
} while (0)

#define ASSERT_STRCMP(a, b) do { \
    ++n_assertions; \
    if (0 != strcmp(a, b)) { \
        _test_print(" - \e[31m\"%s\" != \"%s\"\e[0m\n", a, b); \
        ++n_failures; \
        return "strcmp() failure"; \
    } \
    _test_print(" - \e[32m\"%s\" == \"%s\"\e[0m\n", a, b); \
} while (0)

#define RUN_TEST(test) do { \
    _test_print("%s\n", #test); \
    const char *msg = (test)(); \
    if (msg) \
    return msg; \
} while (0)

#define RUN_SUITE(test) do { \
    _test_print("%s\n", #test); \
    ++indent; \
    const char *msg = (test)(); \
    if (msg) \
    return msg; \
    --indent; \
} while (0)
