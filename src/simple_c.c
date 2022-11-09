// Copyright (C) 1996-2022 Markus Franz Xaver Johannes Oberhumer

#include <stdio.h>
// always enable assertions
#undef NDEBUG
#include <assert.h>

int main() {
    assert(sizeof(int) == 4);
    printf("simple test passed.\n");
    return 0;
}
