package org.wvxvws.rendering
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * Port class.
	 * @author wvxvw
	 */
	public class Port extends Sprite
	{
		protected var _bounds:Rectangle = new Rectangle();
		protected var _invalidLayout:Boolean;
		protected var _updater:Event = new Event(Event.RENDER);
		
		public override function get x():Number { return _bounds.x; }
		
		public override function set x(value:Number):void 
		{
			if (_bounds.x == value) return;
			_bounds.x = value;
			invalidLayout = true;
		}
		
		public override function get y():Number { return _bounds.y; }
		
		public override function set y(value:Number):void 
		{
			if (_bounds.y == value) return;
			_bounds.y = value;
			invalidLayout = true;
		}
		
		public override function get width():Number { return _bounds.width; }
		
		public override function set width(value:Number):void 
		{
			if (_bounds.width == value) return;
			_bounds.width = value;
			invalidLayout = true;
		}
		
		public override function get height():Number { return _bounds.height; }
		
		public override function set height(value:Number):void 
		{
			if (_bounds.height == value) return;
			_bounds.height = value;
			invalidLayout = true;
		}
		
		public function Port()
		{
			super();
			super.addEventListener(Event.RENDER, renderListener);
			super.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			super.dispatchEvent(_updater);
		}
		
		private function addedHandler(event:Event):void 
		{
			renderHandler(null);
		}
		
		private function renderListener(event:Event):void 
		{
			removeEventListener(Event.RENDER, renderListener);
		}
		
		public function get bounds():Rectangle { return _bounds; }
		
		public function get invalidLayout():Boolean { return _invalidLayout; }
		
		public function set invalidLayout(value:Boolean):void 
		{
			if (value === _invalidLayout) return;
			if (value) addEventListener(Event.ENTER_FRAME, renderHandler);
			else removeEventListener(Event.ENTER_FRAME, renderHandler);
			_invalidLayout = value;
		}
		
		protected function renderHandler(event:Event):void 
		{
			var i:int = numChildren;
			graphics.clear();
			graphics.beginFill(0, .2);
			graphics.drawRect(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
			graphics.endFill();
			while (i--) getChildAt(i).dispatchEvent(_updater);
			invalidLayout = false;
		}
		
	}
	
}