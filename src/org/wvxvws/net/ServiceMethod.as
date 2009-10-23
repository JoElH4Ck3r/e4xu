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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	
	[DefaultProperty("parameters")]
	
	/**
	* ServiceMethod class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class ServiceMethod extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property parameters
		//------------------------------------
		
		[Bindable("parametersChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>parametersChanged</code> event.
		*/
		public function get parameters():ServiceArguments { return _parameters; }
		
		public function set parameters(value:ServiceArguments):void 
		{
		   if (_parameters == value) return;
		   _parameters = value;
		   super.dispatchEvent(new Event("parametersChanged"));
		}
		
		//------------------------------------
		//  Public property name
		//------------------------------------
		
		[Bindable("nameChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>nameChanged</code> event.
		*/
		public function get name():String
		{
			if (_document)
				return _document.id + "." + _name;
			return _name;
		}
		
		public function set name(value:String):void 
		{
			if (_name === value) return;
			_name = value;
			super.dispatchEvent(new Event("nameChanged"));
		}
		
		public function get id():String { return _id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:IService;
		protected var _id:String;
		protected var _parameters:ServiceArguments;
		protected var _name:String;
		
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
		
		public function ServiceMethod(){ super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document as IService;
			if (_id === "" || _id === null) _id = id;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function send(parameters:ServiceArguments = null):void
		{
			if (!_document) return;
			if (parameters) _document.send(_name, parameters);
			else _document.send(_name, _parameters);
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