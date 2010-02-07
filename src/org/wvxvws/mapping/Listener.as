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
	import mx.core.IMXMLObject;
	
	/**
	* Listener class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Listener extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		//------------------------------------
		//  Public property eventType
		//------------------------------------
		
		private var _eventType:String;
		
		[Bindable("eventTypeChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>eventTypeChanged</code> event.
		 */
		public function get eventType():String { return this._eventType; }
		
		public function set eventType(value:String):void 
		{
			if (this._eventType === value) return;
			this._eventType = value;
			super.dispatchEvent(new Event("eventTypeChanged"));
		}
		
		//------------------------------------
		//  Public property listener
		//------------------------------------
		
		private var _listener:Function = null;
		
		[Bindable("listenerChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>listenerChanged</code> event.
		 */
		public function get listener():Function { return this._listener; }
		
		public function set listener(value:Function):void 
		{
			if (this._listener == value) return;
			this._listener = value;
			super.dispatchEvent(new Event("listenerChanged"));
		}
		
		//------------------------------------
		//  Public property priority
		//------------------------------------
		
		private var _priority:int;
		
		[Bindable("priorityChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>priorityChanged</code> event.
		 */
		public function get priority():int { return this._priority; }
		
		public function set priority(value:int):void 
		{
			if (this._priority == value) return;
			this._priority = value;
			super.dispatchEvent(new Event("priorityChanged"));
		}
		
		//------------------------------------
		//  Public property useWeakReference
		//------------------------------------
		
		private var _useWeakReference:Boolean = false;
		
		[Bindable("useWeakReferenceChanged")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>useWeakReferenceChanged</code> event.
		 */
		public function get useWeakReference():Boolean
		{
			return this._useWeakReference;
		}
		
		public function set useWeakReference(value:Boolean):void 
		{
			if (this._useWeakReference == value) return;
			this._useWeakReference = value;
			super.dispatchEvent(new Event("useWeakReferenceChanged"));
		}
		
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
		
		private var _document:Object;
		private var _id:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Listener(eventType:String = null, listener:Function = null, 
																	priority:int = 0) 
		{
			super();
			this._eventType = eventType;
			this._listener = listener;
			this._priority = priority;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function initialized(document:Object, id:String):void
		{
			this._document = document;
			this._id = id;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
	}
}