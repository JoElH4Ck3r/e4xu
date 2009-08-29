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
	import flash.events.SecurityErrorEvent;
	import flash.net.LocalConnection;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/**
	 * AVM1LC class. This class is created in AVM1Loader class and it's instance is
	 * accessible through AVM1Loader.lc property.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.12.36
	 */
	public class AVM1LC extends LocalConnection
	{
		private static const LC_NAME:String = "__LC645F8553-33B1-47D1-996F-5EDFB4863061";
		private static const LC_SEND_NAME:String = "__LC_SEND";
		private static const LC_RECEIVE_NAME:String = "__LC_RECEIVE";
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The name of the connection, where this LocalConnection listens.
		 */
		public function get receivingConnection():String { return _receivingConnection; }
		
		/**
		 * The name of the connection, where this LocalConnection sends data.
		 */
		public function get sendingConnection():String { return _sendingConnection; }
		
		/**
		 * Set this property to the function which should be invoken 
		 * on each connection operation.
		 */
		public function get defaultCallBack():Function { return _defaultCallBack; }
		public function set defaultCallBack(value:Function):void
		{
			if (value == null) return;
			_defaultCallBack = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		private var _receivingConnection:String;
		private var _sendingConnection:String;
		
		private var _bytesLoader:AVM1Loader;
		
		private var _a:Array = []; // will hold the try_lc.swf in byte sequence
		private var _ba:ByteArray = new ByteArray();
		
		private var _defaultCallBack:Function = function (...rest):void { };
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * @param	loader
		 */
		public function AVM1LC(loader:AVM1Loader)
		{
			super();
			for each(var i:int in _a) _ba.writeByte(i);
			_bytesLoader = loader;
			_bytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
										loadHandler, false, int.MAX_VALUE);
			client = this;
			super.addEventListener(StatusEvent.STATUS, statusHandler);
			super.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			//_bytesLoader.loadBytes(_ba);
			_bytesLoader.$load(new URLRequest("bridge.swf"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Calls the <code>method</code> with arbitrary number of parameters 
		 * on the loaded AVM1Movie in the scope specified by <code>scope</code> 
		 * parameter. If the AVM1 function returns non-null value
		 * the <code>receiver</code> function will be called when the AVM1LC receives
		 * the response.
		 * When the operation completes, the AVM1LC dispatches 
		 * <code>AVM1Event.LC_READY</code> event.
		 * 
		 * @param	scope		The context where to invoke the AVM1 function. 
		 * 						You can specify <code>AVM1Protocol.GLOBAL</code>, 
		 * 						<code>AVM1Protocol.CONTENT</code>, 
		 * 						<code>AVM1Protocol.NULL</code>, 
		 * 						<code>AVM1Protocol.ROOT</code> or
		 * 						<code>AVM1Protocol.THIS</code> as well as any 
		 * 						expression valid to be used in <code>eval()</code>.
		 * 
		 * @see		AVM1Protocol
		 * 
		 * @param	method		The name of the method to invoke. If the <code>scope</code>
		 * 						is <code>AVM1Protocol.NULL</code>, the function will
		 * 						be called in no context.
		 * 
		 * @param	receiver	This function is called when the AVM1 methods returns 
		 * 						non-null value. However, if you want to receive null
		 * 						values, you will need to define <code>defaultCallBack</code>
		 * 						for this AVM1LC. If you don't want to receive the 
		 * 						returned value pass <code>null</code>.
		 * 
		 * @see		#defaultCallBack
		 * 
		 * @param	...params	An arbitrary number of arguments to be passed to the
		 * 						AVM1Movie. Note that arguments are serialized using AMF0
		 * 						format compatible with AVM1. This means, that, for
		 * 						example ByteArray is not valid, while BitmapData is.
		 * 
		 * @see 	#setProperty
		 */
		public function callMethod(scope:String, method:String, 
									receiver:Function, ...params):void
		{
			// TODO: implement
		}
		
		/**
		 * Sets the property <code>property</code> on <code>scope</code> object.
		 * When the operation completes, the AVM1LC dispatches 
		 * <code>AVM1Event.LC_READY</code> event.
		 * 
		 * @param	scope		The context where you want to set the AVM1 property. 
		 * 						You can specify <code>AVM1Protocol.GLOBAL</code>, 
		 * 						<code>AVM1Protocol.CONTENT</code>, 
		 * 						<code>AVM1Protocol.NULL</code>, 
		 * 						<code>AVM1Protocol.ROOT</code> or
		 * 						<code>AVM1Protocol.THIS</code> as well as any 
		 * 						expression valid to be used in <code>eval()</code>.
		 * 
		 * @param	property	The name of the property you want to set.
		 * 
		 * @param	value		The value to assign to the <code>property</code> property.
		 * 						Note that values are serialized using AMF0 format.
		 * 
		 * @see 	#callMethod
		 */
		public function setProperty(scope:String, property:String, value:*):void
		{
			// TODO: implement
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * @param	event
		 */
		private function loadHandler(event:Event):void
		{
			event.stopImmediatePropagation();
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
		
		/**
		 * @private
		 * @param	event
		 */
		private function statusHandler(event:StatusEvent):void
		{
			trace("AS3 statusHandler " + event);
		}
		
		/**
		 * @private
		 * @param	event
		 */
		private function errorHandler(event:Event):void
		{
			trace("AS3 errorHandler " + event);
		}
		
		/**
		 * @private
		 * @param	message
		 */
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
		
		/**
		 * @private
		 * @param	request
		 */
		internal function loadAVM1Movie(request:URLRequest):void
		{
			trace("loadAVM1Movie");
			var message:Object = { kind: AVM1Event.LC_COMMAND, data: "ld|" + request.url };
			this.send(_receivingConnection, "as2recieve", message);
		}
		
	}
	
}
