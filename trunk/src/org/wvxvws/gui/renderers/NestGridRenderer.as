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
			if (super._width === value) return;
			super._width = value;
			if (super._data) this.render();
		}
		
		public function get indent():int { return this._indent; }
		
		public function set indent(value:int):void 
		{
			if (this._indent === value) return;
			this._indent = value;
			if (this._data) this.render();
		}
		
		public function get depth():int { return this._depth; }
		
		public function set depth(value:int):void 
		{
			if (this._depth === value) return;
			this._depth = value;
			if (super._data) this.render();
		}
		
		public function get gutter():int { return this._gutter; }
		
		public function set gutter(value:int):void 
		{
			if (this._gutter === value) return;
			this._gutter = value;
			if (super._data) this.render();
		}
		
		public function get closed():Boolean { return _closed; }
		
		public function set closed(value:Boolean):void 
		{
			if (this._closed === value) return;
			this._closed = value;
			if (super._data) this.render();
		}
		
		public function get openClass():Class { return this._openClass; }
		
		public function set openClass(value:Class):void 
		{
			if (this._openClass === value) return;
			this._openClass = value;
			if (super._data) this.render();
		}
		
		public function get closedClass():Class { return this._closedClass; }
		
		public function set closedClass(value:Class):void 
		{
			if (this._closedClass === value) return;
			this._closedClass = value;
			if (super._data) this.render();
		}
		
		public function get iconProducer():ISkin { return this._iconProducer; }
		
		public function set iconProducer(value:ISkin):void 
		{
			if (this._iconProducer === value) return;
			this._iconProducer = value;
			if (super._data) this.render();
		}
		
		public function get selected():Boolean { return this._selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (this._selected === value) return;
			this._selected = value;
			if (super._data) this.renderText();
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
			if (!super.contains(this._openClose) || 
				!(this._openClass in this._openClose.states) || 
				!(this._closedClass in this._openClose.states))
			{
				this._openClose.states = 
					{ "open": this._openClass, "closed": this._closedClass };
				super.addChildAt(this._openClose, 0);
				this._openClose.state = this._closed ? "closed" : "open";
				this._openClose.addEventListener(MouseEvent.MOUSE_DOWN, 
					this.openClose_mouseDownHandler);
			}
			this._openClose.x = this._depth * this._indent;
			if (this._icon && super.contains(this._icon))
				super.removeChild(this._icon);
			if (this._iconProducer)
			{
				this._icon = this._iconProducer.produce(this) as InteractiveObject;
				if (this._icon) super.addChild(this._icon);
			}
			if (this._icon)
			{
				if (this._openClose.width)
				{
					this._icon.x = 
						this._openClose.x + this._openClose.width + this._gutter;
					this._openClose.x = 
						this._depth * this._indent + (this._gutter >> 1);
				}
				else
				{
					this._icon.x = this._openClose.x + this._openClose.width;
				}
				this._openClose.y = 
					(this._icon.height - this._openClose.height) >> 1;
			}
		}
		
		protected override function renderText():void
		{
			if (!super._data) return;
			if (!super._field.hasEventListener(MouseEvent.CLICK))
			{
				super._field.addEventListener(
					MouseEvent.CLICK, this.text_clickHandler);
				super._field.doubleClickEnabled = true;
				super._field.addEventListener(
					MouseEvent.DOUBLE_CLICK, this.text_doubleClickHandler);
			}
			if (super._labelSkin)
				super._field.text = super._labelSkin.produce(super._data) as String;
			else super._field.text = super._data.localName();
			if (this._icon)
				super._field.x = this._icon.x + this._icon.width + this._gutter;
			else super._field.x = this._depth * this._indent;
			if (this._selected)
			{
				super._field.background = true;
				super._field.backgroundColor = 0xC0C0C0;
			}
			else super._field.background = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function openClose_mouseDownHandler(event:MouseEvent):void 
		{
			if (this._openClose.state === "open")
			{
				this._openClose.state = "closed";
				this.closed = true;
			}
			else
			{
				this._openClose.state = "open";
				this.closed = false;
			}
			super.dispatchEvent(new GUIEvent(GUIEvent.OPENED.type, true, true));
		}
		
		private function text_doubleClickHandler(event:MouseEvent):void 
		{
			
		}
		
		private function text_clickHandler(event:MouseEvent):void 
		{
			this.selected = true;
			super.dispatchEvent(new GUIEvent(GUIEvent.SELECTED.type, true, true));
		}
		
	}
	
}