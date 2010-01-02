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
	import flash.events.MouseEvent;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.Renderer;
	
	[Event(name="opened", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * DrillRenderer class.
	 * @author wvxvw
	 */
	public class DrillRenderer extends Renderer implements IDrillRenderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get closed():Boolean { return this._closed; }
		
		public function set closed(value:Boolean):void 
		{
			if (this._closed === value) return;
			this._closed = value;
		}
		
		public function get selected():Boolean { return this._selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (this._selected === value) return;
			this._selected = value;
			if (!this._selected) super._backgroundColor = 0xFFFFFF;
			else this._backgroundColor = 0xAAAAFF;
			super.drawBackground();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _closed:Boolean;
		protected var _selected:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DrillRenderer()
		{
			super();
			super.mouseChildren = false;
			super.tabChildren = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function renderText():void 
		{
			super.renderText();
			super.addEventListener(MouseEvent.CLICK, this.clickHandler);
		}
		
		protected function clickHandler(event:MouseEvent):void 
		{
			this.closed = (!this._closed);
			this.selected = true;
			super.dispatchEvent(new GUIEvent(GUIEvent.OPENED.type, true, true));
			super.dispatchEvent(new GUIEvent(GUIEvent.SELECTED.type, true, true));
		}
	}

}