package org.wvxvws.gui.repeaters 
{
	import flash.events.Event;
	
	/**
	 * RepeaterEvent event.
	 * @author wvxvw
	 */
	public class RepeaterEvent extends Event 
	{
		public static const REPEAT:String = "repeat";
		
		public function get index():int { return _repeater.index; }
		
		public function get currentItem():Object { return _repeater.currentItem; }
		
		private var _repeater:IRepeater;
		
		public function RepeaterEvent(type:String, repeater:IRepeater) 
		{ 
			super(type);
			_repeater = repeater;
		} 
		
		public override function clone():Event { return this; } 
		
		public override function toString():String 
		{ 
			return formatToString("RepeaterEvent", "type", "index", "currentItem"); 
		}
	}
}