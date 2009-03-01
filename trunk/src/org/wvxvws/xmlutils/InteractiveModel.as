package org.wvxvws.xmlutils
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import mx.core.IMXMLObject;
	
	[Event(name="imchange", type="org.wvxvws.xmlutils.IMEvent")]
	
	/**
	* InteractiveModel class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public dynamic class InteractiveModel extends Proxy implements IEventDispatcher, 
																	IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		//------------------------------------
		//  Public property source
		//------------------------------------
		
		private var _source:XML = null;
		
		[Bindable("imchange")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>sourceChange</code> event.
		 */
		public function get source():XML { return _map; }
		
		public function set source(value:XML):void 
		{
			if (_source == value) return;
			var old:XML = _map === null ? null : _map.copy();
			var path:String = "";
			var pt:Object = _source === null ? null : _source.parent();
			if (pt) 
			{
				path = pt.name();
				while (pt.parent())
				{
					path = path + "." + pt.name();
					pt = pt.parent();
				}
			}
			_source = value.copy();
			_children = new InteractiveList(_root, value.*);
			_attributes = new InteractiveList(_root, value.@*);
			_map.setChildren(_source);
			trace(toXMLString());
			dispatchEvent(new IMEvent(IMEvent.IMCHANGE, path, old, _map));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _instanceCounter:int;
		
		
		private var _dispatcher:EventDispatcher;
		private var _root:InteractiveModel;
		private var _id:String = idGenerator();
		private var _map:XML;
		private var _children:InteractiveList;
		private var _attributes:InteractiveList;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function InteractiveModel(xml:XML = null, root:InteractiveModel = null) 
		{
			super();
			_root = root ? root : this;
			if (xml)
			{
				//trace("InteractiveModel xml:", xml.toXMLString());
				if (xml.nodeKind() == "element")
				{
					_children = new InteractiveList(_root, xml.*);
				}
				else
				{
					_children = new InteractiveList(_root, null);
				}
				//trace("InteractiveModel setting attributes to:", xml.@*.toXMLString());
				_attributes = new InteractiveList(_root, xml.@*);
				_source = xml.copy();
				_map = xml.parent();
			}
			else
			{
				_children = new InteractiveList(_root, null);
				_attributes = new InteractiveList(_root, null);
				_source = <source/>;
				_map = <map/>;
			}
			if (_source[0].nodeKind() == "element")
			{
				_map.setChildren(_source);
				//_children = new InteractiveList(_root, xml.*);
			}
			else 
			{
				//_attributes = new InteractiveList(_root, xml.@*);
			}
			//if (_children) trace("InteractiveModel _children", _children.toXMLString());
			//if (_attributes) trace("InteractiveModel _attributes", _attributes.toXMLString());
			_dispatcher = new EventDispatcher(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function imeChangeHandler(event:IMEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		public function addEventListener(type:String, listener:Function, 
						useCapture:Boolean = false, priority:int = 0, 
						useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, 
												priority, useWeakReference);
		}
 	 	
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
 	 	
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
 	 	
		public function removeEventListener(type:String, listener:Function, 
									useCapture:Boolean = false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
 	 	
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		
		public function initialized(document:Object, id:String):void
		{ 
			_map.setName(id);
		}
		
		public function toString():String { return _map.toString(); }
		
		public function toXMLString():String { return _map.toXMLString(); }
		
		public function root():InteractiveModel { return _root; }
		
		public function toXML():XML { return XUtils.objectToXML(this); }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		flash_proxy override function callProperty(name:*, ...rest):* 
		{
			switch (String(name))
			{
				case "addNamespace":
					return _source.addNamespace(rest[0]);
				case "appendChild":
					return _source.appendChild(rest[0]);
				case "attribute":
					return _source.attribute(rest[0]);
				case "attributes":
					return _source.attributes();
				case "child":
					return _source.child(rest[0]);
				case "childIndex":
					return _source.childIndex();
				case "children":
					return _source.children();
				case "comments":
					return _source.comments();
				case "contains":
					return _source.contains(rest[0]);
				case "copy":
					return _source.copy();
				case "descendants":
					return _source.descendants(rest[0]);
				case "elements":
					return _source.elements(rest[0]);
				case "hasComplexContent":
					return _source.hasComplexContent();
				case "hasSimpleContent":
					return _source.hasSimpleContent();
				case "inScopeNamespaces":
					return _source.inScopeNamespaces();
				case "insertChildAfter":
					return _source.insertChildAfter(rest[0], rest[1]);
				case "insertChildBefore":
					return _source.insertChildBefore(rest[0], rest[1]);
				case "length":
					return _source.length();
				case "localName":
					return _source.localName();
				case "name":
					return _source.name();
				case "namespace":
					return _source.namespace(rest[0]);
				case "namespaceDeclarations":
					return _source.namespaceDeclarations();
				case "nodeKind":
					return _source.nodeKind();
				case "normalize":
					return _source.normalize();
				case "parent":
					return _source.parent();
				case "prependChild":
					return _source.prependChild(rest[0]);
				case "processingInstructions":
					return _source.processingInstructions(rest[0]);
				case "removeNamespace":
					return _source.removeNamespace(rest[0]);
				case "replace":
					return _source.replace(rest[0], rest[1]);
				case "setChildren":
					return _source.setChildren(rest[0]);
				case "setLocalName":
					return _source.setLocalName(rest[0]);
				case "setName":
					return _source.setName(rest[0]);
				case "setNamespace":
					return _source.setNamespace(rest[0]);
				case "text":
					return _source.text();
				case "toXMLString":
					return _source.toXMLString();
				default:
					throw new IllegalOperationError("No method " + 
								name + " on " + _id);
			}
			return undefined;
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean 
		{
			_source.replace(name as Object, null);
			return true;
		}
		
		flash_proxy override function getProperty(name:*):* 
		{
			trace("InteractiveModel getProperty", name, toXMLString());
			if (flash_proxy::isAttribute(name)) return _attributes[name];
			return _children[name];
		}
		
		flash_proxy override function hasProperty(name:*):Boolean 
		{
			if (_source[name].lenght()) return true;
			return false;
		}
		
		flash_proxy override function nextName(index:int):String 
		{
			return _source.*[index].name();
		}
		
		flash_proxy override function nextNameIndex(index:int):int 
		{
			if (index < _source.*.length()) return index + 1;
			return 0;
		}
		
		flash_proxy override function nextValue(index:int):* 
		{
			return _source.*[index];
		}
		
		flash_proxy override function setProperty(name:*, value:*):void 
		{
			trace("InteractiveModel setProperty", name, value);
			var old:XML;
			var checkName:XML = XUtils.objectToXML(name);
			var checkValue:XML = XUtils.objectToXML(value);
			if (checkName.hasSimpleContent() && !checkName.@ * .length() && 
					checkValue.hasSimpleContent() && !checkValue.@ * .length())
			{
				old = _source.@[name] ? _source.@[name].copy() : null;
				_source.@[name] = value;
				dispatchEvent(new IMEvent(IMEvent.IMCHANGE, "", old, value));
				return;
			}
			old = _source[name] ? _source[name].copy() : null;
			_source[name] = value;
			dispatchEvent(new IMEvent(IMEvent.IMCHANGE, "", old, value));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function idGenerator():String
		{
			return "InteractiveModel" + (++_instanceCounter);
		}
	}
	
}