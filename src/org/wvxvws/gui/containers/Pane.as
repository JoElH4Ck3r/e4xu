package org.wvxvws.gui.containers 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.events.Event;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	//}
	
	[Event(name="childrenCreated", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="dataChanged", type="org.wvxvws.gui.GUIEvent")]
	
	[DefaultProperty("dataProvider")]
	
	[Skin("org.wvxvws.skins.LabelSkin")]
	
	/**
	* Pane class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Pane extends DIV implements ISkinnable
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
			super.invalidate("_dataProvider", _dataProvider, false);
			super.dispatchEvent(new GUIEvent(GUIEvent.DATA_CHANGED));
		}
		
		[Bindable("labelSkinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelSkinChanged</code> event.
		*/
		public function get labelSkin():ISkin { return _labelSkin; }
		
		public function set labelSkin(value:ISkin):void 
		{
			if (_labelSkin === value) return;
			_labelSkin = value;
			super.invalidate("_labelSkin", _labelSkin, false);
			if (super.hasEventListener(EventGenerator.getEventType("labelSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return new <ISkin>[_labelSkin]; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (value && value.length && _labelSkin === value[0]) return;
			if (value && value.length) _labelSkin = value[0];
			else _labelSkin = null;
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		public function get subContainers():Vector.<Pane> { return _subContainers; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _dataProvider:XML;
		protected var _dataProviderCopy:XML;
		protected var _currentItem:int;
		protected var _removedChildren:Vector.<DisplayObject>;
		protected var _rendererFactory:Class;
		protected var _dispatchCreated:Boolean;
		protected var _subContainers:Vector.<Pane>;
		protected var _labelSkin:ISkin;
		
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
		
		public override function validate(properties:Object):void 
		{
			if ("_dataProvider" in properties) this.layOutChildren();
			super.validate(properties);
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
			_removedChildren = new <DisplayObject>[];
			var i:int;
			while (super.numChildren > i)
				_removedChildren.push(super.removeChildAt(0));
			_dispatchCreated = false;
			_dataProvider.*.(this.createChild(valueOf()));
			if (_dispatchCreated) 
				super.dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED, false, true));
		}
		
		protected function createChild(xml:XML):DisplayObject
		{
			var child:DisplayObject;
			var recycledChild:DisplayObject;
			var dirtyChild:DisplayObject;
			for each (var ir:IRenderer in _removedChildren)
			{
				if (ir.data === xml && ir.isValid)
					recycledChild = ir as DisplayObject;
				else if (ir.data === xml)
					dirtyChild = ir as DisplayObject;
			}
			if (recycledChild) child = recycledChild;
			else if (dirtyChild) child = dirtyChild;
			else
			{
				_dispatchCreated = true;
				child = new _rendererFactory() as DisplayObject;
			}
			if (!child) return null;
			if (!(child is IRenderer)) return null;
			//if (_useLabelField) (child as IRenderer).labelField = _labelField;
			//if (_useLabelFunction)
			(child as IRenderer).labelSkin = _labelSkin;
			if (!recycledChild || dirtyChild)
			{
				(child as IRenderer).data = xml;
				if (child is IMXMLObject)
					(child as IMXMLObject).initialized(this, xml.localName());
			}
			super.addChild(child);
			_currentItem++;
			return child;
		}
		
		protected function providerNotifier(targetCurrent:Object, command:String, 
									target:Object, value:Object, detail:Object):void
		{
			var renderer:IRenderer;
			var pane:Pane;
			var doc:DisplayObject;
			var subs:Vector.<Pane>;
			switch (command)
			{
				    case "attributeAdded":
					case "attributeChanged":
					case "attributeRemoved":
						doc = getItemForNode(target as XML);
						renderer = doc as IRenderer;
						pane = doc as Pane;
						if (renderer) renderer.data = target as XML;
						else if (pane)
						{
							subs = pane.subContainers;
							for each (var p:Pane in subs)
							{
								doc = p.getItemForNode(target as XML);
								renderer = doc as IRenderer;
								if (renderer) renderer.data = target as XML;
							}
							//pane.dataProvider = target as XML;
						}
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
							invalidate("_dataProvider", _dataProvider, false);
						}
						break;
					case "textSet":
					case "nameSet":
					case "nodeChanged":
					case "nodeRemoved":
						invalidate("_dataProvider", _dataProvider, false);
						break;
					case "namespaceAdded":
						
						break;
					case "namespaceRemoved":
						
						break;
					case "namespaceSet":
						
						break;
			}
			_dataProviderCopy = _dataProvider.copy();
			dispatchEvent(new GUIEvent(GUIEvent.DATA_CHANGED));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
	}
	
}