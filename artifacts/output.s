	.text
	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
.set @feat.00, 0
	.file	"output.ll"
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
	movl	$0, 44(%rsp)
	leaq	__unnamed_1(%rip), %rsi
	cmpl	$8191, 44(%rsp)                 # imm = 0x1FFF
	jg	.LBB0_3
	.p2align	4, 0x90
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	movl	44(%rsp), %edx
	incl	%edx
	movl	%edx, 44(%rsp)
	movq	%rsi, %rcx
	callq	printf
	cmpl	$8191, 44(%rsp)                 # imm = 0x1FFF
	jle	.LBB0_2
.LBB0_3:
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

