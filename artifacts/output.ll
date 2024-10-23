@0 = global [4 x i8] c"%d\0A\00"

define i32 @main() {
0:
	%x = alloca i32
	store i32 0, i32* %x
	br label %1

1:
	%2 = load i32, i32* %x
	%3 = icmp slt i32 %2, u0x2000
	br i1 %3, label %4, label %9

4:
	%5 = load i32, i32* %x
	%6 = add i32 %5, 1
	store i32 %6, i32* %x
	%7 = load i32, i32* %x
	%8 = call i32 (i8*, ...) @printf([4 x i8]* @0, i32 %7)
	br label %1

9:
	ret i32 0
}

declare i32 @printf(i8* %format, ...)
