/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.css;

class CSSGlobal 
{
	private var _className:String;
	private var _styles:Hash<CSSRule>;
	private var _children:List<ICSSClient>;
	private var _pseudoClasses:List<String>;
	
	public function new()
	{
		this._className = getQualifiedClassName(this);
	}
	
	/* INTERFACE org.wvxvws.css.ICSSClient */
	
	public function className():String { return this._className; }
	
	public function styleNames():List<String>
	{
		var v:List<String>;
		for (var p:String in this._styles)
		{
			if (!v) v = new <String>[];
			v.push(p);
		}
		return v;
	}
	
	public function parentClient():ICSSClient { return null; }
	
	public function childClients():List<ICSSClient>
	{
		return this._children;
	}
	
	public function getStyle(name:String):CSSRule
	{
		return this._styles[name];
	}
	
	public function addStyle(name:String, style:CSSRule):void
	{
		this._styles[name] = style;
	}
	
	public function pseudoClasses():List<String>
	{
		return this._pseudoClasses;
	}
}