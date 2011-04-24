package org.wvxvws.parsers.as3.sinks.xml
{
	public class E4XReadState
	{
		public static const LT:E4XReadState = new E4XReadState();
		
		public static const NAME:E4XReadState = new E4XReadState();
		
		public static const ATTRIBUTE:E4XReadState = new E4XReadState();
		
		public static const GT:E4XReadState = new E4XReadState();
		
		public static const TAIL:E4XReadState = new E4XReadState();
		
		public static const BRACKET:E4XReadState = new E4XReadState();
		
		public static const BACK:E4XReadState = new E4XReadState();
		
		public static const CONTINUE:E4XReadState = new E4XReadState();
		
		private static var _initialized:Boolean;
		
		public function E4XReadState()
		{
			super();
			if (_initialized) throw new ArgumentError();
		}
		
		public static function lock():void { _initialized = true; }
		
		public function toString():String
		{
			var result:String = "[object E4XReadState name=";
			
			switch (this)
			{
				case LT: result += "lt"; break;
				case ATTRIBUTE: result += "attribute"; break;
				case NAME: result += "name"; break;
				case GT: result += "gt"; break;
				case TAIL: result += "tail"; break;
				case BRACKET: result += "bracket"; break;
				case BACK: result += "back"; break;
				case CONTINUE: result += "continue"; break;
			}
			return result + "]";
		}
	}
}

import org.wvxvws.parsers.as3.sinks.xml.E4XReadState;

E4XReadState.lock();