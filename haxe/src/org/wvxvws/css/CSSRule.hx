/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.css;

class CSSRule 
{
	private var _className:String;
	private var _mustHaveProperties:List<String>;
	private var _mustHaveParent:CSSRule;
	private var _mustHaveChildren:List<String>;
	private var _mustHaveDescendants:List<String>;
	private var _mustHavePseudoClasses:List<String>;
	private var _mustBeNth:List<UInt>;
	private var _mustFollow:String;
	private var _mustPrecede:String;
	private var _table:Hash<String>;
	
	public function new(className:String, table:Hash<String>, 
						properties:List<String> = null, 
						parent:CSSRule = null, 
						children:List<String> = null,
						descendants:List<String> = null, 
						pseudoClasses:List<String> = null,
						nth:List<UInt> = null, follow:String = null,
						precede:String = null) 
	{
		super();
		this._className = className;
		this._table = table;
		this._mustHaveProperties = properties;
		this._mustHaveParent = parent;
		this._mustHaveChildren = children;
		this._mustHaveDescendants = descendants;
		this._mustHavePseudoClasses = pseudoClasses;
		this._mustBeNth = nth;
		this._mustFollow = follow;
		this._mustPrecede = precede;
	}
	
	public function matches(client:ICSSClient):Bool
	{
		var i:int;
		var len:int;
		var other:ICSSClient;
		var others:List<ICSSClient>;
		var strings:List<String>;
		
		if (this._className != client.className()) return false;
		if (this._mustHaveProperties)
		{
			len = this._mustHaveProperties.length;
			for (i = 0; i < len; i++)
			{
				if (!(client as Object).hasOwnProperty(
					this._mustHaveProperties[i]))
					return false;
			}
		}
		if (this._mustHaveParent)
		{
			other = client.parentClient();
			if (!other) return false;
			if (!this._mustHaveParent.matches(other)) return false;
		}
		if (this._mustHaveChildren)
		{
			others = client.childClients();
			len = others.length;
			for (i = 0; i < len; i++)
			{
				other = others[i];
				if (this._mustHaveChildren.indexOf(other.className()) < 0)
					return false;
			}
		}
		if (this._mustHaveDescendants)
		{
			others = this.descendantsOf(client);
			len = others.length;
			for (i = 0; i < len; i++)
			{
				other = others[i];
				if (this._mustHaveChildren.indexOf(other.className()) < 0)
					return false;
			}
		}
		if (this._mustHavePseudoClasses)
		{
			len = this._mustHavePseudoClasses.length;
			strings = client.pseudoClasses();
			for (i = 0; i < len; i++)
			{
				if (strings.indexOf(this._mustHavePseudoClasses[i]) < 0)
					return false;
			}
		}
		return true;
	}
	
	public function equails(to:CSSRule):Bool
	{
		if (this === to) return true;
		if (this._className !== to._className) return false;
		if (this._table !== to._table) return false;
		if (this._mustHaveProperties !== to._mustHaveProperties) return false;
		if (this._mustHaveParent !== to._mustHaveParent) return false;
		if (this._mustHaveChildren !== to._mustHaveChildren) return false;
		if (this._mustHaveDescendants !== to._mustHaveDescendants) return false;
		if (this._mustHavePseudoClasses !== to._mustHavePseudoClasses)
			return false;
		if (this._mustBeNth !== to._mustBeNth) return false;
		if (this._mustFollow !== to._mustFollow) return false;
		if (this._mustPrecede !== to._mustPrecede) return false;
		return true;
	}
	
	private function descendantsOf(client:ICSSClient):List<ICSSClient>
	{
		var i:int;
		var len:int;
		var v:List<ICSSClient> = client.childClients();
		var cv:List<ICSSClient>;
		
		if (!v) return null;
		len = v.length;
		for (i = 0; i < len; i++)
		{
			cv = this.descendantsOf(v[i]);
			if (cv) v = v.concat(cv);
		}
		return v;
	}
}