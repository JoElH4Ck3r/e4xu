package org.wvxvws.automation.nodes
{
	public class Node
	{
		public var parent:Node;
		
		public function get value():* { return this._value; }
		
		protected var _value:*;
		
		protected var _context:Function;
		protected var _methodResolver:Function;
		
		public function Node(value:* = undefined, context:Function = null, 
			methodResolver:Function = null)
		{
			super();
			this._value = value;
			this._context = context;
			this._methodResolver = methodResolver;
		}
	}
}