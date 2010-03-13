/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.css;

class CSSTable 
{
	private var _knownClasses:Hash<CSSRule>;
	private var _global:CSSGlobal;
	
	public function new(global:CSSGlobal)
	{
		super();
		this._global = global;
	}
	
	public function global():CSSGlobal { return this._global; }
	
	public function getValueForClient(client:ICSSClient, property:String)
	{
		return null;
	}
}