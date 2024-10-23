@0 = global [4 x i8] c"%d\0A\00"
@1 = global [4 x i8] c"%d\0A\00"

define i32 @fucFunction(i32 %x) {
0:
	%1 = mul i32 1024, 1024
	%2 = icmp sgt i32 %x, %1
	br i1 %2, label %3, label %4

3:
	ret i32 %x

4:
	%5 = alloca i32
	store i32 %x, i32* %5
	%6 = load i32, i32* %5
	%7 = mul i32 %6, 2
	store i32 %7, i32* %5
	%8 = load i32, i32* %5
	%9 = call i32 (i8*, ...) @printf([4 x i8]* @0, i32 %8)
	%10 = load i32, i32* %5
	%11 = call i32 @fucFunction(i32 %10)
	ret i32 %11
}

declare i32 @printf(i8* %format, ...)

define i32 @main() {
0:
	%x = alloca i32
	store i32 2, i32* %x
	br label %1

1:
	%2 = load i32, i32* %x
	%3 = icmp sle i32 %2, 1024
	br i1 %3, label %4, label %9

4:
	%5 = load i32, i32* %x
	%6 = mul i32 %5, 4
	store i32 %6, i32* %x
	%7 = load i32, i32* %x
	%8 = call i32 (i8*, ...) @printf([4 x i8]* @1, i32 %7)
	br label %1

9:
	%10 = load i32, i32* %x
	%11 = call i32 @fucFunction(i32 %10)
	%12 = load i32, i32* %x
	%13 = call i32 @fucFunction(i32 %12)
	ret i32 0
}
