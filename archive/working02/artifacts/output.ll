declare i32 @printf(i8*, ...) nounwind
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00"

define i32 @test(i32 %x) {
  %tmp1 = icmp eq i32 %x, 5
  br i1 %tmp1, label %if.then.1, label %if.else.1

if.then.1:
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 5)
  br label %if.end.1

if.else.1:
  %tmp3 = srem i32 %x, 2
  %tmp4 = icmp eq i32 %tmp3, 0
  br i1 %tmp4, label %if.then.4, label %if.else.4

if.then.4:
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 2)
  br label %if.end.4

if.else.4:
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 1)
  br label %if.end.4

if.end.4:
  br label %if.end.1

if.end.1:
  ret i32 0
}

define i32 @main() {
  call void @test(i32 5)
  call void @test(i32 4)
  call void @test(i32 3)
  call void @test(i32 2)
  call void @test(i32 1)
  call void @test(i32 0)
  ret i32 0
}

