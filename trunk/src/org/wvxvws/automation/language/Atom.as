package org.wvxvws.automation.language
{
	import org.wvxvws.automation.types.Char;

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
			trace("--- creating atom:", name);
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
				case Char:
					result = (this._value as Char).valueOf();
					break;
				default:
					result = inContext.resolve(this._name);
			}
			
			return result;
		}
		
		public function toString():String
		{
			var result:String;
			// TODO: we probably should ask the readtable about the case...
			switch (this._type)
			{
				case Number:
					result = Number(this._value).toString();
					break;
				case int:
					result = int(this._value).toString();
					break;
				case uint:
					result = uint(this._value).toString();
					break;
				case Boolean:
					if (this._value)
					{
						result = "T";
						break;
					}
				case null:
				case undefined:
					if (this._name) result = this._name;
					else result = "NIL";
					break;
				case Char:
					result = "#" + (this._value as Char).toString();
					break;
				case String:
					result = "\"" + this._value + "\"";
					break;
				default:
					result = "#" + this._name + "";
			}
			return result;
		}
	}
}