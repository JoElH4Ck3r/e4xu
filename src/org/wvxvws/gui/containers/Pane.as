package org.wvxvws.gui.containers 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	//}
	
	[Event(name="childrenCreated", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="dataChanged", type="org.wvxvws.gui.GUIEvent")]
	
	[DefaultProperty("dataProvider")]
	
	[Skin("org.wvxvws.skins.LabelSkin")]
	[Skin("org.wvxvws.skins.renderers.ListRendererSkin")]
	
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
		
		public function get dataProvider():XML { return this._dataProvider; }
		
		public function set dataProvider(value:XML):void 
		{
			if (this._dataProvider === value) return;
			this._dataProvider = value;
			if (value) this._dataProviderCopy = value.copy();
			else this._dataProviderCopy = null;
			this._dataProvider.setNotification(this.providerNotifier);
			super.invalidate(Invalides.DATAPROVIDER, false);
			super.dispatchEvent(GUIEvent.DATA_CHANGED);
		}
		
		[Bindable("labelSkinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelSkinChanged</code> event.
		*/
		public function get labelSkin():ISkin { return this._labelSkin; }
		
		public function set labelSkin(value:ISkin):void 
		{
			if (this._labelSkin === value) return;
			this._labelSkin = value;
			if (!this._skin) this._skin = new <ISkin>[];
			while (this._skin.length < 2) this._skin.push(null);
			this._skin[0] = this._labelSkin;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("labelSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("rendererSkinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>rendererSkinChanged</code> event.
		*/
		public function get rendererSkin():ISkin { return this._rendererSkin; }
		
		public function set rendererSkin(value:ISkin):void 
		{
			if (this._rendererSkin === value) return;
			this._rendererSkin = value;
			if (!this._skin) this._skin = new <ISkin>[];
			while (this._skin.length < 2) this._skin.push(null);
			this._skin[1] = this._rendererSkin;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("rendererSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return this._skin; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (this._skin === value) return;
			this._skin = value;
			if (this._skin)
			{
				if (this._skin.length) this._labelSkin = this._skin[0];
				if (this._skin.length > 1) this._rendererSkin = this._skin[1];
			}
			super.invalidate(Invalides.SKIN, false);
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		public function get subContainers():Vector.<Pane> { return this._subContainers; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _dataProvider:XML;
		protected var _dataProviderCopy:XML;
		protected var _currentItem:int;
		protected var _removedChildren:Vector.<DisplayObject>;
		protected var _rendererSkin:ISkin;
		protected var _dispatchCreated:Boolean;
		protected var _subContainers:Vector.<Pane>;
		protected var _labelSkin:ISkin;
		protected var _skin:Vector.<ISkin>;
		
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
					return this._dataProvider.*[i];
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
			return this._dataProvider.*[index];
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
		
		public override function validate(properties:Dictionary):void 
		{
			if (!_skin)
			{
				this.skin = SkinManager.getSkin(this);
				if (!this._skin) this._skin = new <ISkin>[];
				this.validate(properties);
				return;
			}
			if (Invalides.DATAPROVIDER in properties) this.layOutChildren();
			super.validate(properties);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function layOutChildren():void
		{
			if (this._dataProvider === null) return;
			if (!this._dataProvider.*.length()) return;
			if (!this._rendererSkin) return;
			this._currentItem = 0;
			this._removedChildren = new <DisplayObject>[];
			var i:int;
			while (super.numChildren > i)
				this._removedChildren.push(super.removeChildAt(0));
			this._dispatchCreated = false;
			this._dataProvider.*.(this.createChild(valueOf()));
			if (this._dispatchCreated) 
				super.dispatchEvent(GUIEvent.CHILDREN_CREATED);
		}
		
		protected function createChild(xml:XML):DisplayObject
		{
			var child:DisplayObject;
			var recycledChild:DisplayObject;
			var dirtyChild:DisplayObject;
			for each (var ir:IRenderer in this._removedChildren)
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
				this._dispatchCreated = true;
				child = _rendererSkin.produce(this, xml) as DisplayObject;
			}
			if (!child) return null;
			if (!(child is IRenderer)) return null;
			(child as IRenderer).labelSkin = this._labelSkin;
			if (!recycledChild || dirtyChild)
			{
				(child as IRenderer).data = xml;
				if (child is IMXMLObject)
					(child as IMXMLObject).initialized(this, xml.localName());
			}
			super.addChild(child);
			this._currentItem++;
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
						doc = this.getItemForNode(target as XML);
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
								if (this._dataProvider.*[firstIndex].contains(
									this._dataProviderCopy.*[firstIndex]))
								{
									nodeList.splice(firstIndex, 1);
									this._dataProvider.setChildren("");
									this._dataProvider.normalize();
									while (nodeList.length)
									{
										_dataProvider.appendChild(nodeList.shift());
									}
									this._dataProviderCopy = this._dataProvider.copy();
									return;
								}
								else
								{
									nodeList.splice(lastIndex, 1);
									this._dataProvider.setChildren("");
									this._dataProvider.normalize();
									while (nodeList.length)
									{
										this._dataProvider.appendChild(nodeList.shift());
									}
									this._dataProviderCopy = this._dataProvider.copy();
									return;
								}
							}
							super.invalidate(Invalides.DATAPROVIDER, false);
						}
						break;
					case "textSet":
					case "nameSet":
					case "nodeChanged":
					case "nodeRemoved":
						invalidate(Invalides.DATAPROVIDER, false);
						break;
					case "namespaceAdded":
						
						break;
					case "namespaceRemoved":
						
						break;
					case "namespaceSet":
						
						break;
			}
			this._dataProviderCopy = this._dataProvider.copy();
			if (super.hasEventListener(GUIEvent.DATA_CHANGED.type))
				super.dispatchEvent(GUIEvent.DATA_CHANGED);
		}
	}
}