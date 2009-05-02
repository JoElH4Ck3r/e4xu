package org.wvxvws.gui 
{
	//{imports
	import flash.display.DisplayObject
	import flash.events.Event;
	import flash.geom.Point;
	//}
	
	/**
	* Column class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Column extends Control
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
		
		public function get rowCount():int { return _rowCount; }
		
		public function set rowCount(value:int):void 
		{
			if (_rowCount === value) return;
			_rowCount = value;
			invalidLayout = true;
		}
		
		public function get filter():String { return _filter; }
		
		public function set filter(value:String):void 
		{
			if (_filter === value) return;
			_filter = value;
			invalidLayout = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _dataProvider:XML;
		protected var _dataProviderCopy:XML;
		protected var _rendererFactory:Class = Renderer;
		protected var _cellSize:Point = new Point(100, 100);
		protected var _rowCount:int = 5;
		protected var _itemCount:int;
		protected var _currentItem:int;
		protected var _removedChildren:Array;
		protected var _filter:String;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function Column() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function validateLayout(event:Event = null):void 
		{
			super.validateLayout(event);
			layOutChildren();
		}
		
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function layOutChildren():void
		{
			if (_dataProvider === null) return;
			if (!_dataProvider.*.length()) return;
			_currentItem = 0;
			_removedChildren = [];
			var i:int;
			while (super.numChildren > i)
			{
				_removedChildren.push(super.removeChildAt(0));
			}
			_dataProvider.*.(createChild(valueOf()));
			dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED));
		}
		
		protected function createChild(xml:XML):Boolean
		{
			var child:DisplayObject;
			var recycledChild:DisplayObject;
			for each(var ir:IRenderer in _removedChildren)
			{
				if (ir.data === xml && ir.isValid)
				{
					recycledChild = ir as DisplayObject;
				}
			}
			if (recycledChild)
			{
				child = recycledChild;
			}
			else
			{
				child = new _rendererFactory() as DisplayObject;
			}
			if (!child) return false;
			if (!(child is IRenderer)) return false;
			child.width = _cellSize.x;
			child.height = _cellSize.y;
			child.y = _currentItem * _cellSize.y;
			if (!recycledChild) (child as IRenderer).data = xml;
			super.addChild(child);
			_currentItem++;
			return true;
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