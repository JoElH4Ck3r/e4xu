/**
 * ...
 * @author wvxvw
 */
package org.wvxvws;

import flash.Lib;
import flash.display.Sprite;
import haxe.xml.Fast;
import org.wvxvws.xml.W;
import org.wvxvws.xml.X;
import org.wvxvws.protobuf.PBException;

class Main extends Sprite
{
	private var _xml:Xml;
	
	public function new() 
	{
		super();
		this._xml = Xml.parse("
		<a>
			<b/>dfghhfj
			<b>vcbnvvbmbnmbnmnbm,b</b>
			<b/>
			<b>
				<c foo=\"bar0\">
					<d abcd=\"123\" qwerty=\"shouldn't catch\"/>
				</c>
				<c foo=\"bar1\"/>
				<c foo=\"bar2\">
					<d abcd=\"456\" qwerty=\"678\"/>
				</c>
				<c foo=\"bar3\"/>
			</b>
			<b/>
		</a>");
		
		// AS3 analogue: this._xml..*.(valueOf().@*.(toXMlString() == "bar2").length()).*.@qwerty;
		
		var a:Array<Hash<String>> = cast W.alk(this._xml).d().a(this.filter).c().a(this.filter2).z();
		
		//trace(a); // TestW.hx 36: [{qwerty=>678}]
		X.path(this._xml, ".//c/d../d/@abcd[1]", this);
		try
		{
			throw PBException.InvalidEndTag;
		}
		catch (ex:PBException)
		{
			trace(ex);
		}
	}
	
	private inline function filter(attName:String, attValue:String, node:Xml):Bool
	{
		return attValue == "bar2";
	}
	
	private inline function filter2(attName:String, attValue:String, node:Xml):Bool
	{
		return attName == "qwerty";
	}
	
	public static function main():Void { Lib.current.addChild(new Main()); }
}