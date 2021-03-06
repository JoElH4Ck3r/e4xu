﻿////////////////////////////////////////////////////////////////////////////////
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
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.skins.ISkin;
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
		
		//------------------------------------
		//  Public property width
		//------------------------------------
		
		public override function set width(value:Number):void 
		{
			if (value < _minWidth) return;
			super.width = value;
			_definedWidth = value;
		}
		
		//------------------------------------
		//  Public property rendererFactory
		//------------------------------------
		
		[Bindable("rendererFactoryChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>rendererFactoryChanged</code> event.
		*/
		public function get rendererFactory():ISkin { return _rendererSkin; }
		
		public function set rendererFactory(value:ISkin):void 
		{
			if (_rendererSkin === value) return;
			_rendererSkin = value;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("rendererFactory")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property cellHeight
		//------------------------------------
		
		[Bindable("cellHeightChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>cellHeightChanged</code> event.
		*/
		public function get cellHeight():int { return _cellHeight; }
		
		public function set cellHeight(value:int):void 
		{
			if (_cellHeight === value) return;
			_cellHeight = value;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("cellHeight")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property gutter
		//------------------------------------
		
		[Bindable("gutterChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>gutterChanged</code> event.
		*/
		public function get gutter():int { return _gutter; }
		
		public function set gutter(value:int):void 
		{
			if (_gutter === value) return;
			_gutter = value;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("gutter")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property padding
		//------------------------------------
		
		[Bindable("paddingChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>paddingChanged</code> event.
		*/
		public function get padding():Rectangle { return _padding; }
		
		public function set padding(value:Rectangle):void 
		{
			if (_padding === value) return;
			_padding = value;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("padding")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property parentIsCreator
		//------------------------------------
		
		[Bindable("parentIsCreatorChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>parentIsCreatorChanged</code> event.
		*/
		public function get parentIsCreator():Boolean { return _parentIsCreator; }
		
		public function set parentIsCreator(value:Boolean):void 
		{
			if (_parentIsCreator === value) return;
			_parentIsCreator = value;
			super.invalidate(Invalides.DATAPROVIDER, false);
			if (super.hasEventListener(EventGenerator.getEventType("parentIsCreator")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property currentRenderer
		//------------------------------------
		
		public function get currentRenderer():DisplayObject { return _currentRenderer; }
		
		//------------------------------------
		//  Public property minWidth
		//------------------------------------
		
		public function get minWidth():int { return _minWidth; }
		
		//------------------------------------
		//  Public property definedWidth
		//------------------------------------
		
		public function get definedWidth():int { return _definedWidth; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _cellHeight:int = int.MIN_VALUE;
		protected var _itemCount:int;
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
		
		public override function validate(properties:Dictionary):void 
		{
			if (super.width < _minWidth) _bounds.x = _minWidth;
			_cumulativeHeight = _padding.top;
			if (!_parentIsCreator)
			{
				super.validate(properties);
				_calculatedHeight = _padding.bottom + _cumulativeHeight - _gutter;
				this.drawBackground();
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
				if (_labelSkin)
					(_currentRenderer as IRenderer).labelSkin = _labelSkin;
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
			this.drawBackground();
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
			if (!_rendererSkin) return;
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
					super.dispatchEvent(new GUIEvent(
						GUIEvent.CHILDREN_CREATED.type, false, true));
				}
			}
		}
		
		protected final function $createChild(xml:XML):DisplayObject
		{
			return super.createChild(xml);
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
				if (_labelSkin)
					(_currentRenderer as IRenderer).labelSkin = _labelSkin;
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