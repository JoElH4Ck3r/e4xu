package org.wvxvws.managers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.windows.IPane;
	import org.wvxvws.gui.windows.PaneEvent;
	
	/**
	 * WindowManager class.
	 * @author wvxvw
	 */
	public class WindowManager
	{
		private static var _windows:Vector.<IPane> = new <IPane>[];
		private static var _events:Object = { };
		private static var _modal:IPane;
		private static var _choosen:IPane;
		private static var _stage:Stage;
		private static var _modalSprite:Sprite = new Sprite();
		
		public function WindowManager() { super(); }
		
		public static function init(stage:Stage):void { _stage = stage; }
		
		public static function attach(windowClass:Class, 
							context:DisplayObjectContainer = null, 
							metrics:Rectangle = null):IPane
		{
			var window:IPane = new windowClass();
			if (!window || !(window is DisplayObject)) return null;
			var modal:Boolean = context === null;
			if (!modal) context = _stage;
			var v:Vector.<Function>;
			var e:PaneEvent;
			var f:Function;
			var lastChoosen:IPane = _choosen;
			v = _events[PaneEvent.ATTACHED];
			if (v)
			{
				e = new PaneEvent(PaneEvent.ATTACHED, window);
				for each (f in v) f(e.clone());
			}
			if (modal)
			{
				_modal = window;
				drawModalBG();
			}
			if (metrics is IMXMLObject)
			{
				(metrics as IMXMLObject).initialized(
								context, "window" + _windows.length);
			}
			if (metrics)
			{
				(window as DisplayObject).x = metrics.x;
				(window as DisplayObject).y = metrics.y;
				(window as DisplayObject).width = metrics.width;
				(window as DisplayObject).height = metrics.height;
			}
			context.addChild(window);
			_windows.push(window);
			window.created();
			_choosen == window;
			window.choosen();
			if (lastChoosen)
			{
				e = new PaneEvent(PaneEvent.DESELECTED, lastChoosen);
				v = _events[PaneEvent.DESELECTED];
				for each (f in v) f(e.clone());
			}
			window.expanded();
			return window;
		}
		
		public static function destroy(window:IPane):void
		{
			var i:int = _windows.indexOf(window);
			var v:Vector.<Function>;
			var e:PaneEvent;
			var f:Function;
			if (i > -1)
			{
				v = _events[PaneEvent.DESTROYED];
				if (v)
				{
					e = new PaneEvent(PaneEvent.DESTROYED, window);
					for each (f in v) f(e.clone());
				}
				window.destroyed();
				v.splice(i, 1);
				if (_modal == window) _modal = null;
				if (_choosen == window)
				{
					e = new PaneEvent(PaneEvent.DESELECTED, window);
					v = _events[PaneEvent.DESELECTED];
					for each (f in v) f(e.clone());
					_choosen.deselected();
					_choosen = null;
				}
			}
		}
		
		public static function choose(window:IPane):Boolean
		{
			if (_modal && _modal !== window) return false;
			var i:int = _windows.indexOf(window);
			var v:Vector.<Function>;
			var e:PaneEvent;
			var f:Function;
			if (i > -1)
			{
				v = _events[PaneEvent.CHOOSEN];
				if (v)
				{
					e = new PaneEvent(PaneEvent.CHOOSEN, window);
					for each (f in v) f(e.clone());
				}
				if (_choosen && _choosen !== window)
				{
					e = new PaneEvent(PaneEvent.DESELECTED, window);
					v = _events[PaneEvent.DESELECTED];
					for each (f in v) f(e.clone());
					_choosen.deselected();
				}
				_choosen = window;
				window.choosen();
			}
			return i > -1;
		}
		
		public static function collapse(window:IPane):void
		{
			var i:int = _windows.indexOf(window);
			var v:Vector.<Function>;
			var e:PaneEvent;
			var f:Function;
			if (i > -1)
			{
				v = _events[PaneEvent.COLLAPSED];
				if (v)
				{
					e = new PaneEvent(PaneEvent.COLLAPSED, window);
					for each (f in v) f(e.clone());
				}
				if (_choosen === window)
				{
					e = new PaneEvent(PaneEvent.DESELECTED, window);
					v = _events[PaneEvent.DESELECTED];
					for each (f in v) f(e.clone());
					window.deselected();
				}
			}
		}
		
		public static function expand(window:IPane):void
		{
			
		}
		
		public static function addHandler(eventType:String, handler:Function):void
		{
			if (!_events.evnetType) = new <Function>[];
			if ((_events.evnetType as Vector.<Function>).indexOf(handler) > -1)
				return;
		}
		
		public static function removeHandler(eventType:String, handler:Function):void
		{
			if (!_events.evnetType) return;
			var i:int = (_events.evnetType as Vector.<Function>).indexOf(handler);
			if (i > -1) (_events.evnetType as Vector.<Function>).splice(i, 1)
		}
		
		private static function drawModalBG():void
		{
			var g:Graphics = _modalSprite.graphics;
			g.clear();
			g.beginFill(0xFFFFFF, 0.2);
			g.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			g.endFill();
			_modalSprite.mouseEnabled = false;
			_modalSprite.tabEnabled = false;
			_modalSprite.focusRect = null;
			var i:int = _stage.numChildren;
			var dos:DisplayObject;
			while (i--)
			{
				dos = _stage.getChildAt(i);
				if (dos is InteractiveObject)
				{
					(dos as InteractiveObject).mouseEnabled = false;
					(dos as InteractiveObject).tabEnabled = false;
				}
				if (dos is DisplayObjectContainer)
				{
					(dos as DisplayObjectContainer).mouseChildren = false;
					(dos as DisplayObjectContainer).tabChildren = false;
				}
			}
			_stage.focus = _modalSprite;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, 
									stage_keyDownHandler, false, int.MAX_VALUE);
			_stage.addEventListener(KeyboardEvent.KEY_UP, 
									stage_keyUpHandler, false, int.MAX_VALUE);
			_stage.addChild(_modalSprite);
		}
		
		private static function stage_keyUpHandler(event:KeyboardEvent):void 
		{
			event.stopImmediatePropagation();
		}
		
		private static function stage_keyDownHandler(event:KeyboardEvent):void 
		{
			event.stopImmediatePropagation();
		}
		
		private static function removeModalBG():void
		{
			if (_stage.contains(_modalSprite)) _stage.addChild(_modalSprite);
			var i:int = _stage.numChildren;
			var dos:DisplayObject;
			while (i--)
			{
				dos = _stage.getChildAt(i);
				if (dos is InteractiveObject)
				{
					(dos as InteractiveObject).mouseEnabled = true;
					(dos as InteractiveObject).tabEnabled = true;
				}
				if (dos is DisplayObjectContainer)
				{
					(dos as DisplayObjectContainer).mouseChildren = true;
					(dos as DisplayObjectContainer).tabChildren = true;
				}
			}
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}
	}
}