package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.NestGridRenderer;
	import org.wvxvws.gui.renderers.Renderer;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class NestGrid extends Pane
	{
		
		public function get iconFactory():Function { return _iconFactory; }
		
		public function set iconFactory(value:Function):void 
		{
			if (_iconFactory === value) return;
			_iconFactory = value;
			invalidate("_iconFactory", _iconFactory, false);
			dispatchEvent(new Event("iconFactoryChanged"));
		}
		
		public function get folderFactory():Function { return _folderFactory; }
		
		public function set folderFactory(value:Function):void 
		{
			if (_folderFactory === value) return;
			_folderFactory = value;
			invalidate("_folderFactory", _folderFactory, false);
			dispatchEvent(new Event("folderFactoryChanged"));
		}
		
		public function get openClass():Class { return _openClass; }
		
		public function set openClass(value:Class):void 
		{
			if (_openClass === value) return;
			_openClass = value;
			invalidate("_openClass", _openClass, false);
			dispatchEvent(new Event("openClassChanged"));
		}
		
		public function get closedClass():Class { return _closedClass; }
		
		public function set closedClass(value:Class):void 
		{
			if (_closedClass === value) return;
			_closedClass = value;
			invalidate("_closedClass", _closedClass, false);
			dispatchEvent(new Event("closedClassChanged"));
		}
		
		public function get columns():Vector.<Column> { return _columns; }
		
		public function set columns(value:Vector.<Column>):void 
		{
			if (_columns === value) return;
			if (!_nestColumn) _nestColumn = new Column();
			if (value) _columns = value.concat();
			else _columns = new <Column>[_nestColumn];
			
			if (_columns.indexOf(_nestColumn) < 0)
			{
				_columns = new <Column>[_nestColumn].concat(_columns);
				trace(_columns[0].filter, _columns.length);
			}
			invalidate("_columns", _columns, false);
			dispatchEvent(new Event("columnsChanged"));
		}
		
		public function set firstColumnWidth(value:int):void 
		{
			if (value < 100) value = 100;
			if (_nestColumn.width === value) return;
			_nestColumn.width = value;
			invalidate("_nestColumn", _nestColumn, false);
		}
		
		public function get selectedItem():XML { return _selectedItem; }
		
		public function get selectedChild():IRenderer { return _selectedChild; }
		
		protected var _cellHeight:int = -0x8000000;
		protected var _itemCount:int;
		protected var _columns:Vector.<Column> = new <Column>[];
		protected var _gutterH:int;
		protected var _gutterV:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _nestColumn:Column = new Column();
		protected var _currentDepth:int;
		protected var _isCurrentClosed:Boolean;
		protected var _closedNodes:Vector.<XML> = new <XML>[];
		protected var _currentNode:XML;
		protected var _currentList:XMLList;
		protected var _indent:int = 16;
		
		protected var _iconFactory:Function;
		protected var _folderFactory:Function;
		
		protected var _openClass:Class;
		protected var _closedClass:Class;
		protected var _selectedItem:XML;
		protected var _selectedChild:IRenderer;
		
		public function NestGrid() 
		{
			super();
			super._rendererFactory = Renderer;
			super.addEventListener(GUIEvent.OPENED, openedHandler, false, int.MAX_VALUE);
			super.addEventListener(GUIEvent.SELECTED, selectedHandler, false, int.MAX_VALUE);
		}
		
		private function selectedHandler(event:GUIEvent):void 
		{
			var lastSelected:IRenderer;
			if (event.target is IRenderer) lastSelected = _selectedChild;
			if (!(event.target is IRenderer)) return;
			_selectedChild = event.target as IRenderer;
			event.stopImmediatePropagation();
			_selectedItem = _selectedChild.data;
			if (lastSelected && lastSelected !== _selectedChild && 
				(lastSelected as Object).hasOwnProperty("selected"))
			{
				(lastSelected as Object).selected = false;
			}
			dispatchEvent(new GUIEvent(GUIEvent.SELECTED));
		}
		
		private function openedHandler(event:GUIEvent):void 
		{
			event.stopImmediatePropagation();
			var index:int;
			var renderer:NestGridRenderer = event.target as NestGridRenderer;
			if (renderer.closed)
			{
				_closedNodes.push(renderer.data);
			}
			else
			{
				index = _closedNodes.indexOf(renderer.data);
				if (index > -1)
				{
					_closedNodes.splice(index, 1);
				}
			}
			super.validate(super._invalidProperties);
		}
		
		protected override function layOutChildren():void 
		{
			if (_dataProvider === null) return;
			var dataList:XMLList = _dataProvider.*;
			var dataLenght:int = dataList.length();
			if (!dataLenght) return;
			if (!_rendererFactory) return;
			_currentItem = 0;
			_removedChildren = new <DisplayObject>[];
			var i:int;
			while (super.numChildren > i)
				_removedChildren.push(super.removeChildAt(0));
			_dispatchCreated = false;
			if (_columns.indexOf(_nestColumn) < 0)
			{
				_columns.unshift(_nestColumn);
			}
			var cumulativeX:int = _padding.left;
			var numColons:int = _columns.length;
			var colWidth:int = width / numColons;
			var col:Column;
			var totalWidth:int = super.width - (_padding.right + _padding.left);
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
					if (col === _nestColumn)
						_nestColumn.rendererFactory = NestGridRenderer;
					else col.rendererFactory = Renderer;
					super.addChild(col);
					col.initialized(this, "column" + _columns.indexOf(col));
					cumulativeX += col.width + _gutterH;
				}
				col.dataProvider = _dataProvider;
				i++;
			}
			for each (col in _columns)
			{
				if (!col.parentIsCreator) col.parentIsCreator = true;
				col.beginLayoutChildren();
			}
			var child:DisplayObject;
			var closedNodes:XMLList;
			var maxChildHeight:int;
			
			var nn:XML;
			_currentList = _dataProvider..*;
			_currentNode = _dataProvider;
			_currentDepth = 0;
			i = 0;
			j = _currentList.length();
			var isClosed:Boolean;
			
			while (i < j)
			{
				nn = _currentList[i];
				_currentDepth = getNodeDepth(nn);
				isClosed = false;
				if (_closedNodes.indexOf(nn) > -1)
				{
					closedNodes = nn..*;
					i += closedNodes.length();
					isClosed = true;
				}
				for each (col in _columns)
				{
					child = col.createNextRow(nn);
					if (!child) continue;
					maxChildHeight = Math.max(maxChildHeight, child.height);
					if (child is NestGridRenderer)
					{
						(child as NestGridRenderer).indent = _indent;
						(child as NestGridRenderer).depth = _currentDepth - 1;
						(child as NestGridRenderer).gutter = 8;
						if (nn.hasSimpleContent())
						{
							(child as NestGridRenderer).iconFactory = _iconFactory;
						}
						else
						{
							if (isClosed) 
								(child as NestGridRenderer).closed = true;
							(child as NestGridRenderer).iconFactory = _folderFactory;
							(child as NestGridRenderer).openClass = _openClass;
							(child as NestGridRenderer).closedClass = _closedClass;
						}
					}
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
			if (_dispatchCreated) 
				dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED, false, true));
		}
		
		protected function getNodeDepth(node:XML):int
		{
			var i:int;
			while (node.parent() is XML)
			{
				node = node.parent();
				i++;
			}
			return i;
		}
		
	}
	
}