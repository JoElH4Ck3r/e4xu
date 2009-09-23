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
	//}
	
	[Event(name="dataChanged", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	* Bar class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Bar extends DIV
	{
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
			invalidate("_position", temp, false);
			_position = temp;
			dispatchEvent(new Event("positionChange"));
			dispatchEvent(new GUIEvent(GUIEvent.DATA_CHANGED));
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
			invalidate("_handle", _handle, false);
			if (_handle && super.contains(_handle))
				super.removeChild(_handle);
			_handle = value;
			dispatchEvent(new Event("handleChange"));
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
			invalidate("_body", _body, false);
			if (_body && super.contains(_body))
				super.removeChild(_body);
			_body = value;
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
			if (value === _direction) return;
			_direction = value;
			invalidate("_direction", _direction, true);
			dispatchEvent(new Event("directionChange"));
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
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
			var m:Matrix;
			if (!_body) _body = drawRect();
			if (!super.contains(_body)) super.addChild(_body);
			if (!_handle) _handle = drawRect();
			if (!super.contains(_handle)) super.addChild(_handle);
			if (super.getChildAt(0) === _handle)
			{
				super.swapChildren(_handle, _body);
			}
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handle_mouseDownHandler);
			if (_direction)
			{
				_body.width = super.width;
				_body.y = (super.height - _body.height) >> 1;
				_handle.y = (super.height - _handle.height) >> 1;
				_handle.x = (super.width - _handle.width) * _position;
			}
			else
			{
				if (_body.scale9Grid)
				{
					_body.height = super.height;
					_body.x = (super.width - _body.width) >> 1;
				}
				else
				{
					m = new Matrix();
					_body.transform.matrix = m;
					m.scale(super.height / _body.width, 1);
					m.rotate(Math.PI / 2);
					m.translate(_body.width + ((super.width - _body.width) >> 1), 0);
					_body.transform.matrix = m;
				}
				_handle.x = (super.width - _handle.width) >> 1;
				_handle.y = (super.height - _handle.height) * _position;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function handle_mouseDownHandler(event:MouseEvent):void 
		{
			if (stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, 
							stage_mouseUpHandler, false, 0, true);
			}
			else
			{
				_handle.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
			super.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void 
		{
			if (_direction) position = super.mouseX / super.width;
			else position = super.mouseY / super.height;
		}
		
		private function stage_mouseUpHandler(event:MouseEvent):void 
		{
			super.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_handle.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		// TODO: move this to the DrawUtils.
		protected function drawRect():Sprite
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			g.beginFill(0xFFFFFF * Math.random());
			g.drawRect(0, 0, 20, 20);
			g.endFill();
			return s;
		}
	}
	
}