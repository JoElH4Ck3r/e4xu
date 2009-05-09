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
	//{ imports
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.Renderer;
	//}
	
	/**
	* TiledPanel class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class TiledPanel extends Pane
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _cellSize:Point = new Point(100, 100);
		protected var _rowCount:int = 5;
		protected var _columnCount:int = 5;
		protected var _itemCount:int;
		
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
		
		public function TiledPanel()
		{
			super();
			_rendererFactory = Renderer;
		}
		
		public function get rendererFactory():Class { return _rendererFactory; }
		
		public function set rendererFactory(value:Class):void 
		{
			if (_rendererFactory === value) return;
			_rendererFactory = value;
			invalidLayout = true;
		}
		
		public function get cellSize():Point { return _cellSize; }
		
		public function set cellSize(value:Point):void 
		{
			if (_cellSize === value) return;
			_cellSize = value;
			invalidLayout = true;
		}
		
		public function get rowCount():int { return _rowCount; }
		
		public function set rowCount(value:int):void 
		{
			if (_rowCount === value) return;
			_rowCount = value;
			invalidLayout = true;
		}
		
		public function get columnCount():int { return _columnCount; }
		
		public function set columnCount(value:int):void 
		{
			if (_rowCount === value) return;
			_columnCount = value;
			invalidLayout = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			throw new Error("Use dataProvider to add or remove children");
			return null;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			throw new Error("Use dataProvider to add or remove children");
			return null;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			throw new Error("Use dataProvider to add or remove children");
			return null;
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			throw new Error("Use dataProvider to add or remove children");
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function createChild(xml:XML):DisplayObject
		{
			var child:DisplayObject = super.createChild(xml);
			if (!child) return;
			child.width = _cellSize.x;
			child.height = _cellSize.y;
			child.x = (_currentItem % _rowCount) * _cellSize.x;
			child.y = ((_currentItem / _columnCount) >> 0) * _cellSize.y;
			return child;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
	}
}