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
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02116-1301, USA.
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
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.skins.ISkin;
	//}
	
	[Event(name="scrolled", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	* Scroller class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 16.0.12.36
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
		[Skinable(states="mouseUp,mouseDown,mouseOver")]
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>minHandleChange</code> event.
		*/
		public function get minHandle():DisplayObject { return _minHandle; }
		
		public function set minHandle(value:DisplayObject):void 
		{
		   if (_minHandle === value) return;
		   _minHandle = value;
		   if (_minHandle is ISkin) (_minHandle as ISkin).state = MouseEvent.MOUSE_UP;
		   invalidLayout = true;
		   dispatchEvent(new Event("minHandleChange"));
		}
		
		//------------------------------------
		//  Public property maxHandle
		//------------------------------------
		
		[Bindable("maxHandleChange")]
		[Skinable(states="mouseUp,mouseDown,mouseOver")]
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>maxHandleChange</code> event.
		*/
		public function get maxHandle():DisplayObject { return _maxHandle; }
		
		public function set maxHandle(value:DisplayObject):void 
		{
			if (_maxHandle === value) return;
			_maxHandle = value;
			if (_maxHandle is ISkin) 
				(_maxHandle as ISkin).state = MouseEvent.MOUSE_UP;
			invalidLayout = true;
			dispatchEvent(new Event("maxHandleChange"));
		}
		
		//------------------------------------
		//  Public property handle
		//------------------------------------
		
		[Bindable("handleChange")]
		[Skinable(states="up,over,down,disabled")]
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>handleChange</code> event.
		*/
		public function get handle():DisplayObject { return _handle; }
		
		public function set handle(value:DisplayObject):void 
		{
			if (_handle === value) return;
			_handle = value;
			if (_handle is ISkin) (_handle as ISkin).state = MouseEvent.MOUSE_UP;
			invalidLayout = true;
			dispatchEvent(new Event("handleChange"));
		}
		
		//------------------------------------
		//  Public property body
		//------------------------------------
		
		[Bindable("bodyChange")]
		[Skinable(states="up,over,down,disabled")]
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>handleChange</code> event.
		*/
		public function get body():DisplayObject { return _body; }
		
		public function set body(value:DisplayObject):void 
		{
			if (_body === value) return;
			if (_body && contains(_body)) removeChild(_body);
			_body = value;
			if (_body is ISkin) (_body as ISkin).state = MouseEvent.MOUSE_UP;
			invalidLayout = true;
			dispatchEvent(new Event("bodyChange"));
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
			if (_direction === value) return;
			_direction = value;
			invalidLayout = true;
			dispatchEvent(new Event("directionChange"));
		}
		
		[Bindable("handleWidthChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>handleWidthChange</code> event.
		*/
		public function get handleWidth():int { return _handleWidth; }
		
		public function set handleWidth(value:int):void 
		{
			if (_handleWidth === value) return;
			_handleWidth = value;
			invalidLayout = true;
			dispatchEvent(new Event("handleWidthChange"));
		}
		
		[Bindable("minMaxHandleSizeChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>minMaxHandleSizeChange</code> event.
		*/
		public function get minMaxHandleSize():int { return _minMaxHandleSize; }
		
		public function set minMaxHandleSize(value:int):void 
		{
			if (_minMaxHandleSize === value) return;
			_minMaxHandleSize = value;
			invalidLayout = true;
			dispatchEvent(new Event("minMaxHandleSizeChange"));
		}
		
		[Bindable("gutterChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>gutterChange</code> event.
		*/
		public function get gutter():int { return _gutter; }
		
		public function set gutter(value:int):void 
		{
			if (_gutter === value) return;
			_gutter = value;
			invalidLayout = true;
			dispatchEvent(new Event("gutterChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _target:DisplayObject;
		protected var _area:Rectangle = new Rectangle(0, 0, 160, 160);
		protected var _minHandle:DisplayObject = new Sprite() as DisplayObject;
		protected var _maxHandle:DisplayObject = new Sprite() as DisplayObject;
		protected var _handle:DisplayObject = new Sprite() as DisplayObject;
		protected var _body:DisplayObject = new Sprite() as DisplayObject;
		
		protected var _direction:Boolean;
		protected var _path:Number = 160;
		protected var _handleWidth:int = 25;
		protected var _minMaxHandleSize:int = 16;
		protected var _gutter:int = 7;
		
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
		
		override public function validate(properties:Object):void 
		{
			// TODO: Later...
			super.validate(properties);
			if ((_minHandle is ISkin) && !(_minHandle as ISkin).state)
			{
				(_minHandle as ISkin).state = MouseEvent.MOUSE_UP;
			}
			if ((_maxHandle is ISkin) && !(_maxHandle as ISkin).state)
			{
				(_maxHandle as ISkin).state = MouseEvent.MOUSE_UP;
			}
			if ((_handle is ISkin) && !(_handle as ISkin).state)
			{
				(_handle as ISkin).state = MouseEvent.MOUSE_UP;
			}
			if ((_body is ISkin) && !(_body as ISkin).state)
			{
				(_body as ISkin).state = MouseEvent.MOUSE_UP;
			}
			if (_direction)
			{
				_minHandle.width = width;
				_minHandle.height = _handleWidth;
				_maxHandle.width = width;
				_maxHandle.height = _handleWidth;
				_handle.width = width;
				_maxHandle.y = height - _maxHandle.height;
				_path = height - (_minHandle.height + _maxHandle.height);
				_handle.height = handleRatio() * _path + _gutter * 2;
				if (_handle.height > height - (_handleWidth + _gutter) * 2)
				{
					_handle.height = height - (_handleWidth + _gutter) * 2
				}
				_handle.y = _minHandle.height + 
							(_path - _handle.height) * _position - _gutter;
				_body.width = width;
				_body.height = height;
				//_body.y = _minHandle.height;
			}
			else
			{
				_minHandle.width = height;
				_minHandle.height = _handleWidth;
				_maxHandle.width = height;
				_maxHandle.height = _handleWidth;
				_minHandle.rotation = -90;
				_minHandle.y = height;
				_maxHandle.rotation = -90;
				_maxHandle.y = height;
				_path = width - (_minHandle.width + _maxHandle.width);
				_maxHandle.x = width - _maxHandle.width;
				_handle.width = _minMaxHandleSize; // width;
				_handle.height = handleRatio() * _path + _gutter * 2;
				_handle.rotation = -90;
				_handle.x = _minHandle.width + 
							(_path - _handle.height) * _position - _gutter;
				_handle.y = height;
				_body.rotation = -90;
				_body.scaleY = 1;
				_body.scaleX = 1;
				_body.width = height;
				_body.height = width;
				_body.scaleX = height / _body.getBounds(_body).height;
				_body.y = height;
			}
			if (!super.contains(_body)) super.addChild(_body);
			if (!super.contains(_minHandle)) super.addChild(_minHandle);
			if (!super.contains(_maxHandle)) super.addChild(_maxHandle);
			if (!super.contains(_handle)) super.addChild(_handle);
			if (!_minHandle.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				_minHandle.addEventListener(MouseEvent.MOUSE_DOWN, 
									minmax_mouseDownHandler, false, 0, true);
				_minHandle.addEventListener(MouseEvent.MOUSE_UP, 
									minmax_mouseUpHandler, false, 0, true);
				_minHandle.addEventListener(MouseEvent.MOUSE_OVER, 
									skinnables_mouseOverHandler, false, 0, true);
				_minHandle.addEventListener(MouseEvent.MOUSE_OUT, 
									skinnables_mouseOutHandler, false, 0, true);
			}
			if (!_maxHandle.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				_maxHandle.addEventListener(MouseEvent.MOUSE_DOWN, 
									minmax_mouseDownHandler, false, 0, true);
				_maxHandle.addEventListener(MouseEvent.MOUSE_UP, 
									minmax_mouseUpHandler, false, 0, true);
				_maxHandle.addEventListener(MouseEvent.MOUSE_OVER, 
									skinnables_mouseOverHandler, false, 0, true);
				_maxHandle.addEventListener(MouseEvent.MOUSE_OUT, 
									skinnables_mouseOutHandler, false, 0, true);
			}
			if (!_handle.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				_handle.addEventListener(MouseEvent.MOUSE_DOWN, 
									handle_mouseDownHandler, false, 0, true);
				_handle.addEventListener(MouseEvent.MOUSE_UP, 
									handle_mouseUpHandler, false, 0, true);
				_handle.addEventListener(MouseEvent.MOUSE_OVER, 
									skinnables_mouseOverHandler, false, 0, true);
				_handle.addEventListener(MouseEvent.MOUSE_OUT, 
									skinnables_mouseOutHandler, false, 0, true);
			}
			if (_area && _target) _target.scrollRect = _area;
		}
		
		protected function skinnables_mouseOverHandler(event:MouseEvent):void
		{
			if (event.currentTarget is ISkin) 
				(event.currentTarget as ISkin).state = MouseEvent.MOUSE_OVER;
		}
		
		protected function skinnables_mouseOutHandler(event:MouseEvent):void
		{
			if (event.currentTarget is ISkin) 
				(event.currentTarget as ISkin).state = MouseEvent.MOUSE_UP;
		}
		
		public function scrollTo(value:Number):void
		{
			if (!_target) return;
			if (value < 0) value = 0;
			if (value > 1) value = 1;
			//trace(value);
			var limit:Number;
			var shift:Number;
			var hBounds:Rectangle = _handle.getBounds(this);
			var minBounds:Rectangle = _minHandle.getBounds(this);
			var maxBounds:Rectangle = _maxHandle.getBounds(this);
			var hWidth:int = hBounds.width;
			var hHeight:int = hBounds.height;
			var minWidth:int = minBounds.width;
			var minHeight:int = minBounds.height;
			var maxWidth:int = maxBounds.width;
			var maxHeight:int = maxBounds.height;
			if (_direction)
			{
				limit = _target.height - _area.height;
				shift = value * limit;
				_area.y = shift;
				_target.scrollRect = _area;
				_position = value;
				_handle.y = (minHeight - _gutter) + 
							(_path + _gutter * 2 - hHeight) * value;
			}
			else
			{
				_path = width - (minWidth + maxWidth);
				limit = _target.width - _area.width;
				shift = value * limit;
				_area.x = shift;
				_target.scrollRect = _area;
				_position = value;
				//trace(_handle.height, _handle.width, _handle.getBounds(_handle));
				_handle.x = (minWidth - _gutter) + 
							(_path + _gutter * 2 - hWidth) * value;
			}
			dispatchEvent(new GUIEvent(GUIEvent.SCROLLED));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function minmax_mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget is ISkin) 
				(event.currentTarget as ISkin).state = event.type;
			if (event.currentTarget === _maxHandle)
			{
				_moveFunction = moveAreaUp;
			}
			else
			{
				_moveFunction = moveAreaDown;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, 
									stage_mouseUpHandler, false, 0, true);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		protected function minmax_mouseUpHandler(event:MouseEvent):void
		{
			if (event.currentTarget is ISkin) 
				(event.currentTarget as ISkin).state = event.type;
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		protected function handle_mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget is ISkin) 
				(event.currentTarget as ISkin).state = event.type;
			var handleBounds:Rectangle = _handle.getBounds(this);
			if (_direction)
			{
				_handleShift = mouseY - handleBounds.y;
			}
			else
			{
				_handleShift = mouseX - handleBounds.x;
			}
			_moveFunction = moveAreaUpDown;
			stage.addEventListener(MouseEvent.MOUSE_UP, 
											stage_mouseUpHandler, false, 0, true);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		protected function handle_mouseUpHandler(event:MouseEvent):void
		{
			if (event.currentTarget is ISkin) 
				(event.currentTarget as ISkin).state = event.type;
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			if (_handle is ISkin) (_handle as ISkin).state = event.type;
			if (_minHandle is ISkin) (_minHandle as ISkin).state = event.type;
			if (_maxHandle is ISkin) (_maxHandle as ISkin).state = event.type;
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
			scrollTo(cs);
		}
		
		protected function moveAreaDown():void
		{
			var cs:Number = _position + .01;
			scrollTo(cs);
		}
		
		protected function moveAreaUpDown():void
		{
			var hBounds:Rectangle = _handle.getBounds(this);
			var minBounds:Rectangle = _minHandle.getBounds(this);
			var maxBounds:Rectangle = _maxHandle.getBounds(this);
			var distAvailable:int;
			if (_direction)
			{
				distAvailable = height - (minBounds.height + maxBounds.height);
				var toBeY:Number = mouseY - _handleShift;
				if (toBeY < minBounds.height)
				{
					toBeY = minBounds.height;
				}
				else if (toBeY > maxBounds.y - hBounds.height)
				{
					toBeY = maxBounds.y - hBounds.height;
				}
				scrollTo((toBeY - maxBounds.height) / 
						(distAvailable - hBounds.height));
			}
			else
			{
				distAvailable = width - (minBounds.width + maxBounds.width);
				var toBeX:Number = mouseX - _handleShift;
				if (toBeX < minBounds.width)
				{
					toBeX = minBounds.width;
				}
				else if (toBeX > maxBounds.x - hBounds.width)
				{
					toBeX = maxBounds.x - hBounds.width;
				}
				scrollTo((toBeX - maxBounds.width) / (distAvailable - hBounds.width));
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
			if (_minHandle is Sprite)
			{
				(_minHandle as Sprite).graphics.beginFill(0);
				(_minHandle as Sprite).graphics.drawRect(0, 0, 
									_minMaxHandleSize, _handleWidth);
				(_minHandle as Sprite).graphics.endFill();
			}
			if (_maxHandle is Sprite)
			{
				(_maxHandle as Sprite).graphics.beginFill(0);
				(_maxHandle as Sprite).graphics.drawRect(0, 0, 
									_minMaxHandleSize, _handleWidth);
				(_maxHandle as Sprite).graphics.endFill();
			}
			if (_handle is Sprite)
			{
				(_handle as Sprite).graphics.beginFill(0xFF);
				(_handle as Sprite).graphics.drawRect(0, 0, 
									_minMaxHandleSize, _minMaxHandleSize);
				(_handle as Sprite).graphics.endFill();
			}
			if (_body is Sprite)
			{
				(_body as Sprite).graphics.beginFill(0xFF00);
				(_body as Sprite).graphics.drawRect(0, 0, 
									_minMaxHandleSize, _minMaxHandleSize);
				(_body as Sprite).graphics.endFill();
			}
			if (_minHandle is ISkin) (_minHandle as ISkin).state = MouseEvent.MOUSE_UP;
			if (_maxHandle is ISkin) (_maxHandle as ISkin).state = MouseEvent.MOUSE_UP;
			if (_handle is ISkin) (_handle as ISkin).state = MouseEvent.MOUSE_UP;
			if (_body is ISkin) (_body as ISkin).state = MouseEvent.MOUSE_UP;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}