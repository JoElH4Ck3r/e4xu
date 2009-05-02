package org.wvxvws.net 
{
	//{imports
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	//}
	
	[DefaultProperty("methods")]
	
	[Event(name="complete", type="flash.events.Event")]
	
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
		
		[Bindable("baseURLChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>baseURLChange</code> event.
		*/
		public function get baseURL():String { return _baseURL; }
		
		public function set baseURL(value:String):void 
		{
		   if (_baseURL == value) return;
		   _baseURL = value;
		   dispatchEvent(new Event("baseURLChange"));
		}
		
		//------------------------------------
		//  Public property methods
		//------------------------------------
		
		[Bindable("methodsChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>methodsChange</code> event.
		*/
		public function get methods():Array { return _methods; }
		
		public function set methods(value:Array):void 
		{
		   if (_methods == value) return;
		   _methods = value;
		   dispatchEvent(new Event("methodsChange"));
		}
		
		//------------------------------------
		//  Public property parameters
		//------------------------------------
		
		[Bindable("parametersChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>parametersChange</code> event.
		*/
		public function get parameters():ServiceArguments { return _parameters; }
		
		public function set parameters(value:ServiceArguments):void 
		{
		   if (_parameters == value) return;
		   _parameters = value;
		   dispatchEvent(new Event("parametersChange"));
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
		public function get resultCallBack():Function { return _resultCallBack; }
		
		public function set resultCallBack(value:Function):void 
		{
		   if (_resultCallBack === value) return;
		   _resultCallBack = value;
		   dispatchEvent(new Event("resultCallBackChange"));
		}
		
		//------------------------------------
		//  Public property faultCallBack
		//------------------------------------
		
		[Bindable("faultCallBackChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>faultCallBackChange</code> event.
		*/
		public function get faultCallBack():Function { return _faultCallBack; }
		
		public function set faultCallBack(value:Function):void 
		{
			if (_faultCallBack === value) return;
			_faultCallBack = value;
			dispatchEvent(new Event("faultCallBackChange"));
		}
		
		//------------------------------------
		//  Public property responder
		//------------------------------------
		
		[Bindable("responderChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>responderChange</code> event.
		*/
		public function get responder():Responder { return _responder; }
		
		public function set responder(value:Responder):void 
		{
		   if (_responder == value) return;
		   _responder = value;
		   dispatchEvent(new Event("responderChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _baseURL:String = "";
		protected var _methods:Array /* of ServiceMethod */ = [];
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
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function AMFService(resultCallBack:Function = null, 
									faultCallBack:Function = null)
		{
			super();
			_resultCallBack = resultCallBack;
			_faultCallBack = faultCallBack;
			_responder = new Responder(defaultResultCallBack, defaultFaultCallBack);
			_synchronizer = Synchronizer.getInstance();
			addEventListener(NetStatusEvent.NET_STATUS, 
												netStatusHandler, false, 0, true);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
											securityErrorHandler, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function call(command:String, responder:Responder, ...rest):void 
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
			var id:int = _synchronizer.putOnQueve(this, method);
			var sm:ServiceMethod = methodForName(method);
			if (sm.parameters && !parameters) parameters = sm.parameters;
			if (!parameters) parameters = _parameters;
			var operation:Operation = new Operation(id, sm, parameters);
			_operations[id] = operation;
		}
		
		public function cancel(method:String = null):void
		{
			_connected = false;
			super.close();
		}
		
		public function get sending():Boolean { return _sending; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function defaultFaultCallBack(value:Object):void
		{
			_synchronizer.acknowledge(_currentID);
			_sending = false;
			if (_faultCallBack !== null) _faultCallBack(value);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function defaultResultCallBack(value:Object):void
		{
			_synchronizer.acknowledge(_currentID);
			_sending = false;
			if (_resultCallBack !== null) _resultCallBack(value);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function methodForName(name:String):ServiceMethod
		{
			for each(var method:ServiceMethod in _methods)
			{
				if (method.fullName == name) return method;
			}
			return null;
		}
		
		protected function netStatusHandler(event:NetStatusEvent):void 
		{
			trace("netStatusHandler", event.info.level, event.info.code);
			switch (event.info.level)
			{
				case "status":
					switch(event.info.code)
					{
						case "NetConnection.Connect.Success":
							if (_deferredOperation)
							{
								super.call.apply(this, _deferredOperation);
								_deferredOperation = null;
							}
							break;
					}
					break;
				case "error":
				case "warning":
					_faultCallBack(event.info);
					break;
			}
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			_faultCallBack("security error");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		net_internal function internalSend(id:int):void
		{
			_sending = true;
			_currentID = id;
			var operation:Operation = _operations[id];
			_deferredOperation = [operation.method.name + "." + 
				operation.method.operation, _responder];
			if (operation.parameters.parameters && 
				operation.parameters.parameters.length)
			{
				_deferredOperation = 
					_deferredOperation.concat(operation.parameters.parameters);
			}
			if (!_baseURL) _baseURL = _synchronizer.defaultGetaway;
			if (!_baseURL) 
			{
				defaultFaultCallBack("must specify baseURL");
				return;
			}
			if (!_connected)
			{
				super.connect(_baseURL);
				_connected = true;
			}
			super.call.apply(this, _deferredOperation);
			_deferredOperation = null;
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