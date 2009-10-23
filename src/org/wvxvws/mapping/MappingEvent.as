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
		
		public function get fault():Object { return _fault; }
		
		public function get result():Object { return _result; }
		
		private var _target:Object;
		private var _fault:Object;
		private var _result:Object;
		
		public function MappingEvent(type:String, target:Object, 
									fault:Object = null, result:Object = null) 
		{ 
			super(type);
			if (target) _target = target;
			_fault = fault;
			_result = result;
		} 
		
		public override function clone():Event 
		{ 
			return new MappingEvent(this.type, _target, _fault, _result);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MappingEvent", "type"); 
		}
		
	}
	
}