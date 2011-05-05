package org.wvxvws.automation.language
{
	public class Cons extends Atom
	{
		protected var _car:Atom;
		
		protected var _cdr:Atom;
		
		public function Cons() { super("CONS", this); }
		
		public override function eval(inContext:Scope):*
		{
			var result:*;
			
			if (this._car) result = this._car.eval(inContext);
			if (this._cdr) result = this._cdr.eval(inContext);
			return result;
		}
		
		public override function toString():String
		{
			return "(" + atomToString(this._car, this._cdr) + ")";
		}
		
		protected static function atomToString(first:Atom, second:Atom):String
		{
			var result:String;
			var consString:String;
			
			if (first) result = first.toString();
			else result = "nil";
			if (second is Cons)
			{
				result += " " + 
					atomToString((second as Cons)._car, (second as Cons)._cdr);
			}
			else if (second) result += " . " + second;
			
			return result;
		}
		
		public static function cons(car:Atom, cdr:Atom):Cons
		{
			var result:Cons = new Cons();
			result._car = car;
			result._cdr = cdr;
			return result;
		}
		
		public static function car(value:Cons):Atom
		{
			return value._car;
		}
		
		public static function cdr(value:Cons):Atom
		{
			return value._cdr;
		}
	}
}