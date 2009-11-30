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
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.StatefulButton;
	
	// TODO: Need to implement ILayoutClient or add suspendLayout()
	
	/**
	 * NestGridRenderer class.
	 * @author wvxvw
	 */
	public class NestGridRenderer extends Renderer 
	//implements IRenderer
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
			if (_data) this.render();
		}
		
		public function get indent():int { return _indent; }
		
		public function set indent(value:int):void 
		{
			if (_indent === value) return;
			_indent = value;
			if (_data) this.render();
		}
		
		public function get depth():int { return _depth; }
		
		public function set depth(value:int):void 
		{
			if (_depth === value) return;
			_depth = value;
			if (_data) this.render();
		}
		
		public function get gutter():int { return _gutter; }
		
		public function set gutter(value:int):void 
		{
			if (_gutter === value) return;
			_gutter = value;
			if (_data) this.render();
		}
		
		public function get closed():Boolean { return _closed; }
		
		public function set closed(value:Boolean):void 
		{
			if (_closed === value) return;
			_closed = value;
			if (_data) this.render();
		}
		
		public function get openClass():Class { return _openClass; }
		
		public function set openClass(value:Class):void 
		{
			if (_openClass === value) return;
			_openClass = value;
			if (_data) this.render();
		}
		
		public function get closedClass():Class { return _closedClass; }
		
		public function set closedClass(value:Class):void 
		{
			if (_closedClass === value) return;
			_closedClass = value;
			if (_data) this.render();
		}
		
		public function get iconProducer():ISkin { return _iconProducer; }
		
		public function set iconProducer(value:ISkin):void 
		{
			if (_iconProducer === value) return;
			_iconProducer = value;
			if (_data) this.render();
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (_selected === value) return;
			_selected = value;
			if (_data) this.renderText();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _openClose:StatefulButton = new StatefulButton();
		protected var _icon:InteractiveObject;
		protected var _iconProducer:ISkin;
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function render():void
		{
			this.drawIcon();
			this.renderText();
			this.drawBackground();
		}
		
		protected function drawIcon():void
		{
			if (!super.contains(_openClose) || 
				!(_openClass in _openClose.states) || 
				!(_closedClass in _openClose.states))
			{
				_openClose.states = { "open": _openClass, "closed": _closedClass };
				super.addChildAt(_openClose, 0);
				_openClose.state = _closed ? "closed" : "open";
				_openClose.addEventListener(MouseEvent.MOUSE_DOWN, 
														openClose_mouseDownHandler);
			}
			_openClose.x = _depth * _indent;
			if (_icon && super.contains(_icon))
				super.removeChild(_icon);
			if (_iconProducer)
			{
				_icon = _iconProducer.produce(this) as InteractiveObject;
				if (_icon) super.addChild(_icon);
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
		
		protected override function renderText():void
		{
			if (!_data) return;
			if (!_field.hasEventListener(MouseEvent.CLICK))
			{
				_field.addEventListener(MouseEvent.CLICK, text_clickHandler);
				_field.doubleClickEnabled = true;
				_field.addEventListener(
							MouseEvent.DOUBLE_CLICK, text_doubleClickHandler);
			}
			if (_labelSkin)
				_field.text = _labelSkin.produce(_data) as String;
			else _field.text = _data.localName();
			if (_icon) _field.x = _icon.x + _icon.width + _gutter;
			else _field.x = _depth * _indent;
			if (_selected)
			{
				_field.background = true;
				_field.backgroundColor = 0xC0C0C0;
			}
			else _field.background = false;
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