package org.wvxvws.automation.syntax
{
	import org.wvxvws.automation.language.Atom;

	public class Token
	{
		public var token:String;
		
		public var value:Atom;
		
		public var current:String;
		
		// This will change later
		public var error:String;
		
		public var cons:Class = Atom;
		
		public function Token() { super(); }
	}
}