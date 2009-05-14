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
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import org.wvxvws.gui.skins.ISkin;
	//}
	
	[Event(name="disabled", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * SkinnableButton class.
	 * @author wvxvw
	 */
	public class ButtonS extends DIV
	{
		protected var _label:String = "";
		protected var _labelField:TextField = new TextField();
		protected var _disabled:Boolean;
		
		protected var _currentState:String;
		protected var _skin:ISkin;
		protected var _labelFormat:TextFormat = new TextFormat("_sans", 12, 0x3E2F1B, true, null, null, null, null, "center");
		
		public function ButtonS()
		{
			super();
			_currentState = MouseEvent.MOUSE_UP;
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			_labelField.defaultTextFormat = _labelFormat;
			_labelField.autoSize = TextFieldAutoSize.LEFT;
			mouseChildren = false;
			buttonMode = true;
		}
		
		protected function mouseDownHandler(event:MouseEvent):void 
		{
			if (_disabled) return;
			currentState = event.type;
		}
		
		protected function mouseUpHandler(event:MouseEvent):void 
		{
			if (_disabled) return;
			currentState = event.type;
		}
		
		protected function rollOverHandler(event:MouseEvent):void 
		{
			if (_disabled) return;
			currentState = event.type;
		}
		
		protected function rollOutHandler(event:MouseEvent):void 
		{
			if (_disabled) return;
			currentState = MouseEvent.MOUSE_UP;
		}
		
		override public function validateLayout(event:Event = null):void 
		{
			super.validateLayout(event);
			if (_skin && _currentState != _skin.state && _skin is DisplayObject)
			{
				_skin.state = _currentState;
				if (!contains(_skin as DisplayObject))
				{
					super.addChildAt(_skin as DisplayObject, 0);
				}
			}
			if (_skin && _skin is DisplayObject)
			{
				(_skin as DisplayObject).width = width;
				(_skin as DisplayObject).height = height;
			}
			if (_labelField.text != _label) _labelField.text = _label;
			if (_labelField.height > height)
			{
				height = _labelField.height;
				validateLayout(event);
			}
			if (_labelField.width > width)
			{
				width = _labelField.width;
				validateLayout(event);
			}
			_labelField.x = (width - _labelField.width) / 2;
			_labelField.y = (height - _labelField.height) / 2;
			if (!contains(_labelField)) addChildAt(_labelField, 1);
		}
		
		//------------------------------------
		//  Public property skin
		//------------------------------------
		
		[Bindable("skinChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>skinChange</code> event.
		*/
		public function get skin():ISkin { return _skin; }
		
		public function set skin(value:ISkin):void 
		{
		   if (_skin == value) return;
		   _skin = value;
		   invalidLayout = true;
		   dispatchEvent(new Event("skinChange"));
		}
		
		public function get label():String { return _label; }
		
		public function set label(value:String):void 
		{
			if (_label == value) return;
			_label = value;
			invalidLayout = true;
		}
		
		public function get labelField():TextField { return _labelField; }
		
		public function get currentState():String { return _currentState; }
		
		public function set currentState(value:String):void 
		{
			if (_currentState == value) return;
			_currentState = value;
			invalidLayout = true;
		}
		
		public function get disabled():Boolean { return _disabled; }
		
		public function set disabled(value:Boolean):void 
		{
			if (_disabled == value) return;
			_disabled = value;
			_currentState = GUIEvent.DISABLED;
			invalidLayout = true;
			dispatchEvent(new GUIEvent(GUIEvent.DISABLED));
		}
	}
}