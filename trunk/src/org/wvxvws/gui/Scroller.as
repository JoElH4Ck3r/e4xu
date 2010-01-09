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
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.Invalides;
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
		public function get target():DisplayObject { return this._target; }
		
		public function set target(value:DisplayObject):void 
		{
			if (this._target === value) return;
			if (this._target)
			{
				this._target.removeEventListener("widthChanged", this.target_changeHandler);
				this._target.removeEventListener("heightChanged", this.target_changeHandler);
			}
			this._target = value;
			if (this._target)
			{
				this._target.addEventListener("widthChanged", this.target_changeHandler);
				this._target.addEventListener("heightChanged", this.target_changeHandler);
			}
			super.invalidate(Invalides.TARGET, false);
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
		public function get area():Rectangle { return this._area; }
		
		public function set area(value:Rectangle):void 
		{
			if (this._area === value) return;
			this._area = value;
			super.invalidate(Invalides.NULL, false);
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
		public function get minHandle():InteractiveObject { return this._minHandle; }
		
		public function set minHandle(value:InteractiveObject):void 
		{
			if (this._minHandle === value) return;
			if (this._minHandle && super.contains(this._minHandle))
				super.removeChild(_minHandle);
			this._minHandle = value;
			if (this._minHandle)
			{
				if (this._minHandle is StatefulButton)
				{
					this._minHandle.addEventListener(MouseEvent.MOUSE_OUT, 
						this.skinnables_mouseOutHandler, false, 0, true);
					this._minHandle.addEventListener(MouseEvent.MOUSE_OVER, 
						this.skinnables_mouseOverHandler, false, 0, true);
					(this._minHandle as StatefulButton).state = UP_STATE;
				}
				super.addChild(_minHandle);
				this._minHandle.addEventListener(MouseEvent.MOUSE_DOWN, 
					this.minmax_mouseDownHandler, false, 0, true);
			}
			this.orderChildren();
			super.invalidate(Invalides.CHILDREN, false);
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
		public function get maxHandle():InteractiveObject { return this._maxHandle; }
		
		public function set maxHandle(value:InteractiveObject):void 
		{
			if (this._maxHandle === value) return;
			if (this._maxHandle && super.contains(this._maxHandle))
				super.removeChild(this._maxHandle);
			this._maxHandle = value;
			if (this._maxHandle)
			{
				if (this._maxHandle is StatefulButton)
				{
					this._maxHandle.addEventListener(MouseEvent.MOUSE_OUT, 
						this.skinnables_mouseOutHandler, false, 0, true);
					this._maxHandle.addEventListener(MouseEvent.MOUSE_OVER, 
						this.skinnables_mouseOverHandler, false, 0, true);
					(this._maxHandle as StatefulButton).state = UP_STATE;
				}
				super.addChild(this._maxHandle);
				this._maxHandle.addEventListener(MouseEvent.MOUSE_DOWN, 
					this.minmax_mouseDownHandler, false, 0, true);
			}
			this.orderChildren();
			super.invalidate(Invalides.CHILDREN, false);
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
		public function get handle():InteractiveObject { return this._handle; }
		
		public function set handle(value:InteractiveObject):void 
		{
			if (this._handle === value) return;
			if (this._handle && super.contains(this._handle))
				super.removeChild(this._handle);
			this._handle = value;
			if (this._handle)
			{
				if (this._handle is StatefulButton)
				{
					this._handle.addEventListener(MouseEvent.MOUSE_OUT, 
						this.skinnables_mouseOutHandler, false, 0, true);
					this._handle.addEventListener(MouseEvent.MOUSE_OVER, 
						this.skinnables_mouseOverHandler, false, 0, true);
					(this._handle as StatefulButton).state = UP_STATE;
				}
				super.addChild(_handle);
				this._handle.addEventListener(MouseEvent.MOUSE_DOWN, 
					this.handle_mouseDownHandler, false, 0, true);
			}
			this.orderChildren();
			super.invalidate(Invalides.CHILDREN, false);
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
		public function get body():InteractiveObject { return this._body; }
		
		public function set body(value:InteractiveObject):void 
		{
			if (this._body === value) return;
			if (this._body && super.contains(this._body))
				super.removeChild(_body);
			this._body = value;
			if (this._body)
			{
				if (this._body is StatefulButton)
				{
					this._body.addEventListener(MouseEvent.MOUSE_OUT, 
						this.skinnables_mouseOutHandler, false, 0, true);
					this._body.addEventListener(MouseEvent.MOUSE_OVER, 
						this.skinnables_mouseOverHandler, false, 0, true);
					(this._body as StatefulButton).state = UP_STATE;
				}
				super.addChild(this._body);
				// TODO: body needs it's own handler
				//_body.addEventListener(MouseEvent.MOUSE_DOWN, 
					//this.minmax_mouseDownHandler, false, 0, true);
			}
			this.orderChildren();
			super.invalidate(Invalides.CHILDREN, false);
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
		public function get direction():Boolean { return this._direction; }
		
		public function set direction(value:Boolean):void 
		{
			if (this._direction === value) return;
			this._direction = value;
			super.invalidate(Invalides.DIRECTION, false);
			if (super.hasEventListener(EventGenerator.getEventType("direction")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("handleWidthChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>handleWidthChanged</code> event.
		 */
		public function get handleWidth():int { return this._handleWidth; }
		
		public function set handleWidth(value:int):void 
		{
			if (this._handleWidth === value) return;
			this._handleWidth = value;
			super.invalidate(Invalides.CHILDREN, false);
			if (super.hasEventListener(EventGenerator.getEventType("handleWidth")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("minMaxHandleSizeChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>minMaxHandleSizeChanged</code> event.
		 */
		public function get minMaxHandleSize():int { return this._minMaxHandleSize; }
		
		public function set minMaxHandleSize(value:int):void 
		{
			if (_minMaxHandleSize === value) return;
			this._minMaxHandleSize = value;
			super.invalidate(Invalides.CHILDREN, false);
			if (super.hasEventListener(EventGenerator.getEventType("minMaxHandleSize")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("gutterChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>gutterChanged</code> event.
		 */
		public function get gutter():int { return this._gutter; }
		
		public function set gutter(value:int):void 
		{
			if (_gutter === value) return;
			this._gutter = value;
			super.invalidate(Invalides.BOUNDS, false);
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
		public function get parts():Object { return this._skinParts; }
		
		public function set parts(value:Object):void
		{
			if (this._skinParts === value) return;
			this._skinParts = value;
			super.invalidate(Invalides.SKIN, false);
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
		
		public override function validate(properties:Dictionary):void 
		{
			var skinChanged:Boolean = (Invalides.SKIN in properties);
			super.validate(properties);
			var m:Matrix;
			var skin:ISkin;
			if (!this._skinParts)
			{
				this._skinParts = SkinManager.getSkinParts(this);
				skinChanged = true;
			}
			if (skinChanged)
			{
				for (var p:String in this._skinParts)
				{
					skin = this._skinParts[p] as ISkin;
					switch (p)
					{
						case BODY:
							this.body = skin.produce(this) as InteractiveObject;
							if (this._body is StatefulButton) 
								(this._body as StatefulButton).state = UP_STATE;
							break;
						case HANDLE:
							this.handle = skin.produce(this) as InteractiveObject;
							if (this._handle is StatefulButton) 
								(this._handle as StatefulButton).state = UP_STATE;
							break;
						case MIN:
							this.minHandle = skin.produce(this) as InteractiveObject;
							if (this._minHandle is StatefulButton) 
								(this._minHandle as StatefulButton).state = UP_STATE;
							break;
						case MAX:
							this.maxHandle = skin.produce(this) as InteractiveObject;
							if (this._maxHandle is StatefulButton) 
								(this._maxHandle as StatefulButton).state = UP_STATE;
							break;
					}
				}
			}
			if (this._target)
			{
				if (this._target.scrollRect && !this._area)
				{
					this._area = this._target.scrollRect;
				}
				else if (!this._target.scrollRect && !this._area)
				{
					this._area = 
						new Rectangle(0, 0, this._target.width, this._target.height);
				}
				this._target.scrollRect = this._area;
			}
			if (this._minHandle && this._maxHandle && this._handle && this._body)
			{
				if (this._direction)
				{
					this._minHandle.width = super.width;
					this._minHandle.height = this._handleWidth;
					this._maxHandle.width = super.width;
					this._maxHandle.height = this._handleWidth;
					this._handle.width = super.width;
					this._maxHandle.y = super.height - this._maxHandle.height;
					this._path = super.height - 
						(this._minHandle.height + this._maxHandle.height);
					this._handle.height = this.handleRatio() * 
						this._path + this._gutter * 2;
					if (this._handle.height > super.height - 
						(this._handleWidth + this._gutter) * 2)
					{
						this._handle.height = super.height - 
							(this._handleWidth + this._gutter) * 2
					}
					this._handle.y = this._minHandle.height + 
						(this._path - this._handle.height) * 
						this._position - this._gutter;
					this._body.width = super.width;
					this._body.height = super.height;
					//_body.y = _minHandle.height;
				}
				else
				{
					// minHandle
					this._minHandle.rotation = 0;
					this._minHandle.scaleX = 1;
					this._minHandle.scaleY = 1;
					this._minHandle.x = 0;
					this._minHandle.y = 0;
					m = new Matrix();
					m.a = this.height / this._minHandle.width;
					m.d = this._handleWidth / this._minHandle.height;
					m.rotate(Math.PI / -2);
					m.translate(0, this.height);
					this._minHandle.transform.matrix = m;
					
					// maxHandle
					this._maxHandle.rotation = 0;
					this._maxHandle.scaleX = 1;
					this._maxHandle.scaleY = 1;
					this._maxHandle.x = 0;
					this._maxHandle.y = 0;
					m = new Matrix();
					m.a = this.height / this._minHandle.width;
					m.d = this._handleWidth / this._minHandle.height;
					m.rotate(Math.PI / -2);
					m.translate(this.width - this._handleWidth, this.height);
					this._maxHandle.transform.matrix = m;
					
					this._path = this.width - this._handleWidth * 2;
					
					// handle
					this._handle.width = this._minMaxHandleSize;
					this._handle.height = 
						this.handleRatio() * this._path + this._gutter * 2;
					this._handle.rotation = -90;
					this._handle.x = this._handleWidth + 
						(this._path - this._handle.height) * 
						this._position - this._gutter;
					this._handle.y = super.height;
					// body
					this._body.rotation = 0;
					this._body.scaleX = 1;
					this._body.scaleY = 1;
					this._body.x = 0;
					this._body.y = 0;
					m = new Matrix();
					m.a = this.height / this._body.width;
					m.d = this.width / this._body.height;
					m.rotate(Math.PI / -2);
					m.translate(0, this.height);
					this._body.transform.matrix = m;
				}
			}
		}
		
		public function scrollTo(value:Number):void
		{
			if (!this._target || !this._area) return;
			if (value < 0) value = 0;
			if (value > 1) value = 1;
			var limit:Number;
			var shift:Number;
			var hBounds:Rectangle = this._handle.getBounds(this);
			var minBounds:Rectangle = this._minHandle.getBounds(this);
			var maxBounds:Rectangle = this._maxHandle.getBounds(this);
			var hWidth:int = hBounds.width;
			var hHeight:int = hBounds.height;
			var minWidth:int = minBounds.width;
			var minHeight:int = minBounds.height;
			var maxWidth:int = maxBounds.width;
			var maxHeight:int = maxBounds.height;
			if (this._direction)
			{
				limit = this._target.height - this._area.height;
				if (limit < 0) return;
				shift = value * limit;
				this._area.y = shift;
				this._target.scrollRect = this._area;
				this._position = value;
				this._handle.y = (minHeight - this._gutter) + 
					(this._path + this._gutter * 2 - hHeight) * value;
			}
			else
			{
				limit = this._target.width - this._area.width;
				if (limit < 0) return;
				this._path = width - (minWidth + maxWidth);
				shift = value * limit;
				this._area.x = shift;
				this._target.scrollRect = this._area;
				this._position = value;
				//trace(_handle.height, _handle.width, _handle.getBounds(_handle));
				this._handle.x = (minWidth - this._gutter) + 
					(this._path + this._gutter * 2 - hWidth) * value;
			}
			if (super.hasEventListener(GUIEvent.SCROLLED.type))
				super.dispatchEvent(GUIEvent.SCROLLED);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
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
		
		protected function minmax_mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget is StatefulButton) 
				(event.currentTarget as StatefulButton).state = event.type;
			if (event.currentTarget === _maxHandle)
				this._moveFunction = this.moveAreaUp;
			else this._moveFunction = this.moveAreaDown;
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
			if (this._direction)
				this._handleShift = super.mouseY - handleBounds.y;
			else this._handleShift = super.mouseX - handleBounds.x;
			_moveFunction = moveAreaUpDown;
			super.stage.addEventListener(MouseEvent.MOUSE_UP, 
										this.stage_mouseUpHandler, false, 0, true);
			super.addEventListener(Event.ENTER_FRAME, 
										this.enterFrameHandler, false, 0, true);
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			if (this._handle is StatefulButton)
				(this._handle as StatefulButton).state = UP_STATE;
			if (this._body is StatefulButton)
				(this._body as StatefulButton).state = UP_STATE;
			if (this._minHandle is StatefulButton)
				(this._minHandle as StatefulButton).state = UP_STATE;
			if (this._maxHandle is StatefulButton)
				(this._maxHandle as StatefulButton).state = UP_STATE;
			super.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			super.stage.removeEventListener(
								MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			this._moveFunction();
		}
		
		protected function target_changeHandler(event:Event):void 
		{
			// TODO:
			this._invalidProperties._target = this._target;
			this.validate(this._invalidProperties);
		}
		
		protected function moveAreaUp():void
		{
			var cs:Number = this._position - .01;
			this.scrollTo(cs);
		}
		
		protected function moveAreaDown():void
		{
			var cs:Number = this._position + .01;
			this.scrollTo(cs);
		}
		
		protected function moveAreaUpDown():void
		{
			var hBounds:Rectangle = this._handle.getBounds(this);
			var minBounds:Rectangle = this._minHandle.getBounds(this);
			var maxBounds:Rectangle = this._maxHandle.getBounds(this);
			var distAvailable:int;
			if (this._direction)
			{
				distAvailable = super.height - (minBounds.height + maxBounds.height);
				var toBeY:Number = super.mouseY - this._handleShift;
				if (toBeY < minBounds.height) toBeY = minBounds.height;
				else if (toBeY > maxBounds.y - hBounds.height)
				{
					toBeY = maxBounds.y - hBounds.height;
				}
				this.scrollTo((toBeY - maxBounds.height) / 
						(distAvailable - hBounds.height));
			}
			else
			{
				distAvailable = super.width - (minBounds.width + maxBounds.width);
				var toBeX:Number = super.mouseX - _handleShift;
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
			if (!this._target) return 1;
			if (this._direction) return this._area.height / this._target.height;
			return this._area.width / this._target.width;
		}
		
		protected function orderChildren():void
		{
			if (this._body) super.setChildIndex(this._body, 0);
			if (this._handle)
			{
				super.setChildIndex(this._handle, 
					Math.max(0, Math.min(super.numChildren - 1, 1)));
			}
			if (this._maxHandle)
			{
				super.setChildIndex(this._maxHandle, Math.max(0, 
					Math.min(super.numChildren - 1, 2)));
			}
			if (this._minHandle)
			{
				super.setChildIndex(this._minHandle, 
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