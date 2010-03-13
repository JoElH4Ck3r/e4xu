/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.css;

enum CSSError 
{
	InvalidName(line:Int, Position:Int);
	InvalidImport(line:Int, Position:Int);
	InvalidDefine(line:Int, Position:Int);
	InvalidKeyword(line:Int, Position:Int);
}