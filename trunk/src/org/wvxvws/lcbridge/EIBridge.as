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
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	//}
	/**
	* EIBridge class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class EIBridge 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get available():Boolean { return _available; }
		
		public function get id():String { return _id; }
		
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
		
		private static var _available:Boolean = ExternalInterface.available;
		private var _id:String = "ieBridge" + 
								(new Date().time * Math.random()).toString(36);
		private var _ourURL:String = new Loader().contentLoaderInfo.loaderURL;
		private var _ourID:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function EIBridge() 
		{
			super();
			createReceiver();
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function as3receive(obj:Object):*
		{
			return obj;
			//AVM1Command.parseFromAMF0(obj);
		}
		
		public function createReceiver():Boolean
		{
			if (!_available) return false;
			ExternalInterface.addCallback("as3receive", as3receive);
			
			var getId:String = 
			<![CDATA[function(){
				var objects = document.getElementsByTagName("object");
				for (var p in objects)
				{
					if (objects[p].data == "]]> + _ourURL + 
			<![CDATA[")	return objects[p].id;
				}
			}
			]]>;
			_ourID = ExternalInterface.call(getId);
			
			var script:String =
			<![CDATA[function(){
				var b = document.getElementsByTagName("body")[0];
				var d = document.createElement("div");
				d.setAttribute("id", "]]> + _id + 
			<![CDATA[");
				d.as3send = function()
				{
					var flash = document.getElementById("]]> + _ourID +
			<![CDATA[");
					return flash.as2receive(arguments);
				}
				d.as2send = function()
				{
					var flash = document.getElementById("]]> + _ourID +
			<![CDATA[");
					return flash.as3receive(arguments);
				}
				d.style.visibility = "hidden";
				d.style.display = "none";
				b.appendChild(d);
			}]]>;
			ExternalInterface.call(script);
			return true;
		}
		
		public function as3send(command:AVM1Command):*
		{
			if (!_available) return undefined;
			var script:String = "document.getElementById(\"" + _id + "\").as2send";
			return AVM1Command.parseFromAMF0(ExternalInterface.call(script, command.toAMF0Object()));
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