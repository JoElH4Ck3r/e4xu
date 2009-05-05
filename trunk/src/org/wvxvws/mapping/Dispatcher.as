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
	//{imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;
	import mx.core.IMXMLObject;
	//}
	
	/**
	* Dispatcher class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Dispatcher extends EventDispatcher implements IMXMLObject
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
		
		protected var _factory:Class;
		protected var _type:String;
		protected var _constructorArguments:Array;
		protected var _eventProperties:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _document:Object;
		private var _name:QName;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Dispatcher() 
		{
			super();
			
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function emitEvent():void
		{
			var e:Event;
			for each (var m:Map in Map.instances)
			{
				if (m.hasEvent(_type))
				{
					e = createEvent();
					populateProperties(e);
					m.dispatchEvent(e);
				}
			}
		}
		
		private function populateProperties(event:Event):void
		{
			for (var p:String in event)
			{
				event[p] = _eventProperties[p];
			}
		}
		
		private function createEvent():Event
		{
			if (!_constructorArguments) return new _factory(_type);
			var aLnt:int = describeType(_factory).factory.constructor.parameter.length();
			var a:Array = _constructorArguments.slice(0, aLnt);
			switch (a.length)
			{
				case 1: return 	_factory(_type, a[0]);
				case 2: return 	_factory(_type, a[0], a[1]);
				case 3: return 	_factory(_type, a[0], a[1], a[2]);
				case 4: return 	_factory(_type, a[0], a[1], a[2], a[3]);
				case 5: return 	_factory(_type, a[0], a[1], a[2], a[3], a[4]);
				case 6: return 	_factory(_type, a[0], a[1], a[2], a[3], a[4], a[5]);
				case 7: return 	_factory(_type, a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
				case 8: return 	_factory(_type, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
				case 9: return 	_factory(_type, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
				case 10: return _factory(_type, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]);
				default: throw new Error("Maximum of 10 constructor arguments allowed.");
			}
			return null;
		}
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_name = new QName(id);
		}
		
		public function get factory():Class { return _factory; }
		
		public function set factory(value:Class):void 
		{
			if (value == Event)
			{
				_factory = value;
				return;
			}
			var eventClass:String = "flash.events::Event";
			var temp:String
			var classEvent:Class = value;
			do
			{
				temp = getQualifiedSuperclassName(classEvent);
				classEvent = getDefinitionByName(temp) as Class;
				if (classEvent == Event)
				{
					_factory = value;
					return;
				}
			}
			while (temp != eventClass && temp != "Object");
			throw new Error("Factory class must subclass flash.events::Event");
		}
		
		public function get type():String { return _type; }
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get constructorArguments():Array { return _constructorArguments; }
		
		public function set constructorArguments(value:Array):void 
		{
			_constructorArguments = value;
		}
		
		public function get eventProperties():Object { return _eventProperties; }
		
		public function set eventProperties(value:Object):void 
		{
			_eventProperties = value;
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