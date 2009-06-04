package com.ayumilove.assets 
{
	//{imports
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	//}
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	* SpriteSheetLoader class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class SpriteSheetLoader extends Loader
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Dissalow direct linking to the loader's content to avoid GC issues later.
		 */
		override public function get content():DisplayObject { return null; }
		
		public function get bitmapData():BitmapData { return _bitmapData; }
		
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
		
		private static const NOTIFY:String = "notify";
		
		private static var _queves:Array /* of Queve */ = [];
		private static var _sharedDispatcher:EventDispatcher = new EventDispatcher();
		private static var _isIdle:Boolean = true;
		
		private var _bitmapData:BitmapData;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SpriteSheetLoader()
		{
			super();
			super.contentLoaderInfo.addEventListener(Event.COMPLETE, 
									internalCompleteHandler, false, int.MAX_VALUE);
			super.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 
									internalIOErrorHandler, false, int.MAX_VALUE);
			super.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
									internalSecurityHandler, false, int.MAX_VALUE);
			_sharedDispatcher.addEventListener(NOTIFY, notifyHandler, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function load(request:URLRequest, context:LoaderContext = null):void 
		{
			var willLoadNow:Boolean;
			if (!_queves.length) willLoadNow = true;
			_queves.push(new Queve(request, this));
			if (willLoadNow) loadNow(request);
		}
		
		private function loadNow(request:URLRequest):void
		{
			if (super.content) super.unload();
			_isIdle = false;
			super.load(request);
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
		
		private function notifyHandler(event:Event):void 
		{
			if (!_queves.length) return;
			if ((_queves[0] as Queve).loader === this)
			{
				loadNow((_queves[0] as Queve).request);
			}
		}
		
		private function internalSecurityHandler(event:SecurityErrorEvent):void
		{
			var queve:Queve;
			for (var i:int; i < _queves.length; i++)
			{
				queve = _queves[i];
				if (queve.loader === this)
				{
					_queves.splice(i, 1);
					dispatchEvent(event);
					_sharedDispatcher.dispatchEvent(new Event(NOTIFY));
					while (_isIdle && _queves.length)
					{
						_queves.shift();
						_sharedDispatcher.dispatchEvent(new Event(NOTIFY));
					}
					break;
				}
			}
		}
		
		private function internalIOErrorHandler(event:IOErrorEvent):void
		{
			var queve:Queve;
			for (var i:int; i < _queves.length; i++)
			{
				queve = _queves[i];
				if (queve.loader === this)
				{
					_queves.splice(i, 1);
					dispatchEvent(event);
					_sharedDispatcher.dispatchEvent(new Event(NOTIFY));
					while (_isIdle && _queves.length)
					{
						_queves.shift();
						_sharedDispatcher.dispatchEvent(new Event(NOTIFY));
					}
					break;
				}
			}
		}
		
		private function internalCompleteHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			var queve:Queve;
			for (var i:int; i < _queves.length; i++)
			{
				queve = _queves[i];
				if (queve.loader === this)
				{
					_queves.splice(i, 1);
					_bitmapData = new BitmapData(super.content.width, super.content.height);
					_bitmapData.draw(super.content);
					dispatchEvent(new Event(Event.COMPLETE));
					_sharedDispatcher.dispatchEvent(new Event(NOTIFY));
					// if we deleted the loader that haven't loaded yet
					// dispatch this event unril there are pending downloads.
					while (_isIdle && _queves.length)
					{
						_queves.shift();
						_sharedDispatcher.dispatchEvent(new Event(NOTIFY));
					}
					break;
				}
			}
		}
	}
	
}

import flash.net.URLRequest;
import com.ayumilove.assets.SpriteSheetLoader;

internal final class Queve
{
	public var request:URLRequest;
	public var loader:SpriteSheetLoader;
	
	public function Queve(request:URLRequest, loader:SpriteSheetLoader)
	{
		super();
		this.request = request;
		this.loader = loader;
	}
}