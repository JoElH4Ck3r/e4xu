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
	private var _theStyle:Object = { };
	private var _client:ICSSClient;
	private var _table:Dictionary;
	
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
		if (_theStyle.hasOwnProperty(name) && _theStyle[name] == value)
		{
			return;
		}
		_theStyle[name] = value;
		dispatchEvent(new Event(name + "Change"));
	}
	
	flash_proxy override function getProperty(name:*):*
	{
		return _theStyle[name];
	}
	
	flash_proxy override function deleteProperty(name:*):Boolean
	{
		return delete _theStyle[name];
	}
	
	flash_proxy override function callProperty(name:*, ...rest):*
	{
		trace("callProperty", name);
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
		for (var p:String in _theStyle)
		{
			temp += (b ? ";" : "") + p + ":" + _theStyle[p];
			b = true;
		}
		return temp + "}";
	}
}