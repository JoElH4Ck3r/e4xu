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
	import org.wvxvws.gui.containers.Menu;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.ILayoutClient;
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
			var ret:int = 50 + _field.width + 2;
			if (_hkField) ret += _hkField.width + 2;
			return ret;
		}
		
		public override function set width(value:Number):void 
		{
			if (_width === (value >> 0)) return;
			_width = value;
			this.invalidate("_width", _width, false);
		}
		
		public override function set height(value:Number):void 
		{
			if (_height === (value >> 0)) return;
			_height = value;
			this.invalidate("_height", _height, false);
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IMenuRenderer */
		
		public function set iconProducer(value:ISkin):void
		{
			if (_iconProducer === value) return;
			_iconProducer = value;
			this.invalidate("_iconProducer", _iconProducer, false);
		}
		
		public function set hotKeys(value:Vector.<int>):void
		{
			if (_hotKeys === value) return;
			_hotKeys = value;
			this.invalidate("_hotKeys", _hotKeys, false);
		}
		
		public function get kind():String { return _kind; }
		
		public function set kind(value:String):void
		{
			if (_kind === value || (value !== Menu.CHECK && 
				value !== Menu.CONTAINER && value !== Menu.NONE && 
				value !== Menu.RADIO && value !== Menu.SEPARATOR)) return;
			_kind = value;
			this.invalidate("_data", _data, false);
		}
		
		public function set clickHandler(value:Function):void
		{
			if (_clickHandler === value) return;
			_clickHandler = value;
		}
		
		public function get enabled():Boolean { return _enabled; }
		
		public function set enabled(value:Boolean):void
		{
			if (_enabled === value) return;
			_enabled = value;
			this.invalidate("_enabled", _enabled, false);
		}
		
		public override function get data():Object { return _data; }
		
		public override function set data(value:Object):void
		{
			_hasChildNodes = false;
			if (value) _hasChildNodes = value.hasComplexContent();
			if (_hasChildNodes) _kind = Menu.CONTAINER;
			if (isValid && _data === value) return;
			_data = value;
			if (!_data) return;
			this.invalidate("_data", _data, false);
		}
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return _validator; }
		
		public function get invalidProperties():Object
		{
			return _invalidProperties;
		}
		
		public function get layoutParent():ILayoutClient { return _layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void
		{
			_layoutParent = value;
			_validator = _layoutParent.validator;
			_validator.append(this, _layoutParent);
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
		protected var _invalidProperties:Object = { };
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
		
		public function validate(properties:Object):void
		{
			this.renderText();
			_invalidLayout = false;
			_invalidProperties = { };
		}
		
		public function invalidate(property:String, 
									cleanValue:*, validateParent:Boolean):void
		{
			_invalidProperties[property] = cleanValue;
			if (!_validator)
			{
				if (super.parent && super.parent is ILayoutClient)
				{
					_layoutParent = super.parent as ILayoutClient;
					_validator = _layoutParent.validator;
					_validator.append(this, _layoutParent);
				}
			}
			if (_validator)  _validator.requestValidation(this, validateParent);
			_invalidLayout = true;
		}
		
		public function drawSelection(isSelected:Boolean):void
		{
			if (isSelected)
			{
				if (!_selection)
				{
					_selection = new Sprite();
					_selection.mouseEnabled = false;
				}
				_selection.graphics.clear();
				_selection.graphics.beginFill(_selectionColor, 0.5);
				_selection.graphics.drawRect(0, 0, _width, super.height);
				_selection.graphics.drawRect(1, 1, _width - 2, super.height - 2);
				if (_enabled) 
				{
					_selection.graphics.beginFill(_selectionColor, 0.2);
					_selection.graphics.drawRect(1, 1, _width - 2, super.height - 2);
				}
				_selection.graphics.endFill();
				super.addChild(_selection);
				super.dispatchEvent(new GUIEvent(GUIEvent.OPENED, true, true));
			}
			else
			{
				if (_selection && super.contains(_selection))
				{
					super.removeChild(_selection);
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
			if (_kind === Menu.SEPARATOR)
			{
				g.clear();
				g.beginFill(0xC0C0C0, 1);
				g.drawRect(30, 2, _width - 30, 1);
				g.endFill();
				if (_icon && super.contains(_icon)) super.removeChild(_icon);
				if (_field && super.contains(_field)) super.removeChild(_field);
				if (_hkField && super.contains(_hkField)) super.removeChild(_hkField);
				return;
			}
			_field.x = 30;
			_field.y = Math.max((_height - _field.height) >> 1, 0);
			if (_labelSkin) 
				_field.text = String(_labelSkin.produce(_data));
			else _field.text = _data.toString();
			
			this.renderIcon();
			this.renderHotKeys();
			this.renderArrow();
			
			if (_enabled)
			{
				_field.setTextFormat(_textFormat);
				if (_hkField) _hkField.setTextFormat(_textFormat);
				if (_arrow) _arrow.alpha = 1;
			}
			else
			{
				_field.setTextFormat(_disabledFormat);
				if (_hkField) _hkField.setTextFormat(_disabledFormat);
				if (_arrow) _arrow.alpha = 0.2;
			}
			this.drawBackground();
		}
		
		protected function renderIcon():void
		{
			if (_icon && super.contains(_icon)) super.removeChild(_icon);
			if (_iconProducer)
			{
				_icon = _iconProducer.produce(this) as DisplayObject;
				_icon.x = 2;
				_icon.y = 2;
				super.addChild(_icon);
			}
		}
		
		protected function renderHotKeys():void
		{
			var hkStr:String = "";
			var i:int;
			if (!_hkField && _hotKeys && _hotKeys.length)
			{
				_hkField = new TextField();
				_hkField.selectable = false;
				_hkField.defaultTextFormat = _textFormat;
				_hkField.height = 1;
				_hkField.width = 1;
				_hkField.autoSize = TextFieldAutoSize.LEFT;
				super.addChild(_hkField);
			}
			if (_hotKeys && _hotKeys.length)
			{
				while (i < _hotKeys.length)
				{
					hkStr += (hkStr ? "+" : "") + KeyUtils.keyToString(_hotKeys[i]);
					i++;
				}
				_hkField.text = hkStr;
				_hkField.x = Math.max(_field.width, _width - (20 + _hkField.width));
				_hkField.y = Math.max((_height - _hkField.height) >> 1, 0);
			}
		}
		
		protected function renderArrow():void
		{
			if (_hasChildNodes && !_arrow)
			{
				_arrow = new Sprite();
				_arrow.graphics.beginFill(0, 1);
				_arrow.graphics.lineTo(5, 4);
				_arrow.graphics.lineTo(0, 9);
				_arrow.graphics.lineTo(0, 0);
				_arrow.graphics.endFill();
				super.addChild(_arrow);
			}
			else if (!_hasChildNodes && _arrow && super.contains(_arrow))
				super.removeChild(_arrow);
			if (_arrow && super.contains(_arrow))
			{
				_arrow.x = _width - (_arrow.width + 4);
				_arrow.y = (_height - _arrow.height) >> 1;
			}
		}
		
		protected override function drawBackground():void 
		{
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(_backgroundColor, _backgroundAlpha);
			g.drawRect(0, 0, _width, _height);
			g.endFill();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function mclickHandler(event:Event = null):void 
		{
			if (_clickHandler !== null) _clickHandler(_data);
		}
		
		private function mouseOverHandler(event:MouseEvent):void 
		{
			if (_kind !== Menu.SEPARATOR) this.drawSelection(true);
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			if (_kind !== Menu.SEPARATOR) this.drawSelection(false);
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IMenuRenderer */
		
		public function get clickHandler():Function { return _clickHandler; }
		
		public function set desiredWidth(value:int):void
		{
			// TODO: do we need this?
		}
	}
}