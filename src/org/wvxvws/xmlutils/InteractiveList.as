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
		
		public function parent():InteractiveModel
		{
			var toBeParent:InteractiveModel;
			for each(var model:InteractiveModel in _nodes)
			{
				if (!toBeParent)
				{
					toBeParent = model.parent();
				}
				else if (toBeParent !== model.parent())
				{
					return null;
				}
			}
			return toBeParent;
		}
		
		public function children():InteractiveList
		{
			var temp:InteractiveList;
			var child:InteractiveModel;
			for each(var model:InteractiveModel in _nodes)
			{
				if (!temp)
				{
					for each (child in model.children())
					{
						if (!temp) temp = new InteractiveList(child.root(), 
														child.parent(), null);
						temp.append(child);
					}
				}
				else
				{
					for each (child in model.children())
					{
						temp.append(child);
					}
				}
			}
			if (temp)
			{
				return temp;
			}
			return new InteractiveList(null, null, null);
		}
		
		public function toXMLString():String
		{
			var rstr:String = "";
			var l:int = _nodes.length;
			for (var i:int; i < l; i++) rstr += (rstr ? "\r" : "") + _nodes[i].toXMLString();
			return rstr;
		}
		
		public function length():int { return _nodes.length; }
		
		public function indexOf(node:InteractiveModel):int
		{
			return _nodes.indexOf(node);
		}
		
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
						list.append(model);
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
		
		xmlutils_internal function filterChildren(name:*):*
		{
			if (!isNaN(Number(name)) && Number(name) == int(name))
			{
				return _nodes[int(name)];
			}
			return findMatch(String(name));
		}
		
		flash_proxy override function getProperty(name:*):* 
		{
			if (!isNaN(Number(name)) && Number(name) == int(name))
			{
				return findNumMatch(int(name));
			}
			return findMatchInChildren(String(name));
		}
		
		private function findMatchInChildren(name:String):InteractiveList
		{
			var temp:InteractiveList;
			var tempChildren:InteractiveList;
			for each(var model:InteractiveModel in _nodes)
			{
				tempChildren = model[name];
				if (tempChildren)
				{
					for each(var child:InteractiveModel in tempChildren)
					{
						if (!temp)
						{
							temp = new InteractiveList(child.root(), child.parent(), null);
						}
						temp.append(child);
					}
				}
			}
			if (temp) return temp;
			return new InteractiveList(null, null, null);
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
		
		private function findMatch(name:String):InteractiveList
		{
			var temp:InteractiveList;
			var model:InteractiveModel;
			var i:int;
			var lnt:int = _nodes.length;
			for (i; i < lnt; i++)
			{
				model = _nodes[i];
				if (model.name() == name)
				{
					if (!temp)
					{
						temp = new InteractiveList(model.root(), model.parent(), null);
					}
					temp.append(model);
				}
			}
			if (temp) return temp;
			return new InteractiveList(null, null, null);
		}
		
		private function findNumMatch(name:int):InteractiveModel
		{
			var tempChildren:InteractiveList;
			var counter:int;
			for each(var model:InteractiveModel in _nodes)
			{
				tempChildren = model.children();
				for each(var child:InteractiveModel in tempChildren)
				{
					if (counter == name) return child;
					counter++;
				}
			}
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