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

package org.wvxvws.gui.windows
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.skins.SkinProducer;
	//}
	
	/**
	 * ChromeBar class.
	 * @author wvxvw
	 */
	public class ChromeBar extends DIV
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property label
		//------------------------------------
		
		[Bindable("labelChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelChanged</code> event.
		*/
		public function get label():String { return _label; }
		
		public function set label(value:String):void 
		{
			if (_label === value) return;
			_label = value;
			super.invalidate("_label", _label, false);
			super.dispatchEvent(new Event("labelChanged"));
		}
		
		//------------------------------------
		//  Public property iconProducer
		//------------------------------------
		
		[Bindable("iconProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>iconProducerChanged</code> event.
		*/
		public function get iconProducer():SkinProducer { return _iconProducer; }
		
		public function set iconProducer(value:SkinProducer):void 
		{
			if (_iconProducer === value) return;
			_iconProducer = value;
			super.invalidate("_iconProducer", _iconProducer, false);
			super.dispatchEvent(new Event("iconProducerChanged"));
		}
		
		//------------------------------------
		//  Public property labelPadding
		//------------------------------------
		
		[Bindable("labelPaddingChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelPaddingChanged</code> event.
		*/
		public function get labelPadding():int { return _labelPadding; }
		
		public function set labelPadding(value:int):void 
		{
			if (_labelPadding === value) return;
			_labelPadding = value;
			super.invalidate("_labelPadding", _labelPadding, false);
			super.dispatchEvent(new Event("labelPaddingChanged"));
		}
		
		//------------------------------------
		//  Public property iconDownHandler
		//------------------------------------
		
		[Bindable("iconDownHandlerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>iconDownHandlerChanged</code> event.
		*/
		public function get iconDownHandler():Function { return _iconDownHandler; }
		
		public function set iconDownHandler(value:Function):void 
		{
			if (_iconDownHandler === value) return;
			_iconDownHandler = value;
			super.dispatchEvent(new Event("iconDownHandlerChanged"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _label:String;
		protected var _labelTXT:TextField;
		protected var _iconProducer:SkinProducer;
		protected var _icon:DisplayObject;
		protected var _labelFormat:TextFormat = new TextFormat("_sans", 11, 0, true);
		protected var _labelPadding:int = 4;
		protected var _iconDownHandler:Function;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ChromeBar() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Object):void 
		{
			var iconClassChanged:Boolean = ("_iconProducer" in properties);
			var labelChanged:Boolean = ("_label" in properties) || 
										iconClassChanged || 
										("_labelPadding" in properties) ||
										("_iconFactory" in properties) || 
										("_bounds" in properties);
			super.validate(properties);
			if (iconClassChanged)
			{
				_icon = _iconProducer.produce(this);
				this.drawIcon();
			}
			if (labelChanged) this.drawLabel();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function drawLabel():void
		{
			if (_label !== null && _label !== "")
			{
				if (!_labelTXT)
				{
					_labelTXT = new TextField();
					_labelTXT.selectable = false;
					_labelTXT.defaultTextFormat = _labelFormat;
					_labelTXT.autoSize = TextFieldAutoSize.LEFT;
					_labelTXT.width = 1;
					_labelTXT.height = 1;
					_labelTXT.mouseEnabled = false;
					_labelTXT.tabEnabled = false;
				}
				_labelTXT.text = _label;
				if (_icon)
				{
					_labelTXT.scrollRect = new Rectangle(0, 0, 
						super.width - (_icon.width + _labelPadding + _icon.x), 
						_labelTXT.height);
					_labelTXT.x = _icon.x + _icon.width + 2;
				}
				else
				{
					_labelTXT.scrollRect = 
						new Rectangle(2, 0, super.width - _labelPadding, 
						_labelTXT.height);
					_labelTXT.x = 2;
				}
				_labelTXT.y = (super.height - _labelTXT.height) >> 1;
				if (!super.contains(_labelTXT)) super.addChild(_labelTXT);
			}
			else if (_labelTXT)
			{
				if (super.contains(_labelTXT)) super.removeChild(_labelTXT);
				_labelTXT = null;
			}
		}
		
		protected function drawIcon():void
		{
			if (_icon is InteractiveObject)
			{
				(_icon as InteractiveObject).addEventListener(
						MouseEvent.MOUSE_DOWN, icon_downHandler);
			}
			else
			{
				super.addEventListener(MouseEvent.MOUSE_DOWN, icon_downHandler);
			}
			if (_icon is DisplayObjectContainer)
			{
				(_icon as DisplayObjectContainer).mouseChildren = false;
				(_icon as DisplayObjectContainer).tabChildren = false;
			}
			_icon.x = 2;
			_icon.y = (super.height - _icon.height) >> 1;
			super.addChild(_icon);
		}
		
		protected function icon_downHandler(event:MouseEvent):void 
		{
			var t:InteractiveObject = event.currentTarget as InteractiveObject;
			if (t && t === _icon)
			{
				if (_iconDownHandler !== null)
					_iconDownHandler(event);
			}
			else if (t === this)
			{
				if (_icon && _iconDownHandler !== null &&
					_icon.hitTestPoint(_icon.mouseX, _icon.mouseY))
				{
					_iconDownHandler(event);
				}
			}
		}
	}
	
}