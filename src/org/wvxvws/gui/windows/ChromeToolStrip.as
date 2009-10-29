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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.containers.Menu;
	import org.wvxvws.gui.containers.Pane;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.ToolStripRenderer;
	import org.wvxvws.gui.skins.SkinProducer;
	import org.wvxvws.managers.DragManager;
	//}
	
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
			super.dispatchEvent(new Event("dragHandleChanged"));
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
		public function get rendererProducer():SkinProducer { return _rendererProducer; }
		
		public function set rendererProducer(value:SkinProducer):void 
		{
			if (_rendererProducer === value) return;
			_rendererProducer = value;
			super.invalidate("_rendererProducer", _rendererProducer, false);
			super.invalidate("_dataProvider", _dataProvider, false);
			super.dispatchEvent(new Event("rendererProducerChanged"));
		}
		
		//------------------------------------
		//  Public property filter
		//------------------------------------
		
		[Bindable("filterChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>filterChanged</code> event.
		*/
		public function get filter():String { return _filter; }
		
		public function set filter(value:String):void 
		{
			if (_filter === value) return;
			_filter = value;
			super.invalidate("_filter", _filter, false);
			super.invalidate("_dataProvider", _dataProvider, false);
			super.dispatchEvent(new Event("filterChanged"));
		}
		
		public function get currentNode():XML { return _currentNode; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _rendererStates:Object;
		protected var _menu:Menu = new Menu();
		protected var _dragHandle:Sprite;
		protected var _rendererProducer:SkinProducer;
		protected var _currentNode:XML;
		protected var _clickLocation:Point = new Point();
		protected var _currentRenderer:DisplayObject;
		protected var _cumulativeWidth:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _cellWidth:int = int.MIN_VALUE;
		protected var _filter:String;
		protected var _gutter:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ChromeToolStrip()
		{
			super();
			super._rendererFactory = ToolStripRenderer;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Object):void 
		{
			if (_menu && ("_filter" in properties))
			{
				_menu.labelField = _filter;
			}
			super.validate(properties);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function layOutChildren():void
		{
			var hadMenu:Boolean;
			if (super.contains(_menu))
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
				_currentRenderer = _rendererProducer.produce(this);
			}
			else _currentRenderer = super.createChild(xml);
			if (!_currentRenderer) return null;
			_currentRenderer.addEventListener(MouseEvent.MOUSE_DOWN, 
									renderer_mouseDownHandler, false, 0, true);
			_currentRenderer.height = super.height - (_padding.top + _padding.bottom);
			if (_cellWidth !== int.MIN_VALUE) _currentRenderer.width = _cellWidth;
			_currentRenderer.y = _padding.top;
			_currentRenderer.height = super._bounds.y;
			super.addChild(_currentRenderer);
			if (_currentRenderer is IRenderer)
			{
				if (_filter !== "")
				{
					(_currentRenderer as IRenderer).labelField = _filter;
				}
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
		
		protected function renderer_mouseDownHandler(event:MouseEvent):void
		{
			var dos:DisplayObject = event.currentTarget as DisplayObject;
			var ir:IRenderer = event.currentTarget as IRenderer;
			if (_menu) _menu.collapseChildMenu();
			if (!ir || !ir.data.*.length())
			{
				if (super.contains(_menu)) super.removeChild(_menu);
				return;
			}
			_menu.x = dos.x;
			_menu.y = super._bounds.y;
			_menu.dataProvider = ir.data;
			_menu.backgroundAlpha = 1;
			_menu.backgroundColor = 0xFF0000;
			super.addChild(_menu);
			_menu.initialized(this, "menu");
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