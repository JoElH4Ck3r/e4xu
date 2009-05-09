////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

package org.wvxvws.gui.containers
{
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import org.wvxvws.animation.easingDefault;
	//}
	
	/**
	 * Menu class.
	 * @author wvxvw
	 */
	public class Tris extends DIV
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property easing
		//------------------------------------
		
		[Bindable("easingChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>easingChange</code> event.
		*/
		public function get easing():Function { return _easing; }
		
		public function set easing(value:Function):void 
		{
		   if (_easing == value) return;
		   _easing = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("easingChange"));
		}
		
		//------------------------------------
		//  Public property duration
		//------------------------------------
		
		[Bindable("durationChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>durationChange</code> event.
		*/
		public function get duration():int { return _duration; }
		
		public function set duration(value:int):void 
		{
		   if (_duration == value) return;
		   _duration = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("durationChange"));
		}
		
		//------------------------------------
		//  Public property distance
		//------------------------------------
		
		[Bindable("distanceChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>distanceChange</code> event.
		*/
		public function get distance():int { return _distance; }
		
		public function set distance(value:int):void 
		{
		   if (_distance == value) return;
		   _distance = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("distanceChange"));
		}
		
		//------------------------------------
		//  Public property gutter
		//------------------------------------
		
		[Bindable("gutterChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>gutterChange</code> event.
		*/
		public function get gutter():int { return _gutter; }
		
		public function set gutter(value:int):void 
		{
		   if (_gutter == value) return;
		   _gutter = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("gutterChange"));
		}
		
		//------------------------------------
		//  Public property dataProvider
		//------------------------------------
		
		[Bindable("dataProviderChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>dataProviderChange</code> event.
		*/
		public function get dataProvider():XML { return _dataProvider; }
		
		public function set dataProvider(value:XML):void 
		{
			if (_dataProvider == value) return;
			_dataProvider = value;
			_dataProviderCopy = value.copy();
			_dataProvider.setNotification(providerNotifier);
			invalidLayout = true;
			dispatchEvent(new Event("dataProviderChange"));
		}
		
		//------------------------------------
		//  Public property playing
		//------------------------------------
		
		[Bindable("playingChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>playingChange</code> event.
		*/
		public function get playing():Boolean { return _playing; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _windows:Array = [];
		protected var _handles:Array = [];
		protected var _gutter:int = 10;
		protected var _distance:int = 100;
		protected var _selection:DisplayObject;
		protected var _windowHolder:Sprite = new Sprite();
		protected var _handleHolder:Sprite = new Sprite();
		protected var _moveLeft:Array = [];
		protected var _moveRight:Array = [];
		protected var _animatedDestinations:Dictionary = new Dictionary();
		protected var _currentRightPosition:Dictionary = new Dictionary();
		
		protected var _duration:int = 1000;
		protected var _currentTime:int;
		protected var _startTime:int;
		protected var _easing:Function = easingDefault;
		protected var _playing:Boolean;
		
		protected var _handleRenderer:Class = Renderer;
		protected var _windowRenderer:Class = Renderer;
		protected var _dataProvider:XML;
		protected var _dataProviderCopy:XML;
		protected var _removedHandles:Array;
		protected var _removedWidows:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Tris()
		{
			super();
			super.addChild(_windowHolder);
			super.addChild(_handleHolder);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function validateLayout(event:Event = null):void 
		{
			super.validateLayout(event);
			layOutChildren();
		}
		
		protected function enterFrameHandler(event:Event):void 
		{
			_currentTime = getTimer() - _startTime;
			var d:Number = _easing(_currentTime, 0, _distance, _duration);
			if (_currentTime > _duration)
			{
				_playing = false;
				animate(1);
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				dispatchEvent(new Event("playingChange"));
				return;
			}
			animate(d / _distance);
		}
		
		protected function item_clickHandler(event:MouseEvent):void 
		{
			_selection = event.currentTarget as DisplayObject;
			_playing = true;
			dispatchEvent(new Event("playingChange"));
			positionForItem(_selection);
			_startTime = getTimer();
			_currentTime = 0;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		public function selectItem(itemPos:int):void
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//---------------------------------
		protected function layOutChildren():void
		{
			if (_dataProvider === null) return;
			if (!_dataProvider.*.length()) return;
			_removedHandles = [];
			_removedWidows = [];
			_handles = [];
			_windows = [];
			while (_removedHandles.numChildren > 0)
			{
				_removedHandles.push(_handleHolder.removeChildAt(0));
			}
			while (_removedWidows.numChildren > 0)
			{
				_removedWidows.push(_windowHolder.removeChildAt(0));
			}
			_dataProvider.*.(addHandle(valueOf()) && addWindow(valueOf()));
			dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED));
		}
		
		protected function addHandle(xml:XML):Boolean
		{
			var child:DisplayObject;
			var recycledChild:DisplayObject;
			var lnt:int = _dataProvider.*.length();
			var handleWidth:int = (width - _distance - _gutter * lnt) / lnt;
			for each(var ir:IRenderer in _removedHandles)
			{
				if (ir.data === xml && ir.isValid)
				{
					recycledChild = ir as DisplayObject;
				}
			}
			if (recycledChild)
			{
				child = recycledChild;
			}
			else
			{
				child = new _handleRenderer() as DisplayObject;
			}
			if (!child) return false;
			if (!(child is IRenderer)) return false;
			var cPos:int = cumulativeWidth();
			if (cPos) child.x = _gutter + cPos;
			else child.x = _distance;
			child.width = handleWidth;
			child.height = height;
			_handles.push(child);
			_animatedDestinations[child] = child.x;
			child.addEventListener(MouseEvent.CLICK, item_clickHandler);
			if (!recycledChild) (child as IRenderer).data = xml;
			_handleHolder.addChild(child);
			return true;
		}
		
		protected function addWindow(xml:XML):Boolean
		{
			var child:DisplayObject;
			var recycledChild:DisplayObject;
			for each(var ir:IRenderer in _removedWidows)
			{
				if (ir.data === xml && ir.isValid)
				{
					recycledChild = ir as DisplayObject;
				}
			}
			if (recycledChild)
			{
				child = recycledChild;
			}
			else
			{
				child = new _windowRenderer() as DisplayObject;
			}
			_windowHolder.addChild(child);
			return true;
		}
		
		//---------------------------------
		
		protected function cumulativeWidth():int
		{
			if (!_handles.length) return 0;
			_handles.sortOn("x");
			var d:DisplayObject = _handles[_handles.length - 1];
			return d.x + d.width;
		}
		
		protected function positionForItem(item:DisplayObject):int
		{
			var i:int;
			var expectedPos:int;
			if (_handles.indexOf(item) < 0) return 0;
			_moveLeft = [];
			_moveRight = [];
			while (_handles[i] !== item)
			{
				expectedPos += _handles[i].width + _gutter;
				_moveLeft.push(_handles[i]);
				i++;
			}
			_moveLeft.push(item);
			for each(var d:DisplayObject in _handles)
			{
				if (_moveLeft.indexOf(d) < 0)
				{
					_moveRight.push(d);
					_currentRightPosition[d] = d.x;
				}
			}
			if (expectedPos) return expectedPos + _gutter;
			return expectedPos;
		}
		
		protected function animate(step:Number):void
		{
			var item:DisplayObject;
			for each(item in _moveLeft)
			{
				item.x = int(_animatedDestinations[item]) - step * _distance;
			}
			for each(item in _moveRight)
			{
				item.x = int(_currentRightPosition[item]) +
					(int(_animatedDestinations[item]) - 
					int(_currentRightPosition[item])) * step;
			}
		}
		
		public function getItemForNode(node:XML):DisplayObject
		{
			var i:int;
			while (i < _handleHolder.numChildren)
			{
				if ((_handleHolder.getChildAt(i) as IRenderer).data === node) 
					return _handleHolder.getChildAt(i);
				i++;
			}
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function providerNotifier(targetCurrent:Object, command:String, 
									target:Object, value:Object, detail:Object):void
		{
			var renderer:IRenderer;
			switch (command)
			{
				    case "attributeAdded":
					case "attributeChanged":
					case "attributeRemoved":
						renderer = getItemForNode(target as XML) as IRenderer;
						renderer.data = target as XML;
						break;
					case "nodeAdded":
						{
							var needReplace:Boolean;
							var nodeList:Array = [];
							var firstIndex:int;
							var lastIndex:int;
							var correctNodeList:XMLList;
							(targetCurrent as XML).*.(nodeList.push(valueOf()));
							for each (var node:XML in nodeList)
							{
								if (nodeList.indexOf(node) != nodeList.lastIndexOf(node))
								{
									firstIndex = nodeList.indexOf(node);
									lastIndex = nodeList.lastIndexOf(node);
									needReplace = true;
									break;
								}
							}
							if (needReplace)
							{
								if (_dataProvider.*[firstIndex].contains(_dataProviderCopy.*[firstIndex]))
								{
									nodeList.splice(firstIndex, 1);
									_dataProvider.setChildren("");
									_dataProvider.normalize();
									while (nodeList.length)
									{
										_dataProvider.appendChild(nodeList.shift());
									}
									_dataProviderCopy = _dataProvider.copy();
									return;
								}
								else
								{
									nodeList.splice(lastIndex, 1);
									_dataProvider.setChildren("");
									_dataProvider.normalize();
									while (nodeList.length)
									{
										_dataProvider.appendChild(nodeList.shift());
									}
									_dataProviderCopy = _dataProvider.copy();
									return;
								}
							}
							invalidLayout = true;
						}
						break;
					case "textSet":
					case "nameSet":
					case "nodeChanged":
					case "nodeRemoved":
						invalidLayout = true;
						break;
					case "namespaceAdded":
						
						break;
					case "namespaceRemoved":
						
						break;
					case "namespaceSet":
						
						break;
			}
			_dataProviderCopy = _dataProvider.copy();
		}
	}
}