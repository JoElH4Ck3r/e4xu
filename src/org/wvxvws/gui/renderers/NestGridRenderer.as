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
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.StatefulButton;
	
	/**
	 * NestGridRenderer class.
	 * @author wvxvw
	 */
	public class NestGridRenderer extends Sprite implements IRenderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public override function set width(value:Number):void 
		{
			if (_width === value) return;
			_width = value;
			if (_data) render();
		}
		
		public function set labelFunction(value:Function):void
		{
			if (_labelFunction === value) return;
			_labelFunction = value;
			if (_data) renderText();
		}
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void 
		{
			if (isValid && _data === value) return;
			_data = value;
			if (_data) render();
		}
		
		public function get labelField():String { return _labelField; }
		
		public function set labelField(value:String):void 
		{
			if (_labelField === value) return;
			_labelField = value;
			if (_data) renderText();
		}
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _field.text == _data.toXMLString();
		}
		
		public function get indent():int { return _indent; }
		
		public function set indent(value:int):void 
		{
			if (_indent === value) return;
			_indent = value;
			if (_data) render();
		}
		
		public function get depth():int { return _depth; }
		
		public function set depth(value:int):void 
		{
			if (_depth === value) return;
			_depth = value;
			if (_data) render();
		}
		
		public function get gutter():int { return _gutter; }
		
		public function set gutter(value:int):void 
		{
			if (_gutter === value) return;
			_gutter = value;
			if (_data) render();
		}
		
		public function get closed():Boolean { return _closed; }
		
		public function set closed(value:Boolean):void 
		{
			if (_closed === value) return;
			_closed = value;
			if (_data) render();
		}
		
		public function get openClass():Class { return _openClass; }
		
		public function set openClass(value:Class):void 
		{
			if (_openClass === value) return;
			_openClass = value;
			if (_data) render();
		}
		
		public function get closedClass():Class { return _closedClass; }
		
		public function set closedClass(value:Class):void 
		{
			if (_closedClass === value) return;
			_closedClass = value;
			if (_data) render();
		}
		
		public function get iconFactory():Function { return _iconFactory; }
		
		public function set iconFactory(value:Function):void 
		{
			if (_iconFactory === value) return;
			_iconFactory = value;
			if (_data) render();
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (_selected === value) return;
			_selected = value;
			if (_data) renderText();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data:XML;
		protected var _field:TextField = new TextField();
		protected var _document:Object;
		protected var _id:String;
		protected var _labelField:String;
		protected var _labelFunction:Function;
		protected var _width:int;
		protected var _backgroundColor:uint = 0xFFFFFF;
		protected var _backgroundAlpha:Number = 1;
		protected var _fieldFormat:TextFormat = new TextFormat("_sans", 11);
		
		protected var _openClose:StatefulButton = new StatefulButton();
		protected var _icon:InteractiveObject;
		protected var _iconClass:Class;
		protected var _iconFactory:Function;
		
		protected var _openClass:Class;
		protected var _closedClass:Class;
		
		protected var _depth:int;
		protected var _indent:int;
		protected var _gutter:int;
		protected var _closed:Boolean;
		protected var _selected:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NestGridRenderer() { super(); }
		
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
		
		protected function render():void
		{
			drawIcon();
			renderText();
			drawBackground();
		}
		
		protected function drawIcon():void
		{
			if (!super.contains(_openClose) || 
				!(_openClass in _openClose.states) || 
				!(_openClass in _openClose.states))
			{
				_openClose.states = { "open": _openClass, "closed": _closedClass };
				super.addChildAt(_openClose, 0);
				_openClose.state = _closed ? "closed" : "open";
				_openClose.addEventListener(MouseEvent.MOUSE_DOWN, 
														openClose_mouseDownHandler);
			}
			_openClose.x = _depth * _indent;
			if (_icon && (_icon as Object).constructor === _iconClass) return;
			else if (_icon && super.contains(_icon))
				super.removeChild(_icon);
			if (_iconClass)
			{
				_icon = new _iconClass() as InteractiveObject;
				super.addChild(_icon);
			}
			else if (_iconFactory !== null)
			{
				_icon = _iconFactory(_data.toString());
				super.addChild(_icon);
			}
			if (_icon)
			{
				if (_openClose.width)
				{
					_icon.x = _openClose.x + _openClose.width + _gutter;
					_openClose.x = _depth * _indent + (_gutter >> 1);
				}
				else
				{
					_icon.x = _openClose.x + _openClose.width;
				}
				_openClose.y = (_icon.height - _openClose.height) >> 1;
			}
		}
		
		protected function renderText():void
		{
			if (!_data) return;
			if (!super.contains(_field))
			{
				_field.autoSize = TextFieldAutoSize.LEFT;
				_field.selectable = false;
				_field.defaultTextFormat = _fieldFormat;
				_field.width = 1;
				_field.height = 1;
				_field.addEventListener(MouseEvent.CLICK, text_clickHandler);
				_field.doubleClickEnabled = true;
				_field.addEventListener(
							MouseEvent.DOUBLE_CLICK, text_doubleClickHandler);
				super.addChild(_field);
			}
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
			if (_icon) _field.x = _icon.x + _icon.width + _gutter;
			else 
			{
				//trace(_depth, _indent);
				_field.x = _depth * _indent;
			}
			if (_selected)
			{
				_field.background = true;
				_field.backgroundColor = 0xC0C0C0;
			}
			else
			{
				_field.background = false;
			}
		}
		
		protected function drawBackground():void
		{
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(_backgroundColor, _backgroundAlpha);
			g.drawRect(0, 0, _width, _field.height);
			g.endFill();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function openClose_mouseDownHandler(event:MouseEvent):void 
		{
			if (_openClose.state === "open")
			{
				_openClose.state = "closed";
				closed = true;
			}
			else
			{
				_openClose.state = "open";
				closed = false;
			}
			super.dispatchEvent(new GUIEvent(GUIEvent.OPENED, true, true));
		}
		
		private function text_doubleClickHandler(event:MouseEvent):void 
		{
			
		}
		
		private function text_clickHandler(event:MouseEvent):void 
		{
			selected = true;
			super.dispatchEvent(new GUIEvent(GUIEvent.SELECTED, true, true));
		}
		
	}
	
}