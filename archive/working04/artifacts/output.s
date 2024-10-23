	.text
	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
.set @feat.00, 0
	.file	"output.ll"
	.def	fucFunction;
	.scl	2;
	.type	32;
	.endef
	.globl	fucFunction                     # -- Begin function fucFunction
	.p2align	4, 0x90
fucFunction:                            # @fucFunction
.seh_proc fucFunction
# %bb.0:
	pushq	%rbp
	.seh_pushreg %rbp
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rax
	.seh_stackalloc 8
	movq	%rsp, %rbp
	.seh_setframe %rbp, 0
	.seh_endprologue
	movl	%ecx, %edx
	cmpl	$1048577, %ecx                  # imm = 0x100001
	jl	.LBB0_3
# %bb.1:
	movl	%edx, %eax
	jmp	.LBB0_2
.LBB0_3:
	movl	$16, %eax
	callq	__chkstk
	subq	%rax, %rsp
	movq	%rsp, %rsi
	addl	%edx, %edx
	movl	%edx, (%rsi)
	subq	$32, %rsp
	leaq	__unnamed_1(%rip), %rcx
	callq	printf
	addq	$32, %rsp
	movl	(%rsi), %ecx
	subq	$32, %rsp
	callq	fucFunction
.LBB0_2:
	nop
	leaq	8(%rbp), %rsp
	popq	%rsi
	popq	%rbp
	retq
	.seh_endproc
                                        # -- End function
	.def	main;
	.scl	2;
	.type	32;
	.endef
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
main:                                   # @main
.seh_proc main
# %bb.0:
	pushq	%rsi
	.seh_pushreg %rsi
	subq	$48, %rsp
	.seh_stackalloc 48
	.seh_endprologue
	movl	$2, 44(%rsp)
	leaq	__unnamed_2(%rip), %rsi
	cmpl	$1024, 44(%rsp)                 # imm = 0x400
	jg	.LBB1_3
	.p2align	4, 0x90
.LBB1_2:                                # =>This Inner Loop Header: Depth=1
	movl	44(%rsp), %edx
	shll	$2, %edx
	movl	%edx, 44(%rsp)
	movq	%rsi, %rcx
	callq	printf
	cmpl	$1024, 44(%rsp)                 # imm = 0x400
	jle	.LBB1_2
.LBB1_3:
	movl	44(%rsp), %ecx
	callq	fucFunction
	movl	44(%rsp), %ecx
	callq	fucFunction
	xorl	%eax, %eax
	addq	$48, %rsp
	popq	%rsi
	retq
	.seh_endproc
                                        # -- End function
	.data
	.globl	__unnamed_1                     # @0
__unnamed_1:
	.asciz	"%d\n"

	.globl	__unnamed_2                     # @1
__unnamed_2:
	.asciz	"%d\n"

