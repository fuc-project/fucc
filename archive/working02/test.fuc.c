int test(int x) {
    if (x == 5) {
        printf(5);
    } else if (x % 2 == 0) {
        printf(2);
    } else {
        printf(1);
    }

    return 0;
}

int main() {
    test(5); // 5
    test(4); // 2
    test(3); // 1
    test(2); // 2
    test(1); // 1
    test(0); // 2

    return 0;
}