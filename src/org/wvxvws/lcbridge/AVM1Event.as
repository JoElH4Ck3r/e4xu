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

package org.wvxvws.lcbridge
{
	import flash.events.Event;
	
	/**
	 * AVM1Event event. This event is dispatched by AVM1Loader and AVM1LC any time
	 * the interaction between AS2 and AS3 SWFs takes place.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.12.36
	 */
	public class AVM1Event extends Event
	{
		public static const LC_CUSTOM:String = "lcCustom";
		public static const LC_RECEIVED:String = "lcReceived";
		public static const LC_ERROR:String = "lcError";
		public static const LC_LOADED:String = "lcLoaded";
		public static const LC_READY:String = "lcReady";
		public static const LC_RECONNECT:String = "lcReconnect";
		public static const LC_COMMAND:String = "lcCommand";
		public static const LC_RETURN:String = "lcReturn";
		public static const LC_LOAD_START:String = "lcLoadStart";
		public static const LC_DISCONNECT:String = "lcDisconnect";
		
		public static const codes:Object = 
		{
			"-1" : "lcCustom",
			"0" : "lcReceived",
			"1" : "lcError",
			"2" : "lcLoaded",
			"3" : "lcReady",
			"4" : "lcReconnect",
			"5" : "lcCommand",
			"6" : "lcReturn",
			"7" : "lcLoadStart",
			"8" : "lcDisconnect"
		};
		
		public var message:String = "";
		
		public function AVM1Event(type:String, bubbles:Boolean = false, 
								cancelable:Boolean = false, message:String = null)
		{ 
			super(type, bubbles, cancelable);
			this.message = message;
		} 
		
		public override function clone():Event
		{ 
			return new AVM1Event(type, bubbles, cancelable);
		} 
		
		public override function toString():String
		{ 
			return formatToString("AVM1Event", "type"); 
		}
		
	}
	
}