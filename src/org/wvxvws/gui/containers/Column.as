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
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.Renderer;
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
		
		public function get rendererFactory():Class { return _rendererFactory; }
		
		public function set rendererFactory(value:Class):void 
		{
			if (_rendererFactory === value) return;
			_rendererFactory = value;
			invalidate("_rendererFactory", _rendererFactory, false);
			dispatchEvent(new Event("rendererFactoryChanged"));
		}
		
		public function get cellSize():Point { return _cellSize; }
		
		public function set cellSize(value:Point):void 
		{
			if (_cellSize === value) return;
			_cellSize = value;
			invalidate("_cellSize", _cellSize, false);
			dispatchEvent(new Event("cellSizeChanged"));
		}
		
		public function get rowCount():int { return _rowCount; }
		
		public function set rowCount(value:int):void 
		{
			if (_rowCount === value) return;
			_rowCount = value;
			invalidate("_rowCount", _rowCount, false);
			dispatchEvent(new Event("rowCountChanged"));
		}
		
		public function get filter():String { return _filter; }
		
		public function set filter(value:String):void 
		{
			if (_filter === value) return;
			_filter = value;
			invalidate("_filter", _filter, false);
			dispatchEvent(new Event("filterChanged"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _rendererFactory:Class = Renderer;
		protected var _cellSize:Point = new Point(100, 100);
		protected var _itemCount:int;
		protected var _filter:String;
		protected var _rowCount:int;
		
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
			super.validate(properties);
			super.layOutChildren();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//protected function layOutChildren():void
		//{
			//super.layou
			//if (_dataProvider === null) return;
			//if (!_dataProvider.*.length()) return;
			//_currentItem = 0;
			//_removedChildren = [];
			//var i:int;
			//while (super.numChildren > i)
			//{
				//_removedChildren.push(super.removeChildAt(0));
			//}
			//_dataProvider.*.(createChild(valueOf()));
			//dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED));
		//}
		
		protected override function createChild(xml:XML):DisplayObject
		{
			var child:DisplayObject = super.createChild(xml);
			if (!child) return;
			child.width = _cellSize.x;
			child.height = _cellSize.y;
			child.y = _currentItem * _cellSize.y;
			super.addChild(child);
			return true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
	}
}