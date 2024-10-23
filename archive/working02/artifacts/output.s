	.text
	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
.set @feat.00, 0
	.file	"output.ll"
	.def	test;
	.scl	2;
	.type	32;
	.endef
	.globl	test                            # -- Begin function test
	.p2align	4, 0x90
test:                                   # @test
.seh_proc test
# %bb.0:
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	cmpl	$5, %ecx
	jne	.LBB0_2
# %bb.1:                                # %if.then.1
	leaq	.L.str(%rip), %rcx
	movl	$5, %edx
	jmp	.LBB0_5
.LBB0_2:                                # %if.else.1
	movl	%ecx, %eax
	shrl	$31, %eax
	addl	%ecx, %eax
	andl	$-2, %eax
	cmpl	%eax, %ecx
	je	.LBB0_3
# %bb.4:                                # %if.else.4
	leaq	.L.str(%rip), %rcx
	movl	$1, %edx
	jmp	.LBB0_5
.LBB0_3:                                # %if.then.4
	leaq	.L.str(%rip), %rcx
	movl	$2, %edx
.LBB0_5:                                # %if.end.1
	callq	printf
	xorl	%eax, %eax
	addq	$40, %rsp
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
	movl	$5, %ecx
	callq	test
	movl	$4, %ecx
	callq	test
	movl	$3, %ecx
	callq	test
	movl	$2, %ecx
	callq	test
	movl	$1, %ecx
	callq	test
	xorl	%ecx, %ecx
	callq	test
	xorl	%eax, %eax
	addq	$40, %rsp
	retq
	.seh_endproc
                                        # -- End function
	.section	.rdata,"dr"
.L.str:                                 # @.str
	.asciz	"%d\n"

