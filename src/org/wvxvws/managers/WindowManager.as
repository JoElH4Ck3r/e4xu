package org.wvxvws.managers 
{
	import flash.display.Stage;
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
		
		public function WindowManager() { super(); }
		
		public static function init(stage:Stage):void { _stage = stage; }
		
		public static function attach(windowClass:Class, modal:Boolean):IPane
		{
			
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
					e = new PaneEvent(PaneEvent.UNCHOOSEN, window);
					v = _events[PaneEvent.UNCHOOSEN];
					for each (f in v) f(e.clone());
					_choosen.unchoosen();
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
					e = new PaneEvent(PaneEvent.UNCHOOSEN, window);
					v = _events[PaneEvent.UNCHOOSEN];
					for each (f in v) f(e.clone());
					_choosen.unchoosen();
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
					e = new PaneEvent(PaneEvent.UNCHOOSEN, window);
					v = _events[PaneEvent.UNCHOOSEN];
					for each (f in v) f(e.clone());
					window.unchoosen();
				}
			}
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
	}
}