package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.wvxvws.cursor.Cursor;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.HeaderRenderer;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.NestGridRenderer;
	import org.wvxvws.gui.renderers.Renderer;
	import org.wvxvws.tools.ToolEvent;
	
	[Event(name="opened", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	
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
		
		public function get headerRenderer():Class { return _headerRenderer; }
		
		public function set headerRenderer(value:Class):void 
		{
			if (_headerRenderer === value) return;
			_headerRenderer = value;
			invalidate("_headerRenderer", _headerRenderer, false);
			dispatchEvent(new Event("headerRendererChanged"));
		}
		
		public function get headerLabel():String { return _headerLabel; }
		
		public function set headerLabel(value:String):void 
		{
			if (_headerLabel === value) return;
			_headerLabel = value;
			invalidate("_headerLabel", _headerLabel, false);
			dispatchEvent(new Event("headerLabelChanged"));
		}
		
		public function get headerFactory():Function { return _headerFactory; }
		
		public function set headerFactory(value:Function):void 
		{
			if (_headerFactory === value) return;
			_headerFactory = value;
			invalidate("_headerFactory", _headerFactory, false);
			dispatchEvent(new Event("headerFactoryChanged"));
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
		
		protected var _headerRenderer:Class;
		protected var _headerLabel:String;
		protected var _headerFactory:Function;
		protected var _headerheight:int = 18;
		protected var _headers:Vector.<IRenderer> = new <IRenderer>[];
		protected var _columnsResizable:Boolean = true;
		
		public function NestGrid() 
		{
			super();
			super._rendererFactory = Renderer;
			_headerRenderer = HeaderRenderer;
			super.addEventListener(GUIEvent.OPENED, openedHandler, false, int.MAX_VALUE);
			super.addEventListener(GUIEvent.SELECTED, selectedHandler, false, int.MAX_VALUE);
			super.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			Cursor.init(stage);
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
			super.dispatchEvent(new GUIEvent(GUIEvent.SELECTED));
		}
		
		private function openedHandler(event:GUIEvent):void 
		{
			if (!(event.target is IRenderer)) return;
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
			super.dispatchEvent(new GUIEvent(GUIEvent.OPENED));
		}
		
		public function isNodeVisibe(node:XML):Boolean
		{
			while (node && node !== _dataProvider)
			{
				node = node.parent() as XML;
				if (_closedNodes.indexOf(node) > -1) return false;
			}
			return true;
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
			var hRenderer:IRenderer;
			while (i < j)
			{
				col = _columns[i];
				if (_headers.length - 1 < i)
					_headers.push(new _headerRenderer() as IRenderer);
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
					col.y = _headerheight + _padding.top;
					col.gutter = _gutterV;
					if (col === _nestColumn)
						_nestColumn.rendererFactory = NestGridRenderer;
					else col.rendererFactory = Renderer;
					super.addChild(col);
					col.initialized(this, "column" + _columns.indexOf(col));
					cumulativeX += col.width + _gutterH;
				}
				(_headers[i] as DisplayObject).width = col.width;
				(_headers[i] as DisplayObject).x = col.x;
				(_headers[i] as DisplayObject).height = _headerheight;
				(_headers[i] as HeaderRenderer).resizable = _columnsResizable;
				if (_headerLabel !== null) _headers[i].labelField = _headerLabel;
				if (_headerFactory !== null)
					_headers[i].labelFunction = _headerFactory;
				_headers[i].data = _dataProvider;
				(_headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZE_END, header_resizeEndHandler);
				(_headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZE_REQUEST, header_resizeRequestHandler);
				(_headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZE_START, header_resizeStartHandler);
				(_headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZED, header_resizedHandler);
				addChild(_headers[i] as DisplayObject);
				col.dataProvider = _dataProvider;
				i++;
			}
			_subContainers = Vector.<Pane>(_columns.concat());
			_dataProvider.setNotification(providerNotifier);
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
			var sRect:Rectangle;
			if (!super.scrollRect)
			{
				super.scrollRect = new Rectangle(0, 0, super.width, super.height);
			}
			else
			{
				sRect = super.scrollRect.clone();
				sRect.width = super.width;
				sRect.height = super.height;
				super.scrollRect = sRect;
			}
			if (_dispatchCreated) 
				dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED, false, true));
		}
		
		protected function header_resizedHandler(event:ToolEvent):void 
		{
			
		}
		
		protected function header_resizeStartHandler(event:ToolEvent):void 
		{
			
		}
		
		protected function header_resizeRequestHandler(event:ToolEvent):void 
		{
			
		}
		
		protected function header_resizeEndHandler(event:ToolEvent):void 
		{
			
		}
		
		public override function getItemForNode(node:XML):DisplayObject
		{
			return this;
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