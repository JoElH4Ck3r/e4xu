package org.wvxvws.automation.types
{
	import org.wvxvws.automation.language.Atom;
	
	public class $Symbol extends Atom
	{
		public function $Symbol(name:String, type:Object)
		{
			super(name, type, name);
		}
		
		public override function toString():String
		{
			return this._name;
		}
	}
}