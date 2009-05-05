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
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import mx.core.IMXMLObject;
	import org.wvxvws.net.net_internal;
	//}
	
	[DefaultProperty("parameters")]
	
	/**
	* XMLService class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class TXTService extends URLLoader implements IService
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
		   if (_resultCallBack == value) return;
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
		   if (_faultCallBack == value) return;
		   _faultCallBack = value;
		   dispatchEvent(new Event("faultCallBackChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _baseURL:String = "";
		protected var _methods:Array /** of ServiceMethod */ = [];
		protected var _parameters:ServiceArguments;
		protected var _resultCallBack:Function;
		protected var _faultCallBack:Function;
		protected var _sending:Boolean;
		protected var _synchronizer:Synchronizer;
		protected var _operations:Object = { };
		protected var _currentID:int;
		
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
		
		public function TXTService(resultCallBack:Function = null, 
									faultCallBack:Function = null)
		{
			super();
			_resultCallBack = resultCallBack;
			_faultCallBack = faultCallBack;
			dataFormat = URLLoaderDataFormat.TEXT;
			_synchronizer = Synchronizer.getInstance();
			addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
												securityErrorHandler, false, 0, true);
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function load(request:URLRequest):void 
		{
			//super.load(request);
		}
		
		/* INTERFACE org.wvxvws.net.IService */
		
		public function send(method:String = null, parameters:ServiceArguments = null):void
		{
			var id:int = _synchronizer.putOnQueve(this, method);
			if (!parameters) parameters = _parameters;
			var operation:Operation = new Operation(id, methodForName(method), parameters);
			_operations[id] = operation;
		}
		
		public function cancel(method:String = null):void
		{
			
		}
		
		public function get sending():Boolean { return _sending; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function defaultFaultCallBack(value:Object):void { };
		protected function defaultResultCallBack(value:Object):void { };
		
		protected function methodForName(name:String):ServiceMethod
		{
			for each(var method:ServiceMethod in _methods)
			{
				if (method.id == name) return method;
			}
			return null;
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			_faultCallBack();
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void 
		{
			_faultCallBack();
		}
		
		protected function completeHandler(event:Event):void 
		{
			_synchronizer.acknowledge(_currentID);
			_resultCallBack();
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
			var postData:String = "";
			if (operation.method) postData += operation.method.id;
			if (operation.parameters)
			{
				postData += (postData ? "=\"" : "") + 
					(operation.parameters ? 
					operation.parameters.toArgumentString() : "") + 
					(postData ? "\"" : "");
			}
			var request:URLRequest = new URLRequest(_baseURL + (postData ? "?" + postData : ""));
			request.method = URLRequestMethod.GET;
			super.load(request);
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