package org.wvxvws.cursor 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * Cursor class.
	 * @author wvxvw
	 */
	public class Cursor
	{
		public static const NONE:int = -3;
		public static const AUTO:int = -2;
		public static const ARROW:int = -1;
		public static const RESIZE_H:int = 0;
		public static const RESIZE_V:int = 1;
		public static const RESIZE_LR:int = 2;
		public static const RESIZE_RL:int = 3;
		public static const MOVE:int = 4;
		public static const ROTATE:int = 5;
		public static const SKEW_H:int = 7;
		public static const SKEW_V:int = 8;
		public static const WAIT:int = 9;
		public static const PAN:int = 10;
		public static const HELP:int = 11;
		public static const IBEAM:int = 12;
		public static const BUTTON:int = 13;
		public static const HAND:int = 14;
		
		private static var _stage:Stage;
		private static var _cursors:Vector.<DisplayObject>;
		private static var _cursor:DisplayObject;
		
		public function Cursor() { super(); }
		
		public static function init(stage:Stage):void { _stage = stage; }
		
		public function setCursors(cursors:Vector.<DisplayObject>):void
		{
			if (cursors)
				_cursors = cursors.concat();
			if (!_cursors) _cursors = new Vector.<DisplayObject>(12, false);
			while (_cursors.length < 14) _cursors.push(null);
		}
		
		public function set cursor(value:int):void
		{
			if (value < 0)
			{
				_cursor = null;
				Mouse.show();
				switch (value)
				{
					case ARROW:
						Mouse.cursor = MouseCursor.ARROW;
						break;
					default:
					case AUTO:
						Mouse.cursor = MouseCursor.AUTO;
						break;
					case NONE:
						Mouse.hide();
						break;
				}
			}
			else
			{
				Mouse.hide();
				switch (value)
				{
					case IBEAM:
						if (!_cursors[value])
						{
							Mouse.show();
							Mouse.cursor = MouseCursor.IBEAM;
						}
						else _cursor = _cursors[value];
						break;
					case BUTTON:
						if (!_cursors[value])
						{
							Mouse.show();
							Mouse.cursor = MouseCursor.BUTTON;
						}
						else _cursor = _cursors[value];
						break;
					case HAND:
						if (!_cursors[value])
						{
							Mouse.show();
							Mouse.cursor = MouseCursor.HAND;
						}
						else _cursor = _cursors[value];
						break;
					default:
						_cursor = _cursors[value];
						break;
				}
				if (_cursor)
				{
					if (_cursor is InteractiveObject)
					{
						(_cursor as InteractiveObject).mouseEnabled = false;
						(_cursor as InteractiveObject).focusRect = false;
						(_cursor as InteractiveObject).tabEnabled = false;
					}
					if (_cursor is DisplayObjectContainer)
					{
						(_cursor as DisplayObjectContainer).mouseChildren = false;
						(_cursor as DisplayObjectContainer).tabChildren = false;
					}
					_stage.addEventListener(MouseEvent.MOUSE_MOVE, 
							stage_mouseMoveHandler, false, 0, true);
					_stage.addEventListener(Event.MOUSE_LEAVE, 
							stage_mouseLeaveHandler, false, 0, true);
					_stage.addEventListener(MouseEvent.ROLL_OVER, 
							stage_rollOverHandler, false, 0, true);
					_cursor.x = _stage.mouseX;
					_cursor.y = _stage.mouseY;
					_stage.addChild(_cursor);
				}
			}
		}
		
		protected function stage_rollOverHandler(event:MouseEvent):void 
		{
			if (_cursor) _cursor.visible = true;
		}
		
		protected function stage_mouseLeaveHandler(event:Event):void 
		{
			if (_cursor) _cursor.visible = false;
		}
		
		protected function stage_mouseMoveHandler(event:MouseEvent):void 
		{
			if (!_cursor) return;
			_cursor.x = event.stageX;
			_cursor.y = event.stageY;
		}
		
		public function get cursor():int { return _cursors.indexOf(_cursor); }
	}

}