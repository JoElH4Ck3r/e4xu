package org.wvxvws.gui 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.wvxvws.binding.EventGenerator;
	
	[Event(name="scrolled", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * ScrollPane class.
	 * @author wvxvw
	 */
	public class ScrollPane extends Sprite
	{
		public override function get width():Number { return _realWidth; }
		
		public override function get height():Number { return _realHeight; }
		
		public function set realWidth(value:int):void
		{
			if (_realWidth === value) return;
			_realWidth = value;
			if (super.hasEventListener(EventGenerator.getEventType("width")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function set realHeight(value:int):void
		{
			if (_realHeight === value) return;
			_realHeight = value;
			if (super.hasEventListener(EventGenerator.getEventType("height")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public override function set scrollRect(value:Rectangle):void 
		{
			if (super.scrollRect && super.scrollRect.equals(value)) return;
			super.scrollRect = value;
			if (super.hasEventListener(GUIEvent.SCROLLED))
				super.dispatchEvent(new GUIEvent(GUIEvent.SCROLLED));
		}
		
		protected var _realWidth:int;
		protected var _realHeight:int;
		
		public function ScrollPane() { super(); }
	}
}