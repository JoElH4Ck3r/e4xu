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

package org.wvxvws.resources 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import mx.core.IMXMLObject;
	
	[Event(name="embedded", type="flash.events.Event")]
	
	[DefaultProperty("embed")]
	
	/**
	* Resource class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Resource extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property embed
		//------------------------------------
		
		public function get embed():Class { return _embed; }
		
		public function set embed(value:Class):void 
		{
			if (_embed === value) return;
			_embed = value;
			if (ApplicationDomain.currentDomain.hasDefinition(
				"org.wvxvws.managers::ResourceManager") && _id !== null)
			{
				var rm:Object = ApplicationDomain.currentDomain.getDefinition(
					"org.wvxvws.managers::ResourceManager");
				if (rm) rm.registerResource(value, _id);
			}
			if (_document)
			{
				_dispatchLater = false;
				super.dispatchEvent(new Event("embedded"));
			}
			else _dispatchLater = true;
		}
		
		public function get id():String { return _id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _embed:Class;
		protected var _dispatchLater:Boolean;
		
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
		public function Resource(){ super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
			if (_embed && ApplicationDomain.currentDomain.hasDefinition(
				"org.wvxvws.managers::ResourceManager"))
			{
				var rm:Object = ApplicationDomain.currentDomain.getDefinition(
					"org.wvxvws.managers::ResourceManager");
				if (rm) rm.registerResource(_embed, _id);
			}
			if (_dispatchLater)
			{
				_dispatchLater = false;
				super.dispatchEvent(new Event("embedded"));
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
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