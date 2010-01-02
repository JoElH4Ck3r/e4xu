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
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.wvxvws.gui.renderers.Renderer;
	import org.wvxvws.gui.StatefulButton;
	import org.wvxvws.tools.ToolEvent;
	//}
	
	// TODO: Either implement ILayoutClient or add suspendLayout()
	
	[Event(name="resized", type="org.wvxvws.tools.ToolEvent")]
	[Event(name="resizeEnd", type="org.wvxvws.tools.ToolEvent")]
	[Event(name="resizeRequest", type="org.wvxvws.tools.ToolEvent")]
	
	/**
	 * HeaderRenderer class.
	 * @author wvxvw
	 */
	public class HeaderRenderer extends Renderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public override function set height(value:Number):void 
		{
			if (this._height === value) return;
			this._height = value;
			if (super._data) super.renderText();
		}
		
		public override function set width(value:Number):void 
		{
			if (value < this._minWidth) value = this._minWidth;
			super.width = value;
			if (super._data) super.renderText();
		}
		
		public function get resizable():Boolean { return this._resizable; }
		
		public function set resizable(value:Boolean):void 
		{
			if (this._resizable === value) return;
			this._resizable = value;
			if (super._data) super.renderText();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _minWidth:int = 30;
		protected var _sortButton:StatefulButton = new StatefulButton();
		protected var _sortUpClass:Class;
		protected var _sortDownClass:Class;
		protected var _resizable:Boolean;
		protected var _resizeHandle:Sprite = new Sprite();
		protected var _resizing:Boolean;
		protected var _height:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function HeaderRenderer()
		{
			super();
			super._backgroundColor = 0xC0C0C0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function drawBackground():void 
		{
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(super._backgroundColor, super._backgroundAlpha);
			g.drawRect(0, 0, super._width, super._height);
			g.endFill();
			if (this._resizable)
			{
				if (!super.contains(this._resizeHandle))
					this.drawResizeHandle(false);
			}
			else this.drawResizeHandle(true);
			super._field.y = (super._height - super._field.height) >> 1;
		}
		
		protected function drawResizeHandle(remove:Boolean):void
		{
			var g:Graphics = this._resizeHandle.graphics;
			g.clear();
			if (!remove)
			{
				g.beginFill(0xFF, 1);
				g.drawRect(-5, 0, 5, super._height);
				g.endFill();
				this._resizeHandle.addEventListener(
						MouseEvent.MOUSE_OVER, this.resize_mouseOverHandler);
				this._resizeHandle.addEventListener(
						MouseEvent.MOUSE_OUT, this.resize_mouseOutHandler);
				this._resizeHandle.addEventListener(
						MouseEvent.MOUSE_DOWN, this.resize_mouseDownHandler);
				this._resizeHandle.x = super._width;
				super.addChild(this._resizeHandle);
			}
			else
			{
				this._resizeHandle.removeEventListener(
						MouseEvent.MOUSE_OVER, this.resize_mouseOverHandler);
				this._resizeHandle.removeEventListener(
						MouseEvent.MOUSE_OUT, this.resize_mouseOutHandler);
				this._resizeHandle.removeEventListener(
						MouseEvent.MOUSE_DOWN, this.resize_mouseDownHandler);
				if (super.contains(this._resizeHandle))
					super.removeChild(this._resizeHandle);
			}
		}
		
		protected function resize_mouseDownHandler(event:MouseEvent):void 
		{
			super.stage.addEventListener(MouseEvent.MOUSE_UP, 
									this.stage_mouseUpHandler, false, 0, true);
			super.stage.addEventListener(MouseEvent.MOUSE_MOVE, 
									this.stage_mouseMoveHandler, false, 0, false);
			this._resizing = true;
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void 
		{
			super.stage.removeEventListener(MouseEvent.MOUSE_UP, 
									this.stage_mouseUpHandler);
			super.stage.removeEventListener(MouseEvent.MOUSE_MOVE, 
									this.stage_mouseMoveHandler);
			this._resizing = false;
			super.dispatchEvent(
				new ToolEvent(ToolEvent.RESIZE_END, false, true, this));
		}
		
		protected function stage_mouseMoveHandler(event:MouseEvent):void 
		{
			super.dispatchEvent(new ToolEvent(ToolEvent.RESIZED, false, true, this));
		}
		
		protected function resize_mouseOutHandler(event:MouseEvent):void 
		{
			if (this._resizing) return;
			super.dispatchEvent(
				new ToolEvent(ToolEvent.RESIZE_END, false, true, this));
		}
		
		protected function resize_mouseOverHandler(event:MouseEvent):void 
		{
			super.dispatchEvent(
				new ToolEvent(ToolEvent.RESIZE_REQUEST, false, true, this));
		}
	}

}