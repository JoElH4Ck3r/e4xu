package org.wvxvws.xmlutils 
{
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	/**
	* InteractiveList class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public dynamic class InteractiveList extends Proxy
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
		
		private var _nodes:Array = [];
		private var _root:InteractiveModel;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function InteractiveList(root:InteractiveModel, nodes:XMLList) 
		{
			super();
			_root = root;
			if (nodes) populate(nodes);
			
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function root():InteractiveModel { return _root; }
		
		public function toXMLString():String
		{
			var rstr:String = "";
			var l:int = _nodes.length;
			for (var i:int; i < l; i++)
			{
				rstr += XUtils.objectToXML(_nodes[i]).toString();
			}
			return rstr;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		flash_proxy override function getProperty(name:*):* 
		{
			trace("getProperty", name);
			return findMatch(String(name));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function findMatch(name:String):InteractiveModel
		{
			var i:int = _nodes.length;
			while (i--) 
			{
				trace("searching " + _nodes[i].name());
				if (_nodes[i].name() == name) return _nodes[i];
			}
			return null;
		}
		
		private function populate(nodes:XMLList):void
		{
			nodes.(_nodes[_nodes.push(new InteractiveModel(valueOf(), 
				_root)) - 1].addEventListener(IMEvent.IMCHANGE, _root.imeChangeHandler));
		}
	}
	
}