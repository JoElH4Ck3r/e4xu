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
		
		public function get embed():Class { return this._embed; }
		
		public function set embed(value:Class):void 
		{
			if (this._embed === value) return;
			this._embed = value;
			if (ApplicationDomain.currentDomain.hasDefinition(
				"org.wvxvws.managers::ResourceManager") && this._id !== null)
			{
				var rm:Object = ApplicationDomain.currentDomain.getDefinition(
					"org.wvxvws.managers::ResourceManager");
				if (rm) rm.registerResource(value, this._id);
			}
			if (_document)
			{
				this._dispatchLater = false;
				super.dispatchEvent(new Event("embedded"));
			}
			else this._dispatchLater = true;
		}
		
		public function get id():String { return this._id; }
		
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
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Resource(){ super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			this._document = document;
			this._id = id;
			if (this._embed && ApplicationDomain.currentDomain.hasDefinition(
				"org.wvxvws.managers::ResourceManager"))
			{
				var rm:Object = ApplicationDomain.currentDomain.getDefinition(
					"org.wvxvws.managers::ResourceManager");
				if (rm) rm.registerResource(this._embed, this._id);
			}
			if (this._dispatchLater)
			{
				this._dispatchLater = false;
				super.dispatchEvent(new Event("embedded"));
			}
		}
		
		public function dispose():void { }
	}
}