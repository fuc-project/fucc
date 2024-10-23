#define MAX 8192

int main() {
    int x = 0;

    while (x < MAX) {
        // if (x % 100 != 0) {
        //     continue;
        // }

        x += 1;
        printf(x);

        // if (x > 1024) {
        //     break;
        // }
    }

    return 0;
}