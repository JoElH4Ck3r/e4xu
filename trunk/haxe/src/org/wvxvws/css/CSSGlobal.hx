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
		this._className = Type.getClassName(cast this);
	}
	
	/* INTERFACE org.wvxvws.css.ICSSClient */
	
	public function className():String { return this._className; }
	
	public function styleNames():List<String>
	{
		var v:List<String>;
		for (p in this._styles)
		{
			if (v == null) v = new List<String>();
			v.add(Std.string(p));
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
		return this._styles.get(name);
	}
	
	public function addStyle(name:String, style:CSSRule):Void
	{
		this._styles.set(name, style);
	}
	
	public function pseudoClasses():List<String>
	{
		return this._pseudoClasses;
	}
}