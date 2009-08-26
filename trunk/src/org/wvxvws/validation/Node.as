package org.wvxvws.validation 
{
	import org.wvxvws.validation.collections.Attributes;
	import org.wvxvws.validation.collections.AttributesChoice;
	import org.wvxvws.validation.collections.AttributesMandatory;
	import org.wvxvws.validation.collections.AttributesOptional;
	import org.wvxvws.validation.collections.IAttributes;
	import org.wvxvws.validation.collections.INodes;
	import org.wvxvws.validation.collections.Nodes;
	import org.wvxvws.validation.collections.NodesChoice;
	import org.wvxvws.validation.collections.NodesMandatory;
	import org.wvxvws.validation.collections.NodesOptional;
	import org.wvxvws.validation.collections.NodesUnique;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Node 
	{
		public static const NONE:int = 0x00;
		public static const ELEMENT:int = 0x01;
		public static const ATTRIBUTE:int = 0x02;
		public static const TEXT:int = 0x04;
		public static const PI:int = 0x08;
		public static const COMMENT:int = 0x0F;
		
		private static const ZERO:String = "0";
		
		private static const XMLTYPES:Object = 
		{
			"element" : 0x01,
			"attribute" : 0x02,
			"text" : 0x04,
			"processing-instruction" : 0x08,
			"comment" : 0x0F
		}
		
		protected var _name:Rule;
		protected var _nodeType:int;
		protected var _error:ValidationError;
		protected var _allowChildren:Boolean;
		
		protected var _nodesCollection:Dictionary = new Dictionary();
		protected var _attributesCollection:Dictionary = new Dictionary();
		
		private var _idGenerator:int;
		
		public function Node(name:Rule, nodeType:int = 0x01, allowChildren:Boolean = true) 
		{
			super();
			_name = name;
			_allowChildren = allowChildren;
			switch (nodeType)
			{
				case ELEMENT:
				case TEXT:
				case PI:
				case COMMENT:
					_nodeType = nodeType;
					break;
				default:
					throw new RangeError("Invalid nodeType");
			}
		}
		
		private function attributesToObject(xml:XML):Object
		{
			var o:Object = { };
			xml.@*.(o[localName()] = toXMLString());
			return o;
		}
		
		public function addNodesCollection(collection:INodes):void
		{
			_nodesCollection[collection] = getID();
		}
		
		public function removeNodesCollection(collection:INodes):void
		{
			delete _nodesCollection[collection];
		}
		
		public function addAttributesCollection(collection:IAttributes):void
		{
			_attributesCollection[collection] = getID();
		}
		
		public function removeAttributesCollection(collection:IAttributes):void
		{
			delete _attributesCollection[collection];
		}
		
		protected function getID():int { return (++_idGenerator); }
		
		public function validate(xml:XML):Boolean
		{
			_error = null;
			if (XMLTYPES[xml.nodeKind()] !== _nodeType)
			{
				for (var p:String in XMLTYPES)
				{
					if (XMLTYPES[p] === _nodeType) break;
				}
				_error = new ValidationError(ValidationError.BAD_TYPE, toString(), p);
				return false;
			}
			if (_nodeType === 0x01 || _nodeType === 0x08)
			{
				if (!_name.validate(xml.localName()))
				{
					_error = new ValidationError(ValidationError.BAD_NAME, toString());
					return false;
				}
			}
			if (_nodeType === 0x01)
			{
				if (!_allowChildren && xml.*.length())
				{
					_error = new ValidationError(ValidationError.CHILDREN_NOT_ALLOWED, toString());
					_error.validation_internal::setContext(xml.toXMLString(), this);
					return false;
				}
				var attributes:Object = attributesToObject(xml);
				var obj:Object;
				var inodes:INodes;
				var iatts:IAttributes;
				for (obj in _attributesCollection)
				{
					iatts = obj as IAttributes;
					if (!iatts.validate(attributes, this))
					{
						_error = iatts.error;
						return false;
					}
				}
				var children:XMLList = xml.*;
				for (obj in _nodesCollection)
				{
					inodes = obj as INodes;
					if (!inodes.validate(children))
					{
						_error = inodes.error;
						return false;
					}
				}
			}
			else if (_nodeType === 0x04)
			{
				if (!_name.validate(xml.toString()))
				{
					_error = _name.error;
					return false;
				}
			}
			// TODO: PI / Comments validation?
			return true;
		}
		
		public function get name():Rule { return _name; }
		
		public function set name(value:Rule):void 
		{
			_name = value;
		}
		
		public function get error():ValidationError { return _error; }
		
		public function toString():String
		{
			return "Node-<" + _name.toString() + ">";
		}
	}
	
}