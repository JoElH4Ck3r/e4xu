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
	import flash.utils.Dictionary;
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
		public function get receivingConnection():String { return this._receivingConnection; }
		
		/**
		 * The name of the connection, where this LocalConnection sends data.
		 */
		public function get sendingConnection():String { return this._sendingConnection; }
		
		/**
		 * Set this property to the function which should be invoken 
		 * on each connection operation.
		 */
		public function get defaultCallBack():Function { return this._defaultCallBack; }
		public function set defaultCallBack(value:Function):void
		{
			if (!(value is Function)) return;
			this._defaultCallBack = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _receivingConnection:String;
		private var _sendingConnection:String;
		
		private var _bytesLoader:AVM1Loader;
		
		private static const _avm1SWF:AVM1SWF = new AVM1SWF();
		
		internal var errorID:int;
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _defaultCallBack:Function = function (...rest):void { };
		protected var _commands:Dictionary = new Dictionary();
		protected var _commandsPool:Dictionary = new Dictionary();
		protected var _sending:Boolean;
		protected var _loading:Boolean;
		protected var _queved:AVM1Command;
		
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
			this._bytesLoader = loader;
			this._bytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
										this.loadHandler, false, int.MAX_VALUE);
			super.client = this;
			super.addEventListener(StatusEvent.STATUS, this.statusHandler);
			super.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.errorHandler);
			super.addEventListener(
				SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
			_avm1SWF.position = 0;
			this._bytesLoader.loadBytes(_avm1SWF);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 * @param	connectionName
		 * @param	methodName
		 * @param	...args
		 */
		public override function send(connectionName:String, 
										methodName:String, ...args):void 
		{
			this._sending = true;
			super.send.apply(super, [connectionName, methodName].concat(args));
		}
		
		/**
		 * This will also try to terminate receiving connection.
		 */
		public override function close():void 
		{
			var command:AVM1Command = new AVM1Command(AVM1Command.CALL_METHOD, 
							AVM1Protocol.THIS, "disconnect");
			this.send(_receivingConnection, "as2recieve", command.toAMF0Object());
			super.close();
			super.dispatchEvent(new AVM1Event(AVM1Event.LC_DISCONNECT, null));
		}
		
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
			var cmd:AVM1Command;
			for (var obj:Object in _commandsPool)
			{
				if ((obj as AVM1Command).type == AVM1Command.CALL_METHOD)
				{
					cmd = obj as AVM1Command;
					break;
				}
			}
			if (!cmd) 
				cmd = new AVM1Command(AVM1Command.CALL_METHOD, 
										scope, method, null, null, params);
			else
			{
				cmd.method = method;
				cmd.methodArguments = params;
			}
			if (receiver !== null) cmd.addEventListener(Event.COMPLETE, receiver);
			this.sendCommand(cmd);
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
		 * @param	receiver	This function is called when the operation completes.
		 * @default	<code>null</code>
		 * 
		 * @see 	#callMethod
		 */
		public function setProperty(scope:String, property:String, 
									value:*, receiver:Function = null):void
		{
			var cmd:AVM1Command;
			for (var obj:Object in this._commandsPool)
			{
				if ((obj as AVM1Command).type == AVM1Command.SET_PROPERTY)
				{
					cmd = obj as AVM1Command;
					break;
				}
			}
			if (!cmd)
			{
				cmd = new AVM1Command(
					AVM1Command.SET_PROPERTY, scope, null, property, value);
			}
			else
			{
				cmd.property = property;
				cmd.propertyValue = value;
			}
			if (receiver !== null) cmd.addEventListener(Event.COMPLETE, receiver);
			sendCommand(cmd);
		}
		
		/**
		 * Sends the <code>AVM1Command</code> to the loaded AVM1Movie.
		 * If the command is expected to return results from AVM1Movie, add listener
		 * for <code>Event.COMPLETE</code> event to the <code>command</code>.
		 * 
		 * @param	command		The AVM1Command that encapsulates the command
		 * 						to be performed by AVM1Movie.
		 * 
		 * @param	recicle		If <code>true</code>, this command will be reused to
		 * 						send other messages.
		 * @default	<code>true</code>
		 */
		public function sendCommand(command:AVM1Command, 
									recicle:Boolean = true):void
		{
			this._commands[command] = recicle;
			if (!this._sending)
			{
				this._queved = command;
				this.send(_receivingConnection, "as2recieve", command.toAMF0Object());
			}
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
			this._receivingConnection = LC_RECEIVE_NAME + new Date().time;
			this._sendingConnection = LC_SEND_NAME + new Date().time;
			var command:AVM1Command = new AVM1Command(AVM1Command.CALL_METHOD, 
				AVM1Protocol.THIS, "reconnect", null, null, 
				[this._receivingConnection + "|" + this._sendingConnection]);
			try
			{
				super.close();
			}
			catch (error:Error)
			{
				if (error.errorID !== 2083)
				{
					throw error;
				}
			}
			this.connect(this._sendingConnection);
			this.send(LC_NAME, "as2recieve", command.toAMF0Object());
		}
		
		/**
		 * @private
		 * @param	event
		 */
		private function statusHandler(event:StatusEvent):void { }
		
		/**
		 * @private
		 * @param	event
		 */
		private function errorHandler(event:Event):void { }
		
		/**
		 * @private
		 * @param	message
		 */
		public function as3recieve(message:Object):void
		{
			this._sending = false;
			var rec:AVM1Command = AVM1Command.parseFromAMF0(message);
			var com:Object;
			var command:AVM1Command;
			var finished:AVM1Command;
			var next:AVM1Command;
			
			switch (rec.type)
			{
				case AVM1Command.CALL_METHOD:
					dispatchEvent(new AVM1Event(AVM1Event.LC_COMMAND, rec));
					break;
				case AVM1Command.SET_PROPERTY:
					dispatchEvent(new AVM1Event(AVM1Event.LC_COMMAND, rec));
					break;
				case AVM1Command.LOAD_CONTENT:
					dispatchEvent(new AVM1Event(AVM1Event.LC_LOADED, rec));
					break;
				case AVM1Command.NOOP:
					if (rec.method === "reconnect")
					{
						dispatchEvent(new AVM1Event(AVM1Event.LC_RECONNECT, rec));
						dispatchEvent(new AVM1Event(AVM1Event.LC_READY, rec));
						break;
					}
					if (rec.method === "disconnect")
					{
						super.close();
						dispatchEvent(new AVM1Event(AVM1Event.LC_DISCONNECT, rec));
						break;
					}
					for (com in _commands)
					{
						command = com as AVM1Command;
						if (this._queved === command) finished = command;
						else next = command;
						if (next && finished) break;
					}
					if (finished)
					{
						finished.operationResult = rec.operationResult;
						if (this._commands[finished])
						{
							this._commandsPool[finished] = true;
						}
						delete this._commands[finished];
						finished.dispatchEvent(new Event(Event.COMPLETE));
					}
					if (next) sendCommand(next, this._commands[next]);
					this._loading = false;
					break;
				case AVM1Command.ERROR:
					if (_loading) errorID = 1;
					else errorID = 0;
				default:
					super.dispatchEvent(new AVM1Event(AVM1Event.LC_ERROR, rec));
			}
			super.dispatchEvent(new AVM1Event(AVM1Event.LC_RECEIVED, rec));
		}
		
		/**
		 * @private
		 * @param	request
		 */
		internal function loadAVM1Movie(request:URLRequest):void
		{
			if (this._loading) return;
			this._loading = true;
			var command:AVM1Command = new AVM1Command(AVM1Command.LOAD_CONTENT, 
							AVM1Protocol.THIS, null, null, null, null, request.url);
			this.send(this._receivingConnection, "as2recieve", command.toAMF0Object());
		}
	}
}
