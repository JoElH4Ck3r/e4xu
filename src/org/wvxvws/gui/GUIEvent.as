package org.wvxvws.gui 
{
	import flash.events.Event;
	
	/**
	* GUIEvent event.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class GUIEvent extends Event 
	{
		public static const INITIALIZED:String = "initialized";
		public static const VALIDATED:String = "validated";
		public static const CHILDREN_CREATED:String = "childrenCreated";
		
		public function GUIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new GUIEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GUIEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}