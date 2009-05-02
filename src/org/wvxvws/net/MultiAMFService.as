package org.wvxvws.net 
{
	//{imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.wvxvws.net.ServiceArguments;
	//}
	
	/**
	* MultyAMFService class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class MultiAMFService extends AMFService
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
		
		protected var _services:Array;
		protected var _queved:Array = [];
		
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
		public function MultiAMFService(resultCallBack:Function = null, 
														faultCallBack:Function = null) 
		{
			super(resultCallBack, faultCallBack);
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function send(method:String = null, 
										parameters:ServiceArguments = null):void 
		{
			var sr:AMFService;
			if (!_services)
			{
				_services = [];
				var enpoints:Array = _synchronizer.endpointsForAlias(_baseURL);
				for each(var s:String in enpoints)
				{
					sr = new AMFService(resultCallBack, faultCallBack);
					sr.addEventListener(Event.COMPLETE, serviceCompleteHandler, false, 0, true);
					sr.initialized(this, s);
					sr.baseURL = s;
					sr.methods = _methods;
					sr.parameters = _parameters;
					_services.push(sr);
				}
			}
			var temp:Array = []
			for each (sr in _services)
			{
				sr.send(method, parameters);
				temp.push(sr);
			}
			_queved.push(temp);
		}
		
		protected function serviceCompleteHandler(event:Event):void 
		{
			var temp:Array = _queved[0];
			var current:int = temp.indexOf(event.currentTarget as AMFService);
			if (current < 0) trace("something went wrong...");
			delete temp.splice(current, 1);
			if (!temp.length)
			{
				_queved.shift();
				dispatchEvent(new Event(Event.COMPLETE));
			}
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