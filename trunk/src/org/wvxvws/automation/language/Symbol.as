package org.wvxvws.automation.language
{
	public class Symbol extends Atom
	{
		// Maybe callable
		private var _function:Function;
		
		private var _package:Package;
		
		private var _properties:Cons;
		
		public function Symbol(name:String, type:Object, value:* = undefined)
		{
			super(name, type, value);
		}
		
		public override function eval(inContext:Scope):* { return this; }
		
		public override function toString():String
		{
			return "#" + super._name;
		}
	}
}