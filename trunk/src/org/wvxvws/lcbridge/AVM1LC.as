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
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.SecurityErrorEvent;
	import flash.net.LocalConnection;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.12.36
	 */
	public class AVM1LC extends LocalConnection
	{
		public static const LC_NAME:String = "__LC645F8553-33B1-47D1-996F-5EDFB4863061";
		public static const LC_SEND_NAME:String = "__LC_SEND";
		public static const LC_RECEIVE_NAME:String = "__LC_RECEIVE";
		
		private var _receivingConnection:String;
		private var _sendingConnection:String;
		
		private var _bytesLoader:Loader;
		private var _parent:DisplayObjectContainer;
		
		private var _a:Array = []; // will hold the try_lc.swf in byte sequence
		private var _ba:ByteArray = new ByteArray();
		
		public function AVM1LC(parent:DisplayObjectContainer)
		{
			super();
			_parent = parent;
			for each(var i:int in _a) _ba.writeByte(i);
			_bytesLoader = new Loader();
			_parent.addChild(_bytesLoader);
			_bytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadHandler);
			client = this;
			super.addEventListener(StatusEvent.STATUS, statusHandler);
			super.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			//_bytesLoader.loadBytes(_ba);
			//_receivingConnection = LC_NAME;
			_bytesLoader.load(new URLRequest("bridge.swf"));
			_parent.addChild(_bytesLoader);
		}
		
		private function loadHandler(event:Event):void
		{
			_receivingConnection = LC_RECEIVE_NAME + new Date().time;
			_sendingConnection = LC_SEND_NAME + new Date().time;
			var message:Object = 
				{ kind: AVM1Event.LC_RECONNECT, 
				data: _receivingConnection + "|" + _sendingConnection };
			try
			{
				this.close();
			}
			catch (error:Error)
			{
				if (error.errorID !== 2083)
				{
					throw error;
				}
			}
			this.connect(_sendingConnection);
			this.send(LC_NAME, "as2recieve", message);
			trace("init");
		}
		
		private function statusHandler(event:StatusEvent):void
		{
			trace("AS3 statusHandler " + event);
		}
		
		private function errorHandler(event:Event):void
		{
			trace("AS3 errorHandler " + event);
		}
		
		public function as3recieve(message:Object):void
		{
			var kind:int = message.kind;
			var kindStr:String = AVM1Event.codes[kind];
			trace("as3recieve", kindStr);
			
			switch (kindStr)
			{
				case AVM1Event.LC_ERROR:
					trace("AS2 reported error >>> " + message.message);
					break;
				case AVM1Event.LC_LOADED:
					trace("AS2 loaded file >>> " + message.message);
					dispatchEvent(new AVM1Event(AVM1Event.LC_LOADED));
					break;
				case AVM1Event.LC_COMMAND:
				case AVM1Event.LC_CUSTOM:
					break;
				case AVM1Event.LC_READY:
					trace("AS3 as2 reported reconnection", this._receivingConnection);
					dispatchEvent(new AVM1Event(AVM1Event.LC_READY));
					break;
				case AVM1Event.LC_RECEIVED:
				case AVM1Event.LC_RECONNECT:
				case AVM1Event.LC_RETURN:
				case AVM1Event.LC_LOAD_START:
				case AVM1Event.LC_DISCONNECT:
					trace("AS3 recieve >>> " + kindStr);
					break;
				default:
					trace("AS3 protocol error");
			}
		}
		
		internal function loadAVM1Movie(request:URLRequest):void
		{
			trace("loadAVM1Movie");
			var message:Object = { kind: AVM1Event.LC_COMMAND, data: "ld|" + request.url };
			this.send(_receivingConnection, "as2recieve", message);
		}
		
		public function get receivingConnection():String { return _receivingConnection; }
		
		public function get sendingConnection():String { return _sendingConnection; }
		
	}
	
}
