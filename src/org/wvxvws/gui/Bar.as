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

package org.wvxvws.gui 
{
	//{ imports
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	//}
	
	[Event(name="dataChanged", type="org.wvxvws.gui.GUIEvent")]
	
	[Skin(part="handle", type="org.wvxvws.skins.bar.BarHandleSkin")]
	[Skin(part="body", type="org.wvxvws.skins.bar.BarBodySkin")]
	
	/**
	* Bar class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Bar extends DIV implements ISkinnable
	{
		public static const BODY:String = "body";
		public static const HANDLE:String = "handle";
		
		public static const UP_STATE:String = "upState";
		public static const OVER_STATE:String = "overState";
		public static const DOWN_STATE:String = "downState";
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property position
		//------------------------------------
		
		[Bindable("positionChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>positionChange</code> event.
		*/
		public function get position():Number { return _position; }
		
		public function set position(value:Number):void 
		{
			var temp:Number = Math.max(Math.min(value, 1), 0);
			if (temp === _position) return;
			super.invalidate(Invalides.TRANSFORM, false);
			_position = temp;
			if (super.hasEventListener(EventGenerator.getEventType("position")))
				super.dispatchEvent(EventGenerator.getEvent());
			super.dispatchEvent(GUIEvent.DATA_CHANGED);
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
		public function get handle():Sprite { return _handle; }
		
		public function set handle(value:Sprite):void 
		{
			if (_handle === value) return;
			super.invalidate(Invalides.CHILDREN, false);
			if (_handle && super.contains(_handle))
			{
				_handle.removeEventListener(
					MouseEvent.MOUSE_OVER, this.handle_overHandler);
				_handle.removeEventListener(
					MouseEvent.MOUSE_OUT, this.handle_outHandler);
				_handle.removeEventListener(
					MouseEvent.MOUSE_DOWN, this.handle_downHandler);
				super.removeChild(_handle);
			}
			_handle = value;
			if (_handle)
			{
				super.addChildAt(_handle, Math.min(super.numChildren, 1));
				_handle.addEventListener(
					MouseEvent.MOUSE_OVER, this.handle_overHandler, false, 0, true);
				_handle.addEventListener(
					MouseEvent.MOUSE_OUT, this.handle_outHandler, false, 0, true);
				_handle.addEventListener(
					MouseEvent.MOUSE_DOWN, this.handle_downHandler, false, 0, true);
			}
			if (super.hasEventListener(EventGenerator.getEventType("handle")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property body
		//------------------------------------
		
		[Bindable("bodyChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>bodyChange</code> event.
		*/
		public function get body():Sprite { return _body; }
		
		public function set body(value:Sprite):void 
		{
			if (_body === value) return;
			if (_body && super.contains(_body))
				super.removeChild(_body);
			_body = value;
			if (_body) super.addChildAt(_body, 0);
			super.invalidate(Invalides.CHILDREN, false);
			if (super.hasEventListener(EventGenerator.getEventType("body")))
				super.dispatchEvent(EventGenerator.getEvent());
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
			if (value === _direction) return;
			_direction = value;
			super.invalidate(Invalides.DIRECTION, true);
			if (super.hasEventListener(EventGenerator.getEventType("direction")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return null; }
		
		public function set skin(value:Vector.<ISkin>):void { }
		
		// TODO: Maybe make this bindable?
		public function get parts():Object { return _skinParts; }
		
		public function set parts(value:Object):void
		{
			_skinParts = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _body:Sprite;
		protected var _handle:Sprite;
		protected var _position:Number = 0.5;
		protected var _direction:Boolean;
		protected var _skinParts:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Bar() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Dictionary):void 
		{
			var skinChanged:Boolean = ("_parts" in properties);
			super.validate(properties);
			var skin:ISkin;
			if (!_skinParts)
			{
				_skinParts = SkinManager.getSkinParts(this);
				skinChanged = true;
			}
			var m:Matrix;
			if (skinChanged)
			{
				if (_skinParts)
				{
					this.body = 
						(_skinParts[BODY] as ISkin).produce(this) as Sprite;
					this.handle = 
						(_skinParts[HANDLE] as ISkin).produce(this) as Sprite;
				}
				else
				{
					this.body = null;
					this.handle = null;
				}
			}
			if (_body && _handle)
			{
				if (super.getChildAt(0) === _handle)
				super.swapChildren(_handle, _body);
				if (_handle is StatefulButton) 
					(_handle as StatefulButton).state = UP_STATE;
				if (_direction)
				{
					_body.rotation = 0;
					_body.width = super.width;
					_body.height = super.height;
					_body.y = (super.height - _body.height) >> 1;
					_handle.y = (super.height - _handle.height) >> 1;
					_handle.x = (super.width - _handle.width) * _position;
				}
				else
				{
					//if (_body.scale9Grid)
					//{
						//_body.height = super.height;
						//_body.x = (super.width - _body.width) >> 1;
					//}
					//else
					//{
						//m = new Matrix();
						//_body.transform.matrix = m;
						//m.scale(super.height / _body.width, 1);
						//m.rotate(Math.PI * 0.5);
						//m.translate(_body.width + 
							//((super.width - _body.width) >> 1), 0);
						//_body.transform.matrix = m;
					//}
					_body.rotation = 0;
					_body.width = super.height;
					_body.height = super.width;
					_body.rotation = 90;
					_body.x = super.width;
					
					_handle.x = (super.width - _handle.width) >> 1;
					_handle.y = (super.height - _handle.height) * _position;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		protected function handle_outHandler(event:MouseEvent):void 
		{
			if (_handle is StatefulButton)
				(_handle as StatefulButton).state = UP_STATE;
		}
		
		protected function handle_overHandler(event:MouseEvent):void 
		{
			if (_handle is StatefulButton)
				(_handle as StatefulButton).state = OVER_STATE;
		}
		
		protected function handle_downHandler(event:MouseEvent):void 
		{
			if (_handle is StatefulButton)
				(_handle as StatefulButton).state = DOWN_STATE;
			if (stage)
			{
				stage.addEventListener(
					MouseEvent.MOUSE_UP, this.stage_mouseUpHandler, false, 0, true);
			}
			else
			{
				_handle.addEventListener(
					MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
			}
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		}
		
		protected function enterFrameHandler(event:Event):void 
		{
			if (_direction) this.position = super.mouseX / super.width;
			else this.position = super.mouseY / super.height;
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void 
		{
			super.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			_handle.removeEventListener(
				MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
			if (stage)
			{
				super.stage.removeEventListener(
					MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
	}
}