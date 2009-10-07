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
	//{ imports
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import org.wvxvws.gui.GUIEvent;
	//}
	
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * NestLeafRenderer class.
	 * @author wvxvw
	 */
	public class LeafRenderer extends Sprite implements IRenderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
			render();
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function set labelFunction(value:Function):void
		{
			if (_labelFunction === value) return;
			_labelFunction = value;
			if (_data) rendrerText();
		}
		
		public function get iconClass():Class { return _iconClass; }
		
		public function set iconClass(value:Class):void 
		{
			if (_iconClass === value) return;
			_iconClass = value;
			render();
		}
		
		public function get iconFactory():Function { return _iconFactory; }
		
		public function set iconFactory(value:Function):void 
		{
			_iconFactory = value;
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (_selected === value) return;
			_selected = value;
			if (_selected)
			{
				dispatchEvent(new GUIEvent(GUIEvent.SELECTED, true, true));
				_field.background = true;
				_field.backgroundColor = 0xD0D0D0;
			}
			else _field.background = false;
		}
		
		public function get labelField():String { return _labelField; }
		
		public function set labelField(value:String):void 
		{
			if (_labelField === value) return;
			_labelField = value;
			if (_data) rendrerText();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _data:XML;
		protected var _dataCopy:XML;
		protected var _icon:DisplayObject;
		protected var _field:TextField;
		protected var _lines:Shape;
		protected var _labelField:String = "@label";
		protected var _labelFunction:Function;
		protected var _textFormat:TextFormat = new TextFormat("_sans", 11);
		protected var _gutter:int = 6;
		protected var _iconClass:Class;
		protected var _iconFactory:Function;
		protected var _dot:BitmapData;
		protected var _selected:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function LeafRenderer() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function drawIcon():DisplayObject
		{
			var s:DisplayObject;
			if (_iconFactory !== null && _data)
				_iconClass = _iconFactory(_data.toXMLString());
			if (_iconClass) s = new _iconClass();
			else
			{
				s = new Sprite();
				(s as Sprite).graphics.beginFill(0);
				(s as Sprite).graphics.drawRect(0, 0, 10, 10);
				(s as Sprite).graphics.endFill();
			}
			if (!(s is Sprite))
			{
				var u:Sprite = new Sprite();
				u.addChild(s);
				s = u;
			}
			(s as Sprite).mouseChildren = false;
			return s;
		}
		
		protected function drawField():TextField
		{
			var t:TextField = new TextField();
			t.defaultTextFormat = _textFormat;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.height = 10;
			t.selectable = false;
			t.doubleClickEnabled = true;
			t.addEventListener(MouseEvent.CLICK, label_clickHandler);
			t.addEventListener(MouseEvent.DOUBLE_CLICK, label_doubleClickHandler);
			t.addEventListener(FocusEvent.FOCUS_OUT, label_focusOutHandler);
			return t;
		}
		
		protected function render():void
		{
			if (_icon && super.contains(_icon))
			{
				_icon.removeEventListener(MouseEvent.MOUSE_DOWN, icon_mouseDownHandler);
				super.removeChild(_icon);
			}
			_icon = drawIcon();
			_icon.addEventListener(MouseEvent.MOUSE_DOWN, 
										icon_mouseDownHandler, false, int.MAX_VALUE);
			_icon.x = 17;
			_icon.y = 1;
			if (!_lines) _lines = new Shape();
			if (!_dot)
			{
				_dot = new BitmapData(2, 1, true, 0x00FFFFFF);
				_dot.setPixel32(1, 0, 0xFFA0A0A0);
			}
			_lines.graphics.clear();
			_lines.graphics.beginBitmapFill(_dot);
			_lines.graphics.drawRect(7, 1 + _icon.height >> 1, 10, 1);
			_lines.graphics.endFill();
			addChild(_lines);
			super.addChild(_icon);
			if (_field && super.contains(_field)) super.removeChild(_field);
			_field = drawField();
			super.addChild(_field);
			_field.x = 14 + _icon.width + _gutter;
			rendrerText();
		}
		
		protected function rendrerText():void
		{
			if (!_data) return;
			if (_labelField && _data.hasOwnProperty(_labelField))
			{
				if (_labelFunction !== null)
					_field.text = _labelFunction(_data[_labelField]);
				else _field.text = _data[_labelField];
			}
			else
			{
				if (_labelFunction !== null)
					_field.text = _labelFunction(_data.toXMLString());
				else _field.text = _data.localName();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function label_focusOutHandler(event:FocusEvent):void 
		{
			_field.border = false;
			_field.selectable = false;
			_field.type = TextFieldType.DYNAMIC;
		}
		
		private function label_doubleClickHandler(event:MouseEvent):void 
		{
			_field.border = true;
			_field.borderColor = 0xA0A0A0;
			_field.selectable = true;
			_field.setSelection(0, _field.text.length);
			_field.type = TextFieldType.INPUT;
		}
		
		private function label_clickHandler(event:MouseEvent):void 
		{
			selected = true;
		}
		
		private function icon_mouseDownHandler(event:MouseEvent):void 
		{
			selected = true;
		}
		
	}
	
}