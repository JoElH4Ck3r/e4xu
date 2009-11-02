package org.wvxvws.jsutils.key 
{
	import flash.display.Loader;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	
	/**
	 * JSKeyHandler class.
	 * @author wvxvw
	 */
	public class JSKeyHandler
	{
		private static var _init:Boolean;
		private static var _ourURL:String = new Loader().contentLoaderInfo.loaderURL;
		private static var _ourID:String;
		private static var _ourShortURL:String;
		private static var _upHandlers:Vector.<Function> = new <Function>[];
		private static var _downHandlers:Vector.<Function> = new <Function>[];
		
		public function JSKeyHandler() { super(); }
		
		public static function init():void
		{
			if (!ExternalInterface.available) return;
			_ourID = whois();
			var script:String = 
<![CDATA[function(){document.kp=function(e){
	var fl=document.getElementById("]]> + _ourID + <![CDATA[");
	fl.keyevt({t:e.type, k:e.keyCode});
	e.preventDefault();
	e.stopPropagation();
	return false;}
document.ku=function(){
	var e=window.event;
	e.cancelBubble=true;
	e.returnValue=false;
	if(e.stop !== undefined)e.stop();
	var fl=document.getElementById("]]> + _ourID + <![CDATA[");
	fl.keyevt({t:e.type, k:e.keyCode});
	return false;}
if(document.addEventListener !== undefined){
	document.addEventListener("keydown", document.kp, true);
	document.addEventListener("keyup", document.kp, true);}
else{window.onkeyup=document.ku;
	window.onkeypress=document.ku;
	window.onkeydown=document.ku;
	document.onkeyup=document.ku;
	document.onkeypress=document.ku;
	document.onkeydown=document.ku;}}]]>;
			ExternalInterface.addCallback("keyevt", keyevt);
			ExternalInterface.call(script);
		}
		
		private static function whois():String
		{
			if (!ExternalInterface.available) null;
			_ourShortURL = _ourURL.match(/(?<=\/)[^\/]+\.swf$/g)[0];
			var getId:String = 
<![CDATA[function(){
	var o=document.getElementsByTagName("object");
	for(var p in o){if(o[p].data == "]]> + 
	_ourURL + 
<![CDATA[" || o[p].Movie == "]]> + _ourShortURL +
<![CDATA[")	return o[p].id;}}]]>;
			return ExternalInterface.call(getId);
		}
		
		public static function keyevt(event:Object):void
		{
			trace("keyevt", event.type);
		}
		
		public static function addHandler(type:String, handler:Function):void
		{
			if (type === KeyboardEvent.KEY_DOWN)
			{
				if (_downHandlers.indexOf(handler) < 0)
				_downHandlers.push(handler);
			}
			else if (type === KeyboardEvent.KEY_UP)
			{
				if (_upHandlers.indexOf(handler) < 0)
				_downHandlers.push(handler);
			}
		}
		
		public static function removeHandler(type:String, handler:Function):void
		{
			var index:int;
			if (type === KeyboardEvent.KEY_DOWN)
			{
				index = _downHandlers.indexOf(handler);
				if (index > -1)_downHandlers.splice(index, 1);
			}
			else if (type === KeyboardEvent.KEY_UP)
			{
				index = _upHandlers.indexOf(handler);
				if (index > -1)_upHandlers.splice(index, 1);
			}
		}
	}

}