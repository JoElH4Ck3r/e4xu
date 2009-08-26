package org.wvxvws.validation.collections
{
	import org.wvxvws.validation.Node;
	import org.wvxvws.validation.ValidationError;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Nodes extends Array implements INodes
	{
		public static const OPTIONAL:int = 0;
		public static const MANDATORY:int = 1;
		public static const UNIQUE:int = 2;
		public static const CHOICE:int = 3;
		
		private var _class:Class;
		protected var _error:ValidationError;
		
		public function Nodes(nodes:Array = null) 
		{
			super();
			_class = (this as Object).constructor as Class;
			if (_class === Nodes) throw new Error("Abstract class.");
			for each (var n:Node in nodes) super.push(n);
		}
		
		AS3 override function concat(...rest):Array 
		{
			var copy:Array = super.concat();
			//for each (var n:Node in rest) n.setDTD(_dtd);
			var result:Nodes = 
				new _class(copy.concat.apply(copy, rest));
			return result;
		}
		
		AS3 override function push(...rest):uint 
		{
			for each (var n:Node in rest)
			{
				super.push(n);
				//n.setDTD(_dtd);
			}
			return super.length;
		}
		
		AS3 override function unshift(...rest):uint 
		{
			for each (var n:Node in rest)
			{
				super.unshift(n);
				//n.setDTD(_dtd);
			}
			return super.length;
		}
		
		AS3 override function splice(...rest):* 
		{
			var copy:Array = rest.slice();
			copy.shift();
			copy.shift();
			var i:int;
			for each (var n:Node in copy) i++;
			return super.splice.apply(this, rest);
		}
		
		public function nodeAt(index:int):Node
		{
			var a:Array = super.concat();
			return a[index];
		}
		
		internal final function clone():Array { return super.concat(); }
		
		public virtual function validate(list:XMLList):Boolean
		{
			throw new Error("Abstract method.");
			return false;
		}
		
		public function get error():ValidationError { return _error; }
		
		public function toString():String
		{
			var c:String = getQualifiedClassName(_class).split("::").pop();
			return c + "-(" + super.concat().toString() + ")";
		}
	}
	
}