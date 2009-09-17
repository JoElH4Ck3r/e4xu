package org.wvxvws.lcbridge 
{
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	
	//{imports
	
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
		private var _id:String = (new Date().time * Math.random()).toString(36);
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
		
		public function as3receive(...rest):*
		{
			return rest.join("\r") + "Ho!";
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
					return flash.as2receive.apply(flash, arguments);
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
		
		public function as3send(command:String):*
		{
			if (!_available) return undefined;
			var script:String =
			<![CDATA[function(){
				var objects = document.getElementsByTagName("object");
				var o = document.getElementById("]]> + _id +
			<![CDATA[");
				return o.as2send("]]> + command +
			<![CDATA[");}]]>;
			return ExternalInterface.call(script);
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