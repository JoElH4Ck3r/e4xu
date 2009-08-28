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
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.Sprite;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	[Event(name="lcReady", type="org.wvxvws.AVM1Event")]
	[Event(name="lcReceived", type="org.wvxvws.AVM1Event")]
	[Event(name="lcReconnect", type="org.wvxvws.AVM1Event")]
	[Event(name="lcLoaded", type="org.wvxvws.AVM1Event")]
	[Event(name="lcError", type="org.wvxvws.AVM1Event")]
	[Event(name="lcCustom", type="org.wvxvws.AVM1Event")]
	[Event(name="lcLoadStart", type="org.wvxvws.AVM1Event")]
	[Event(name="lcDisconnect", type="org.wvxvws.AVM1Event")]
	
	/**
	 * AVM1Loader class. This class loads AS2 content and establishes the local 
	 * connection between it and AVM1LC.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.12.36
	 */
	public class AVM1Loader extends Loader
	{
		private var _connection:AVM1LC;
		private var _request:URLRequest;
		protected var _context:LoaderContext;
		protected var _content:DisplayObject;
		
		public function AVM1Loader(request:URLRequest = null, context:LoaderContext = null)
		{
			super();
			_request = request;
			_context = context;
			if (_request) load(_request, _context);
		}
		
		private function contentCompleteHandler(event:Event):void
		{
			event.stopImmediatePropagation();
		}
		
		public override function load(request:URLRequest, context:LoaderContext = null):void
		{
			_request = request;
			_context = context;
			if (!_connection)
			{
				_connection = new AVM1LC(this);
				_connection.addEventListener(AVM1Event.LC_RECEIVED, receivedHandler);
				_connection.addEventListener(AVM1Event.LC_RECONNECT, reconnectHandler);
				_connection.addEventListener(AVM1Event.LC_LOADED, loadedHandler);
				_connection.addEventListener(AVM1Event.LC_ERROR, errorHandler);
				_connection.addEventListener(AVM1Event.LC_READY, readyHandler);
			}
		}
		
		internal final function $load(request:URLRequest, context:LoaderContext = null):void
		{
			super.load(request, context);
		}
		
		private function readyHandler(event:AVM1Event):void 
		{
			_connection.loadAVM1Movie(_request);
		}
		
		private function loadedHandler(event:AVM1Event):void 
		{
			trace("Loader: as2 movie loaded");
		}
		
		private function reconnectHandler(event:AVM1Event):void 
		{
			
		}
		
		private function receivedHandler(event:AVM1Event):void 
		{
			trace("redispatching ");
			//_connection.removeEventListener(AVM1Event.MESSAGE_RECIEVED, messageHandler);
		}
		
		private function errorHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			trace(">>> failied to load AVM1 movie: " + _request, event);
			// handle error here
		}
		
	}
	
}
