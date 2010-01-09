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
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.renderers.HeaderRenderer;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.NestGridRenderer;
	import org.wvxvws.gui.renderers.Renderer;
	import org.wvxvws.gui.ScrollPane;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.SkinManager;
	import org.wvxvws.skins.Skin;
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
		public function get openClass():Class { return this._openClass; }
		
		public function set openClass(value:Class):void 
		{
			if (this._openClass === value) return;
			this._openClass = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get closedClass():Class { return this._closedClass; }
		
		public function set closedClass(value:Class):void 
		{
			if (this._closedClass === value) return;
			this._closedClass = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get iconProducer():ISkin { return this._iconProducer; }
		
		public function set iconProducer(value:ISkin):void 
		{
			if (this._iconProducer == value) return;
			this._iconProducer = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get folderProducer():ISkin { return this._folderProducer; }
		
		public function set folderProducer(value:ISkin):void 
		{
			if (this._folderProducer === value) return;
			this._folderProducer = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get columns():Vector.<Column> { return this._columns; }
		
		public function set columns(value:Vector.<Column>):void 
		{
			if (this._columns === value) return;
			if (!this._nestColumn) this._nestColumn = new Column();
			if (value) this._columns = value.concat();
			else this._columns = new <Column>[this._nestColumn];
			
			if (this._columns.indexOf(this._nestColumn) < 0)
			{
				this._columns = new <Column>[this._nestColumn].concat(this._columns);
			}
			super.invalidate(Invalides.CHILDREN, false);
			if (super.hasEventListener(EventGenerator.getEventType("columns")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property iconProducer
		//------------------------------------
		
		public function set firstColumnWidth(value:int):void 
		{
			if (value < 100) value = 100;
			if (this._nestColumn.width === value) return;
			this._nestColumn.width = value;
			super.invalidate(Invalides.CHILDREN, false);
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
		public function get headerRenderer():Class { return this._headerRenderer; }
		
		public function set headerRenderer(value:Class):void 
		{
			if (_headerRenderer === value) return;
			_headerRenderer = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get headerLabel():String { return this._headerLabel; }
		
		public function set headerLabel(value:String):void 
		{
			if (this._headerLabel === value) return;
			this._headerLabel = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get headerFactory():Function { return this._headerFactory; }
		
		public function set headerFactory(value:Function):void 
		{
			if (this._headerFactory === value) return;
			this._headerFactory = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get includeText():Boolean { return this._includeText; }
		
		public function set includeText(value:Boolean):void 
		{
			if (this._includeText === value) return;
			this._includeText = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get headerHeight():int { return this._headerHeight; }
		
		public function set headerHeight(value:int):void 
		{
			if (this._headerHeight === value) return;
			this._headerHeight = value;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("headerHeight")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property selectedItem
		//------------------------------------
		
		public function get selectedItem():XML { return this._selectedItem; }
		
		//------------------------------------
		//  Public property selectedChild
		//------------------------------------
		
		public function get selectedChild():IRenderer { return this._selectedChild; }
		
		//------------------------------------
		//  Public property nestColumn
		//------------------------------------
		
		public function get nestColumn():Column { return this._nestColumn; }
		
		//------------------------------------
		//  Public property scrollPane
		//------------------------------------
		
		public function get scrollPane():DisplayObjectContainer { return this._scrollPane; }
		
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
		// TODO: remove this dependency.
		protected var _defaultRenderer:ISkin = new Skin(NestGridRenderer);
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function NestGrid() 
		{
			super();
			super._rendererSkin = new Skin(Renderer);
			// TODO: remove this dependency.
			_headerRenderer = HeaderRenderer;
			var headSkin:Vector.<ISkin> = SkinManager.getSkin(new Renderer());
			if (headSkin && headSkin.length) this._headerProducer = headSkin[0];
			super.addEventListener(GUIEvent.OPENED.type, 
									this.openedHandler, false, int.MAX_VALUE);
			super.addEventListener(GUIEvent.SELECTED.type, 
									this.selectedHandler, false, int.MAX_VALUE);
			super.addEventListener(Event.ADDED_TO_STAGE, 
									this.addedToStageHandler, false, 0, true);
			super.addChild(this._scrollPane);
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
			while (node && node !== this._dataProvider)
			{
				node = node.parent() as XML;
				if (this._closedNodes.indexOf(node) > -1) return false;
			}
			return true;
		}
		
		public override function validate(properties:Dictionary):void 
		{
			var needLayout:Boolean = (!(Invalides.DATAPROVIDER in properties)) &&
			((Invalides.SKIN in properties) || (Invalides.CHILDREN in properties));
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
			if (this._dataProvider === null || !this._rendererSkin) return;
			var dataList:XMLList = 
				this._dataProvider.*.(nodeKind() !== "text" || this._includeText);
			var dataLenght:int = dataList.length();
			if (!dataLenght) return;
			this._currentItem = 0;
			this._removedChildren = new <DisplayObject>[];
			var i:int;
			while (this._scrollPane.numChildren > i)
				this._removedChildren.push(this._scrollPane.removeChildAt(0));
			this._dispatchCreated = false;
			if (this._columns.indexOf(this._nestColumn) < 0)
			{
				this._columns.unshift(this._nestColumn);
			}
			var cumulativeX:int = this._padding.left;
			var numColons:int = this._columns.length;
			var colWidth:int = width / numColons;
			var col:Column;
			var totalWidth:int = 
				super.width - (this._padding.right + this._padding.left);
			var j:int = this._columns.length;
			var hRenderer:IRenderer;
			while (i < j)
			{
				col = this._columns[i];
				if (this._headers.length - 1 < i)
					this._headers.push(new this._headerRenderer() as IRenderer);
				if (!super.contains(col))
				{
					if (col.minWidth > col.definedWidth)
					{
						col.width = colWidth;
						totalWidth -= colWidth + this._gutterH;
					}
					else totalWidth -= col.width + this._gutterH;
					if (j - i === 1 && totalWidth + this._gutterH > 0)
						col.width += totalWidth + this._gutterH;
					col.x = cumulativeX;
					col.y = this._headerHeight + this._padding.top;
					col.gutter = _gutterV;
					if (col === this._nestColumn)
						this._nestColumn.rendererFactory = this._defaultRenderer;
					else col.rendererFactory = super._rendererSkin;
					this._scrollPane.addChild(col);
					col.initialized(this, "column" + this._columns.indexOf(col));
					cumulativeX += col.width + this._gutterH;
				}
				(this._headers[i] as DisplayObject).width = col.width;
				(this._headers[i] as DisplayObject).x = col.x;
				(this._headers[i] as DisplayObject).height = this._headerHeight;
				(this._headers[i] as HeaderRenderer).resizable = this._columnsResizable;
				this._headers[i].labelSkin = _headerProducer;
				this._headers[i].data = this._dataProvider;
				(this._headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZE_END, this.header_resizeEndHandler);
				(this._headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZE_REQUEST, this.header_resizeRequestHandler);
				(this._headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZE_START, this.header_resizeStartHandler);
				(this._headers[i] as DisplayObject).addEventListener(
						ToolEvent.RESIZED, this.header_resizedHandler);
				super.addChild(_headers[i] as DisplayObject);
				col.dataProvider = this._dataProvider;
				i++;
			}
			this._subContainers = Vector.<Pane>(this._columns.concat());
			this._dataProvider.setNotification(providerNotifier);
			for each (col in _columns)
			{
				if (!col.parentIsCreator) col.parentIsCreator = true;
				col.beginLayoutChildren();
			}
			var child:DisplayObject;
			var closedNodes:XMLList;
			var maxChildHeight:int;
			
			var nn:XML;
			this._currentList = 
				this._dataProvider..*.(nodeKind() !== "text" || this._includeText);
			this._currentNode = this._dataProvider;
			this._currentDepth = 0;
			i = 0;
			j = this._currentList.length();
			var isClosed:Boolean;
			
			while (i < j)
			{
				nn = this._currentList[i];
				this._currentDepth = this.getNodeDepth(nn);
				isClosed = false;
				if (this._closedNodes.indexOf(nn) > -1)
				{
					closedNodes = nn..*.(nodeKind() !== "text" || this._includeText);
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
						(child as NestGridRenderer).indent = this._indent;
						(child as NestGridRenderer).depth = this._currentDepth - 1;
						(child as NestGridRenderer).gutter = 8;
						if (nn.hasSimpleContent())
						{
							(child as NestGridRenderer).iconProducer = 
								this._iconProducer;
						}
						else
						{
							if (isClosed) 
								(child as NestGridRenderer).closed = true;
							(child as NestGridRenderer).iconProducer = 
								this._folderProducer;
							(child as NestGridRenderer).openClass = this._openClass;
							(child as NestGridRenderer).closedClass = 
								this._closedClass;
						}
					}
				}
				for each (col in _columns)
				{
					col.adjustHeight(maxChildHeight + this._gutterV);
				}
				i++;
			}
			for each (col in _columns)
			{
				col.endLayoutChildren(super.height - 
										(this._padding.top + this._padding.bottom));
			}
			var sRect:Rectangle;
			_scrollPane.realHeight = child.y + child.height;
			_scrollPane.realWidth = super.width;
			if (!this._scrollPane.scrollRect)
			{
				this._scrollPane.scrollRect = 
					new Rectangle(0, 0, super.width, super.height);// - _headerHeight);
			}
			else
			{
				sRect = this._scrollPane.scrollRect.clone();
				sRect.width = super.width;
				sRect.height = super.height;// - _headerHeight;
				this._scrollPane.scrollRect = sRect;
			}
			if (this._dispatchCreated)
			{
				super.dispatchEvent(GUIEvent.CHILDREN_CREATED);
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
			if (event.target is IRenderer) lastSelected = this._selectedChild;
			if (!(event.target is IRenderer)) return;
			this._selectedChild = event.target as IRenderer;
			event.stopImmediatePropagation();
			this._selectedItem = this._selectedChild.data as XML;
			if (lastSelected && lastSelected !== this._selectedChild && 
				(lastSelected as Object).hasOwnProperty("selected"))
			{
				(lastSelected as Object).selected = false;
			}
			super.dispatchEvent(GUIEvent.SELECTED);
		}
		
		protected function openedHandler(event:GUIEvent):void 
		{
			if (!(event.target is IRenderer)) return;
			event.stopImmediatePropagation();
			var index:int;
			var renderer:NestGridRenderer = event.target as NestGridRenderer;
			if (renderer.closed)
			{
				this._closedNodes.push(renderer.data);
			}
			else
			{
				index = this._closedNodes.indexOf(renderer.data);
				if (index > -1)
				{
					this._closedNodes.splice(index, 1);
				}
			}
			super._invalidProperties[Invalides.DATAPROVIDER] = true;
			super.validate(super._invalidProperties);
			super.dispatchEvent(GUIEvent.OPENED);
		}
		
		protected function addedToStageHandler(event:Event):void 
		{
			super.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
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