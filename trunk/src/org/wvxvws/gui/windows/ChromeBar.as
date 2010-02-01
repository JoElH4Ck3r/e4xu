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
	import flash.utils.Dictionary;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.skins.ISkin;
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
		public function get label():String { return this._label; }
		
		public function set label(value:String):void 
		{
			if (this._label === value) return;
			this._label = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get iconProducer():ISkin { return this._iconProducer; }
		
		public function set iconProducer(value:ISkin):void 
		{
			if (this._iconProducer === value) return;
			this._iconProducer = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get labelPadding():int { return this._labelPadding; }
		
		public function set labelPadding(value:int):void 
		{
			if (this._labelPadding === value) return;
			this._labelPadding = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get iconDownHandler():Function { return this._iconDownHandler; }
		
		public function set iconDownHandler(value:Function):void 
		{
			if (this._iconDownHandler === value) return;
			this._iconDownHandler = value;
			super.dispatchEvent(new Event("iconDownHandlerChanged"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _label:String;
		protected var _labelTXT:TextField;
		protected var _iconProducer:ISkin;
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
		
		public override function validate(properties:Dictionary):void 
		{
			var iconClassChanged:Boolean = (Invalides.SKIN in properties);
			var labelChanged:Boolean = 
				iconClassChanged || (Invalides.BOUNDS in properties);
			super.validate(properties);
			if (iconClassChanged)
			{
				if (this._iconProducer)
				{
					this._icon = this._iconProducer.produce(this) as DisplayObject;
					this.drawIcon();
				}
				else if (this._icon)
				{
					this._icon.removeEventListener(
						MouseEvent.MOUSE_DOWN, this.icon_downHandler);
					if (super.contains(this._icon))
						super.removeChild(this._icon);
					this._icon = null;
				}
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
			if (this._label !== null && this._label !== "")
			{
				if (!this._labelTXT)
				{
					this._labelTXT = new TextField();
					this._labelTXT.selectable = false;
					this._labelTXT.defaultTextFormat = this._labelFormat;
					this._labelTXT.autoSize = TextFieldAutoSize.LEFT;
					this._labelTXT.width = 1;
					this._labelTXT.height = 1;
					this._labelTXT.mouseEnabled = false;
					this._labelTXT.tabEnabled = false;
				}
				this._labelTXT.text = _label;
				if (_icon)
				{
					this._labelTXT.scrollRect = new Rectangle(0, 0, 
						super.width - (this._icon.width + 
						this._labelPadding + this._icon.x), 
						this._labelTXT.height);
					this._labelTXT.x = this._icon.x + this._icon.width + 2;
				}
				else
				{
					this._labelTXT.scrollRect = 
						new Rectangle(2, 0, super.width - this._labelPadding, 
						this._labelTXT.height);
					this._labelTXT.x = 2;
				}
				this._labelTXT.y = (super.height - this._labelTXT.height) >> 1;
				if (!super.contains(this._labelTXT)) super.addChild(this._labelTXT);
			}
			else if (this._labelTXT)
			{
				if (super.contains(this._labelTXT)) super.removeChild(this._labelTXT);
				this._labelTXT = null;
			}
		}
		
		protected function drawIcon():void
		{
			if (this._icon is InteractiveObject)
			{
				(this._icon as InteractiveObject).addEventListener(
						MouseEvent.MOUSE_DOWN, this.icon_downHandler);
			}
			else
			{
				super.addEventListener(MouseEvent.MOUSE_DOWN, this.icon_downHandler);
			}
			if (this._icon is DisplayObjectContainer)
			{
				(this._icon as DisplayObjectContainer).mouseChildren = false;
				(this._icon as DisplayObjectContainer).tabChildren = false;
			}
			this._icon.x = 2;
			this._icon.y = (super.height - this._icon.height) >> 1;
			super.addChild(this._icon);
		}
		
		protected function icon_downHandler(event:MouseEvent):void 
		{
			var t:InteractiveObject = event.currentTarget as InteractiveObject;
			if (t && t === this._icon)
			{
				if (this._iconDownHandler !== null)
					this._iconDownHandler(event);
			}
			else if (t === this)
			{
				if (this._icon && this._iconDownHandler !== null &&
					this._icon.hitTestPoint(this._icon.mouseX, this._icon.mouseY))
				{
					this._iconDownHandler(event);
				}
			}
		}
	}
}