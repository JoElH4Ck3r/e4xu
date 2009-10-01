package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.Renderer;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class NetsGrid extends Pane
	{
		protected var _cellHeight:int = -0x8000000;
		protected var _itemCount:int;
		protected var _columns:Vector.<Column> = new <Column>[];
		protected var _gutterH:int;
		protected var _gutterV:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _nestColumn:Column = new Column();
		protected var _currentDepth:int;
		protected var _cursor:int;
		protected var _isCurrentClosed:Boolean;
		protected var _closedNodes:Dictionary = new Dictionary();
		protected var _currentNode:XML;
		protected var _currentList:XMLList;
		
		public function NetsGrid() 
		{
			super();
			super._rendererFactory = Renderer;
		}
		
		protected override function layOutChildren():void 
		{
			if (_dataProvider === null) return;
			if (!_dataProvider.*.length()) return;
			if (!_rendererFactory) return;
			_currentItem = 0;
			_removedChildren = new <DisplayObject>[];
			var i:int;
			while (super.numChildren > i)
				_removedChildren.push(super.removeChildAt(0));
			_dispatchCreated = false;
			var nn:XML;
			_currentList = _dataProvider.*;
			_currentNode = _currentList[0];
			while (nn = nextNode())
			{
				trace("-------------------", _cursor, _currentDepth);
				trace(nn.toXMLString());
				//createChild(nn);
				if (_closedNodes[nn]) continue;
			}
			if (_dispatchCreated) 
				dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED, false, true));
		}
		
		protected function nextNode():XML
		{
			var lastNode:Boolean;
			if (_dataProvider === null)
			{
				_currentNode = null;
			}
			else if (_currentNode === null)
			{
				_currentList = _dataProvider.*;
				_currentNode = _currentList[0];
				//_cursor++;
			}
			else if (_cursor < _currentList.length())
			{
				_currentNode = _currentList[_cursor];
				if (!_cursor) _currentDepth++;
				if (_currentNode.*.length())
				{
					_currentList = _currentNode.*;
					_cursor = 0;
				}
				else _cursor++;
			}
			else
			{
				while (_cursor >= _currentList.length())
				{
					_currentNode = _currentNode.parent();
					if (_currentNode === _dataProvider)
					{
						_currentNode = null;
						_cursor = 0;
						lastNode = true;
						break;
					}
					_currentDepth--;
					_currentList = _currentNode.parent().*;
					_cursor = _currentNode.childIndex() + 1;
				}
				if (!lastNode)
				{
					_currentNode = _currentList[_cursor];
					_cursor++;
				}
			}
			return _currentNode;
		}
	}
	
}