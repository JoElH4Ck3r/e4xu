package org.wvxvws.gui.containers 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.events.Event;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.IRenderer;
	//}
	
	[Event(name="childrenCreated", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	* Pane class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Pane extends DIV
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
		
		[Bindable("labelFieldChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelFieldChange</code> event.
		*/
		public function get labelField():String { return _labelField; }
		
		public function set labelField(value:String):void 
		{
			if (_labelField === value) return;
			_labelField = value;
			invalidLayout = true;
			dispatchEvent(new Event("labelFieldChange"));
		}
		
		[Bindable("labelFunctionChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelFunctionChange</code> event.
		*/
		public function get labelFunction():Function { return _labelFunction; }
		
		public function set labelFunction(value:Function):void 
		{
			if (_labelFunction === value) return;
			_labelFunction = value;
			invalidLayout = true;
			dispatchEvent(new Event("labelFunctionChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _dataProvider:XML;
		protected var _dataProviderCopy:XML;
		protected var _currentItem:int;
		protected var _removedChildren:Array;
		protected var _rendererFactory:Class;
		protected var _labelFunction:Function;
		protected var _labelField:String = "@label";
		
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
		
		public function Pane() { super(); }
		
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
			for each (var xn:XML in _dataProvider.*)
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
			if (!_rendererFactory) return;
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
		
		protected function createChild(xml:XML):DisplayObject
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
			if (!child) return null;
			if (!(child is IRenderer)) return null;
			(child as IRenderer).labelField = _labelField;
			(child as IRenderer).labelFunction = _labelFunction;
			if (!recycledChild) (child as IRenderer).data = xml;
			super.addChild(child);
			_currentItem++;
			return child;
		}
		
		protected function providerNotifier(targetCurrent:Object, command:String, 
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
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
	}
	
}