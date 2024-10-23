int recursiveFunction(int x) {
    if (x > 1024) {
        return x;
    }

    x *= 2;
    printf(x);

    return recursiveFunction(x);
}

int main() {
    printf(recursiveFunction(2));

    return 0;
}