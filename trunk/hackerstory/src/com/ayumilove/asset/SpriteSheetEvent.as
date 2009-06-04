package com.ayumilove.assets 
{
	import flash.events.Event;
	
	/**
	 * SpriteSheetEvent event.
	 * @author wvxvw
	 */
	public class SpriteSheetEvent extends Event 
	{
		public static const READY:String = "ready";
		
		public function SpriteSheetEvent(type:String) 
		{ 
			super(type);
			
		} 
		
		public override function clone():Event 
		{ 
			return new SpriteSheetEvent(type);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SpriteSheetEvent", "type"); 
		}
		
	}
	
}