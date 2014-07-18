#include "test.h"

#include "placeholder.h"

const char *placeholder_test()
{
    ASSERT("the answer is 42", 42 == placeholder());

    return NULL;
}
