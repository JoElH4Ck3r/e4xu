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
		/**
		 * Currently not used. Reserved for future use.
		 */
		public static const LC_CUSTOM:String = "lcCustom";
		
		/**
		 * Dispatched by AVM1Loader every time the AVM1Movie responds.
		 */
		public static const LC_RECEIVED:String = "lcReceived";
		
		/**
		 * Dispatched by AVM1Loader when connection or protocol error occures.
		 */
		public static const LC_ERROR:String = "lcError";
		
		/**
		 * Dispatched by AVM1Loader when proxying AVM1Movie has loaded the targeted AVM1Movie.
		 */
		public static const LC_LOADED:String = "lcLoaded";
		
		/**
		 * Dispatched by AVM1Loader when connection with the proxying AVM1Movie establishes.
		 */
		public static const LC_READY:String = "lcReady";
		
		/**
		 * Dispatched by AVM1Loader when proxying AVM1Movie reconnects.
		 */
		public static const LC_RECONNECT:String = "lcReconnect";
		
		/**
		 * Dispatched by AVM1Loader when proxying AVM1Movie asks to execute a command.
		 */
		public static const LC_COMMAND:String = "lcCommand";
		
		/**
		 * Dispatched by AVM1Loader when proxying AVM1Movie disconnects.
		 */
		public static const LC_DISCONNECT:String = "lcDisconnect";
		
		private var _command:AVM1Command;
		
		public function AVM1Event(type:String, command:AVM1Command)
		{ 
			super(type);
			_command = command;
		} 
		
		public override function clone():Event
		{ 
			return new AVM1Event(type, _command);
		} 
		
		public override function toString():String
		{ 
			return formatToString("AVM1Event", "type", "command"); 
		}
		
		public function get command():AVM1Command { return _command; }
		
	}
	
}