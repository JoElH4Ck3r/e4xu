package org.wvxvws.gui 
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import mx.core.IMXMLObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	//}
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="open", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * IMG class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 9.0.155
	 */
	public class IMG extends Bitmap implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property src
		//------------------------------------
		
		[Bindable("srcChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>srcChanged</code> event.
		*/
		public function get src():String { return _src; }
		
		public function set src(value:String):void 
		{
			if (_src === value) return;
			_src = value;
			if (!_loader) this.initLoader();
			var context:LoaderContext = 
				new LoaderContext(true, ApplicationDomain.currentDomain);
			_loader.load(new URLRequest(_src), context);
			super.dispatchEvent(new Event("srcChanged"));
		}
		
		//------------------------------------
		//  Public property embed
		//------------------------------------
		
		[Bindable("embedChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>embedChanged</code> event.
		*/
		public function get embed():Class { return _embed; }
		
		public function set embed(value:Class):void 
		{
			if (_embed === value) return;
			_embed = value;
			var bd:Bitmap = new value() as Bitmap;
			this.bitmapData = bd.bitmapData.clone();
			bd.bitmapData.dispose();
			super.dispatchEvent(new Event("embedChanged"));
		}
		
		public function get id():String { return _id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _src:String;
		protected var _embed:Class;
		protected var _id:String;
		protected var _loader:Loader;
		
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
		public function IMG(bitmapData:BitmapData = null, 
						pixelSnapping:String = "auto", smoothing:Boolean = false) 
		{
			super(bitmapData, pixelSnapping, smoothing);
			
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			if (document is DisplayObjectContainer)
			{
				(document as DisplayObjectContainer).addChild(this);
			}
			_id = id;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function initLoader():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(
							Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(
							ProgressEvent.PROGRESS, loaderEventsHandler);
			_loader.contentLoaderInfo.addEventListener(
							Event.OPEN, loaderEventsHandler);
			_loader.contentLoaderInfo.addEventListener(
							IOErrorEvent.IO_ERROR, loaderEventsHandler);
			_loader.contentLoaderInfo.addEventListener(
							SecurityErrorEvent.SECURITY_ERROR, loaderEventsHandler);
		}
		
		protected function completeHandler(event:Event):void 
		{
			var d:DisplayObject = _loader.content;
			var bd:BitmapData;
			if (d is Bitmap)
			{
				super.bitmapData = (d as Bitmap).bitmapData.clone();
				_loader.unload();
			}
			else
			{
				bd = new BitmapData(_loader.loaderInfo.width, 
									_loader.loaderInfo.height, true, 0x00FFFFFF);
				bd.draw(_loader);
				super.bitmapData = bd;
			}
			super.dispatchEvent(event);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function loaderEventsHandler(event:Event):void 
		{
			super.dispatchEvent(event);
		}
		
	}
	
}