package org.wvxvws.css
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class CSSTable
	{
		protected var _knownClasses:Object = { };
		protected var _global:CSSGlobal;
		
		public function CSSTable(global:CSSGlobal)
		{
			super();
			this._global = global;
		}
		
		public function global():CSSGlobal { return this._global; }
		
		public function getValueForClient(client:ICSSClient, property:String):Object
		{
			return null;
		}
	}
}