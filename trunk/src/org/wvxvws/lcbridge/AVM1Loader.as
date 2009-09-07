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
 * @includeExample C:\www\projects\xmlhelpers\src\tests\AVM1Test.as
 */
package org.wvxvws.lcbridge
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * Dispatched when receiving connection sends unrecognised command.
	 */
	[Event(name="lcCustom", type="org.wvxvws.AVM1Event")]
	
	/**
	 * Dispatched after receiving connection responded.
	 */
	[Event(name="lcReceived", type="org.wvxvws.AVM1Event")]
	
	/**
	 * Dispatched when connection error occures.
	 * Note: when loading error occures <code>AVM1ErrorEvent.CONNECTION_ERROR</code>
	 * @see #connectionError
	 */
	[Event(name="lcError", type="org.wvxvws.AVM1Event")]
	
	/**
	 * Dispatched when targeted AVM1Movie loads.
	 */
	[Event(name="lcLoaded", type="org.wvxvws.AVM1Event")]
	
	/**
	 * Dispatched after LocalConnection associated with this loader establishes
	 * bilinear connection with the proxying AVM1Movie.
	 */
	[Event(name="lcReady", type="org.wvxvws.AVM1Event")]
	
	/**
	 * Dispatched when proxying AVM1Movie reconnects.
	 */
	[Event(name="lcReconnect", type="org.wvxvws.AVM1Event")]
	
	/**
	 * Dispatched when AVM1Movie request AVM2 movie to perform action 
	 * such as call method or set property.
	 */
	[Event(name="lcCommand", type="org.wvxvws.AVM1Event")]
	
	/**
	 * Dispatched when proxying AVM1Movie disconnects.
	 */
	[Event(name="lcDisconnect", type="org.wvxvws.AVM1Event")]
	
	/**
	 * Dispatched when targeted AVM1Movie fails to load. You must handle this even
	 * if you suspect loading errors.
	 */
	[Event(name="connectionError", type="org.wvxvws.AVM1ErrorEvent")]
	
	/**
	 * AVM1Loader class. This class loads AS2 content and establishes the local 
	 * connection between it and AVM1LC.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.12.36
	 */
	public class AVM1Loader extends Loader
	{
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The reference to the LocalConnection object associated with this loader.
		 * This propery is null until you call <code>load()</code>.
		 */
		public function get connection():AVM1LC { return _connection; }
		
		protected var _connection:AVM1LC;
		protected var _request:URLRequest;
		protected var _context:LoaderContext;
		protected var _content:DisplayObject;
		protected var _hasAVM1Content:Boolean;
		
		/**
		 * Creates new AVM1Loader.
		 * @param	request
		 * @param	context
		 */
		public function AVM1Loader(request:URLRequest = null, context:LoaderContext = null)
		{
			super();
			_request = request;
			_context = context;
			if (_request) load(_request, _context);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * This will initiate LocalConnection associated with this loader on first call
		 * and make it load proxying AVM1Movie. The events dispatched during the first
		 * call and any further calls will slightly vary. For instance, 
		 * <code>AVM1Event.LC_RECONNECT</code> will fire only first time.
		 * 
		 * @param	request	Note: only the <code>url</code> of this request will be used.
		 * 			Data as well as headers will be ignored.
		 * 
		 * @param	context	Note: this parameter is not used.
		 */
		public override function load(request:URLRequest, context:LoaderContext = null):void
		{
			_request = request;
			_context = context;
			_hasAVM1Content = false;
			if (!_connection)
			{
				_connection = new AVM1LC(this);
				_connection.addEventListener(AVM1Event.LC_CUSTOM, lcEventHandler);
				_connection.addEventListener(AVM1Event.LC_RECEIVED, lcEventHandler);
				_connection.addEventListener(AVM1Event.LC_RECONNECT, lcEventHandler);
				_connection.addEventListener(AVM1Event.LC_LOADED, lcEventHandler);
				_connection.addEventListener(AVM1Event.LC_COMMAND, lcEventHandler);
				_connection.addEventListener(AVM1Event.LC_DISCONNECT, lcEventHandler);
				
				_connection.addEventListener(AVM1Event.LC_ERROR, errorHandler);
				
				_connection.addEventListener(AVM1Event.LC_READY, readyHandler);
			}
		}
		
		/**
		 * This will also close the LocalConnection associated with this loader.
		 */
		override public function unload():void 
		{
			_connection.close();
			super.unload();
			_hasAVM1Content = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * @param	request
		 * @param	context
		 */
		internal final function $load(request:URLRequest, 
									context:LoaderContext = null):void
		{
			super.load(request, context);
		}
		
		/**
		 * @private
		 * @param	event
		 */
		private function readyHandler(event:AVM1Event):void 
		{
			if (!_hasAVM1Content)
				_connection.loadAVM1Movie(_request);
			super.dispatchEvent(event);
		}
		
		/**
		 * @private
		 * @param	event
		 */
		private function lcEventHandler(event:AVM1Event):void 
		{
			if (event.type === AVM1Event.LC_LOADED) _hasAVM1Content = true;
			super.dispatchEvent(event);
		}
		
		/**
		 * @private
		 * @param	event
		 */
		private function errorHandler(event:AVM1Event):void
		{
			event.stopImmediatePropagation();
			switch (_connection.errorID)
			{
				case 1:
					super.dispatchEvent(new AVM1ErrorEvent(
								AVM1ErrorEvent.CONNECTION_ERROR, 
								"Failed to load URL " + _request.url, 1));
					break;
				default:
					super.dispatchEvent(event);
					break;
			}
		}
	}
	
}
