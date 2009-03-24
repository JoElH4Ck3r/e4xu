package org.wvxvws.xmlutils
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import mx.core.IMXMLObject;
	import org.wvxvws.xmlutils.xmlutils_internal;
	
	[Event(name="imchange", type="org.wvxvws.xmlutils.IMEvent")]
	
	/**
	* InteractiveModel class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public dynamic class InteractiveModel extends Proxy implements IEventDispatcher, 
															IMXMLObject, IInteracive
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const ELEMENT:String = "element";
		public static const ATTRIBUTE:String = "attribute";
		public static const TEXT:String = "text";
		public static const COMMENT:String = "comment";
		public static const PI:String = "processing-instruction";
		public static const CDATA:String = "CData";
		
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
			_name = value.name();
			_children = new InteractiveList(_root, this, value.*);
			_attributes = new InteractiveList(_root, this, value.@*);
			if (_map === null) _map = <map/>;
			_map.setChildren(_source);
			//dispatchEvent(new IMEvent(generateEventType(), old, _map, this));
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
		
		private namespace wc3xml = "http://www.w3.org/XML/1998/namespace";
		
		private static var _instanceCounter:int;
		
		
		private var _dispatcher:EventDispatcher;
		private var _root:InteractiveModel;
		private var _id:String = idGenerator();
		private var _map:XML;
		private var _children:InteractiveList;
		private var _attributes:InteractiveList;
		private var _type:String = ELEMENT;
		private var _name:QName;
		private var _text:String;
		private var _url:String;
		private var _lang:String;
		private var _parent:InteractiveModel;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function InteractiveModel(xml:XML = null, root:InteractiveModel = null, 
													nodeIsAttribute:Boolean = false) 
		{
			super();
			_root = root ? root : this;
			var nodeKind:String
			if (xml !== null)
			{
				nodeKind = nodeIsAttribute ? ATTRIBUTE : xml.nodeKind();
				switch (nodeKind)
				{
					case ATTRIBUTE:
						_type = ATTRIBUTE;
						_text = xml.toXMLString();
						_name = QName(xml.name());
						break;
					case COMMENT:
						_type = COMMENT;
						_text = xml.toString();
						break;
					case ELEMENT:
						_type = ELEMENT;
						_name = xml.name();
						_text = xml.text().toXMLString();
						_children = new InteractiveList(_root, this, xml.children());
						_attributes = new InteractiveList(_root, this, xml.attributes());
						break;
					case PI:
						_type = PI;
						_name = QName(xml.name());
						break;
					case TEXT:
						if (xmlutils_internal::isCData(xml)) _type = CDATA;
						else _type = TEXT;
						_text = xml.toXMLString();
						break;
				}
				_map = XML(xml.copy());
			}
			_dispatcher = new EventDispatcher(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function generateEventType():String
		{
			var etype:String = _name ? _name.toString() : "*";
			if (_type == ATTRIBUTE) etype = "#" + etype;
			var nextParent:InteractiveModel = parent() as InteractiveModel;
			if (nextParent === root()) return nextParent.name() + "/" + etype;
			while (nextParent !== root())
			{
				etype = nextParent.name() + "/" + etype;
				nextParent = nextParent.parent();
			}
			return nextParent.name() + "/" + etype;
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
			if (event is IMEvent && this !== _root)
			{
				var etype:String = event.type;
				var tempEvent:String = etype;
				while (tempEvent.indexOf("/") > -1)
				{
					if (_root.hasEventListener(tempEvent))
					{
						_root.dispatchEvent(new IMEvent(tempEvent, 
							(event as IMEvent).oldValue, (event as IMEvent).newValue, this));
					}
					tempEvent = tempEvent.substr(0, tempEvent.lastIndexOf("/"));
				}
			}
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
			_name = new QName(id);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public XML methods
		//
		//--------------------------------------------------------------------------
		
		public function toString():String { return _map.toString(); }
		
		public function toXMLString():String
		{
			switch (_type)
			{
				case ATTRIBUTE:
				case COMMENT:
				case CDATA:
				case TEXT:
					return _text;
				case ELEMENT:
					return(
					<{_name} {generateAttributeString(_attributes)}>
						{generateChildrenList(_children)}</{_name}>.toXMLString()
					);
				case PI:
					return "<?" + _name + "?>";
			}
			return "";
		}
		
		public function name():Object { return _name ? _name : "*"; }
		
		public function root():InteractiveModel { return _root; }
		
		public function parent():InteractiveModel { return _parent; }
		
		public function url():String { return _url; }
		
		public function toXML():XML { return XUtils.objectToXML(this); }
		
		public function nodeKind():String { return _type; }
		
		wc3xml function lang():String { return _lang; }
		
		public function children():InteractiveList { return _children; }
		
		public function text():InteractiveList
		{
			var ret:InteractiveList;
			for each (var model:InteractiveModel in _children)
			{
				if (model.nodeKind() == InteractiveModel.TEXT)
				{
					if (!ret)
					{
						ret = new InteractiveList(model.root(), model.parent(), null);
						ret.append(model);
					}
					else
					{
						ret.append(model);
					}
				}
			}
			if (ret)
			{
				return ret;
			}
			return new InteractiveList(null, null, null);
		}
		
		public function filter(expression:String):InteractiveList
		{
			var list:InteractiveList;
			XPath.eval(expression, this);
			return list;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		xmlutils_internal function isCData(node:XML):Boolean
		{
			if (node.toXMLString().match(/^<!\[CDATA\[[^(\]\]>)]*\]\]>$/)) return true;
			return false;
		}
		
		xmlutils_internal function setParent(model:InteractiveModel):void
		{
			_parent = model;
		}
		
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
				case "namespace":
					return _source.namespace(rest[0]);
				case "namespaceDeclarations":
					return _source.namespaceDeclarations();
				case "normalize":
					return _source.normalize();
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
			var old:InteractiveModel;
			var oldName:String;
			if (flash_proxy::isAttribute(name))
			{
				old = _attributes[name];
				_attributes[name] = value;
				oldName = "/#" + old.name();
			}
			else
			{
				old = _children[name];
				_children[name] = value;
				oldName = "/" + old.name();
			}
			dispatchEvent(new IMEvent(generateEventType() + oldName, old, value, this));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function generateAttributeString(list:InteractiveList):String
		{
			var rs:String = "";
			for each(var p:InteractiveModel in list)
			{
				rs += p.name() + "=\"" + p.toString() + "\" ";
			}
			return rs;
		}
		
		private static function generateChildrenList(list:InteractiveList):XMLList
		{
			var rl:XMLList;
			for each(var p:InteractiveModel in list)
			{
				if (rl) rl += XML(p.toXMLString());
				else rl = XMLList(p.toXMLString());
			}
			return rl === null ? new XMLList() : rl;
		}
		
		private static function idGenerator():String
		{
			return "InteractiveModel" + (++_instanceCounter);
		}
	}
	
}