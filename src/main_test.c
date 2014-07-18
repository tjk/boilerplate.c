#include "test.h"

#include "common.h"

int n_assertions = 0, n_failures = 0, n_pending = 0;
int indent = 0;

const char *placeholder_test();

const char *run_tests()
{
    RUN_TEST(placeholder_test);

    return NULL;
}

int main(UNUSED int argc, UNUSED char **argv)
{
     fprintf(stderr, "\n");
     const char *result = run_tests();
     fprintf(stderr, "\n");

     fprintf(stdout, "\e[%dm%d assertions, %d failures, %d pending\e[0m\n",
             result ? 31 : 32, n_assertions, n_failures, n_pending);
     fprintf(stderr, "\n");

     return n_failures ? EXIT_FAILURE : EXIT_SUCCESS;
}
