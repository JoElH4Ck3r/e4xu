package org.wvxvws.gui 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="dataChanged", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Bar extends DIV
	{
		protected var _body:Sprite;
		protected var _handle:Sprite;
		protected var _position:Number = 0.5;
		protected var _direction:Boolean;
		
		public function Bar() { super(); }
		
		public function get position():Number { return _position; }
		
		public function set position(value:Number):void 
		{
			var temp:Number = Math.max(Math.min(value, 1), 0);
			if (temp === _position) return;
			invalidate("_position", temp, false);
			_position = temp;
			dispatchEvent(new Event("positionChange"));
			dispatchEvent(new GUIEvent(GUIEvent.DATA_CHANGED));
		}
		
		public function get handle():Sprite { return _handle; }
		
		public function set handle(value:Sprite):void 
		{
			if (_handle === value) return;
			invalidate("_handle", _handle, false);
			if (_handle && super.contains(_handle))
				super.removeChild(_handle);
			_handle = value;
			dispatchEvent(new Event("handleChange"));
		}
		
		public function get body():Sprite { return _body; }
		
		public function set body(value:Sprite):void 
		{
			if (_body === value) return;
			invalidate("_body", _body, false);
			if (_body && super.contains(_body))
				super.removeChild(_body);
			_body = value;
			dispatchEvent(new Event("bodyChange"));
		}
		
		public function get direction():Boolean { return _direction; }
		
		public function set direction(value:Boolean):void 
		{
			if (value === _direction) return;
			_direction = value;
			invalidate("_direction", _direction, true);
			dispatchEvent(new Event("directionChange"));
		}
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
			if (!_body) _body = drawRect();
			if (!super.contains(_body)) super.addChild(_body);
			if (!_handle) _handle = drawRect();
			if (!super.contains(_handle)) super.addChild(_handle);
			if (super.getChildAt(0) === _handle)
			{
				super.swapChildren(_handle, _body);
			}
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handle_mouseDownHandler);
			if (_direction)
			{
				_body.width = super.width;
				_body.y = (super.height - _body.height) >> 1;
				_handle.y = (super.height - _handle.height) >> 1;
				_handle.x = (super.width - _handle.width) * _position;// - (_handle.width >> 1);
			}
		}
		
		private function handle_mouseDownHandler(event:MouseEvent):void 
		{
			if (stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, 
							stage_mouseUpHandler, false, 0, true);
			}
			else
			{
				_handle.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
			super.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void 
		{
			if (_direction) position = super.mouseX / super.width;
			else position = super.mouseY / super.height;
		}
		
		private function stage_mouseUpHandler(event:MouseEvent):void 
		{
			super.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_handle.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
		}
		
		protected function drawRect():Sprite
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			g.beginFill(0xFFFFFF * Math.random());
			g.drawRect(0, 0, 20, 20);
			g.endFill();
			return s;
		}
	}
	
}