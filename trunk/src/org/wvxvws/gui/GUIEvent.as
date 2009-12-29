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
	import flash.events.Event;
	
	/**
	* GUIEvent event.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class GUIEvent extends Event 
	{
		public static const INITIALIZED:GUIEvent = new GUIEvent("initialized");
		public static const VALIDATED:GUIEvent = new GUIEvent("validated");
		public static const CHILDREN_CREATED:GUIEvent = new GUIEvent("childrenCreated");
		public static const DISABLED:GUIEvent = new GUIEvent("disabled");
		public static const SELECTED:GUIEvent = new GUIEvent("selected");
		public static const DATA_CHANGED:GUIEvent = new GUIEvent("dataChanged");
		public static const SCROLLED:GUIEvent = new GUIEvent("scrolled");
		public static const OPENED:GUIEvent = new GUIEvent("opened");
		
		private var _handled:Boolean;
		
		public function GUIEvent(type:String, bubbles:Boolean = false, 
								cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event
		{
			if (!this._handled)
			{
				this._handled = true;
				return this;
			}
			return new GUIEvent(this.type, this.bubbles, this.cancelable);
		} 
		
		public override function toString():String 
		{ 
			return super.formatToString("GUIEvent", "type", "bubbles", "cancelable"); 
		}
		
	}
	
}