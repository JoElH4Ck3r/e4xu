package org.wvxvws.parsers.as3.sinks.xml
{
	public class ReadExitState
	{
		public static const NODE_NAME:ReadExitState = new ReadExitState();
		
		public static const ATTRIBUTES:ReadExitState = new ReadExitState();
		
		private static var _initialized:Boolean;
		
		public function ReadExitState()
		{
			super();
			if (_initialized) throw new ArgumentError();
		}
		
		public static function initialize():void { _initialized = true; }
	}
}

import org.wvxvws.parsers.as3.sinks.xml.ReadExitState;

ReadExitState.initialize();