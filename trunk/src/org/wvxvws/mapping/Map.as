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

package org.wvxvws.mapping 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.core.IMXMLObject;
	
	[DefaultProperty("links")]
	
	/**
	* Map class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Map extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get id():String { return _id; }
		
		public function get eventTypes():Vector.<String>
		{
			return _eventTypes.concat();
		}
		
		//public function get links():Vector.<Link> { return _links.concat(); }
		
		public function set links(value:Vector.<Link>):void 
		{
			for each (var l:Link in value)
			{
				_links[l.id] = l;
				if (_eventTypes.indexOf(l.id) < 0) _eventTypes.push(l.id);
			}
		}
		//------------------------------------
		//  Public property dispatchers
		//------------------------------------
		
		[Bindable("dispatchersChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>dispatchersChanged</code> event.
		*/
		public function get dispatchers():Vector.<IEventDispatcher> { return _dispatchers; }
		
		public function set dispatchers(value:Vector.<IEventDispatcher>):void 
		{
			if (_dispatchers == value) return;
			_dispatchers = value;
			super.dispatchEvent(new Event("dispatchersChanged"));
		}
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _eventTypes:Vector.<String> = new <String>[];
		protected var _dispatchers:Vector.<IEventDispatcher> = 
										new <IEventDispatcher>[];
		protected var _document:Object;
		protected var _id:String;
		protected var _links:Object = { };
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		internal static const instances:Vector.<Map> = new <Map>[];
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Map() 
		{
			super();
			instances.push(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function remove():void
		{
			var i:int = instances.indexOf(this);
			if (i > -1) instances.splice(i, 1);
		}
		
		public function getLink(eventType:String):Link
		{
			return _links[eventType];
		}
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function generateEvent(type:String, target:Object, 
										fault:Object, result:Object):MappingEvent
		{
			return new MappingEvent(type, target, fault, result);
		}
		
	}
}