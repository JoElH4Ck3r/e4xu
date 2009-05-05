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

package org.wvxvws.mxmlutils 
{
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	* MXMLHelper class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class MXMLHelper 
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
		public function MXMLHelper() { super(); }
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function nameForMXMLListener(dispatcher:IEventDispatcher, 
														eventType:String):Function
		{
			if (!dispatcher.hasEventListener(eventType)) return null;
			
			var id:String = "_" + getQualifiedClassName(dispatcher) + "_" +
				getQualifiedSuperclassName(dispatcher).match(/[^:]+$/g)[0];
			var re:RegExp = 
				new RegExp("__" + id + "\\d+" + "_" + eventType + "$", "g");
			var listeners:XMLList = 
				describeType(dispatcher).method.(String(@name).match(re).length);
			var f:Function = Object(dispatcher)[listeners[0].@name];
			return f;
		}
		
		public static function listenerForBindedProperty(dispatcher:IEventDispatcher, 
										property:String, eventType:String):Function
		{
			return Object(dispatcher)["__" + property + "_" + eventType];
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