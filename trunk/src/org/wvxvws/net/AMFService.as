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
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import org.wvxvws.binding.EventGenerator;
	//}
	
	[DefaultProperty("methods")]
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="fault", type="org.wvxvws.net.ServiceEvent")]
	[Event(name="result", type="org.wvxvws.net.ServiceEvent")]
	
	/**
	* AMFService class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	* EclipsePHP update site.
	* http://phpeclipse.sourceforge.net/update/stable/1.2.x
	* http://update.phpeclipse.net/update/stable/1.2.x
	*/
	public class AMFService extends NetConnection implements IService
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property baseURL
		//------------------------------------
		
		[Bindable("baseURLChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>baseURLChanged</code> event.
		*/
		public function get baseURL():String { return this._baseURL; }
		
		public function set baseURL(value:String):void 
		{
			if (this._baseURL === value) return;
			this._baseURL = value;
			if (super.hasEventListener(EventGenerator.getEventType("baseURL")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property methods
		//------------------------------------
		
		[Bindable("methodsChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>methodsChanged</code> event.
		*/
		public function get methods():Vector.<ServiceMethod>
		{
			return this._methods.concat();
		}
		
		public function set methods(value:Vector.<ServiceMethod>):void 
		{
			if (this._methods === value) return;
			this._methods.length = 0;
			for each (var sm:ServiceMethod in value)
			{
				if (this._methods.indexOf(sm) < 0)
				{
					this._methods.push(sm);
					sm.initialized(this, "method");
				}
			}
			if (super.hasEventListener(EventGenerator.getEventType("methods")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property parameters
		//------------------------------------
		
		[Bindable("parametersChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>parametersChanged</code> event.
		*/
		public function get parameters():ServiceArguments { return this._parameters; }
		
		public function set parameters(value:ServiceArguments):void 
		{
			if (this._parameters === value) return;
			this._parameters = value;
			if (super.hasEventListener(EventGenerator.getEventType("parameters")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property resultCallBack
		//------------------------------------
		
		[Bindable("resultCallBackChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>resultCallBackChange</code> event.
		*/
		public function get resultCallBack():Function { return this._resultCallBack; }
		
		public function set resultCallBack(value:Function):void 
		{
			if (this._resultCallBack === value) return;
			this._resultCallBack = value;
			if (super.hasEventListener(EventGenerator.getEventType("resultCallBack")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property faultCallBack
		//------------------------------------
		
		[Bindable("faultCallBackChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>faultCallBackChanged</code> event.
		*/
		public function get faultCallBack():Function { return this._faultCallBack; }
		
		public function set faultCallBack(value:Function):void 
		{
			if (this._faultCallBack === value) return;
			this._faultCallBack = value;
			if (super.hasEventListener(EventGenerator.getEventType("faultCallBack")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property responder
		//------------------------------------
		
		[Bindable("responderChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>responderChanged</code> event.
		*/
		public function get responder():Responder { return this._responder; }
		
		public function set responder(value:Responder):void 
		{
			if (this._responder === value) return;
			this._responder = value;
			if (super.hasEventListener(EventGenerator.getEventType("responder")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get id():String { return this._id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _baseURL:String = "";
		protected var _methods:Vector.<ServiceMethod> = new <ServiceMethod>[];
		protected var _parameters:ServiceArguments;
		protected var _resultCallBack:Function;
		protected var _faultCallBack:Function;
		protected var _sending:Boolean;
		protected var _synchronizer:Synchronizer;
		protected var _operations:Object = { };
		protected var _currentID:int;
		protected var _responder:Responder;
		protected var _deferredOperation:Array;
		protected var _connected:Boolean;
		protected var _result:Object;
		protected var _fault:Object;
		
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
		
		public function AMFService(resultCallBack:Function = null, 
									faultCallBack:Function = null)
		{
			super();
			this._resultCallBack = resultCallBack;
			this._faultCallBack = faultCallBack;
			this._responder = 
				new Responder(this.defaultResultCallBack, this.defaultFaultCallBack);
			this._synchronizer = Synchronizer.getInstance();
			super.addEventListener(
				NetStatusEvent.NET_STATUS, this.netStatusHandler, false, 0, true);
			super.addEventListener(
				SecurityErrorEvent.SECURITY_ERROR, 
				this.securityErrorHandler, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function call(command:String, responder:Responder, ...rest):void 
		{
			//super.call(command, responder);
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		/* INTERFACE org.wvxvws.net.IService */
		
		public function send(method:String = null, parameters:ServiceArguments = null):void
		{
			if (!method) throw new Error("Must specify method");
			var id:int = this._synchronizer.putOnQueve(this, method);
			var sm:ServiceMethod = this.methodForName(this._id + "." + method);
			if (sm.parameters && !parameters) parameters = sm.parameters;
			if (!parameters) parameters = this._parameters;
			var operation:Operation = new Operation(id, sm, parameters);
			this._operations[id] = operation;
		}
		
		public function cancel(method:String = null):void
		{
			this._connected = false;
			super.close();
		}
		
		public function get sending():Boolean { return this._sending; }
		
		public function get result():Object { return this._result; }
		
		public function get fault():Object { return this._fault; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function defaultFaultCallBack(value:Object):void
		{
			this._synchronizer.acknowledge(this._currentID);
			this._sending = false;
			this._fault = value;
			if (this._faultCallBack !== null) this._faultCallBack(value);
			super.dispatchEvent(new Event(Event.COMPLETE));
			super.dispatchEvent(new ServiceEvent(ServiceEvent.FAULT, value));
		}
		
		protected function defaultResultCallBack(value:Object):void
		{
			this._synchronizer.acknowledge(this._currentID);
			this._sending = false;
			this._result = value;
			if (this._resultCallBack !== null) this._resultCallBack(value);
			super.dispatchEvent(new Event(Event.COMPLETE));
			super.dispatchEvent(new ServiceEvent(ServiceEvent.RESULT, value));
		}
		
		protected function methodForName(name:String):ServiceMethod
		{
			for each(var method:ServiceMethod in this._methods)
			{
				if (method.name === name) return method;
			}
			return null;
		}
		
		protected function netStatusHandler(event:NetStatusEvent):void 
		{
			switch (event.info.level)
			{
				case "status":
					switch (event.info.code)
					{
						case "NetConnection.Connect.Success":
							if (this._deferredOperation)
							{
								super.call.apply(this, this._deferredOperation);
								this._deferredOperation = null;
							}
							break;
					}
					break;
				case "error":
				case "warning":
					this.defaultFaultCallBack(event.info);
					break;
			}
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			this.defaultFaultCallBack(event);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		net_internal function internalSend(id:int):void
		{
			this._sending = true;
			this._currentID = id;
			var operation:Operation = this._operations[id];
			this._deferredOperation = [operation.method.name, this._responder];
			if (operation.parameters.parameters && 
				operation.parameters.parameters.length)
			{
				this._deferredOperation = 
					this._deferredOperation.concat(operation.parameters.parameters);
			}
			if (!this._baseURL) this._baseURL = this._synchronizer.defaultGetaway;
			if (!this._baseURL) 
			{
				this.defaultFaultCallBack("must specify baseURL");
				return;
			}
			if (!this._connected)
			{
				super.connect(this._baseURL);
				this._connected = true;
			}
			super.call.apply(this, this._deferredOperation);
			this._deferredOperation = null;
		}
	}
}

import org.wvxvws.net.ServiceMethod;
import org.wvxvws.net.ServiceArguments;

internal final class Operation
{
	public var method:ServiceMethod;
	public var id:int;
	public var parameters:ServiceArguments;
	
	public function Operation(id:int, method:ServiceMethod = null, 
								parameters:ServiceArguments = null)
	{
		super();
		this.id = id;
		this.method = method;
		this.parameters = parameters;
	}
}