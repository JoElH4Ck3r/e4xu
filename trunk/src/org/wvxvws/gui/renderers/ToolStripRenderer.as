package org.wvxvws.gui.renderers 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.StatefulButton;
	
	/**
	 * ToolStripRenderer class.
	 * @author wvxvw
	 */
	public class ToolStripRenderer extends StatefulButton 
									implements IRenderer, ILayoutClient
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _invalidLayout;
		}
		
		public function set labelFunction(value:Function):void
		{
			if (_labelFunction === value) return;
			_labelFunction = value;
			this.invalidate("_labelFunction", _data, false);
		}
		
		public function set labelField(value:String):void
		{
			if (_labelField === value) return;
			_labelField = value;
			this.invalidate("_labelField", _data, false);
		}
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void
		{
			if (isValid && _data === value) return;
			_data = value;
			this.invalidate("_data", _data, false);
		}
		
		public function get label():String { return _label; }
		
		public function set label(value:String):void 
		{
			if (_label == value) return;
			_label = value;
			this.invalidate("_label", _label, false);
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
		
		protected var _data:XML;
		protected var _labelField:String;
		protected var _labelFunction:Function;
		protected var _validator:LayoutValidator;
		protected var _layoutParent:ILayoutClient;
		protected var _invalidProperties:Object = { };
		protected var _invalidLayout:Boolean;
		protected var _labelTXT:TextField;
		protected var _label:String;
		protected var _labelFormat:TextFormat = new TextFormat("_sans", 11);
		protected var _width:int = -1;
		protected var _height:int = -1;
		protected var _backgroundColor:uint;
		protected var _backgroundAlpha:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ToolStripRenderer()
		{
			super();
			_labelTXT = new TextField();
			_labelTXT.defaultTextFormat = _labelFormat;
			_labelTXT.autoSize = TextFieldAutoSize.LEFT;
			_labelTXT.width = 1;
			_labelTXT.height = 1;
			_labelTXT.selectable = false;
			super.addChild(_labelTXT);
			super.mouseChildren = false;
			super.tabChildren = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
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
		
		public function validate(properties:Object):void 
		{
			trace("validate");
			if (!_data && !("_label" in properties)) properties._label = "";
			else
			{
				if (_labelField && _data.hasOwnProperty(_labelField))
				{
					if (_labelFunction !== null)
						properties._label = _labelFunction(_data[_labelField]);
					else properties._label = _data[_labelField];
				}
				else
				{
					if (_labelFunction !== null)
						properties._label = _labelFunction(_data.toXMLString());
					else properties._label = _data.localName();
				}
			}
			_label = properties._label;
			if (_labelTXT.text !== _label)
			{
				_labelTXT.text = _label;
				_labelTXT.x = (Math.max(super.width, _width) - _labelTXT.width) >> 1;
				_labelTXT.y = (Math.max(super.height, _height) - _labelTXT.height) >> 1;
				if (_labelTXT.x < 0)
				{
					_labelTXT.x = 0;
					if (super.numChildren > 1)
					{
						_labelTXT.scrollRect = 
							new Rectangle(0, 0, super.width - 2, super.height - 2);
					}
				}
				if (_labelTXT.y < 0) _labelTXT.y = 0;
			}
			this.drawBackground();
			_invalidProperties = { };
			_invalidLayout = false;
		}
		
		protected function drawBackground():void
		{
			if (_width < 0) _width = super.width;
			if (_height < 0) _height = super.height;
			_backgroundAlpha = 1;
			_backgroundColor = 0xFF8000;
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(_backgroundColor, _backgroundAlpha);
			g.drawRect(0, 0, _width, _height);
			g.endFill();
		}
	}

}