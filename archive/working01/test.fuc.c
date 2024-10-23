#define FOO 1

int bar() {
    return (1 + FOO) * 2;
}

int baz(int a, int b) {
    return a + b;
}

int biz() {
    return 1 + 3 * 4 * (8 * 3 / 2 + 1) - 2;
}

int bap() {
    printf(biz());

    return 0;
}

int main() {
    int a = 5;

    printf(FOO + 1 + bar() * baz(a, 4));

    bap();

    return 0;
}