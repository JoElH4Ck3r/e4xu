////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

package org.wvxvws.managers 
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.windows.IPane;
	import org.wvxvws.gui.windows.PaneEvent;
	//}
	
	/**
	 * WindowManager class.
	 * @author wvxvw
	 */
	public class WindowManager
	{
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _windows:Vector.<IPane> = new <IPane>[];
		private static var _events:Object = { };
		private static var _modal:IPane;
		private static var _choosen:IPane;
		private static var _stage:Stage;
		private static var _modalSprite:Sprite = new Sprite();
		
		private static const _tabbed:Dictionary = new Dictionary(true);
		private static const _moused:Dictionary = new Dictionary(true);
		private static const _mChildren:Dictionary = new Dictionary(true);
		private static const _tChildren:Dictionary = new Dictionary(true);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function WindowManager() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function init(stage:Stage):void
		{
			_stage = stage;
			_stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);
		}
		
		public static function append(window:IPane, 
							context:DisplayObjectContainer = null, 
							metrics:Rectangle = null):IPane
		{
			if (!window || !(window is DisplayObject)) return null;
			var modal:Boolean = context === null;
			if (modal) context = _stage;
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
			if (window is IMXMLObject)
			{
				(window as IMXMLObject).initialized(
								context, "window" + _windows.length);
			}
			if (metrics)
			{
				(window as DisplayObject).x = metrics.x;
				(window as DisplayObject).y = metrics.y;
				(window as DisplayObject).width = metrics.width;
				(window as DisplayObject).height = metrics.height;
			}
			if (!(window as DisplayObject).parent)
				context.addChild(window as DisplayObject);
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
		
		public static function attach(windowClass:Class, 
							context:DisplayObjectContainer = null, 
							metrics:Rectangle = null):IPane
		{
			var window:IPane = new windowClass();
			if (!window || !(window is DisplayObject)) return null;
			var modal:Boolean = context === null;
			if (modal) context = _stage;
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
			if (window is IMXMLObject)
			{
				(window as IMXMLObject).initialized(
								context, "window" + _windows.length);
			}
			if (metrics)
			{
				(window as DisplayObject).x = metrics.x;
				(window as DisplayObject).y = metrics.y;
				(window as DisplayObject).width = metrics.width;
				(window as DisplayObject).height = metrics.height;
			}
			if (!(window as DisplayObject).parent)
				context.addChild(window as DisplayObject);
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
				if (_modal == window) _modal = null;
				if (_choosen == window)
				{
					e = new PaneEvent(PaneEvent.DESELECTED, window);
					v = _events[PaneEvent.DESELECTED];
					for each (f in v) f(e.clone());
					_choosen.deselected();
					_choosen = null;
				}
				_windows.splice(i, 1);
			}
			if ((window as DisplayObject).parent)
			{
				(window as DisplayObject).parent.removeChild(
									window as DisplayObject);
			}
			if (!_windows.length) removeModalBG();
			else
			{
				_stage.setChildIndex(_modalSprite, _stage.numChildren - 2);
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
			var v:Vector.<Function>;
			if (!_events.evnetType) v = new <Function>[];
			if ((_events.evnetType as Vector.<Function>).indexOf(handler) > -1)
				return;
		}
		
		public static function removeHandler(eventType:String, handler:Function):void
		{
			if (!_events.evnetType) return;
			var i:int = (_events.evnetType as Vector.<Function>).indexOf(handler);
			if (i > -1) (_events.evnetType as Vector.<Function>).splice(i, 1)
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static function drawModalBG():void
		{
			if (_stage.contains(_modalSprite))
			{
				_stage.setChildIndex(_modalSprite, _stage.numChildren - 1);
				return;
			}
			var g:Graphics = _modalSprite.graphics;
			g.clear();
			g.beginFill(0xFFFFFF, 0.3);
			g.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			g.endFill();
			_modalSprite.mouseEnabled = false;
			_modalSprite.tabEnabled = false;
			_modalSprite.focusRect = false;
			var i:int = _stage.numChildren;
			var dos:DisplayObject;
			while (i--)
			{
				dos = _stage.getChildAt(i);
				if (dos is InteractiveObject)
				{
					_moused[dos] = (dos as InteractiveObject).mouseEnabled;
					_tabbed[dos] = (dos as InteractiveObject).tabEnabled;
					(dos as InteractiveObject).mouseEnabled = false;
					(dos as InteractiveObject).tabEnabled = false;
				}
				if (dos is DisplayObjectContainer)
				{
					_mChildren[dos] = (dos as DisplayObjectContainer).mouseChildren;
					_tChildren[dos] = (dos as DisplayObjectContainer).tabChildren;
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
		
		private static function stage_resizeHandler(event:Event):void 
		{
			if (_stage.contains(_modalSprite))
			{
				var g:Graphics = _modalSprite.graphics;
				g.clear();
				g.beginFill(0xFFFFFF, 0.2);
				g.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
				g.endFill();
			}
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
			_stage.focus = null;
			if (_stage.contains(_modalSprite)) _stage.removeChild(_modalSprite);
			var i:int = _stage.numChildren;
			var dos:DisplayObject;
			while (i--)
			{
				dos = _stage.getChildAt(i);
				if (dos is InteractiveObject)
				{
					(dos as InteractiveObject).mouseEnabled = _moused[dos];
					(dos as InteractiveObject).tabEnabled = _tabbed[dos];
				}
				if (dos is DisplayObjectContainer)
				{
					(dos as DisplayObjectContainer).mouseChildren = _mChildren[dos];
					(dos as DisplayObjectContainer).tabChildren = _tChildren[dos];
				}
			}
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}
	}
}