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
	import org.wvxvws.binding.EventGenerator;
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
		public function get src():String { return this._src; }
		
		public function set src(value:String):void 
		{
			if (this._src === value) return;
			this._src = value;
			if (!_loader) this.initLoader();
			var context:LoaderContext = 
				new LoaderContext(true, ApplicationDomain.currentDomain);
			this._loader.load(new URLRequest(this._src), context);
			if (super.hasEventListener(EventGenerator.getEventType("src")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public function get embed():Class { return this._embed; }
		
		public function set embed(value:Class):void 
		{
			if (this._embed === value) return;
			this._embed = value;
			if (value)
			{
				var bd:Bitmap = new value() as Bitmap;
				super.bitmapData = bd.bitmapData.clone();
				bd.bitmapData.dispose();
			}
			else if (super.bitmapData)
			{
				super.bitmapData.dispose();
				super.bitmapData = null;
			}
			if (super.hasEventListener(EventGenerator.getEventType("embed")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get id():String { return this._id; }
		
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
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function IMG(bitmapData:BitmapData = null, 
						pixelSnapping:String = "auto", smoothing:Boolean = false) 
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			if (document is DisplayObjectContainer)
			{
				(document as DisplayObjectContainer).addChild(this);
			}
			this._id = id;
		}
		
		public function dispose():void { }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function initLoader():void
		{
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(
							Event.COMPLETE, this.completeHandler);
			this._loader.contentLoaderInfo.addEventListener(
							ProgressEvent.PROGRESS, super.dispatchEvent);
			this._loader.contentLoaderInfo.addEventListener(
							Event.OPEN, super.dispatchEvent);
			this._loader.contentLoaderInfo.addEventListener(
							IOErrorEvent.IO_ERROR, super.dispatchEvent);
			this._loader.contentLoaderInfo.addEventListener(
							SecurityErrorEvent.SECURITY_ERROR, super.dispatchEvent);
		}
		
		protected function completeHandler(event:Event):void 
		{
			var d:DisplayObject = this._loader.content;
			var bd:BitmapData;
			if (d is Bitmap)
			{
				super.bitmapData = (d as Bitmap).bitmapData.clone();
				this._loader.unload();
			}
			else
			{
				bd = new BitmapData(this._loader.loaderInfo.width, 
								this._loader.loaderInfo.height, true, 0x00FFFFFF);
				bd.draw(this._loader);
				super.bitmapData = bd;
			}
			if (super.hasEventListener(Event.COMPLETE)) super.dispatchEvent(event);
		}
	}
}