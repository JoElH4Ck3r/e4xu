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

package org.wvxvws.gui.renderers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	/**
	* ImageRenderer class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class ImageRenderer extends Sprite implements IRenderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void 
		{
			if (isValid && _data === value) return;
			_data = value;
			var lastSRC:String = _src;
			_src = _data.@src;
			if (!_src) throw new Error("Must define @src attribute");
			if (_image.content && lastSRC != _src) _image.unload();
			else _image.load(new URLRequest(_src));
		}
		
		/**
		 * Returns <code>false</code> if the data is out of sync with the source.
		 * Otherwise returns <code>true</code>
		 */
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _src == _data.@src;
		}
		
		public function set labelFunction(value:Function):void
		{
			// TODO:
		}
		
		public function set labelField(value:String):String
		{
			// TODO:
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _image:Loader = new Loader();
		protected var _imageBitmap:Bitmap;
		protected var _imageData:BitmapData;
		protected var _data:XML;
		protected var _src:String;
		protected var _document:Object;
		protected var _id:String;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function ImageRenderer() 
		{
			super();
			graphics.beginFill(0xFFFFFF, 0);
			graphics.drawRect(0, 0, 100, 100);
			graphics.endFill();
			_image.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_image.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 
																	ioErrorHandler);
			_image.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
																securityErrorHandler);
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			trace(event);
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void 
		{
			trace(event);
		}
		
		protected function completeHandler(event:Event):void 
		{
			if (_imageData) _imageData.dispose();
			_image.width = width;
			_image.height = height;
			_image.scaleX = Math.min(_image.scaleX, _image.scaleY);
			_image.scaleY = _image.scaleX;
			_imageData = new BitmapData(_image.width, 
											_image.height, true, 0x00FFFFFF);
			trace(_image.content.scaleX, _image.content.scaleY); // 1, 1
			trace(scaleX, scaleY); // 1, 1
			_imageData.draw(_image.content, _image.transform.matrix, 
														null, null, null, true);
			_imageBitmap = new Bitmap(_imageData, "always", true);
			_imageBitmap.x = (width - _imageBitmap.width) >> 1;
			_imageBitmap.y = (height - _imageBitmap.height) >> 1;
			addChild(_imageBitmap);
		}
		
		/* INTERFACE org.wvxvws.gui.IRenderer */
		/**
		 * Necessary implementation of IMXMLObject. Otherwise we cannot live in the 
		 * MXML file.
		 * @param	document	The object which called this methid.
		 * @param	id			The ID either assigned through MXML or autogenerated.
		 */
		public function initialized(document:Object, id:String):void
		{
			_document = document;
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
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}