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
		
		public function get index():int { return this._repeater.index; }
		
		public function get currentItem():Object { return this._repeater.currentItem; }
		
		private var _repeater:IRepeater;
		private var _handled:Boolean;
		
		public function RepeaterEvent(type:String, repeater:IRepeater) 
		{ 
			super(type);
			this._repeater = repeater;
		} 
		
		public override function clone():Event
		{
			if (!this._handled)
			{
				this._handled = true;
				return this;
			}
			return new RepeaterEvent(super.type, this._repeater);
		} 
		
		public override function toString():String 
		{ 
			return super.formatToString("RepeaterEvent", "type", "index", "currentItem"); 
		}
	}
}