package org.wvxvws.parsers.as3.sinks.xml
{
	public class E4XNodeKind
	{
		public static const ELEMENT:E4XNodeKind = new E4XNodeKind();
		
		public static const ATTRIBUTE:E4XNodeKind = new E4XNodeKind();
		
		public static const COMMENT:E4XNodeKind = new E4XNodeKind();
		
		public static const PROCESSING_INSTRUCTION:E4XNodeKind = new E4XNodeKind();
		
		public static const CDATA:E4XNodeKind = new E4XNodeKind();
		
		public static const TEXT:E4XNodeKind = new E4XNodeKind();
		
		private static var _initialized:Boolean;
		
		public function E4XNodeKind()
		{
			super();
			if (_initialized) throw new ArgumentError();
		}
		
		public static function lock():void { _initialized = true; }
	}
}

import org.wvxvws.parsers.as3.sinks.xml.E4XNodeKind;

E4XNodeKind.lock();