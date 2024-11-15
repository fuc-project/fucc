#define CONSTANT 1024

int fucFunction(int x) {
    if (x > CONSTANT * CONSTANT) {
        return x;
    }

    x *= 2;
    printf(x);

    return fucFunction(x);
}

int main() {
    int x = 2;
    
    while (x <= CONSTANT) {
        x *= 4;
        printf(x);
    }

    fucFunction(x);
    fucFunction(x);

    return 0;
}