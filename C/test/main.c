#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

int add(int a, int b) {
    return a + b;
}

static void test_add(void **state) {
    assert_int_equal(add(1, 1), 2);
}

int main(void) {
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_add),
    };
    return cmocka_run_group_tests(tests, NULL, NULL);
}