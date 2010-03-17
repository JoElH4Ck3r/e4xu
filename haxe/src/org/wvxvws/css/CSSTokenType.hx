/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.css;


enum CSSTokenType
{
	Keyword;
	NameSpace;
	Comment;
	VarName;
	ScopeThis;
	ScopeGlob;
	NewVal;
	ByRef;
	ByVal;
	StatProp;
	InstProp;
	
	BoolVal;
	FloatVal;
	IntVal;
	NullVal;
	DynamicVal;
	
	Invoke;
	Definition;
	
	// TODO: later.
	OpAdd;
	OpSub;
	OpMul;
	OpDiv;
	OpAnd;
	OpOr;
	OpEq;
	OpNe;
	OpGt;
	OpLt;
}