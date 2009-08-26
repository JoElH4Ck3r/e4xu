package org.wvxvws.validation.collections
{
	import org.wvxvws.validation.Node;
	import org.wvxvws.validation.validation_internal;
	import org.wvxvws.validation.Attribute;
	import org.wvxvws.validation.Rule;
	import org.wvxvws.validation.ValidationError;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Attributes extends Dictionary implements IAttributes
	{
		private var _class:Class;
		private var _idGenerator:int;
		
		protected var _error:ValidationError;
		
		public function Attributes(attributes:Array = null) 
		{
			super();
			_class = (this as Object).constructor as Class;
			if (_class === Attributes) throw new Error("Abstract class.");
			for each (var att:Attribute in attributes) add(att);
		}
		
		public function add(attribute:Attribute):Attribute
		{
			attribute.validation_internal::setIndex(generateID());
			this[attribute] = attribute.index.toString(36) + attribute.nameSpace;
			return attribute;
		}
		
		public function remove(attribute:Attribute):Attribute
		{
			delete this[attribute];
			return attribute;
		}
		
		public function find(index:int, nameSpace:String = ""):Attribute
		{
			for (var obj:Object in this)
			{
				if (this[obj] === index.toString(36) + nameSpace)
				{
					return obj as Attribute;
				}
			}
			return null;
		}
		
		public function merge(attributes:Attributes):Attributes
		{
			var a:Attributes = new _class() as Attributes;
			var obj:Object;
			for (obj in this)
			{
				a[obj] = this[obj];
			}
			for (obj in attributes)
			{
				a[obj] = attributes[obj];
			}
			return a;
		}
		
		public virtual function validate(attributes:Object, owner:Node):Boolean
		{
			throw new Error("Must override");
			return false;
		}
		
		public function toString():String
		{
			var s:String = "";
			for (var obj:Object in this)
			{
				s += s ? "|" + obj.toString() : obj.toString();
			}
			return s;
		}
		
		protected function attributesToString(attributes:Object):String
		{
			var s:String;
			for (var p:String in attributes)
			{
				s += s ? "|" + p : p;
			}
			return s;
		}
		
		private function generateID():int { return (++_idGenerator); }
		
		public function get error():ValidationError { return _error; }
	}
	
}