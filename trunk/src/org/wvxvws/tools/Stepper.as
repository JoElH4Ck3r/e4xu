package org.wvxvws.tools 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import org.wvxvws.gui.DIV;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Stepper extends DIV
	{
		protected var _position:Number;
		protected var _step:Number;
		protected var _max:Number;
		protected var _min:Number;
		protected var _hasFocus:Boolean;
		
		protected var _field:TextField;
		protected var _incrementBTN:Sprite;
		protected var _decrementBTN:Sprite;
		
		public function Stepper() 
		{
			super();
			super.addEventListener(Event.ADDED_TO_STAGE, adtsHandler, false, 0, true);
		}
		
		private function adtsHandler(event:Event):void 
		{
			super.addEventListener(Event.REMOVED_FROM_STAGE, cleanup, false, 0, true);
			
		}
		
		protected function cleanup(event:Event = null):void 
		{
			
		}
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
			if (!_field)
			{
				_field = new TextField();
				_field.width = super.width;
				_field.height = super.height;
			}
		}
		
		public function increment():void
		{
			
		}
		
		public function decrement():void
		{
			
		}
	}

}