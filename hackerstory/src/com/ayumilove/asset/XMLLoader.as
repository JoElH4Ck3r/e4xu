package com.ayumilove.asset 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	//{imports
	
	//}
	/**
	* XMLLoader class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class XMLLoader extends URLLoader
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
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _model:XML = <model/>;
		private var _loading:Boolean;
		private var _listeners:Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function XMLLoader()
		{
			super();
			addEventListener(Event.COMPLETE, privateCompleteHandler, false, int.MAX_VALUE, true);
			addEventListener(IOErrorEvent.IO_ERROR, privateErrorHandler, false, int.MAX_VALUE, true);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, privateErrorHandler, false, int.MAX_VALUE, true);
		}
		
		private function privateErrorHandler(event:Event):void 
		{
			event.stopImmediatePropagation();
			_listeners.shift();
			if (_listeners.length)
			{
				super.load(new URLRequest("./xml/" + (_listeners[0] as XMLToken).node + ".xml"));
			}
			else if((_listeners[0] as XMLToken).callback !== null)
			{
				(_listeners[0] as XMLToken).callback(null);
			}
			else
			{
				trace("We did something wrong", (_listeners[0] as XMLToken).node);
			}
		}
		
		private function privateCompleteHandler(event:Event):void 
		{
			event.stopImmediatePropagation();
			var t:XMLToken = _listeners.shift() as XMLToken;
			if (t.callback === null) return;
			var searchNodes:XMLList;
			var modelCopy:XMLList = XMLList(_model);
			var nodePath:Array = t.query.split("/");
			var currentName:String;
			do
			{
				searchNodes = modelCopy.*;
				modelCopy = searchNodes;
			}
			while (d-- > 0);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function getAsyncData(node:String, callback:Function):void
		{
			var searchNodes:XMLList;
			var modelCopy:XMLList = XMLList(_model);
			var names:Array = node.split("/");
			var nodeNum:int;
			var currentName:String;
			var path:String = "";
			var nodeName:String;
			var needLoad:Boolean;
			var query:String = "";
			var listenersLength:int = _listeners.length;
			do
			{
				currentName = names.shift();
				query += currentName;
				if (currentName.indexOf("["))
				{
					nodeNum = int(currentName.replace(/[^\[]+\[(\d+)\]/, "$1"));
					nodeName = currentName.replace(/([^\[]+)\[\d+\]/, "$1");
				}
				else
				{
					nodeName = currentName;
				}
				path += "/" + nodeName;
				searchNodes = modelCopy.children(nodeName);
				if (!searchNodes.length())
				{
					_listeners.push(new XMLToken(path, (names.length ? null : callback), query));
					needLoad = true;
					modelCopy[0].appendChild(<{nodeName}/>);
				}
				modelCopy = searchNodes;
			}
			while (names.length > 0);
			if (needLoad && !_loading)
			{
				super.load(new URLRequest("./xml/" + (_listeners[listenersLength] as XMLToken).node + ".xml"));
			}
			else if (!needLoad)
			{
				callback(searchNodes);
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

internal final class XMLToken
{
	public var node:String;
	public var query:String;
	public var callback:Function;
	
	public function XMLToken(node:String, callback:Function, query:String)
	{
		super();
		this.node = node;
		this.callback = callback;
		this.query = query;
	}
}