package org.wvxvws.gui.windows 
{
	import flash.events.Event;
	
	/**
	 * PaneEvent event.
	 * @author wvxvw
	 */
	public class PaneEvent extends Event 
	{
		public static const ATTACHED:String = "attached";
		public static const DESTROYED:String = "destroyed";
		public static const CHOOSEN:String = "choosen";
		public static const COLLAPSED:String = "collapsed";
		public static const OPENED:String = "opened";
		public static const UNCHOOSEN:String = "unchoosen";
		
		private var _window:IPane;
		
		public function PaneEvent(type:String, window:IPane) 
		{ 
			super(type);
			_window = window;
		} 
		
		public override function get target():Object { return _window; }
		
		public override function clone():Event 
		{ 
			return new PaneEvent(type, _window);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PaneEvent", "type"); 
		}
		
	}
	
}