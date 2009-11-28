package org.wvxvws.lcbridge 
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AVM1EILoader extends Loader
	{
		protected var _bridge:EIBridge;
		protected var _request:URLRequest;
		protected var _context:LoaderContext;
		protected var _hasAVM1Content:Boolean;
		
		public function AVM1EILoader(request:URLRequest = null, context:LoaderContext = null) 
		{
			super();
			_request = request;
			_context = context;
			if (_request) load(_request, _context);
		}
		
		public override function load(request:URLRequest, context:LoaderContext = null):void 
		{
			_request = request;
			_context = context;
			_hasAVM1Content = false;
			if (!_bridge)
			{
				_bridge = new EIBridge();
				_bridge.addEventListener(AVM1Event.LC_LOADED, bridgeEventHandler);
			}
			super.load(request, context);
		}
	}

}