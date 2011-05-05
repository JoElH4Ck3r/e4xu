package org.wvxvws.automation.language
{
	public class Quote extends Atom
	{
		public function Quote(name:String, type:Object, value:* = undefined)
		{
			super(name, type, value);
		}
		
		public override function eval(inContext:Scope):*
		{
			return this;
		}
		
		public function lateEval(inContext:Scope):*
		{
			return super.eval(inContext);
		}
	}
}