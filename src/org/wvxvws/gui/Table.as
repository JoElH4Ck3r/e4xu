package org.wvxvws.gui 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	* Table class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Table extends DIV
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
		
		protected var _dataProvider:XML;
		protected var _dataProviderCopy:XML;
		protected var _rendererFactory:Class = Renderer;
		protected var _cellSize:Point = new Point(100, 100);
		protected var _columnCount:int = 5;
		protected var _itemCount:int;
		protected var _currentItem:int;
		protected var _removedChildren:Array;
		protected var _columns:Array = [];
		
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
		
		public function get columns():Array { return _columns; }
		
		public function set columns(value:Array):void 
		{
			if (_columns === value) return;
			_columns = value;
			invalidLayout = true;
		}
		
		public function get dataProvider():XML { return _dataProvider; }
		
		public function set dataProvider(value:XML):void 
		{
			if (_dataProvider === value) return;
			_dataProvider = value;
			_dataProviderCopy = value.copy();
			_dataProvider.setNotification(providerNotifier);
			invalidLayout = true;
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
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function getItemForNode(node:XML):DisplayObject
		{
			var i:int;
			while (i < super.numChildren)
			{
				if ((super.getChildAt(i) as IRenderer).data === node) 
					return super.getChildAt(i);
				i++;
			}
			return null;
		}
		
		public function getNodeForItem(renderer:DisplayObject):XML
		{
			var i:int;
			while (i < super.numChildren)
			{
				if (super.getChildAt(i) === renderer)
					return _dataProvider.*[i];
				i++;
			}
			return null;
		}
		
		public function getItemAt(index:int):DisplayObject
		{
			return getItemForNode(getNodeAt(index));
		}
		
		public function getNodeAt(index:int):XML
		{
			return _dataProvider.*[index];
		}
		
		public function getIndexForItem(renderer:DisplayObject):int
		{
			var i:int;
			while (i < super.numChildren)
			{
				if (super.getChildAt(i) === renderer) return i;
				i++;
			}
			return -1;
		}
		
		public function getIndexForNode(node:XML, position:int = -1):int
		{
			var i:int;
			for each(var xn:XML in _dataProvider.*)
			{
				if (xn === node && i > position) return i;
				i++;
			}
			return -1;
		}
		
		override public function validateLayout(event:Event = null):void 
		{
			super.validateLayout(event);
			layOutChildren();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function layOutChildren():void
		{
			if (_dataProvider === null) return;
			if (!_dataProvider.*.length()) return;
			var cumulativeX:int;
			var numColons:int = _columns.length;
			var colWidth:int = width / numColons;
			for each(var col:Column in _columns)
			{
				if (!super.contains(col))
				{
					col.width = colWidth;
					col.cellSize.x = colWidth;
					super.addChild(col);
					col.x = cumulativeX;
					cumulativeX = cumulativeX + col.width;
				}
				col.dataProvider = listColumnChildren(col.filter);
				col.validateLayout();
			}
			dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED));
		}
		
		protected function listColumnChildren(filter:String):XML
		{
			var temp:XML = <$/>;
			_dataProvider.*.(hasOwnProperty(filter) ? temp.appendChild(valueOf()) : false);
			return temp;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function providerNotifier(targetCurrent:Object, command:String, 
									target:Object, value:Object, detail:Object):void
		{
			var renderer:IRenderer;
			switch (command)
			{
				    case "attributeAdded":
					case "attributeChanged":
					case "attributeRemoved":
						renderer = getItemForNode(target as XML) as IRenderer;
						renderer.data = target as XML;
						break;
					case "nodeAdded":
						{
							var needReplace:Boolean;
							var nodeList:Array = [];
							var firstIndex:int;
							var lastIndex:int;
							var correctNodeList:XMLList;
							(targetCurrent as XML).*.(nodeList.push(valueOf()));
							for each (var node:XML in nodeList)
							{
								if (nodeList.indexOf(node) != nodeList.lastIndexOf(node))
								{
									firstIndex = nodeList.indexOf(node);
									lastIndex = nodeList.lastIndexOf(node);
									needReplace = true;
									break;
								}
							}
							if (needReplace)
							{
								if (_dataProvider.*[firstIndex].contains(_dataProviderCopy.*[firstIndex]))
								{
									nodeList.splice(firstIndex, 1);
									_dataProvider.setChildren("");
									_dataProvider.normalize();
									while (nodeList.length)
									{
										_dataProvider.appendChild(nodeList.shift());
									}
									_dataProviderCopy = _dataProvider.copy();
									return;
								}
								else
								{
									nodeList.splice(lastIndex, 1);
									_dataProvider.setChildren("");
									_dataProvider.normalize();
									while (nodeList.length)
									{
										_dataProvider.appendChild(nodeList.shift());
									}
									_dataProviderCopy = _dataProvider.copy();
									return;
								}
							}
							invalidLayout = true;
						}
						break;
					case "textSet":
					case "nameSet":
					case "nodeChanged":
					case "nodeRemoved":
						invalidLayout = true;
						break;
					case "namespaceAdded":
						
						break;
					case "namespaceRemoved":
						
						break;
					case "namespaceSet":
						
						break;
			}
			_dataProviderCopy = _dataProvider.copy();
		}
	}
	
}