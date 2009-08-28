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

/**
 * org.wvxvws.lcbridge.LCMessage class. This class packs the information 
 * to be sent to AS3 LocalConnection.
 * @author wvxvw
 * @langVersion 2.0
 * @playerVersion 10.0.12.36
 */
class org.wvxvws.lcbridge.LCMessage
{
	public static var LC_CUSTOM:Number = -1;
	public static var LC_RECEIVED:Number = 0; // "lcReceived";
	public static var LC_ERROR:Number = 1; // "lcError";
	public static var LC_LOADED:Number = 2; // "lcLoaded";
	public static var LC_READY:Number = 3; // "lcReady";
	public static var LC_RECONNECT:Number = 4; // "lcReconnect";
	
	public static var LC_COMMAND:Number = 5; // "lcCommand";
	public static var LC_RETURN:Number = 6; // "lcReturn";
	public static var LC_LOAD_START:Number = 7; // "lcLoadStart";
	public static var LC_DISCONNECT:Number = 8; // "lcDisconnect";
	
	public static var codes:Array = 
	[
		"lcReceived", "lcError", "lcLoaded", "lcReady", 
		"lcReconnect", "lcCommand", "lcReturn", "lcLoadStart", "lcDisconnect"
	];
	
	public var kind:Number;
	public var message:String;
	public var data:Object;
	
	public function LCMessage(kind:Number, message:String, data:Object)
	{
		super();
		this.kind = kind;
		this.message = message;
		this.data = data;
		if (kind > -1 && !message) this.message = codes[kind];
	}
}