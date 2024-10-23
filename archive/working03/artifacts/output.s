	.text
	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
.set @feat.00, 0
	.file	"output.ll"
	.def	recursiveFunction;
	.scl	2;
	.type	32;
	.endef
	.globl	recursiveFunction               # -- Begin function recursiveFunction
	.p2align	4, 0x90
recursiveFunction:                      # @recursiveFunction
.seh_proc recursiveFunction
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
	cmpl	$1025, %ecx                     # imm = 0x401
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
	callq	recursiveFunction
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
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	movl	$2, %ecx
	callq	recursiveFunction
	leaq	__unnamed_2(%rip), %rcx
	movl	%eax, %edx
	callq	printf
	xorl	%eax, %eax
	addq	$40, %rsp
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

