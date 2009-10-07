package org.wvxvws.tools 
{
	import flash.events.Event;
	
	/**
	 * ToolEvent event.
	 * @author wvxvw
	 */
	public class ToolEvent extends Event 
	{
		public static const MOVED:String = "moved";
		public static const RESIZED:String = "resized";
		public static const RESIZE_START:String = "resizeStart";
		public static const RESIZE_END:String = "resizeEnd";
		public static const RESIZE_REQUEST:String = "resizeRequest";
		public static const ROTATED:String = "rotated";
		public static const DISTORTED:String = "distorted";
		
		private var _toolTarget:Object;
		
		public function ToolEvent(type:String, bubbles:Boolean = false, 
					cancelable:Boolean = false, toolTarget:Object = null)
		{ 
			super(type, bubbles, cancelable);
			_toolTarget = toolTarget;
		} 
		
		public override function clone():Event 
		{ 
			return new ToolEvent(type, bubbles, cancelable, toolTarget);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ToolEvent", "type", "bubbles", "cancelable", "toolTarget"); 
		}
		
		public function get toolTarget():Object { return _toolTarget; }
		
	}
	
}