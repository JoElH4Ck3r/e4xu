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
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import org.wvxvws.net.net_internal;
	//}
	
	/**
	* Synchronizer class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Synchronizer extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get hasConfig():Boolean { return _hasConfig; }
		
		public function get defaultGetaway():String { return _defaultGetaway; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _instance:Synchronizer;
		private static var _serviceID:int;
		private var _queves:Array = [];
		private var _available:Boolean = true;
		private var _timer:Timer = new Timer(1, 1);
		private var _hasConfig:Boolean;
		private var _config:XML;
		private var _destinations:Object = { };
		private var _defaultGetaway:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Synchronizer(initializer:Initializer) 
		{
			super();
			if (!initializer) throw new Error("Cannot instantiate");
			try
			{
				var c:Object = getDefinitionByName("mx.messaging.config.ServerConfig");
				_config = c.xml;
				_hasConfig = true;
				var channelClass:Class;
				var destinations:XMLList = _config..destination;
				var destinationID:String;
				var channelID:String;
				var endpoints:XMLList;
				var endpointsArr:Array;
				var channels:XMLList;
				var channelsArr:Array;
				var channel:Channel;
				var ep:Endpoint;
				var dstChannels:Array;
				var destination:Destination;
				var definitions:XMLList = _config..channel.(hasOwnProperty("@id"));
				for each(var dst:XML in destinations)
				{
					channels = dst.channels.channel;
					destinationID = dst.@id;
					dstChannels = [];
					for each(var chn:XML in channels)
					{
						channelID = chn.@ref;
						endpointsArr = [];
						channelsArr = [];
						endpoints = definitions.(@id == channelID).endpoint;
						endpoints.(endpointsArr.push(new Endpoint(@uri)) && 
								channelsArr.push(getDefinitionByName(parent().@type)));
						while (endpointsArr.length)
						{
							ep = endpointsArr.pop() as Endpoint;
							if (!_defaultGetaway) _defaultGetaway = ep.uri;
							channelsArr[endpointsArr.length] = 
								new (channelsArr[endpointsArr.length] as Class)(channelID, ep);
						}
						dstChannels = dstChannels.concat(channelsArr);
					}
					destination = new Destination(destinationID, dstChannels);
					_destinations[destinationID] = destination;
				}
			}
			catch (error:Error) { };
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
		}
		
		private function timerCompleteHandler(event:TimerEvent):void 
		{
			sendNext();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function getInstance():Synchronizer
		{
			if (_instance) return _instance;
			_instance = new Synchronizer(new Initializer());
			return _instance;
		}
		
		public function putOnQueve(target:IService, 
										method:String = "", priority:int = -1):int
		{
			var queve:Queve = new Queve(target, method, 
					priority > -1 ? priority : _queves.length, serviceID());
			_queves[queve.priority] = queve;
			if (_timer.currentCount) _timer.reset();
			_timer.start();
			return queve.id;
		}
		
		public function acknowledge(id:int):void
		{
			var i:int;
			var lnt:int = _queves.length;
			var queve:Queve
			for (i = 0; i < lnt; i++)
			{
				queve = _queves[i];
				if (queve && queve.id == id)
				{
					_queves.splice(i, 1);
					_available = true;
					sendNext();
					break;
				}
			}
		}
		
		public function hasDestination(destination:String):Boolean
		{
			return (destination in _destinations);
		}
		
		public function endpointsForAlias(alias:String):Array
		{
			var destination:Destination = _destinations[alias] as Destination;
			var channels:Array = destination.channels;
			var endpoints:Array = [];
			for each (var cn:Channel in channels)
			{
				if (!cn.available) continue;
				endpoints.push(cn.endpoint.uri);
			}
			return endpoints;
		}
		
		private function sendNext():void
		{
			var queve:Queve;
			if (_available)
			{
				queve = hasNext();
				if (queve)
				{
					_available = false;
					queve.target.net_internal::internalSend(queve.id);
				}
				else
				{
					_available = true;
				}
			}
		}
		
		private function hasNext():Queve
		{
			for each (var queve:Queve in _queves)
			{
				if (queve) return queve;
			}
			return null;
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
		
		private static function serviceID():int { return ++_serviceID; }
	}
	
}

internal final class Initializer 
{
	public function Initializer() { super(); }
}

import org.wvxvws.net.IService;

internal final class Queve
{
	public var target:IService;
	public var priority:int;
	public var method:String;
	public var id:int;
	
	public function Queve(target:IService, method:String, priority:int, id:int)
	{
		super();
		this.target = target;
		this.method = method;
		this.priority = priority;
		this.id = id;
	}
}