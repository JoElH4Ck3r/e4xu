/**
* ...
* @author wvxvw
*/
package org.wvxvws;

import flash.Lib;
import flash.display.Sprite;
import org.wvxvws.xml.W;
import org.wvxvws.xml.X;

class TestW extends Sprite
{
	private var _xml:Xml;
	private var _removeWhite:EReg;
	
	public function new()
	{
		super();
		this._xml = Xml.parse("
		<a xmlns:foo=\"test\">
			 <b> test </b>
			 <b/> --foobar--
			 
			 
			 <b>
				<foo:c foo=\"bar0\"> 1111111
					 <d abcd=\"123\" qwerty=\"shouldn't catch\"/>
				</foo:c>
				<c foo=\"bar1\"/>
				<c foo=\"bar2\"> 999
					 <d abcd=\"456\" qwerty=\"678\"/>
					 <d abcd=\"456\" qwerty=\"678\"/>
					 <foo:d foo=\"bar0\"> 1111111
						 <e abcd=\"-------------\" qwerty=\"%%%%%%%%%%%%%\"/> 222222222
					</foo:d>
					 <d abcd=\"456\" qwerty=\"678\"/>
					 *****************
					 <d abcd=\"456\" qwerty=\"678\"/>
				</c>
				<c foo=\"bar3\"/>
			 </b>
			 <b/>
		</a>");
		this._removeWhite = ~/^[\t\s\r\n]+([^\t\s\r\n]+)*[\t\s\r\n]+$/g;
		// AS3 analogue: this._xml..*.(valueOf().@*.(toXMlString() == "bar2").length()).*.@qwerty;

		//var a:Array<Hash<String>> = cast W.alk(this._xml).d().a(this.filter).c().a(this.filter2).z();

		//trace(a); // TestW.hx 36: [{qwerty=>678}]
		//var b:Array<Xml> = cast W.alk(this._xml).c().c().p().c().z();
		//var d:Array<String> = cast W.alk(this._xml).d().t(this.filterTexts).z();
		//trace(this._xml);
		//X.print(this._xml);
		trace(X.print(this._xml));
		X.path(this._xml, ".//@qwerty", this);
	}
	
	private function filterTexts(text:String, node:Xml):Bool
	{
		node.nodeValue = this._removeWhite.replace(text, "$1");
		return true;
	}
	
	private function filter(attName:String, attValue:String, node:Xml):Bool
	{
		return attValue == "bar2";
	}

	private function filter2(attName:String, attValue:String, node:Xml):Bool
	{
		return attName == "qwerty";
	}

	public static function main() { Lib.current.addChild(new TestW()); }
}