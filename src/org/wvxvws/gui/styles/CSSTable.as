package org.wvxvws.gui.styles 
{
	//{imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	//}
	
	/**
	* CSSTable class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public dynamic class CSSTable extends Dictionary implements IEventDispatcher
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
		
		private var _dispatcher:EventDispatcher;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function CSSTable(weakKeys:Boolean = true) 
		{
			super(weakKeys);
			_dispatcher = new EventDispatcher(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function addClass(className:String, classBody:Object):IEventDispatcher
		{
			var newClass:CSSProxy = getClass(className) as CSSProxy;
			if (!newClass)
			{
				newClass = new CSSProxy(className);
				this[newClass] = className;
			}
			for (var p:String in classBody)
			{
				newClass[p] = classBody[p];
			}
			return newClass;
		}
		
		public function getClass(className:String):IEventDispatcher
		{
			for (var o:Object in this)
			{
				if (this[o] == className) return o as IEventDispatcher;
			}
			return null;
		}
		
		/* INTERFACE flash.events.IEventDispatcher */
		//{ flash.events.IEventDispatcher
		public function addEventListener(type:String, listener:Function, 
			useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, 
										useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, 
											useCapture:Boolean = false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		//}
		
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
import flash.events.EventDispatcher;

internal final dynamic class CSSProxy extends EventDispatcher
{
	private var _className:String;
	public function get className():String { return _className; }
	
	public function CSSProxy(className:String)
	{
		super();
		_className = className;
	}
}