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

package org.wvxvws.net 
{
	//{imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.wvxvws.net.ServiceArguments;
	//}
	
	/**
	* MultyAMFService class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class MultiAMFService extends AMFService
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _services:Array;
		protected var _queved:Array = [];
		
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
		public function MultiAMFService(resultCallBack:Function = null, 
														faultCallBack:Function = null) 
		{
			super(resultCallBack, faultCallBack);
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function send(method:String = null, 
										parameters:ServiceArguments = null):void 
		{
			var sr:AMFService;
			if (!_services)
			{
				_services = [];
				var enpoints:Array = _synchronizer.endpointsForAlias(_baseURL);
				for each(var s:String in enpoints)
				{
					sr = new AMFService(resultCallBack, faultCallBack);
					sr.addEventListener(Event.COMPLETE, serviceCompleteHandler, false, 0, true);
					sr.initialized(this, s);
					sr.baseURL = s;
					sr.methods = _methods;
					sr.parameters = _parameters;
					_services.push(sr);
				}
			}
			var temp:Array = []
			for each (sr in _services)
			{
				sr.send(method, parameters);
				temp.push(sr);
			}
			_queved.push(temp);
		}
		
		protected function serviceCompleteHandler(event:Event):void 
		{
			var temp:Array = _queved[0];
			var current:int = temp.indexOf(event.currentTarget as AMFService);
			if (current < 0) trace("something went wrong...");
			delete temp.splice(current, 1);
			if (!temp.length)
			{
				_queved.shift();
				dispatchEvent(new Event(Event.COMPLETE));
			}
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
	}
	
}