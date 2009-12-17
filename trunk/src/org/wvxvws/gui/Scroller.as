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
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	//}
	
	[Event(name="scrolled", type="org.wvxvws.gui.GUIEvent")]
	
	[Skin(part="body", type="org.wvxvws.skins.scroller.ScrollBodySkin")]
	[Skin(part="handle", type="org.wvxvws.skins.scroller.ScrollHandleSkin")]
	[Skin(part="min", type="org.wvxvws.skins.scroller.ScrollMinSkin")]
	[Skin(part="max", type="org.wvxvws.skins.scroller.ScrollMaxSkin")]
	
	/**
	* Scroller class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 16.0.12.36
	*/
	public class Scroller extends DIV implements ISkinnable
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const BODY:String = "body";
		public static const HANDLE:String = "handle";
		public static const MIN:String = "min";
		public static const MAX:String = "max";
		
		public static const UP_STATE:String = "upState";
		public static const OVER_STATE:String = "overState";
		public static const DOWN_STATE:String = "downState";
		public static const DISABLED_STATE:String = "disabledState";
		
		//------------------------------------
		//  Public property target
		//------------------------------------
		
		[Bindable("targetChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>targetChanged</code> event.
		*/
		public function get target():DisplayObject { return _target; }
		
		public function set target(value:DisplayObject):void 
		{
			if (_target === value) return;
			if (_target)
			{
				_target.removeEventListener("widthChanged", this.target_changeHandler);
				_target.removeEventListener("heightChanged", this.target_changeHandler);
			}
			_target = value;
			if (_target)
			{
				_target.addEventListener("widthChanged", this.target_changeHandler);
				_target.addEventListener("heightChanged", this.target_changeHandler);
			}
			super.invalidate("_target", _target, false);
			if (super.hasEventListener(EventGenerator.getEventType("target")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property area
		//------------------------------------
		
		[Bindable("areaChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>areaChanged</code> event.
		*/
		public function get area():Rectangle { return _area; }
		
		public function set area(value:Rectangle):void 
		{
			if (_area == value) return;
			_area = value;
			super.invalidate("_area", _area, false);
			if (super.hasEventListener(EventGenerator.getEventType("area")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public function get minHandle():InteractiveObject { return _minHandle; }
		
		public function set minHandle(value:InteractiveObject):void 
		{
			if (_minHandle === value) return;
			if (_minHandle && super.contains(_minHandle))
				super.removeChild(_minHandle);
			_minHandle = value;
			if (_minHandle)
			{
				if (_minHandle is StatefulButton)
				{
					_minHandle.addEventListener(MouseEvent.MOUSE_OUT, 
						this.skinnables_mouseOutHandler, false, 0, true);
					_minHandle.addEventListener(MouseEvent.MOUSE_OVER, 
						this.skinnables_mouseOverHandler, false, 0, true);
					(_minHandle as StatefulButton).state = UP_STATE;
				}
				super.addChild(_minHandle);
				_minHandle.addEventListener(MouseEvent.MOUSE_DOWN, 
					this.minmax_mouseDownHandler, false, 0, true);
			}
			this.orderChildren();
			super.invalidate("_minHandle", _minHandle, false);
			if (super.hasEventListener(EventGenerator.getEventType("minHandle")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public function get maxHandle():InteractiveObject { return _maxHandle; }
		
		public function set maxHandle(value:InteractiveObject):void 
		{
			if (_maxHandle === value) return;
			if (_maxHandle && super.contains(_maxHandle))
				super.removeChild(_maxHandle);
			_maxHandle = value;
			if (_maxHandle)
			{
				if (_maxHandle is StatefulButton)
				{
					_maxHandle.addEventListener(MouseEvent.MOUSE_OUT, 
						this.skinnables_mouseOutHandler, false, 0, true);
					_maxHandle.addEventListener(MouseEvent.MOUSE_OVER, 
						this.skinnables_mouseOverHandler, false, 0, true);
					(_minHandle as StatefulButton).state = UP_STATE;
				}
				super.addChild(_maxHandle);
				_maxHandle.addEventListener(MouseEvent.MOUSE_DOWN, 
					this.minmax_mouseDownHandler, false, 0, true);
			}
			this.orderChildren();
			super.invalidate("_maxHandle", _maxHandle, false);
			if (super.hasEventListener(EventGenerator.getEventType("maxHandle")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property handle
		//------------------------------------
		
		[Bindable("handleChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>handleChanged</code> event.
		 */
		public function get handle():InteractiveObject { return _handle; }
		
		public function set handle(value:InteractiveObject):void 
		{
			if (_handle === value) return;
			if (_handle && super.contains(_handle))
				super.removeChild(_handle);
			_handle = value;
			if (_handle)
			{
				if (_handle is StatefulButton)
				{
					_handle.addEventListener(MouseEvent.MOUSE_OUT, 
						this.skinnables_mouseOutHandler, false, 0, true);
					_handle.addEventListener(MouseEvent.MOUSE_OVER, 
						this.skinnables_mouseOverHandler, false, 0, true);
					(_handle as StatefulButton).state = UP_STATE;
				}
				super.addChild(_handle);
				_handle.addEventListener(MouseEvent.MOUSE_DOWN, 
					this.handle_mouseDownHandler, false, 0, true);
			}
			this.orderChildren();
			super.invalidate("_handle", _handle, false);
			if (super.hasEventListener(EventGenerator.getEventType("handle")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property body
		//------------------------------------
		
		[Bindable("bodyChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>handleChanged</code> event.
		 */
		public function get body():InteractiveObject { return _body; }
		
		public function set body(value:InteractiveObject):void 
		{
			if (_body === value) return;
			if (_body && super.contains(_body))
				super.removeChild(_body);
			_body = value;
			if (_body)
			{
				if (_body is StatefulButton)
				{
					_body.addEventListener(MouseEvent.MOUSE_OUT, 
						this.skinnables_mouseOutHandler, false, 0, true);
					_body.addEventListener(MouseEvent.MOUSE_OVER, 
						this.skinnables_mouseOverHandler, false, 0, true);
					(_body as StatefulButton).state = UP_STATE;
				}
				super.addChild(_body);
				// TODO: body needs it's own handler
				//_body.addEventListener(MouseEvent.MOUSE_DOWN, 
					//this.minmax_mouseDownHandler, false, 0, true);
			}
			this.orderChildren();
			super.invalidate("_body", _body, false);
			if (super.hasEventListener(EventGenerator.getEventType("body")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property direction
		//------------------------------------
		
		[Bindable("directionChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>directionChanged</code> event.
		 */
		public function get direction():Boolean { return _direction; }
		
		public function set direction(value:Boolean):void 
		{
			if (_direction === value) return;
			_direction = value;
			super.invalidate("_direction", _direction, false);
			if (super.hasEventListener(EventGenerator.getEventType("direction")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("handleWidthChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>handleWidthChanged</code> event.
		 */
		public function get handleWidth():int { return _handleWidth; }
		
		public function set handleWidth(value:int):void 
		{
			if (_handleWidth === value) return;
			_handleWidth = value;
			super.invalidate("_handleWidth", _handleWidth, false);
			if (super.hasEventListener(EventGenerator.getEventType("handleWidth")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("minMaxHandleSizeChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>minMaxHandleSizeChanged</code> event.
		 */
		public function get minMaxHandleSize():int { return _minMaxHandleSize; }
		
		public function set minMaxHandleSize(value:int):void 
		{
			if (_minMaxHandleSize === value) return;
			_minMaxHandleSize = value;
			super.invalidate("_minMaxHandleSize", _minMaxHandleSize, false);
			if (super.hasEventListener(EventGenerator.getEventType("minMaxHandleSize")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("gutterChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>gutterChanged</code> event.
		 */
		public function get gutter():int { return _gutter; }
		
		public function set gutter(value:int):void 
		{
			if (_gutter === value) return;
			_gutter = value;
			super.invalidate("_gutter", _gutter, false);
			if (super.hasEventListener(EventGenerator.getEventType("gutter")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return null; }
		
		public function set skin(value:Vector.<ISkin>):void { }
		
		[Bindable("partsChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>partsChanged</code> event.
		 */
		public function get parts():Object { return _skinParts; }
		
		public function set parts(value:Object):void
		{
			if (_skinParts === value) return;
			_skinParts = value;
			super.invalidate("_parts", _skinParts, false);
			if (super.hasEventListener(EventGenerator.getEventType("parts")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get position():Number { return _position; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _target:DisplayObject;
		protected var _area:Rectangle;
		protected var _minHandle:InteractiveObject;
		protected var _maxHandle:InteractiveObject;
		protected var _handle:InteractiveObject;
		protected var _body:InteractiveObject;
		
		protected var _direction:Boolean;
		protected var _path:Number = 160;
		protected var _handleWidth:int = 25;
		protected var _minMaxHandleSize:int = 16;
		protected var _gutter:int = 7;
		
		protected var _moveFunction:Function;
		protected var _handleShift:Number;
		protected var _position:Number = 0;
		
		protected var _skinParts:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Scroller() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Object):void 
		{
			var skinChanged:Boolean = ("_parts" in properties);
			super.validate(properties);
			var m:Matrix;
			var skin:ISkin;
			if (!_skinParts)
			{
				_skinParts = SkinManager.getSkinParts(this);
				skinChanged = true;
			}
			if (skinChanged)
			{
				for (var p:String in _skinParts)
				{
					skin = _skinParts[p] as ISkin;
					switch (p)
					{
						case BODY:
							this.body = skin.produce(this) as InteractiveObject;
							if (_body is StatefulButton) 
								(_body as StatefulButton).state = UP_STATE;
							break;
						case HANDLE:
							this.handle = skin.produce(this) as InteractiveObject;
							if (_handle is StatefulButton) 
								(_handle as StatefulButton).state = UP_STATE;
							break;
						case MIN:
							this.minHandle = skin.produce(this) as InteractiveObject;
							if (_minHandle is StatefulButton) 
								(_minHandle as StatefulButton).state = UP_STATE;
							break;
						case MAX:
							this.maxHandle = skin.produce(this) as InteractiveObject;
							if (_maxHandle is StatefulButton) 
								(_maxHandle as StatefulButton).state = UP_STATE;
							break;
					}
				}
			}
			if (_target)
			{
				if (_target.scrollRect && !_area)
				{
					_area = _target.scrollRect;
				}
				else if (!_target.scrollRect && !_area)
				{
					_area = new Rectangle(0, 0, _target.width, _target.height);
				}
				_target.scrollRect = _area;
			}
			if (_minHandle && _maxHandle && _handle && _body)
			{
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
					// minHandle
					_minHandle.rotation = 0;
					_minHandle.scaleX = 1;
					_minHandle.scaleY = 1;
					_minHandle.x = 0;
					_minHandle.y = 0;
					m = new Matrix();
					m.a = this.height / _minHandle.width;
					m.d = _handleWidth / _minHandle.height;
					m.rotate(Math.PI / -2);
					m.translate(0, this.height);
					_minHandle.transform.matrix = m;
					
					// maxHandle
					_maxHandle.rotation = 0;
					_maxHandle.scaleX = 1;
					_maxHandle.scaleY = 1;
					_maxHandle.x = 0;
					_maxHandle.y = 0;
					m = new Matrix();
					m.a = this.height / _minHandle.width;
					m.d = _handleWidth / _minHandle.height;
					m.rotate(Math.PI / -2);
					m.translate(this.width - _handleWidth, this.height);
					_maxHandle.transform.matrix = m;
					
					_path = this.width - _handleWidth * 2;
					
					// handle
					_handle.width = _minMaxHandleSize;
					_handle.height = handleRatio() * _path + _gutter * 2;
					_handle.rotation = -90;
					_handle.x = _handleWidth + 
								(_path - _handle.height) * _position - _gutter;
					_handle.y = height;
					// body
					_body.rotation = 0;
					_body.scaleX = 1;
					_body.scaleY = 1;
					_body.x = 0;
					_body.y = 0;
					m = new Matrix();
					m.a = this.height / _body.width;
					m.d = this.width / _body.height;
					m.rotate(Math.PI / -2);
					m.translate(0, this.height);
					_body.transform.matrix = m;
				}
			}
		}
		
		protected function skinnables_mouseOverHandler(event:MouseEvent):void
		{
			if (event.currentTarget is StatefulButton) 
				(event.currentTarget as StatefulButton).state = OVER_STATE;
		}
		
		protected function skinnables_mouseOutHandler(event:MouseEvent):void
		{
			if (event.currentTarget is StatefulButton) 
				(event.currentTarget as StatefulButton).state = UP_STATE;
		}
		
		public function scrollTo(value:Number):void
		{
			if (!_target || !_area) return;
			if (value < 0) value = 0;
			if (value > 1) value = 1;
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
				if (limit < 0) return;
				shift = value * limit;
				_area.y = shift;
				_target.scrollRect = _area;
				_position = value;
				_handle.y = (minHeight - _gutter) + 
							(_path + _gutter * 2 - hHeight) * value;
			}
			else
			{
				limit = _target.width - _area.width;
				if (limit < 0) return;
				_path = width - (minWidth + maxWidth);
				shift = value * limit;
				_area.x = shift;
				_target.scrollRect = _area;
				_position = value;
				//trace(_handle.height, _handle.width, _handle.getBounds(_handle));
				_handle.x = (minWidth - _gutter) + 
							(_path + _gutter * 2 - hWidth) * value;
			}
			if (super.hasEventListener(GUIEvent.SCROLLED))
				super.dispatchEvent(new GUIEvent(GUIEvent.SCROLLED));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function minmax_mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget is StatefulButton) 
				(event.currentTarget as StatefulButton).state = event.type;
			if (event.currentTarget === _maxHandle)
			{
				_moveFunction = moveAreaUp;
			}
			else
			{
				_moveFunction = moveAreaDown;
			}
			super.stage.addEventListener(MouseEvent.MOUSE_UP, 
									this.stage_mouseUpHandler, false, 0, true);
			super.addEventListener(Event.ENTER_FRAME, 
									this.enterFrameHandler, false, 0, true);
		}
		
		protected function handle_mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget is StatefulButton) 
				(event.currentTarget as StatefulButton).state = DOWN_STATE;
			var handleBounds:Rectangle = _handle.getBounds(this);
			if (_direction)
			{
				_handleShift = super.mouseY - handleBounds.y;
			}
			else
			{
				_handleShift = super.mouseX - handleBounds.x;
			}
			_moveFunction = moveAreaUpDown;
			super.stage.addEventListener(MouseEvent.MOUSE_UP, 
										this.stage_mouseUpHandler, false, 0, true);
			super.addEventListener(Event.ENTER_FRAME, 
										this.enterFrameHandler, false, 0, true);
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			if (_handle is StatefulButton)
				(_handle as StatefulButton).state = UP_STATE;
			if (_body is StatefulButton)
				(_body as StatefulButton).state = UP_STATE;
			if (_minHandle is StatefulButton)
				(_minHandle as StatefulButton).state = UP_STATE;
			if (_maxHandle is StatefulButton)
				(_maxHandle as StatefulButton).state = UP_STATE;
			super.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			super.stage.removeEventListener(
								MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			_moveFunction();
		}
		
		protected function target_changeHandler(event:Event):void 
		{
			_invalidProperties._target = _target;
			this.validate(_invalidProperties);
		}
		
		protected function moveAreaUp():void
		{
			var cs:Number = _position - .01;
			this.scrollTo(cs);
		}
		
		protected function moveAreaDown():void
		{
			var cs:Number = _position + .01;
			this.scrollTo(cs);
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
				this.scrollTo((toBeY - maxBounds.height) / 
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
				this.scrollTo((toBeX - maxBounds.width) / 
						(distAvailable - hBounds.width));
			}
		}
		
		protected function handleRatio():Number
		{
			if (!_target) return 1;
			if (_direction) return _area.height / _target.height;
			return _area.width / _target.width;
		}
		
		protected function orderChildren():void
		{
			if (_body) super.setChildIndex(_body, 0);
			if (_handle)
			{
				super.setChildIndex(_handle, 
					Math.max(0, Math.min(super.numChildren - 1, 1)));
			}
			if (_maxHandle)
			{
				super.setChildIndex(_maxHandle, Math.max(0, 
					Math.min(super.numChildren - 1, 2)));
			}
			if (_minHandle)
			{
				super.setChildIndex(_minHandle, 
					Math.max(0, Math.min(super.numChildren - 1, 3)));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}