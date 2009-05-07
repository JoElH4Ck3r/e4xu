﻿////////////////////////////////////////////////////////////////////////////////
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

package org.wvxvws.gui 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	//}
	
	[CSS(x="n", y="n", width="n", height="n", direction="b", backgroundColor="u")]
	
	/**
	* Scroller class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Scroller extends DIV
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property target
		//------------------------------------
		
		[Bindable("targetChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>targetChange</code> event.
		*/
		public function get target():DisplayObject { return _target; }
		
		public function set target(value:DisplayObject):void 
		{
		   if (_target == value) return;
		   _target = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("targetChange"));
		}
		
		//------------------------------------
		//  Public property area
		//------------------------------------
		
		[Bindable("areaChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>areaChange</code> event.
		*/
		public function get area():Rectangle { return _area; }
		
		public function set area(value:Rectangle):void 
		{
		   if (_area == value) return;
		   _area = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("areaChange"));
		}
		
		//------------------------------------
		//  Public property minHandle
		//------------------------------------
		
		[Bindable("minHandleChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>minHandleChange</code> event.
		*/
		public function get minHandle():DisplayObject { return _minHandle; }
		
		public function set minHandle(value:DisplayObject):void 
		{
		   if (_minHandle == value) return;
		   _minHandle = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("minHandleChange"));
		}
		
		//------------------------------------
		//  Public property maxHandle
		//------------------------------------
		
		[Bindable("maxHandleChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>maxHandleChange</code> event.
		*/
		public function get maxHandle():DisplayObject { return _maxHandle; }
		
		public function set maxHandle(value:DisplayObject):void 
		{
		   if (_maxHandle == value) return;
		   _maxHandle = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("maxHandleChange"));
		}
		
		//------------------------------------
		//  Public property handle
		//------------------------------------
		
		[Bindable("handleChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>handleChange</code> event.
		*/
		public function get handle():DisplayObject { return _handle; }
		
		public function set handle(value:DisplayObject):void 
		{
		   if (_handle == value) return;
		   _handle = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("handleChange"));
		}
		
		//------------------------------------
		//  Public property direction
		//------------------------------------
		
		[Bindable("directionChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>directionChange</code> event.
		*/
		public function get direction():Boolean { return _direction; }
		
		public function set direction(value:Boolean):void 
		{
		   if (_direction == value) return;
		   _direction = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("directionChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _target:DisplayObject;
		protected var _area:Rectangle = new Rectangle(0, 0, 100, 100);
		protected var _minHandle:DisplayObject = new Sprite() as DisplayObject;
		protected var _maxHandle:DisplayObject = new Sprite() as DisplayObject;
		protected var _handle:DisplayObject = new Sprite() as DisplayObject;
		
		protected var _direction:Boolean;
		protected var _path:Number = 100;
		protected var _handleSize:int = 10;
		protected var _minMaxHandleSize:int = 10;
		
		protected var _moveFunction:Function;
		protected var _handleShift:Number;
		protected var _position:Number = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Scroller()
		{
			super();
			initUI();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function validateLayout(event:Event = null):void 
		{
			super.validateLayout(event);
			if (_direction)
			{
				_minHandle.width = width;
				_maxHandle.width = width;
				_handle.width = width;
				_maxHandle.y = height - _maxHandle.height;
				_path = height - (_minHandle.height + _maxHandle.height);
				_handle.height = handleRatio() * _path;
				_handle.y = _minHandle.height + (_path - _handle.height) * _position;
			}
			else
			{
				_minHandle.width = height;
				_maxHandle.width = height;
				_handle.width = width;
				_handle.rotation = -90;
				_handle.y = height;
				_minHandle.rotation = -90;
				_minHandle.y = height;
				_maxHandle.rotation = -90;
				_maxHandle.y = height;
				_path = width - (_minHandle.width + _maxHandle.width);
				_maxHandle.x = width - _maxHandle.height;
				_handle.height = handleRatio() * _path;
				_handle.x = _minHandle.height + (_path - _handle.height) * _position;
			}
			if (!super.contains(_minHandle)) super.addChild(_minHandle);
			if (!super.contains(_maxHandle)) super.addChild(_maxHandle);
			if (!super.contains(_handle)) super.addChild(_handle);
			if (!_minHandle.willTrigger(MouseEvent.MOUSE_DOWN))
			{
				_minHandle.addEventListener(MouseEvent.MOUSE_DOWN, 
									minmax_mouseDownHandler, false, 0, true);
				_minHandle.addEventListener(MouseEvent.MOUSE_UP, 
									minmax_mouseUpHandler, false, 0, true);
			}
			if (!_maxHandle.willTrigger(MouseEvent.MOUSE_DOWN))
			{
				_maxHandle.addEventListener(MouseEvent.MOUSE_DOWN, 
									minmax_mouseDownHandler, false, 0, true);
				_maxHandle.addEventListener(MouseEvent.MOUSE_UP, 
									minmax_mouseUpHandler, false, 0, true);
			}
			if (!_handle.willTrigger(MouseEvent.MOUSE_DOWN))
			{
				_handle.addEventListener(MouseEvent.MOUSE_DOWN, 
									handle_mouseDownHandler, false, 0, true);
				_handle.addEventListener(MouseEvent.MOUSE_UP, 
									handle_mouseUpHandler, false, 0, true);
			}
			_target.scrollRect = _area;
		}
		
		public function scrollTo(value:Number):void
		{
			var limit:Number;
			var shift:Number;
			if (_direction)
			{
				limit = _target.height - _area.height;
				shift = value * limit;
				_area.y = shift;
				_target.scrollRect = _area;
				_position = value;
				_handle.y = _minHandle.height + (_path - _handle.height) * value;
			}
			else
			{
				limit = _target.width - _area.width;
				shift = value * limit;
				_area.x = shift;
				_target.scrollRect = _area;
				_position = value;
				_handle.x = _minHandle.height + (_path - _handle.width) * value;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function minmax_mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget === _maxHandle)
			{
				_moveFunction = moveAreaUp;
			}
			else
			{
				_moveFunction = moveAreaDown;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		protected function minmax_mouseUpHandler(event:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		protected function handle_mouseDownHandler(event:MouseEvent):void
		{
			_handleShift = _handle.mouseY * _handle.scaleY;
			_moveFunction = moveAreaUpDown;
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		protected function handle_mouseUpHandler(event:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			_moveFunction();
		}
		
		protected function moveAreaUp():void
		{
			var cs:Number = _position - .01;
			if (cs < 0) cs = 0;
			scrollTo(cs);
		}
		
		protected function moveAreaDown():void
		{
			var cs:Number = _position + .01;
			if (cs > 1) cs = 1;
			scrollTo(cs);
		}
		
		protected function moveAreaUpDown():void
		{
			if (_direction)
			{
				var toBeY:Number = mouseY - _handleShift;
				if (toBeY < _minHandle.height)
				{
					toBeY = _minHandle.height;
				}
				else if (toBeY > _maxHandle.y - _handle.height)
				{
					toBeY = _maxHandle.y - _handle.height;
				}
				scrollTo((toBeY - _maxHandle.height) / (_path - _handle.height));
			}
			else
			{
				var toBeX:Number = mouseX - _handleShift;
				if (toBeX < _minHandle.width)
				{
					toBeX = _minHandle.width;
				}
				else if (toBeX > _maxHandle.x - _handle.width)
				{
					toBeX = _maxHandle.x - _handle.width;
				}
				scrollTo((toBeX - _maxHandle.width) / (_path - _handle.width));
			}
		}
		
		protected function handleRatio():Number
		{
			if (!_target) return 1;
			if (_direction) return _area.height / _target.height;
			return _area.width / _target.width;
		}
		
		protected function initUI():void
		{
			(_minHandle as Sprite).graphics.beginFill(0);
			(_minHandle as Sprite).graphics.drawRect(0, 0, 10, 10);
			(_minHandle as Sprite).graphics.endFill();
			(_maxHandle as Sprite).graphics.beginFill(0);
			(_maxHandle as Sprite).graphics.drawRect(0, 0, 10, 10);
			(_maxHandle as Sprite).graphics.endFill();
			(_handle as Sprite).graphics.beginFill(0xFF);
			(_handle as Sprite).graphics.drawRect(0, 0, 10, 10);
			(_handle as Sprite).graphics.endFill();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}