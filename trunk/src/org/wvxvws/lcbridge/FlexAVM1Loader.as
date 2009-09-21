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
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import mx.core.UIComponent;
	//}
	
	/**
	* FlexAVM1Loader class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class FlexAVM1Loader extends UIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The reference to the LocalConnection object associated with this loader.
		 * This propery is null until you call <code>load()</code>.
		 */
		public function get connection():AVM1LC { return _connection; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _connection:AVM1LC;
		protected var _request:URLRequest;
		protected var _content:DisplayObject;
		protected var _hasAVM1Content:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FlexAVM1Loader() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function load(request:URLRequest):void
		{
			_request = request;
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
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
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