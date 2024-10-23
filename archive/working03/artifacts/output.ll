@0 = global [4 x i8] c"%d\0A\00"
@1 = global [4 x i8] c"%d\0A\00"

define i32 @recursiveFunction(i32 %x) {
0:
	%1 = icmp sgt i32 %x, 1024
	br i1 %1, label %2, label %3

2:
	ret i32 %x

3:
	%4 = alloca i32
	store i32 %x, i32* %4
	%5 = load i32, i32* %4
	%6 = mul i32 %5, 2
	store i32 %6, i32* %4
	%7 = load i32, i32* %4
	%8 = call i32 (i8*, ...) @printf([4 x i8]* @0, i32 %7)
	%9 = load i32, i32* %4
	%10 = call i32 @recursiveFunction(i32 %9)
	ret i32 %10
}

declare i32 @printf(i8* %format, ...)

define i32 @main() {
0:
	%1 = call i32 @recursiveFunction(i32 2)
	%2 = call i32 (i8*, ...) @printf([4 x i8]* @1, i32 %1)
	ret i32 0
}
