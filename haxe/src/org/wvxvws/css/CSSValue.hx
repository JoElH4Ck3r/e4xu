/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.css;

class CSSValue 
{
	//--------------------------------------------------------------------------
	//  Private properties
	//--------------------------------------------------------------------------
	
	private var _isByRef:Bool;
	private var _isNew:Bool;
	private var _isSimple:Bool;
	private var _type:Class;
	private var _ns:Namespace;
	private var _evalChain:List<String>;
	private var _cachedValue:*;
	private var _scope:Int;
	
	//--------------------------------------------------------------------------
	//  Constructor
	//--------------------------------------------------------------------------
	
	public function new() { }
	
	//--------------------------------------------------------------------------
	//  Public methods
	//--------------------------------------------------------------------------
	
	public function value()
	{
		if (this._isSimple) return this._cachedValue;
		if (this._isByRef)
		{
			if (this._cachedValue === undefined)
			{
				
			}
		}
	}
	
	public function dispose():Void
	{
		if ((this._cachedValue is Object) && 
			this._cachedValue.hasOwnProperty("dispose") && 
			this._cachedValue["dispose"] is Function)
		{
			try { this._cachedValue["dispose"](); }
			catch (error:Dynamic) { }
		}
		this._cachedValue = null;
	}
}