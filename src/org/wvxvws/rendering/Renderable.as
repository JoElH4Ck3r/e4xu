package org.wvxvws.rendering
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * Renderable class.
	 * @author wvxvw
	 */
	public class Renderable extends Sprite
	{
		protected var _bounds:Rectangle = new Rectangle();
		protected var _hasVisibleParts:Boolean;
		protected var _valid:Boolean;
		protected var _color:uint = 0xFF;
		protected var _alpha:Number = 1;
		protected var _port:Port;
		protected var _newBounds:Rectangle = new Rectangle();
		protected var _visibleBounds:Rectangle = new Rectangle();
		
		public override function get x():Number { return _newBounds.x; }
		
		public override function set x(value:Number):void 
		{
			_newBounds.x = value;
			valid = false;
		}
		
		public override function get y():Number { return _newBounds.y; }
		
		public override function set y(value:Number):void 
		{
			_newBounds.y = value;
			valid = false;
		}
		
		public override function get width():Number { return _newBounds.width; }
		
		public override function set width(value:Number):void 
		{
			_newBounds.width = value;
			valid = false;
		}
		
		public override function get height():Number { return _newBounds.height; }
		
		public override function set height(value:Number):void 
		{
			_newBounds.height = value;
			valid = false;
		}
		
		public function get valid():Boolean { return _valid; }
		
		public function set valid(value:Boolean):void 
		{
			if (value === _valid) return;
			if (value) removeEventListener(Event.ENTER_FRAME, renderHandler);
			else if (stage) addEventListener(Event.ENTER_FRAME, renderHandler);
			_valid = value;
		}
		
		public function get visibleWidth():int
		{
			return _visibleBounds.width;
		}
		
		public function get visibleHeight():int
		{
			return _visibleBounds.height;
		}
		
		public function Renderable()
		{
			super();
			//addEventListener(Event.ADDED_TO_STAGE, 
								//addedToStageHandler, false, 0, true);
			addEventListener(Event.ADDED, addedToStageHandler, false, 0, true);
		}
		
		protected function addedToStageHandler(event:Event):void 
		{
			if (parent is Port)
			{
				_port = parent as Port;
				drawIn((parent as Port).bounds);
				addEventListener(Event.REMOVED, removedHandler);
				addEventListener(Event.RENDER, renderHandler);
				if (stage && !_valid) 
					addEventListener(Event.ENTER_FRAME, renderHandler);
			}
		}
		
		protected function renderHandler(event:Event):void 
		{
			if (!(parent is Port) || !stage) return; //_bounds.equals(_newBounds) || 
			_bounds = _newBounds.clone();
			drawIn((parent as Port).bounds);
			_valid = true;
		}
		
		protected function removedHandler(event:Event):void 
		{
			if (parent is Port) clear();
			removeEventListener(Event.RENDER, renderHandler);
			valid = false;
		}
		
		public function drawIn(port:Rectangle):void
		{
			//trace("drawIn", stage);
			var cPort:Rectangle = port.clone();
			var dRect:Rectangle = 
				new Rectangle(port.x, port.y, _bounds.width, _bounds.height);
			var iRect:Rectangle;
			cPort.x = 0;
			cPort.y = 0;
			iRect = cPort.intersection(_bounds);
			if (!iRect.isEmpty())
			{
				dRect.width = iRect.width;
				dRect.height = iRect.height;
				dRect.x += iRect.x;
				dRect.y += iRect.y;
				drawInBounds(dRect);
			}
			else if (cPort.containsRect(_bounds))
			{
				dRect.x += _bounds.x;
				dRect.y += _bounds.y;
				drawInBounds(dRect);
			}
			else clear();
		}
		
		protected function clear():void
		{
			graphics.clear();
			_visibleBounds.x = 0;
			_visibleBounds.y = 0;
			_visibleBounds.width = 0;
			_visibleBounds.height = 0;
			_hasVisibleParts = false;
		}
		
		protected function drawInBounds(rect:Rectangle):void
		{
			_hasVisibleParts = true;
			_visibleBounds.x = rect.x;
			_visibleBounds.y = rect.y;
			_visibleBounds.width = rect.width;
			_visibleBounds.height = rect.height;
			graphics.clear();
			graphics.beginFill(_color, _alpha);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
		}
	}
	
}