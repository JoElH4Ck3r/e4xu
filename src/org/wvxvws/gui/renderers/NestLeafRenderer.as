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

package org.wvxvws.gui.renderers 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import org.wvxvws.gui.GUIEvent;
	
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * NestLeafRenderer class.
	 * @author wvxvw
	 */
	public class NestLeafRenderer extends Sprite implements IRenderer
	{
		protected var _document:Object;
		protected var _id:String;
		protected var _data:XML;
		protected var _dataCopy:XML;
		protected var _icon:Sprite;
		protected var _field:TextField;
		protected var _labelField:String = "@label";
		protected var _labelFunction:Function;
		
		public function NestLeafRenderer() { super(); }
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		protected function drawIcon():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0);
			s.graphics.drawRect(0, 0, 10, 10);
			s.graphics.endFill();
			return s;
		}
		
		protected function drawField():TextField
		{
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.height = 10;
			t.border = true;
			return t;
		}
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _dataCopy.contains(_data);
		}
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void
		{
			if (isValid && _data === value) return;
			_data = value;
			_dataCopy = value.copy();
			if (_icon && super.contains(_icon))
			{
				_icon.removeEventListener(MouseEvent.CLICK, icon_mouseClickHandler);
				super.removeChild(_icon);
			}
			_icon = drawIcon();
			_icon.addEventListener(MouseEvent.CLICK, icon_mouseClickHandler);
			super.addChild(_icon);
			if (_field && super.contains(_field))
			{
				super.removeChild(_field);
			}
			_field = drawField();
			super.addChild(_field);
			_field.x = _icon.width + 5;
			//trace("_labelField", _labelField);
			rendrerText();
		}
		
		protected function rendrerText():void
		{
			if (_labelField && _data.hasOwnProperty(_labelField))
			{
				if (_labelFunction !== null)
				{
					_field.text = _labelFunction(_data[_labelField]);
				}
				else
				{
					_field.text = _data[_labelField];
				}
			}
			else
			{
				if (_labelFunction !== null)
				{
					_field.text = 
						_labelFunction(_data.toXMLString().replace(/[\r\n]+/g, " "));
				}
				else
				{
					_field.text = _data.toXMLString().replace(/[\r\n]+/g, " ");
				}
			}
		}
		
		public function get labelField():String { return _labelField; }
		
		public function set labelField(value:String):void 
		{
			if (_data) rendrerText();
			_labelField = value;
		}
		
		protected function icon_mouseClickHandler(event:MouseEvent):void 
		{
			dispatchEvent(new GUIEvent(GUIEvent.SELECTED, true));
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function set labelFunction(value:Function):void
		{
			_labelFunction = value;
			if (_data) rendrerText();
		}
	}
	
}