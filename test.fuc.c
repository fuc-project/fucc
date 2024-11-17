// #define MAX 8192

// int main() {
//     int x = 0;

//     // while (x < MAX) {
//     //     // if (x % 100 != 0) {
//     //     //     continue;
//     //     // }

//     //     x += 1;
//     //     printf(x);

//     //     if (x > 1024) {
//     //         break;
//     //     }
//     // }

//     if (x > 0) {
//         if (x + 1 > 0) {
//             printf(x);
//         }
//     }

//     return 0;
// }

#define MAX 1024

int main() {
    int x = 0;
    
    while (x < MAX) {
        x += 1;

        if (x % 5 != 0) {
            continue;
        }

        printf(x);
    }

    return 0;
}