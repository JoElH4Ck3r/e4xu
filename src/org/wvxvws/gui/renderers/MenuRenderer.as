package org.wvxvws.gui.renderers 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.wvxvws.gui.containers.Menu;
	import org.wvxvws.utils.KeyUtils;
	//}
	
	/**
	* MenuRenderer class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class MenuRenderer extends Sprite implements IMenuRenderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public override function set width(value:Number):void 
		{
			if (_width === value) return;
			_width = value;
			render();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _data:XML;
		protected var _dataCopy:XML;
		protected var _icon:DisplayObject;
		protected var _field:TextField;
		protected var _hkField:TextField;
		protected var _enabled:Boolean;
		protected var _clickHandler:Function;
		protected var _labelFunction:Function;
		protected var _labelField:String;
		protected var _kind:String;
		protected var _hotKeys:Vector.<int>;
		protected var _iconFactory:Class;
		protected var _arrow:Sprite;
		protected var _hasChildNodes:Boolean;
		protected var _defaultFormat:TextFormat = new TextFormat("_sans", 11);
		protected var _fieldScrollRect:Rectangle = new Rectangle();
		protected var _width:int;
		
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
		
		public function MenuRenderer() { super(); }
		
		/* INTERFACE org.wvxvws.gui.renderers.IMenuRenderer */
		
		public function set iconFactory(value:Class):void
		{
			if (_iconFactory === value) return;
			_iconFactory = value;
		}
		
		public function set hotKeys(value:Vector.<int>):void
		{
			if (_hotKeys === value) return;
			_hotKeys = value;
		}
		
		public function get kind():String { return _kind; }
		
		public function set kind(value:String):void
		{
			if (_kind === value || (value !== Menu.CHECK && 
				value !== Menu.CONTAINER && value !== Menu.NONE && 
				value !== Menu.RADIO && value !== Menu.SEPARATOR)) return;
			_kind = value;
		}
		
		public function set clickHandler(value:Function):void
		{
			if (_clickHandler === value) return;
			_clickHandler = value;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (_enabled === value) return;
			_enabled = value;
		}
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _dataCopy.contains(_data);
		}
		
		public function set labelFunction(value:Function):void
		{
			if (_labelFunction === value) return;
			_labelFunction = value;
		}
		
		public function set labelField(value:String):void
		{
			if (_labelField === value) return;
			_labelField = value;
		}
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void
		{
			if (isValid && _data === value) return;
			_data = value;
			_dataCopy = value.copy();
			_hasChildNodes = _data.hasComplexContent();
			render();
		}
		
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
		
		protected function render():void
		{
			var hkStr:String = "";
			var i:int;
			if (!_icon || !(_icon as Object).constructor !== _iconFactory)
			{
				if (_icon && super.contains(_icon))
				{
					super.removeChild(_icon);
				}
				if (_iconFactory)
				{
					_icon = new _iconFactory() as DisplayObject;
					_icon.x = 2;
					_icon.y = 2;
					super.addChild(_icon);
				}
			}
			if (!_field)
			{
				_field = new TextField();
				_field.selectable = false;
				_field.defaultTextFormat = _defaultFormat;
				_field.height = 1;
				_field.width = 1;
				_field.autoSize = TextFieldAutoSize.LEFT;
				_field.x = 30;
				super.addChild(_field);
			}
			if (_labelFunction !== null) _field.text = _labelFunction(data);
			else if (_labelField !== null && _labelField !== "")
				_field.text = _data[_labelField].toString();
			else _field.text = _data.localName().toString();
			if (!_hkField)
			{
				_hkField = new TextField();
				_hkField.selectable = false;
				_hkField.defaultTextFormat = _defaultFormat;
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
			}
			_hkField.x = Math.max(_width - (30 + _hkField.width), _field.width + _field.x + 2);
			if (_hasChildNodes && !_arrow)
			{
				_arrow = new Sprite();
				_arrow.graphics.beginFill(0, 1);
				_arrow.graphics.lineTo(5, 4);
				_arrow.graphics.lineTo(0, 9);
				_arrow.graphics.lineTo(0, 0);
				_arrow.graphics.endFill();
				_arrow.addEventListener(MouseEvent.MOUSE_OVER, arrow_mouseOverHandler);
				super.addChild(_arrow);
			}
			else if (!_hasChildNodes && _arrow && super.contains(_arrow))
				super.removeChild(_arrow);
			if (_arrow && super.contains(_arrow))
			{
				_arrow.x = Math.max(_width - (_arrow.width + 2), _hkField.x + _hkField.width + 2);
				_arrow.y = (height - _arrow.height) >> 1;
			}
		}
		
		protected function arrow_mouseOverHandler(event:MouseEvent):void 
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}