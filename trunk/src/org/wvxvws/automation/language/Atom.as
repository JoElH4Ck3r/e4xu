package org.wvxvws.automation.language
{
	public class Atom
	{
		public function get type():Object{ return this._type; }
		
		public function get name():String { return this._name; }
		
		protected var _value:*;
		
		protected var _name:String;
		
		protected var _type:Object;
		
		public function Atom(name:String, type:Object, value:* = undefined)
		{
			super();
			this._name = name;
			this._type = type;
			this._value = value;
		}
		
		public function eval(inContext:Scope):*
		{
			var result:*;
			
			switch (this._type)
			{
				case String:
				case Number:
				case int:
				case uint:
				case Boolean:
				case null:
				case undefined:
					result = this._value;
					break;
				default:
					result = inContext.resolve(this._name);
			}
			
			return result;
		}
		
		public function toString():String
		{
			var result:String;
			
			switch (this._type)
			{
				case String:
				case Number:
				case int:
				case uint:
				case Boolean:
				case null:
				case undefined:
					result = String(this._value);
					break;
				default:
					result = "#<" + this._name + ">";
			}
			return result;
		}
	}
}