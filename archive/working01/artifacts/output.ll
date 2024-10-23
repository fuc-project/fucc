declare i32 @printf(i8*, ...) nounwind
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00"

; #define FOO 1
define i32 @bar() {
  %tmp1 = add i32 1, 1
  %tmp2 = mul i32 %tmp1, 2
  ret i32 %tmp2
}

define i32 @baz(i32 %a, i32 %b) {
  %tmp3 = add i32 %a, %b
  ret i32 %tmp3
}

define i32 @biz() {
  %tmp4 = mul i32 3, 4
  %tmp5 = mul i32 8, 3
  %tmp6 = sdiv i32 %tmp5, 2
  %tmp7 = add i32 %tmp6, 1
  %tmp8 = mul i32 %tmp4, %tmp7
  %tmp9 = add i32 1, %tmp8
  %tmp10 = sub i32 %tmp9, 2
  ret i32 %tmp10
}

define i32 @bap() {
  %tmp11 = call i32 @biz()
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %tmp11)
  ret i32 0
}

define i32 @main() {
  %a = alloca i32
  store i32 5, i32* %a
  %tmp12 = add i32 1, 1
  %tmp13 = call i32 @bar()
  %tmp14 = load i32, i32* %a
  %tmp15 = call i32 @baz(i32 %tmp14, i32 4)
  %tmp16 = mul i32 %tmp13, %tmp15
  %tmp17 = add i32 %tmp12, %tmp16
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %tmp17)
  call void @bap()
  ret i32 0
}

