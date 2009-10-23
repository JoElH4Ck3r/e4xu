package org.wvxvws.mapping 
{
	import flash.events.Event;
	
	/**
	 * MappingEvent event.
	 * @author wvxvw
	 */
	public class MappingEvent extends Event 
	{
		public override function get target():Object { return _target; }
		
		public function get originalEvent():Object { return _originalEvent; }
		
		private var _target:Object;
		private var _originalEvent:Event;
		
		public function MappingEvent(type:String, target:Object, originalEvent:Event = null) 
		{ 
			super(type);
			if (target) _target = target;
			_originalEvent = originalEvent;
		} 
		
		public override function clone():Event 
		{ 
			return new MappingEvent(this.type, _target, _originalEvent);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MappingEvent", "type"); 
		}
		
	}
	
}