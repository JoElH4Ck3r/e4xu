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

package org.wvxvws.gui.containers
{
	//{imports
	import flash.display.DisplayObject
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.IRenderer;
	//}
	
	/**
	* Column class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Column extends Pane
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		
		public override function set width(value:Number):void 
		{
			if (value < _minWidth) return;
			super.width = value;
			_definedWidth = value;
		}
		
		public function get rendererFactory():Class { return _rendererFactory; }
		
		public function set rendererFactory(value:Class):void 
		{
			if (_rendererFactory === value) return;
			_rendererFactory = value;
			invalidate("_rendererFactory", _rendererFactory, false);
			dispatchEvent(new Event("rendererFactoryChanged"));
		}
		
		public function get cellHeight():int { return _cellHeight; }
		
		public function set cellHeight(value:int):void 
		{
			if (_cellHeight === value) return;
			_cellHeight = value;
			invalidate("_cellHeight", _cellHeight, false);
			dispatchEvent(new Event("cellHeightChanged"));
		}
		
		public function get filter():String { return _filter; }
		
		public function set filter(value:String):void 
		{
			if (_filter === value) return;
			_filter = value;
			invalidate("_filter", _filter, false);
			dispatchEvent(new Event("filterChanged"));
		}
		
		public function get gutter():int { return _gutter; }
		
		public function set gutter(value:int):void 
		{
			if (_gutter === value) return;
			_gutter = value;
			invalidate("_gutter", _gutter, false);
			dispatchEvent(new Event("gutterChanged"));
		}
		
		public function get padding():Rectangle { return _padding; }
		
		public function set padding(value:Rectangle):void 
		{
			if (_padding === value) return;
			_padding = value;
			invalidate("_padding", _padding, false);
			dispatchEvent(new Event("paddingChanged"));
		}
		
		public function get parentIsCreator():Boolean { return _parentIsCreator; }
		
		public function set parentIsCreator(value:Boolean):void 
		{
			if (_parentIsCreator === value) return;
			_parentIsCreator = value;
			invalidate("_parentIsCreator", _parentIsCreator, false);
			dispatchEvent(new Event("parentIsCreatorChanged"));
		}
		
		public function get currentRenderer():DisplayObject { return _currentRenderer; }
		
		public function get minWidth():int { return _minWidth; }
		
		public function get definedWidth():int { return _definedWidth; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _cellHeight:int = int.MIN_VALUE;
		protected var _itemCount:int;
		protected var _filter:String;
		protected var _cumulativeHeight:int;
		protected var _gutter:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _calculatedHeight:int;
		protected var _parentIsCreator:Boolean;
		protected var _currentRenderer:DisplayObject;
		protected var _minWidth:int = 20;
		protected var _definedWidth:int = -1;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Column() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Object):void 
		{
			if (super.width < _minWidth) _bounds.x = _minWidth;
			_cumulativeHeight = _padding.top;
			if (!_parentIsCreator)
			{
				super.validate(properties);
				_calculatedHeight = _padding.bottom + _cumulativeHeight - _gutter;
				drawBackground();
			}
		}
		
		public function createNextRow(from:XML = null):DisplayObject
		{
			var xml:XML = from || _dataProvider.*[_currentItem];
			_currentRenderer = super.createChild(xml);
			if (!_currentRenderer) return null;
			_currentRenderer.width = super.width - (_padding.left + _padding.right);
			_currentRenderer.y = _cumulativeHeight;
			_currentRenderer.x = _padding.left;
			super.addChild(_currentRenderer);
			if (_currentRenderer is IRenderer)
			{
				if (_filter !== "")
				{
					(_currentRenderer as IRenderer).labelField = _filter;
				}
			}
			return _currentRenderer;
		}
		
		public function adjustHeight(newHeight:int):void
		{
			_cumulativeHeight += newHeight;
		}
		
		public function beginLayoutChildren():void
		{
			_currentItem = 0;
			_removedChildren = new <DisplayObject>[];
			var i:int;
			while (super.numChildren > i)
				_removedChildren.push(super.removeChildAt(0));
		}
		
		public function endLayoutChildren(newHeight:int):void
		{
			_calculatedHeight = newHeight;
			drawBackground();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function layOutChildren():void
		{
			if (_dataProvider === null) return;
			if (!_dataProvider.*.length()) return;
			if (!_rendererFactory) return;
			_currentItem = 0;
			_removedChildren = new <DisplayObject>[];
			var i:int;
			while (super.numChildren > i)
				_removedChildren.push(super.removeChildAt(0));
			_dispatchCreated = false;
			if (!_parentIsCreator)
			{
				_dataProvider.*.(createChild(valueOf()));
				if (_dispatchCreated)
				{
					dispatchEvent(new GUIEvent(
						GUIEvent.CHILDREN_CREATED, false, true));
				}
			}
		}
		
		protected override function createChild(xml:XML):DisplayObject
		{
			_currentRenderer = super.createChild(xml);
			if (!_currentRenderer) return null;
			_currentRenderer.width = super.width - (_padding.left + _padding.right);
			if (_cellHeight !== int.MIN_VALUE) _currentRenderer.height = _cellHeight;
			_currentRenderer.y = _cumulativeHeight;
			_currentRenderer.x = _padding.left;
			_cumulativeHeight += _currentRenderer.height + _gutter;
			super.addChild(_currentRenderer);
			if (_currentRenderer is IRenderer)
			{
				if (_filter !== "")
				{
					(_currentRenderer as IRenderer).labelField = _filter;
				}
			}
			return _currentRenderer;
		}
		
		protected override function drawBackground():void
		{
			_background.clear();
			_background.beginFill(_backgroundColor, _backgroundAlpha);
			_background.drawRect(0, 0, _bounds.x, _calculatedHeight);
			_background.endFill();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
	}
}