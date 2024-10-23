package builder

import (
	"fmt"
	"strconv"

	"fuc.eparker.dev/compiler/ast"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/enum"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
)

// AST Text reference
/*Program(Program) {
    FunctionDeclaration(recursiveFunction) {
        Identifier(int)
        Parameters(Parameters) {
            VariableDeclaration(x) {
                Identifier(int)
            }
        }
        Block(Block) {
            Statement(if) {
                BinaryExpression(>) {
                    Identifier(x)
                    Literal(1024)
                }
                Block(Block) {
                    ReturnStatement(return) {
                        Identifier(x)
                    }
                }
            }
            Statement(if) {
                BinaryExpression(==) {
                    BinaryExpression(%) {
                        Identifier(x)
                        Literal(2)
                    }
                    Literal(0)
                }
                Block(Block) {
                    Assignment(x) {
                        Identifier(*=)
                        BinaryExpression(*) {
                            BinaryExpression(%) {
                                Identifier(x)
                                Literal(6)
                            }
                            Literal(2)
                        }
                    }
                }
            }
            ReturnStatement(return) {
                FunctionCall(recursiveFunction) {
                    BinaryExpression(-) {
                        Identifier(x)
                        Literal(1)
                    }
                }
            }
        }
    }
    FunctionDeclaration(main) {
        Identifier(int)
        Parameters(Parameters)
        Block(Block) {
            VariableDeclaration(x) {
                Literal(1024)
            }
            FunctionCall(printf) {
                FunctionCall(recursiveFunction) {
                    Identifier(x)
                }
            }
            ReturnStatement(return) {
                Literal(0)
            }
        }
    }
}*/

type Builder struct {
	ast      *ast.ASTNode
	module   *ir.Module
	function *ir.Func
	block    *ir.Block
	locals   map[string]value.Value
	globals  map[string]constant.Constant
}

func NewBuilder(ast *ast.ASTNode) *Builder {
	return &Builder{
		ast:     ast,
		module:  ir.NewModule(),
		locals:  make(map[string]value.Value),
		globals: make(map[string]constant.Constant),
	}
}

type targetType int

const (
	Windowsx86 targetType = iota
	Windowsx64
	Linuxx86
	Linuxx64
	WebAssembly
)

func (b *Builder) SetTarget(target targetType) {
	switch target {
	case Windowsx86:
		b.module.TargetTriple = "i686-pc-windows-msvc"
	case Windowsx64:
		b.module.TargetTriple = "x86_64-pc-windows-msvc"
	case Linuxx86:
		b.module.TargetTriple = "i686-pc-linux-gnu"
	case Linuxx64:
		b.module.TargetTriple = "x86_64-pc-linux-gnu"
	case WebAssembly:
		b.module.TargetTriple = "wasm32-unknown-unknown"
	default:
		panic(fmt.Sprintf("Unsupported target: %d", target))
	}
}

func (b *Builder) Build() *ir.Module {
	b.generateProgram(b.ast)
	return b.module
}

func (b *Builder) generateProgram(node *ast.ASTNode) {
	for _, child := range node.Children {
		switch child.Type {
		case ast.PreprocessorDirective:
			b.generatePreprocessorDirective(child)
		case ast.FunctionDeclaration:
			b.generateFunction(child)
		}
	}
}

func (b *Builder) generatePreprocessorDirective(node *ast.ASTNode) {
	if node.Name == "#define" && len(node.Children) == 2 {
		name := node.Children[0].Name

		// Parse value to int
		var value int64 = 0

		if node.Children[1].Type == ast.Literal {
			fmt.Sscanf(node.Children[1].Name, "%d", &value)
		} else {
			panic(fmt.Sprintf("Unsupported value type: %v", node.Children[1].Type))
		}

		// Add to globals
		b.globals[name] = constant.NewInt(types.I32, value)
		return
	}

	panic(fmt.Sprintf("Unsupported preprocessor directive: %v", node.Name))
}

func (b *Builder) generateFunction(node *ast.ASTNode) {
	name := node.Name
	retType := getTypeFromName(node.Children[0].Name)

	// Create parameter types
	var paramTypes []types.Type
	var paramNames []string
	for _, param := range node.Children[1].Children {
		paramName := param.Name
		paramType := getTypeFromName(param.Children[0].Name)
		paramTypes = append(paramTypes, paramType)
		paramNames = append(paramNames, paramName)
	}

	// Create function type
	var funcType *types.FuncType

	if len(paramTypes) > 0 {
		funcType = types.NewFunc(retType, paramTypes...)
	} else {
		funcType = types.NewFunc(retType)
	}

	var params []*ir.Param
	for i, paramName := range paramNames {
		params = append(params, ir.NewParam(paramName, paramTypes[i]))
	}

	// Create function
	fn := b.module.NewFunc(name, funcType.RetType, params...)

	// Set parameter names and add them to locals
	b.locals = make(map[string]value.Value) // Clear locals for the new function
	for i, param := range fn.Params {
		param.SetName(paramNames[i])
		b.locals[paramNames[i]] = param
	}

	b.function = fn

	// Create entry block
	entry := fn.NewBlock("")
	b.generateBlock(entry, node.Children[2])

	// Add return statement if not present
	if entry.Term == nil {
		entry.NewRet(constant.NewInt(types.I32, 0))
	}
}

func (b *Builder) generateFunctionCall(node *ast.ASTNode) value.Value {
	fnName := node.Name
	var fn *ir.Func

	// Find the function in the module
	for _, f := range b.module.Funcs {
		if f.Name() == fnName {
			fn = f
			break
		}
	}

	if fn == nil {
		if fnName == "printf" {
			// Create printf function
			fn = b.module.NewFunc("printf", types.I32, ir.NewParam("format", types.NewPointer(types.I8)))
			fn.Sig.Variadic = true
		} else {
			// Function not found
			panic(fmt.Sprintf("Function not found: %s", fnName))
		}
	}

	var args []value.Value
	if fnName == "printf" {
		// Add format string for printf
		formatStr := b.module.NewGlobalDef("", constant.NewCharArray([]byte("%d\n\x00")))
		args = append(args, formatStr)
	}
	for _, arg := range node.Children {
		args = append(args, b.generateExpression(arg))
	}

	return b.block.NewCall(fn, args...)
}

func (b *Builder) generateBlock(block *ir.Block, node *ast.ASTNode) {
	b.block = block
	for _, child := range node.Children {
		switch child.Type {
		case ast.ReturnStatement:
			b.generateReturn(child)
		case ast.VariableDeclaration:
			b.generateVariableDeclaration(child)
		case ast.FunctionCall:
			b.generateFunctionCall(child)
		case ast.Statement:
			// if child.Name == "if" {
			// 	b.generateConditional(child)
			// } else {
			// 	panic(fmt.Sprintf("Unsupported statement type: %s", child.Name))
			// }
			switch child.Name {
			case "if":
				b.generateConditional(child)
			case "continue":
				b.generateBreakContinue(child, true)
			case "break":
				b.generateBreakContinue(child, false)
			default:
				panic(fmt.Sprintf("Unsupported statement type: %s", child.Name))
			}
		case ast.Assignment:
			b.generateAssignment(child)
		case ast.WhileStatement:
			b.generateWhileStatement(child)
		default:
			panic(fmt.Sprintf("Unsupported block type: %d", child.Type))
		}
	}
}

func (b *Builder) generateReturn(node *ast.ASTNode) {
	if len(node.Children) == 0 {
		b.block.NewRet(nil)
	} else {
		value := b.generateExpression(node.Children[0])
		b.block.NewRet(value)
	}
}

func (b *Builder) generateVariableDeclaration(node *ast.ASTNode) {
	varName := node.Name
	varType := getTypeFromName(node.Children[0].Name)
	alloca := b.block.NewAlloca(varType)
	alloca.SetName(varName)
	b.locals[varName] = alloca

	if len(node.Children) > 1 {
		value := b.generateExpression(node.Children[1])
		b.block.NewStore(value, alloca)
	}
}

func (b *Builder) generateConditional(node *ast.ASTNode) {
	condition := b.generateExpression(node.Children[0])
	thenBlock := b.function.NewBlock("")
	endBlock := b.function.NewBlock("")
	var elseBlock *ir.Block

	if len(node.Children) > 2 {
		elseBlock = b.function.NewBlock("")
		b.block.NewCondBr(condition, thenBlock, elseBlock)
	} else {
		b.block.NewCondBr(condition, thenBlock, endBlock)
	}

	b.generateBlock(thenBlock, node.Children[1])
	if thenBlock.Term == nil {
		thenBlock.NewBr(endBlock)
	}

	if elseBlock != nil {
		b.generateBlock(elseBlock, node.Children[2])
		if elseBlock.Term == nil {
			elseBlock.NewBr(endBlock)
		}
	}

	b.block = endBlock
}

func (b *Builder) generateAssignment(node *ast.ASTNode) {
	varName := node.Name
	operator := node.Children[0].Name
	rightExpr := b.generateExpression(node.Children[1])

	alloca, ok := b.locals[varName]

	if !ok {
		panic(fmt.Sprintf("Undefined variable: %s", varName))
	}

	// If it's a IntType and not a PointerType, handle differently
	if _, isParam := alloca.(*ir.Param); isParam {
		alloca = b.block.NewAlloca(alloca.Type())
		b.block.NewStore(b.locals[varName], alloca)
	}

	loadInst := b.block.NewLoad(alloca.Type().(*types.PointerType).ElemType, alloca)

	var result value.Value
	switch operator {
	case "=":
		result = rightExpr
	case "+=":
		result = b.block.NewAdd(loadInst, rightExpr)
	case "-=":
		result = b.block.NewSub(loadInst, rightExpr)
	case "*=":
		result = b.block.NewMul(loadInst, rightExpr)
	case "/=":
		result = b.block.NewSDiv(loadInst, rightExpr)
	case "%=":
		result = b.block.NewSRem(loadInst, rightExpr)
	default:
		panic(fmt.Sprintf("Unsupported assignment operator: %s", operator))
	}

	b.block.NewStore(result, alloca)
	b.locals[varName] = alloca
}

func (b *Builder) generateExpression(node *ast.ASTNode) value.Value {
	switch node.Type {
	case ast.Literal:
		return b.generateLiteral(node)
	case ast.Identifier:
		return b.generateIdentifier(node)
	case ast.BinaryExpression:
		return b.generateBinaryExpression(node)
	case ast.FunctionCall:
		return b.generateFunctionCall(node)
	default:
		panic(fmt.Sprintf("Unsupported expression type: %d", node.Type))
	}
}

func (b *Builder) generateLiteral(node *ast.ASTNode) value.Value {
	val, err := strconv.Atoi(node.Name)
	if err != nil {
		panic(fmt.Sprintf("Invalid literal: %s", node.Name))
	}
	return constant.NewInt(types.I32, int64(val))
}

func (b *Builder) generateIdentifier(node *ast.ASTNode) value.Value {
	if val, ok := b.locals[node.Name]; ok {
		if _, isParam := val.(*ir.Param); isParam {
			return val // Return the parameter directly
		}

		return b.block.NewLoad(val.Type().(*types.PointerType).ElemType, val)
	}

	if val, ok := b.globals[node.Name]; ok {
		return val
	}

	panic(fmt.Sprintf("Undefined variable: %s", node.Name))
}

func (b *Builder) generateBinaryExpression(node *ast.ASTNode) value.Value {
	left := b.generateExpression(node.Children[0])
	right := b.generateExpression(node.Children[1])

	switch node.Name {
	case "+":
		return b.block.NewAdd(left, right)
	case "-":
		return b.block.NewSub(left, right)
	case "*":
		return b.block.NewMul(left, right)
	case "/":
		return b.block.NewSDiv(left, right)
	case "%":
		return b.block.NewSRem(left, right)
	case "==":
		return b.block.NewICmp(enum.IPredEQ, left, right)
	case "!=":
		return b.block.NewICmp(enum.IPredNE, left, right)
	case "<":
		return b.block.NewICmp(enum.IPredSLT, left, right)
	case "<=":
		return b.block.NewICmp(enum.IPredSLE, left, right)
	case ">":
		return b.block.NewICmp(enum.IPredSGT, left, right)
	case ">=":
		return b.block.NewICmp(enum.IPredSGE, left, right)
	default:
		panic(fmt.Sprintf("Unsupported binary operator: %s", node.Name))
	}
}

func (b *Builder) generateWhileStatement(node *ast.ASTNode) {
	conditionBlock := b.function.NewBlock("")
	loopBlock := b.function.NewBlock("")
	endBlock := b.function.NewBlock("")

	b.block.NewBr(conditionBlock)

	b.block = conditionBlock
	condition := b.generateExpression(node.Children[0])
	b.block.NewCondBr(condition, loopBlock, endBlock)

	b.generateBlock(loopBlock, node.Children[1])
	if loopBlock.Term == nil {
		loopBlock.NewBr(conditionBlock)
	}

	b.block = endBlock
}

func getTypeFromName(name string) types.Type {
	switch name {
	case "int":
		return types.I32
	case "void":
		return types.Void
	default:
		panic(fmt.Sprintf("Unsupported type: %s", name))
	}
}

func (b *Builder) generateBreakContinue(node *ast.ASTNode, isContinue bool) {}
