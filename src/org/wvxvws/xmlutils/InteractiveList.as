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
	public dynamic class InteractiveList extends Proxy implements IInteracive
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
		private var _parent:InteractiveModel;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function InteractiveList(root:InteractiveModel, parent:InteractiveModel,
																	nodes:XMLList) 
		{
			super();
			_root = root;
			_parent = parent;
			if (nodes) populate(nodes);
			
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function root():InteractiveModel { return _root; }
		
		public function toString():String { return toXMLString(); }
		
		public function text():InteractiveList
		{
			var ret:InteractiveList;
			for each(var node:InteractiveModel in _nodes)
			{
				if (node.nodeKind() == InteractiveModel.ELEMENT)
				{
					if (!ret)
					{
						ret = new InteractiveList(node.root(), node.parent(),
										XMLList(node.text().toXMLString()));
						ret.append(node);
					}
					else
					{
						ret.append(node);
					}
				}
			}
			if (ret)
			{
				return ret;
			}
			return new InteractiveList(null, null, null);
		}
		
		public function attributes():InteractiveList
		{
			var ret:InteractiveList;
			for each(var node:InteractiveModel in _nodes)
			{
				if (node.nodeKind() == InteractiveModel.ELEMENT)
				{
					if (!ret)
					{
						ret = new InteractiveList(node.root(), node.parent(), 
									XMLList(node.children().toXMLString()));
						ret.append(node);
					}
					else
					{
						ret.append(node);
					}
				}
			}
			if (ret)
			{
				return ret;
			}
			return new InteractiveList(null, null, null);
		}
		
		public function toXMLString():String
		{
			var rstr:String = "";
			var l:int = _nodes.length;
			for (var i:int; i < l; i++) rstr += _nodes[i].toXMLString();
			return rstr;
		}
		
		public function length():int { return _nodes.length; }
		
		public function append(node:InteractiveModel):InteractiveList
		{
			_nodes.push(node);
			return this;
		}
		
		public function filter(contition:String):InteractiveList
		{
			var list:InteractiveList;
			for each(var model:InteractiveModel in _nodes)
			{
				if (XPath.eval(contition, model))
				{
					if (!list)
					{
						list = new InteractiveList(model.root(), model.parent(), null);
					}
					else
					{
						list.append(model);
					}
				}
			}
			if (!list) return new InteractiveList(null, null, null);
			return list;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		xmlutils_internal function append(model:InteractiveModel):void
		{
			_nodes.push(model);
		}
		
		flash_proxy override function getProperty(name:*):* 
		{
			if (!isNaN(Number(name)) && Number(name) == int(name))
			{
				return _nodes[int(name)];
			}
			return findMatch(String(name));
		}
		
		flash_proxy override function setProperty(name:*, value:*):void 
		{
			var i:int = _nodes.length;
			var nodeIsAttribute:Boolean;
			var xml:XML;
			while (i--) 
			{
				if (_nodes[i].name() == name)
				{
					nodeIsAttribute = _nodes[i].nodeKind() == InteractiveModel.ATTRIBUTE;
					if (nodeIsAttribute) xml = <{name}>{value}</{name}>;
					else xml = XML(value);
					_nodes[i] = new InteractiveModel(xml, _root, nodeIsAttribute);
					(_nodes[i] as InteractiveModel).xmlutils_internal::setParent(_parent);
					return;
				}
			}
			nodeIsAttribute = flash_proxy::isAttribute(name);
			if (nodeIsAttribute) xml = <{name}>{value}</{name}>;
			else xml = XML(value);
			_nodes.push(new InteractiveModel(xml, _root, nodeIsAttribute));
			(_nodes[_nodes.length - 1] as InteractiveModel).xmlutils_internal::setParent(_parent);
		}
		
		flash_proxy override function nextName(index:int):String 
		{
			return _nodes[index - 1].name();
		}
		
		flash_proxy override function nextNameIndex(index:int):int 
		{
			if (index < _nodes.length) return index + 1;
			return 0;
		}
		
		flash_proxy override function nextValue(index:int):* 
		{
			return _nodes[index - 1];
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function findMatch(name:String):InteractiveModel
		{
			var i:int = _nodes.length;
			while (i--) if (_nodes[i].name() == name) return _nodes[i];
			return null;
		}
		
		private function populate(nodes:XMLList):void
		{
			if (nodes[0] === undefined) return;
			nodes.(_nodes.push(new InteractiveModel(valueOf(), _root)) &&
				_nodes[_nodes.length - 1].xmlutils_internal::setParent(_parent));
		}
	}
	
}