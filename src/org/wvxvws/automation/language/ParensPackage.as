package org.wvxvws.automation.language
{
	public class ParensPackage
	{
		public function get name():String { return this._name; }
		
		private var _name:String;
		
		private const _internal:Object = { };
		
		private const _external:Object = { };
		
		public function ParensPackage(name:String)
		{
			super();
			this._name = name;
		}
		
		public function intern(name:String, value:*):void
		{
			this._internal[name] = value;
		}
		
		public function extern(name:String, value:*):void
		{
			this.intern(name, value);
			this._external[name] = value;
		}
		
		public function get(name:String, pack:ParensPackage = null):*
		{
			var result:*;
			
			if (pack === this) result = this._internal[name];
			else result = this._external[name];
			return result;
		}
		
		public function has(name:String, pack:ParensPackage = null):Boolean
		{
			var result:Boolean;
			
			if (pack === this) result = name in this._internal;
			else result = name in this._external;
			return result;
		}
	}
}