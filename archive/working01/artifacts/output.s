	.text
	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
.set @feat.00, 0
	.file	"output.ll"
	.def	bar;
	.scl	2;
	.type	32;
	.endef
	.globl	bar                             # -- Begin function bar
	.p2align	4, 0x90
bar:                                    # @bar
# %bb.0:
	movl	$4, %eax
	retq
                                        # -- End function
	.def	baz;
	.scl	2;
	.type	32;
	.endef
	.globl	baz                             # -- Begin function baz
	.p2align	4, 0x90
baz:                                    # @baz
# %bb.0:
                                        # kill: def $edx killed $edx def $rdx
                                        # kill: def $ecx killed $ecx def $rcx
	leal	(%rcx,%rdx), %eax
	retq
                                        # -- End function
	.def	biz;
	.scl	2;
	.type	32;
	.endef
	.globl	biz                             # -- Begin function biz
	.p2align	4, 0x90
biz:                                    # @biz
# %bb.0:
	movl	$155, %eax
	retq
                                        # -- End function
	.def	bap;
	.scl	2;
	.type	32;
	.endef
	.globl	bap                             # -- Begin function bap
	.p2align	4, 0x90
bap:                                    # @bap
.seh_proc bap
# %bb.0:
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	callq	biz
	leaq	.L.str(%rip), %rcx
	movl	%eax, %edx
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
	pushq	%rsi
	.seh_pushreg %rsi
	subq	$48, %rsp
	.seh_stackalloc 48
	.seh_endprologue
	movl	$5, 44(%rsp)
	callq	bar
	movl	%eax, %esi
	movl	44(%rsp), %ecx
	movl	$4, %edx
	callq	baz
	imull	%eax, %esi
	addl	$2, %esi
	leaq	.L.str(%rip), %rcx
	movl	%esi, %edx
	callq	printf
	callq	bap
	xorl	%eax, %eax
	addq	$48, %rsp
	popq	%rsi
	retq
	.seh_endproc
                                        # -- End function
	.section	.rdata,"dr"
.L.str:                                 # @.str
	.asciz	"%d\n"

