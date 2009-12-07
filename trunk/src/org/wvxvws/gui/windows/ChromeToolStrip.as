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

package org.wvxvws.gui.windows 
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.containers.Menu;
	import org.wvxvws.gui.containers.Pane;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.ToolStripRenderer;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.managers.DragManager;
	import org.wvxvws.skins.Skin;
	import org.wvxvws.utils.KeyUtils;
	//}
	
	[Skin("org.wvxvws.skins.ToolStripSkin")]
	
	/**
	 * ToolStripChrome class.
	 * @author wvxvw
	 */
	public class ChromeToolStrip extends Pane
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public override function set dataProvider(value:XML):void 
		{
			var list:XMLList;
			var i:int;
			var j:int;
			var node:XML;
			var menu:Menu;
			if (value) list = value.*;
			j = list.length();
			_menus.length = 0;
			if (j)
			{
				while (i < j)
				{
					node = list[i];
					menu = new Menu();
					menu.layoutParent = this;
					menu.backgroundAlpha = 1;
					menu.backgroundColor = 0xFF0000;
					menu.itemClickHandler = _itemClickHandler;
					menu.dataProvider = node;
					menu.initiKeyListener();
					_menus.push(menu);
					i++;
				}
			}
			super.dataProvider = value;
		}
		
		//------------------------------------
		//  Public property dragHandle
		//------------------------------------
		
		[Bindable("dragHandleChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>dragHandleChanged</code> event.
		*/
		public function get dragHandle():Sprite { return _dragHandle; }
		
		public function set dragHandle(value:Sprite):void 
		{
			if (_dragHandle === value) return;
			if (_dragHandle && super.contains(_dragHandle)) 
				super.removeChild(_dragHandle);
			_dragHandle = value;
			if (_dragHandle)
			{
				_dragHandle.addEventListener(
					MouseEvent.MOUSE_DOWN, handle_mouseDownHandler);
			}
			super.invalidate("_dragHandle", _dragHandle, false);
			super.invalidate("_dataProvider", _dataProvider, false);
			if (super.hasEventListener(EventGenerator.getEventType("dataProvider")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property rendererProducer
		//------------------------------------
		
		[Bindable("rendererProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>rendererProducerChanged</code> event.
		*/
		public function get rendererProducer():ISkin { return _rendererProducer; }
		
		public function set rendererProducer(value:ISkin):void 
		{
			if (_rendererProducer === value) return;
			_rendererProducer = value;
			super.invalidate("_rendererProducer", _rendererProducer, false);
			super.invalidate("_dataProvider", _dataProvider, false);
			if (super.hasEventListener(EventGenerator.getEventType("rendererProducer")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get currentNode():XML { return _currentNode; }
		
		public function get itemClickHandler():Function { return _itemClickHandler; }
		
		public function set itemClickHandler(value:Function):void 
		{
			if (_itemClickHandler === value) return;
			_itemClickHandler = value;
			for each (var m:Menu in _menus)
			{
				m.itemClickHandler = _itemClickHandler;
				m.initiKeyListener();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _rendererStates:Object;
		protected var _menu:Menu;
		protected var _menus:Vector.<Menu> = new <Menu>[];
		protected var _dragHandle:Sprite;
		protected var _rendererProducer:ISkin;
		protected var _currentNode:XML;
		protected var _clickLocation:Point = new Point();
		protected var _currentRenderer:DisplayObject;
		protected var _cumulativeWidth:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _cellWidth:int = int.MIN_VALUE;
		protected var _filter:String;
		protected var _gutter:int;
		protected var _itemClickHandler:Function;
		protected var _activated:Boolean;
		protected var _activeRenderer:IRenderer;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ChromeToolStrip()
		{
			super();
			// TODO: remove this dependency
			super._rendererSkin = new Skin(ToolStripRenderer);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Object):void 
		{
			if (_menu && ("_labelSkin" in properties))
				_menu.labelSkin = _labelSkin;
			else if ("_labelSkin" in properties)
				properties._dataProvider = _dataProvider;
			super.validate(properties);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function adtsHandler(event:Event):void 
		{
			super.adtsHandler(event);
			KeyUtils.obtainStage(stage);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_menuUpHandler, false, 0, true);
		}
		
		protected function stage_menuUpHandler(event:MouseEvent):void 
		{
			var p:Point = new Point(super.mouseX, super.mouseY);
			var r:Rectangle = new Rectangle(0, 0, _bounds.x, _bounds.y);
			var a:Array = stage.getObjectsUnderPoint(p);
			if (_activated)
			{
				if (_menu && !r.containsPoint(p) && !_menu.hasMouse)
				{
					_menu.collapseChildMenu();
					super.removeChild(_menu);
					_activated = false;
				}
				else if (!_menu && !r.containsPoint(p))
				{
					_activated = false;
				}
			}
		}
		
		protected override function layOutChildren():void
		{
			var hadMenu:Boolean;
			if (_menu && super.contains(_menu))
			{
				_menu.collapseChildMenu();
				hadMenu = Boolean(super.removeChild(_menu));
			}
			if (_dragHandle && super.contains(_dragHandle))
			{
				super.removeChild(_dragHandle);
			}
			if (_dragHandle) _cumulativeWidth = _padding.top + _dragHandle.width;
			super.layOutChildren();
			if (hadMenu) super.addChild(_menu);
			if (!super.contains(_dragHandle)) super.addChild(_dragHandle);
		}
		
		protected override function createChild(xml:XML):DisplayObject
		{
			if (_rendererProducer)
			{
				_currentNode = xml;
				_currentRenderer = _rendererProducer.produce(this) as DisplayObject;
			}
			else _currentRenderer = super.createChild(xml);
			if (!_currentRenderer) return null;
			_currentRenderer.addEventListener(MouseEvent.MOUSE_DOWN, 
									renderer_mouseDownHandler, false, 0, true);
			_currentRenderer.addEventListener(MouseEvent.MOUSE_OVER, 
									renderer_mouseOverHandler, false, 0, true);
			_currentRenderer.height = super.height - (_padding.top + _padding.bottom);
			if (_cellWidth !== int.MIN_VALUE) _currentRenderer.width = _cellWidth;
			_currentRenderer.y = _padding.top;
			_currentRenderer.height = super._bounds.y;
			super.addChild(_currentRenderer);
			if (_currentRenderer is IRenderer)
			{
				if (_labelSkin)
					(_currentRenderer as IRenderer).labelSkin = _labelSkin;
			}
			if (_currentRenderer is ILayoutClient)
			{
				(_currentRenderer as ILayoutClient).validate(
					(_currentRenderer as ILayoutClient).invalidProperties);
			}
			_currentRenderer.x = _cumulativeWidth;
			_cumulativeWidth += _currentRenderer.width + _gutter;
			return _currentRenderer;
		}
		
		protected override function drawBackground():void
		{
			_background.clear();
			_background.beginFill(_backgroundColor, _backgroundAlpha);
			_background.drawRect(0, 0, 
				Math.max(_cumulativeWidth, super._bounds.x), _bounds.y);
			_background.endFill();
		}
		
		protected function renderer_mouseOverHandler(event:MouseEvent):void
		{
			var dos:DisplayObject = event.currentTarget as DisplayObject;
			if (_activeRenderer == dos || !_activated) return;
			_activeRenderer = dos as IRenderer;
			var node:XML;
			var list:XMLList;
			var i:int;
			var j:int;
			if (_activeRenderer && _activeRenderer.data) node = _activeRenderer.data;
			if (_dataProvider)
			{
				list = _dataProvider.*;
				j = list.length();
			}
			if (_menu && super.contains(_menu))
			{
				_menu.collapseChildMenu();
				super.removeChild(_menu);
			}
			while (i < j)
			{
				if (node === list[i])
				{
					_menu = _menus[i];
					_menu.x = dos.x;
					_menu.y = super._bounds.y;
					_menu.initialized(this, "menu");
				}
				i++;
			}
		}
		
		protected function renderer_mouseDownHandler(event:MouseEvent):void
		{
			var dos:DisplayObject = event.currentTarget as DisplayObject;
			_activeRenderer = dos as IRenderer;
			var node:XML;
			var list:XMLList;
			var i:int;
			var j:int;
			if (_activeRenderer && _activeRenderer.data) node = _activeRenderer.data;
			if (_dataProvider)
			{
				list = _dataProvider.*;
				j = list.length();
			}
			if (_activated)
			{
				if (_menu)
				{
					_menu.collapseChildMenu();
					super.removeChild(_menu);
				}
				_activated = false;
			}
			else
			{
				while (i < j)
				{
					if (node === list[i])
					{
						_menu = _menus[i];
						_menu.x = dos.x;
						_menu.y = super._bounds.y;
						_menu.initialized(this, "menu");
					}
					i++;
				}
				_activated = true;
			}
			super.scrollRect = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function handle_mouseDownHandler(event:MouseEvent):void 
		{
			_clickLocation.x = super.mouseX;
			_clickLocation.y = super.mouseY;
			DragManager.setDragTarget(this, _clickLocation);
			super.visible = false;
			super.stage.addEventListener(MouseEvent.MOUSE_UP, 
											stage_mouseUpHandler, false, 0, true);
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			DragManager.drop();
			super.x = parent.mouseX - _clickLocation.x;
			super.y = parent.mouseY - _clickLocation.y;
			super.visible = true;
		}
		
	}

}