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
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import org.wvxvws.gui.containers.Menu;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.utils.KeyUtils;
	//}
	
	[Event(name="opened", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	* MenuRenderer class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class MenuRenderer extends Renderer implements IMenuRenderer, ILayoutClient
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get desiredWidth():int
		{
			var ret:int = 50 + super._field.width + 2;
			if (this._hkField) ret += this._hkField.width + 2;
			return ret;
		}
		
		public override function set width(value:Number):void 
		{
			if (super._width === (value >> 0)) return;
			super._width = value;
			this.invalidate("_width", _width, false);
		}
		
		public override function set height(value:Number):void 
		{
			if (super._height === (value >> 0)) return;
			super._height = value;
			this.invalidate("_height", _height, false);
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IMenuRenderer */
		
		public function set iconProducer(value:ISkin):void
		{
			if (this._iconProducer === value) return;
			this._iconProducer = value;
			this.invalidate("_iconProducer", _iconProducer, false);
		}
		
		public function set hotKeys(value:Vector.<int>):void
		{
			if (this._hotKeys === value) return;
			this._hotKeys = value;
			this.invalidate("_hotKeys", _hotKeys, false);
		}
		
		public function get kind():String { return this._kind; }
		
		public function set kind(value:String):void
		{
			if (this._kind === value || (value !== Menu.CHECK && 
				value !== Menu.CONTAINER && value !== Menu.NONE && 
				value !== Menu.RADIO && value !== Menu.SEPARATOR)) return;
			this._kind = value;
			this.invalidate("_data", _data, false);
		}
		
		public function set clickHandler(value:Function):void
		{
			if (this._clickHandler === value) return;
			this._clickHandler = value;
		}
		
		public function get enabled():Boolean { return this._enabled; }
		
		public function set enabled(value:Boolean):void
		{
			if (_enabled === value) return;
			_enabled = value;
			this.invalidate("_enabled", _enabled, false);
		}
		
		public override function get data():Object { return this._data; }
		
		public override function set data(value:Object):void
		{
			this._hasChildNodes = false;
			if (value) this._hasChildNodes = value.hasComplexContent();
			if (this._hasChildNodes) this._kind = Menu.CONTAINER;
			if (isValid && super._data === value) return;
			super._data = value;
			if (!super._data) return;
			this.invalidate("_data", _data, false);
		}
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return this._validator; }
		
		public function get invalidProperties():Object
		{
			return this._invalidProperties;
		}
		
		public function get layoutParent():ILayoutClient { return this._layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void
		{
			this._layoutParent = value;
			if (value) this._validator = this._layoutParent.validator;
			else this._validator = null;
			this._validator.append(this, this._layoutParent);
		}
		
		public function get childLayouts():Vector.<ILayoutClient> { return null; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _icon:DisplayObject;
		protected var _hkField:TextField;
		protected var _enabled:Boolean;
		protected var _clickHandler:Function;
		protected var _kind:String;
		protected var _hotKeys:Vector.<int>;
		protected var _iconProducer:ISkin;
		protected var _arrow:Sprite;
		protected var _hasChildNodes:Boolean;
		protected var _disabledFormat:TextFormat = 
							new TextFormat("_sans", 11, 0xC0C0C0);
		protected var _fieldScrollRect:Rectangle = new Rectangle();
		protected var _selection:Sprite;
		protected var _selectionColor:uint = 0xFF;
		protected var _validator:LayoutValidator;
		protected var _layoutParent:ILayoutClient;
		protected var _invalidProperties:Dictionary = new Dictionary();
		protected var _invalidLayout:Boolean;
		protected var _height:int;
		
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
		
		public function MenuRenderer()
		{
			super();
			super.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
			super.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
			super.addEventListener(MouseEvent.CLICK, this.mclickHandler);
			super.mouseChildren = false;
			super.tabChildren = false;
			super._backgroundAlpha = 0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function validate(properties:Dictionary):void
		{
			this.renderText();
			this._invalidLayout = false;
			this._invalidProperties = new Dictionary();
		}
		
		public function invalidate(invalides:Invalides, validateParent:Boolean):void
		{
			this._invalidProperties[invalides] = true;
			if (!this._validator)
			{
				if (super.parent && super.parent is ILayoutClient)
				{
					this._layoutParent = super.parent as ILayoutClient;
					this._validator = this._layoutParent.validator;
					this._validator.append(this, this._layoutParent);
				}
			}
			if (this._validator)
				this._validator.requestValidation(this, validateParent);
			this._invalidLayout = true;
		}
		
		public function drawSelection(isSelected:Boolean):void
		{
			if (isSelected)
			{
				if (!this._selection)
				{
					this._selection = new Sprite();
					this._selection.mouseEnabled = false;
				}
				this._selection.graphics.clear();
				this._selection.graphics.beginFill(this._selectionColor, 0.5);
				this._selection.graphics.drawRect(0, 0, super._width, super.height);
				this._selection.graphics.drawRect(
					1, 1, super._width - 2, super.height - 2);
				if (this._enabled) 
				{
					this._selection.graphics.beginFill(this._selectionColor, 0.2);
					this._selection.graphics.drawRect(
						1, 1, super._width - 2, super.height - 2);
				}
				this._selection.graphics.endFill();
				super.addChild(this._selection);
				super.dispatchEvent(new GUIEvent(GUIEvent.OPENED.type, true, true));
			}
			else
			{
				if (this._selection && super.contains(this._selection))
				{
					super.removeChild(this._selection);
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function renderText():void 
		{
			var g:Graphics = super.graphics;
			if (this._kind === Menu.SEPARATOR)
			{
				g.clear();
				g.beginFill(0xC0C0C0, 1);
				g.drawRect(30, 2, _width - 30, 1);
				g.endFill();
				if (this._icon && super.contains(this._icon))
					super.removeChild(this._icon);
				if (super._field && super.contains(super._field))
					super.removeChild(super._field);
				if (this._hkField && super.contains(this._hkField))
					super.removeChild(this._hkField);
				return;
			}
			super._field.x = 30;
			super._field.y = Math.max((super._height - super._field.height) >> 1, 0);
			if (super._labelSkin) 
				super._field.text = super._labelSkin.produce(super._data) as String;
			else super._field.text = super._data.toString();
			
			this.renderIcon();
			this.renderHotKeys();
			this.renderArrow();
			
			if (this._enabled)
			{
				super._field.setTextFormat(super._textFormat);
				if (this._hkField) this._hkField.setTextFormat(super._textFormat);
				if (this._arrow) this._arrow.alpha = 1;
			}
			else
			{
				super._field.setTextFormat(this._disabledFormat);
				if (this._hkField) this._hkField.setTextFormat(this._disabledFormat);
				if (this._arrow) this._arrow.alpha = 0.2;
			}
			this.drawBackground();
		}
		
		protected function renderIcon():void
		{
			if (this._icon && super.contains(this._icon))
				super.removeChild(this._icon);
			if (this._iconProducer)
			{
				this._icon = this._iconProducer.produce(this) as DisplayObject;
				this._icon.x = 2;
				this._icon.y = 2;
				super.addChild(this._icon);
			}
		}
		
		protected function renderHotKeys():void
		{
			var hkStr:String = "";
			var i:int;
			if (!this._hkField && this._hotKeys && this._hotKeys.length)
			{
				this._hkField = new TextField();
				this._hkField.selectable = false;
				this._hkField.defaultTextFormat = super._textFormat;
				this._hkField.height = 1;
				this._hkField.width = 1;
				this._hkField.autoSize = TextFieldAutoSize.LEFT;
				super.addChild(_hkField);
			}
			if (this._hotKeys && this._hotKeys.length)
			{
				while (i < this._hotKeys.length)
				{
					hkStr += (hkStr ? "+" : "") + 
						KeyUtils.keyToString(this._hotKeys[i]);
					i++;
				}
				this._hkField.text = hkStr;
				this._hkField.x = Math.max(super._field.width, 
					super._width - (20 + this._hkField.width));
				this._hkField.y = 
					Math.max((super._height - super._hkField.height) >> 1, 0);
			}
		}
		
		protected function renderArrow():void
		{
			if (this._hasChildNodes && !this._arrow)
			{
				this._arrow = new Sprite();
				this._arrow.graphics.beginFill(0, 1);
				this._arrow.graphics.lineTo(5, 4);
				this._arrow.graphics.lineTo(0, 9);
				this._arrow.graphics.lineTo(0, 0);
				this._arrow.graphics.endFill();
				super.addChild(this._arrow);
			}
			else if (!this._hasChildNodes && this._arrow && 
				super.contains(this._arrow))
				super.removeChild(this._arrow);
			if (this._arrow && super.contains(this._arrow))
			{
				this._arrow.x = super._width - (this._arrow.width + 4);
				this._arrow.y = (super._height - this._arrow.height) >> 1;
			}
		}
		
		protected override function drawBackground():void 
		{
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(super._backgroundColor, super._backgroundAlpha);
			g.drawRect(0, 0, super._width, super._height);
			g.endFill();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function mclickHandler(event:Event = null):void 
		{
			if (this._clickHandler !== null) this._clickHandler(super._data);
		}
		
		private function mouseOverHandler(event:MouseEvent):void 
		{
			if (this._kind !== Menu.SEPARATOR) this.drawSelection(true);
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			if (this._kind !== Menu.SEPARATOR) this.drawSelection(false);
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IMenuRenderer */
		
		public function get clickHandler():Function { return this._clickHandler; }
		
		public function set desiredWidth(value:int):void
		{
			// TODO: do we need this?
		}
	}
}