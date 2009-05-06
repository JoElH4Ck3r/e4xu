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
				newClass = new CSSProxy(className, this);
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
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;
import org.wvxvws.gui.styles.ICSSClass;
import org.wvxvws.gui.styles.ICSSClient;

internal final dynamic class CSSProxy extends Proxy implements ICSSClass
{
	private var _className:String;
	private var _dispatcher:EventDispatcher;
	private var _theStyle:Array = [];
	private var _client:ICSSClient;
	private var _table:Dictionary;
	private var _props:Dictionary = new Dictionary(true);
	
	public function CSSProxy(className:String, table:Dictionary)
	{
		super();
		_className = className;
		_table = table;
		_dispatcher = new EventDispatcher(this);
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
	
	flash_proxy override function setProperty(name:*, value:*):void
	{
		var index:int = _theStyle.indexOf(String(name));
		var prop:*;
		var nextIndex:int;
		for (var o:Object in _props)
		{
			if (_props[o] == index) prop = o;
			nextIndex++;
		}
		if (index > -1 && prop == value) return;
		_theStyle[nextIndex] = name;
		_props[value] = nextIndex;
		dispatchEvent(new Event(name + "Change"));
	}
	
	flash_proxy override function getProperty(name:*):*
	{
		var index:int = _theStyle.indexOf(String(name));
		var prop:*;
		for (var o:Object in _props)
		{
			if (_props[o] == index)
			{
				prop = o;
				break;
			}
		}
		return prop;
	}
	
	flash_proxy override function deleteProperty(name:*):Boolean
	{
		var index:int = _theStyle.indexOf(String(name));
		if (index < 0) return false;
		var prop:*;
		for (var o:Object in _props)
		{
			if (_props[o] == index) prop = o;
			break;
		}
		_theStyle.splice(index, 1);
		return delete _props[prop];
	}
	
	flash_proxy override function callProperty(name:*, ...rest):*
	{
		trace("callProperty", name);
	}
	
	flash_proxy override function nextName(index:int):String { return _theStyle[index - 1]; }
	
	flash_proxy override function nextNameIndex(index:int):int 
	{
		if (_theStyle.length > index) return index + 1;
		return 0;
	}
	
	override flash_proxy function nextValue(index:int):*
	{
		for (var o:Object in _props)
		{
			if (_props[o] == index) return o;
		}
		return undefined;
	}
	
	/* INTERFACE org.wvxvws.gui.styles.ICSSClass */
	
	public function get className():String { return _className; }
	
	public function get client():ICSSClient { return _client; }
	
	public function set client(value:ICSSClient):void { _client = value; }
	
	public function get table():Dictionary { return _table; }
	
	public function set table(value:Dictionary):void { _table = value; }
	
	public function commit():void
	{
		if (!_client) return;
		for (var p:String in _theStyle)
		{
			if ((_client as Object).hasOwnProperty(p)) _client[p] = _theStyle[p];
		}
	}
	
	public function toString():String
	{
		var temp:String = _className + "{";
		var b:Boolean;
		for (var o:Object in _props)
		{
			temp += (b ? ";" : "") + _theStyle[_props[o]] + ":" + o;
			b = true;
		}
		return temp + "}";
	}
}