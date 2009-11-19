package org.wvxvws.cursor 
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	//}
	
	/**
	 * Cursor class.
	 * @author wvxvw
	 */
	public class Cursor
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static function get cursor():int { return _cursors.indexOf(_cursor); }
		
		public static function set cursor(value:int):void
		{
			if (value < 0)
			{
				if (_cursor && _cursor.stage) _stage.removeChild(_cursor);
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
					_cursor.filters = _filters;
					_stage.addChild(_cursor);
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public constants
		//
		//--------------------------------------------------------------------------
		
		public static const NONE:int = -6;
		public static const AUTO:int = -5;
		public static const ARROW:int = -4;
		public static const IBEAM:int = -3;
		public static const BUTTON:int = -2;
		public static const HAND:int = -1;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _stage:Stage;
		private static var _cursors:Vector.<DisplayObject> = new <DisplayObject>[];
		private static var _cursor:DisplayObject;
		private static var _filters:Array = [new DropShadowFilter(4, 45, 0, 0.5, 6, 6, 0.8)];
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Cursor() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function init(stage:Stage):void
		{
			_stage = stage;
			_stage.addEventListener(Event.ADDED, addedHandler, false, 0, true);
		}
		
		protected static function addedHandler(event:Event):void 
		{
			if (_cursor && _cursor.stage) _stage.addChild(_cursor);
		}
		
		public static function registerCursor(type:DisplayObject):int
		{
			if (_cursors.indexOf(type) < 0) return _cursors.push(type) - 1;
			return -1;
		}
		
		public static function enumerateCursors(closure:Function):void
		{
			var i:int;
			var j:int = _cursors.length;
			while (i < j)
			{
				if (closure(i, (_cursors[i] as Object).constructor)) break;
				i++;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private static function stage_rollOverHandler(event:MouseEvent):void 
		{
			if (_cursor) _cursor.visible = true;
		}
		
		private static function stage_mouseLeaveHandler(event:Event):void 
		{
			if (_cursor) _cursor.visible = false;
		}
		
		private static function stage_mouseMoveHandler(event:MouseEvent):void 
		{
			if (!_cursor) return;
			_cursor.visible = true;
			_cursor.x = event.stageX >> 0;
			_cursor.y = event.stageY >> 0;
		}
		
	}

}