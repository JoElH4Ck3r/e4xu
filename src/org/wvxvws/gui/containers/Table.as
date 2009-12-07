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

// TODO: Needs major update

package org.wvxvws.gui.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.Renderer;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.skins.Skin;
	
	/**
	* Table class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Table extends Pane
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get columns():Vector.<Column> { return _columns; }
		
		public function set columns(value:Vector.<Column>):void 
		{
			if (_columns === value) return;
			_columns = value;
			super.invalidate("_columns", _columns, false);
			if (super.hasEventListener(EventGenerator.getEventType("columns")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get rendererSkin():ISkin { return _rendererSkin; }
		
		public function set rendererSkin(value:ISkin):void 
		{
			if (_rendererSkin === value) return;
			_rendererSkin = value;
			super.invalidate("_rendererSkin", _rendererSkin, false);
			if (super.hasEventListener(EventGenerator.getEventType("rendererSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get cellHeight():int { return _cellHeight; }
		
		public function set cellHeight(value:int):void 
		{
			if (_cellHeight === value) return;
			_cellHeight = value;
			super.invalidate("_cellHeight", _cellHeight, false);
			if (super.hasEventListener(EventGenerator.getEventType("cellHeight")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get gutterH():int { return _gutterH; }
		
		public function set gutterH(value:int):void 
		{
			if (_gutterH === value) return;
			_gutterH = value;
			super.invalidate("_gutterH", _gutterH, false);
			if (super.hasEventListener(EventGenerator.getEventType("gutterH")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get gutterV():int { return _gutterV; }
		
		public function set gutterV(value:int):void 
		{
			if (_gutterV === value) return;
			_gutterV = value;
			super.invalidate("_gutterV", _gutterV, false);
			if (super.hasEventListener(EventGenerator.getEventType("gutterV")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get padding():Rectangle { return _padding; }
		
		public function set padding(value:Rectangle):void 
		{
			if (_padding === value || _padding && value && _padding.equals(value))
				return;
			_padding = value;
			super.invalidate("_padding", _padding, false);
			if (super.hasEventListener(EventGenerator.getEventType("padding")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _cellHeight:int = -0x8000000;
		protected var _itemCount:int;
		protected var _columns:Vector.<Column> = new <Column>[];
		protected var _gutterH:int;
		protected var _gutterV:int;
		protected var _padding:Rectangle = new Rectangle();
		// TODO: remove this dependancy
		protected var _defaultRenderer:ISkin = new Skin(Renderer);
		
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
		public function Table() 
		{
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function layOutChildren():void
		{
			if (_dataProvider === null) return;
			var dataList:XMLList = _dataProvider.*;
			var dataLenght:int = dataList.length();
			if (!dataLenght) return;
			var cumulativeX:int = _padding.left;
			var numColons:int = _columns.length;
			var colWidth:int = width / numColons;
			var col:Column;
			var totalWidth:int = super.width - (_padding.right + _padding.left);
			var i:int;
			var j:int = _columns.length;
			while (i < j)
			{
				col = _columns[i];
				if (!super.contains(col))
				{
					if (col.minWidth > col.definedWidth)
					{
						col.width = colWidth;
						totalWidth -= colWidth + _gutterH;
					}
					else totalWidth -= col.width + _gutterH;
					if (j - i === 1 && totalWidth + _gutterH > 0)
						col.width += totalWidth + _gutterH;
					col.x = cumulativeX;
					col.y = _padding.top;
					col.gutter = _gutterV;
					col.rendererFactory = _defaultRenderer;
					super.addChild(col);
					col.initialized(this, "column" + _columns.indexOf(col));
					cumulativeX += col.width + _gutterH;
				}
				col.dataProvider = _dataProvider;
				i++;
				//col.validate(col.invalidProperties);
			}
			for each (col in _columns)
			{
				if (!col.parentIsCreator) col.parentIsCreator = true;
				col.beginLayoutChildren();
			}
			i = 0;
			var child:DisplayObject;
			var currentData:XML;
			var maxChildHeight:int;
			while (i < dataLenght)
			{
				currentData = dataList[i];
				for each (col in _columns)
				{
					child = col.createNextRow();
					if (!child) continue;
					maxChildHeight = Math.max(maxChildHeight, child.height);
				}
				for each (col in _columns)
				{
					col.adjustHeight(maxChildHeight + _gutterV);
				}
				i++;
			}
			for each (col in _columns)
			{
				col.endLayoutChildren(super.height - (_padding.top + _padding.bottom));
			}
			super.dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
	}
	
}