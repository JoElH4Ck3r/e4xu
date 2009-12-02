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

package org.wvxvws.tools 
{
	import flash.events.Event;
	
	/**
	 * ToolEvent event.
	 * @author wvxvw
	 */
	public class ToolEvent extends Event 
	{
		public static const MOVED:String = "moved";
		public static const RESIZED:String = "resized";
		public static const RESIZE_START:String = "resizeStart";
		public static const RESIZE_END:String = "resizeEnd";
		public static const RESIZE_REQUEST:String = "resizeRequest";
		public static const ROTATED:String = "rotated";
		public static const DISTORTED:String = "distorted";
		
		private var _toolTarget:Object;
		
		public function ToolEvent(type:String, bubbles:Boolean = false, 
					cancelable:Boolean = false, toolTarget:Object = null)
		{ 
			super(type, bubbles, cancelable);
			_toolTarget = toolTarget;
		} 
		
		public override function clone():Event { return this; } 
		
		public override function toString():String 
		{ 
			return formatToString("ToolEvent", "type", "bubbles", "cancelable", "toolTarget"); 
		}
		
		public function get toolTarget():Object { return _toolTarget; }
		
	}
	
}