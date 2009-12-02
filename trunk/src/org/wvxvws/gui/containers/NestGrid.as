package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.cursor.Cursor;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.HeaderRenderer;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.NestGridRenderer;
	import org.wvxvws.gui.renderers.Renderer;
	import org.wvxvws.gui.ScrollPane;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.tools.ToolEvent;
	
	[Event(name="opened", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * NestGrid class
	 * @author wvxvw
	 */
	public class NestGrid extends Pane
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property openClass
		//------------------------------------
		
		[Bindable("openClassChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>openClassChanged</code> event.
		*/
		public function get openClass():Class { return _openClass; }
		
		public function set openClass(value:Class):void 
		{
			if (_openClass === value) return;
			_openClass = value;
			super.invalidate("_openClass", _openClass, false);
			if (super.hasEventListener(EventGenerator.getEventType("openClass")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property closedClass
		//------------------------------------
		
		[Bindable("closedClassChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>closedClassChanged</code> event.
		*/
		public function get closedClass():Class { return _closedClass; }
		
		public function set closedClass(value:Class):void 
		{
			if (_closedClass === value) return;
			_closedClass = value;
			super.invalidate("_closedClass", _closedClass, false);
			if (super.hasEventListener(EventGenerator.getEventType("closedClass")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property iconProducer
		//------------------------------------
		
		[Bindable("iconProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>iconProducerChanged</code> event.
		*/
		public function get iconProducer():ISkin { return _iconProducer; }
		
		public function set iconProducer(value:ISkin):void 
		{
			if (_iconProducer == value) return;
			_iconProducer = value;
			super.invalidate("_iconProducer", _iconProducer, false);
			if (super.hasEventListener(EventGenerator.getEventType("iconProducer")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property folderProducer
		//------------------------------------
		
		[Bindable("folderProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>folderProducerChanged</code> event.
		*/
		public function get folderProducer():ISkin { return _folderProducer; }
		
		public function set folderProducer(value:ISkin):void 
		{
			if (_folderProducer === value) return;
			_folderProducer = value;
			super.invalidate("_folderProducer", _folderProducer, false);
			if (super.hasEventListener(EventGenerator.getEventType("folderProducer")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property columns
		//------------------------------------
		
		[Bindable("columnsChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>columnsChanged</code> event.
		*/
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
			}
			super.invalidate("_columns", _columns, false);
			if (super.hasEventListener(EventGenerator.getEventType("columns")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property iconProducer
		//------------------------------------
		
		public function set firstColumnWidth(value:int):void 
		{
			if (value < 100) value = 100;
			if (_nestColumn.width === value) return;
			_nestColumn.width = value;
			super.invalidate("_nestColumn", _nestColumn, false);
		}
		
		//------------------------------------
		//  Public property iconProducer
		//------------------------------------
		
		[Bindable("headerRendererChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>headerRendererChanged</code> event.
		*/
		public function get headerRenderer():Class { return _headerRenderer; }
		
		public function set headerRenderer(value:Class):void 
		{
			if (_headerRenderer === value) return;
			_headerRenderer = value;
			super.invalidate("_headerRenderer", _headerRenderer, false);
			if (super.hasEventListener(EventGenerator.getEventType("headerRenderer")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property headerLabel
		//------------------------------------
		
		[Bindable("headerLabelChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>headerLabelChanged</code> event.
		*/
		public function get headerLabel():String { return _headerLabel; }
		
		public function set headerLabel(value:String):void 
		{
			if (_headerLabel === value) return;
			_headerLabel = value;
			super.invalidate("_headerLabel", _headerLabel, false);
			if (super.hasEventListener(EventGenerator.getEventType("headerLabel")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property headerFactory
		//------------------------------------
		
		[Bindable("headerFactoryChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>headerFactoryChanged</code> event.
		*/
		public function get headerFactory():Function { return _headerFactory; }
		
		public function set headerFactory(value:Function):void 
		{
			if (_headerFactory === value) return;
			_headerFactory = value;
			super.invalidate("_headerFactory", _headerFactory, false);
			if (super.hasEventListener(EventGenerator.getEventType("headerFactory")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property includeText
		//------------------------------------
		
		[Bindable("includeTextChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>includeTextChanged</code> event.
		*/
		public function get includeText():Boolean { return _includeText; }
		
		public function set includeText(value:Boolean):void 
		{
			if (_includeText === value) return;
			_includeText = value;
			super.invalidate("_includeText", _includeText, false);
			if (super.hasEventListener(EventGenerator.getEventType("includeText")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property headerHeight
		//------------------------------------
		
		[Bindable("headerHeightChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>headerHeightChanged</code> event.
		*/
		public function get headerHeight():int { return _headerHeight; }
		
		public function set headerHeight(value:int):void 
		{
			if (_headerHeight === value) return;
			_headerHeight = value;
			super.invalidate("_headerHeight", _headerHeight, false);
			if (super.hasEventListener(EventGenerator.getEventType("headerHeight")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property selectedItem
		//------------------------------------
		
		public function get selectedItem():XML { return _selectedItem; }
		
		//------------------------------------
		//  Public property selectedChild
		//------------------------------------
		
		public function get selectedChild():IRenderer { return _selectedChild; }
		
		//------------------------------------
		//  Public property nestColumn
		//------------------------------------
		
		public function get nestColumn():Column { return _nestColumn; }
		
		//------------------------------------
		//  Public property scrollPane
		//------------------------------------
		
		public function get scrollPane():DisplayObjectContainer { return _scrollPane; }
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
		
		protected var _iconProducer:ISkin;
		protected var _folderProducer:ISkin;
		
		protected var _openClass:Class;
		protected var _closedClass:Class;
		protected var _selectedItem:XML;
		protected var _selectedChild:IRenderer;
		
		protected var _headerRenderer:Class;
		protected var _headerLabel:String;
		protected var _headerFactory:Function;
		protected var _headerHeight:int = 18;
		protected var _headers:Vector.<IRenderer> = new <IRenderer>[];
		protected var _columnsResizable:Boolean = true;
		protected var _includeText:Boolean;
		protected var _headerProducer:ISkin;
		protected var _scrollPane:ScrollPane = new ScrollPane();
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function NestGrid() 
		{
			super();
			super._rendererFactory = Renderer;
			_headerRenderer = HeaderRenderer;
			super.addEventListener(GUIEvent.OPENED, 
									this.openedHandler, false, int.MAX_VALUE);
			super.addEventListener(GUIEvent.SELECTED, 
									this.selectedHandler, false, int.MAX_VALUE);
			super.addEventListener(Event.ADDED_TO_STAGE, 
									this.addedToStageHandler, false, 0, true);
			super.addChild(_scrollPane);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function getItemForNode(node:XML):DisplayObject
		{
			return this;
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
		
		public override function validate(properties:Object):void 
		{
			var needLayout:Boolean = (!("_dataProvider" in properties)) &&
			(("_iconProducer" in properties) || ("_folderProducer" in properties) ||
			("_nestColumn" in properties) || ("_columns" in properties) ||
			("_openClass" in properties) || ("_closedClass" in properties) || 
			("_includeText" in properties) || ("_headerHeight" in properties));
			super.validate(properties);
			if (needLayout) this.layOutChildren();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function layOutChildren():void 
		{
			if (_dataProvider === null) return;
			var dataList:XMLList = 
				_dataProvider.*.(nodeKind() !== "text" || _includeText);
			var dataLenght:int = dataList.length();
			if (!dataLenght) return;
			if (!_rendererFactory) return;
			_currentItem = 0;
			_removedChildren = new <DisplayObject>[];
			var i:int;
			while (_scrollPane.numChildren > i)
				_removedChildren.push(_scrollPane.removeChildAt(0));
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
					col.y = _headerHeight + _padding.top;
					col.gutter = _gutterV;
					if (col === _nestColumn)
						_nestColumn.rendererFactory = NestGridRenderer;
					else col.rendererFactory = Renderer;
					_scrollPane.addChild(col);
					col.initialized(this, "column" + _columns.indexOf(col));
					cumulativeX += col.width + _gutterH;
				}
				(_headers[i] as DisplayObject).width = col.width;
				(_headers[i] as DisplayObject).x = col.x;
				(_headers[i] as DisplayObject).height = _headerHeight;
				(_headers[i] as HeaderRenderer).resizable = _columnsResizable;
					_headers[i].labelSkin = _headerProducer;
				_headers[i].data = _dataProvider;
				(_headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZE_END, header_resizeEndHandler);
				(_headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZE_REQUEST, header_resizeRequestHandler);
				(_headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZE_START, header_resizeStartHandler);
				(_headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZED, header_resizedHandler);
				super.addChild(_headers[i] as DisplayObject);
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
			_currentList = _dataProvider..*.(nodeKind() !== "text" || _includeText);
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
					closedNodes = nn..*.(nodeKind() !== "text" || _includeText);
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
							(child as NestGridRenderer).iconProducer = _iconProducer;
						}
						else
						{
							if (isClosed) 
								(child as NestGridRenderer).closed = true;
							(child as NestGridRenderer).iconProducer = 
																_folderProducer;
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
				col.endLayoutChildren(super.height - 
										(_padding.top + _padding.bottom));
			}
			var sRect:Rectangle;
			_scrollPane.realHeight = child.y + child.height;
			_scrollPane.realWidth = super.width;
			if (!_scrollPane.scrollRect)
			{
				_scrollPane.scrollRect = 
					new Rectangle(0, 0, super.width, super.height);// - _headerHeight);
			}
			else
			{
				sRect = _scrollPane.scrollRect.clone();
				sRect.width = super.width;
				sRect.height = super.height;// - _headerHeight;
				_scrollPane.scrollRect = sRect;
			}
			if (_dispatchCreated)
			{
				super.dispatchEvent(
					new GUIEvent(GUIEvent.CHILDREN_CREATED, false, true));
			}
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
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		protected function selectedHandler(event:GUIEvent):void 
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
		
		protected function openedHandler(event:GUIEvent):void 
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
			super._invalidProperties._dataProvider = _dataProvider;
			super.validate(super._invalidProperties);
			super.dispatchEvent(new GUIEvent(GUIEvent.OPENED));
		}
		
		protected function addedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			Cursor.init(stage);
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
		
	}
	
}