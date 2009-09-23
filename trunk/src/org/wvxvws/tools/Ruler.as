package org.wvxvws.tools 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.wvxvws.gui.DIV;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Ruler extends DIV
	{
		protected var _ratio:uint = 10;
		protected var _step:uint = 2;
		protected var _position:int;
		protected var _bitmapData:BitmapData;
		protected var _textFormat:TextFormat = new TextFormat("_sans", 10);
		protected var _textHolder:Sprite;
		
		public function Ruler() { super(); }
		
		public function get ratio():uint { return _ratio; }
		
		public function set ratio(value:uint):void
		{
			var temp:Number = Math.max(1, value);
			if (temp === _ratio) return;
			invalidate("_ratio", _ratio, false);
			_ratio = temp;
			dispatchEvent(new Event("ratioChange"));
		}
		
		public function get step():uint { return _step; }
		
		public function set step(value:uint):void 
		{
			var temp:Number = Math.max(2, value);
			if (temp === _step) return;
			invalidate("_step", _step, false);
			_step = value;
			dispatchEvent(new Event("setpChange"));
		}
		
		public function get position():int { return _position; }
		
		public function set position(value:int):void 
		{
			if (_position === value) return;
			invalidate("_position", _position, false);
			_position = value;
			dispatchEvent(new Event("positionChange"));
		}
		
		public override function validate(properties:Object):void 
		{
			var ratioChanged:Boolean = ("_ratio" in properties) || 
							("_ratio" in properties) || !_bitmapData;
			var needRedraw:Boolean = ratioChanged || ("_position" in properties) ||
							("_transformMatrix" in properties)
			super.validate(properties);
			var g:Graphics = super.graphics;
			var m:Matrix = new Matrix();
			var localStep:uint;
			var localWidth:uint;
			var divisionBig:Rectangle;
			var divisionSmall:Rectangle;
			var localBackgroundColor:uint;
			var field:TextField;
			var delta:int;
			var recicledFields:Vector.<TextField>;
			var fieldIndex:int;
			var textBounds:Rectangle;
			var numStart:int;
			if (ratioChanged)
			{
				if (_bitmapData) _bitmapData.dispose();
				localBackgroundColor = ((Math.min(Math.max(super._backgroundAlpha, 
									0), 1) * 0xFF) << 24) | super._backgroundColor;
				_bitmapData = new BitmapData(_step * _ratio, 
										super.height, true, localBackgroundColor);
				localWidth = _step * _ratio;
				localStep = _step;
				divisionBig = new Rectangle(0, 0, 1, super.height - 15);
				divisionSmall = new Rectangle(0, 0, 1, super.height - 20);
				_bitmapData.fillRect(divisionBig, 0xFF000000);
				while (localStep < localWidth)
				{
					divisionSmall.x = localStep;
					_bitmapData.fillRect(divisionSmall, 0xFF000000);
					localStep += _step;
				}
			}
			if (needRedraw)
			{
				delta = _position % (_step * _ratio);
				m.translate(delta * -1, 0);
				g.clear();
				g.beginBitmapFill(_bitmapData, m);
				g.drawRect(0, 0, super.width, super.height);
				g.endFill();
				if (!_textHolder) _textHolder = super.addChild(new Sprite()) as Sprite;
				recicledFields = new Vector.<TextField>(0, false);
				while (fieldIndex < _textHolder.numChildren)
				{
					recicledFields.push(_textHolder.getChildAt(fieldIndex) as TextField);
					fieldIndex++;
				}
				while (recicledFields.length > super.width / (_step * _ratio))
				{
					recicledFields.pop();
					_textHolder.removeChildAt(_textHolder.numChildren - 1);
				}
				while (recicledFields.length <= super.width / (_step * _ratio))
				{
					recicledFields.push(createTextField(_textHolder));
				}
				fieldIndex = 0;
				textBounds = new Rectangle(0, 0, super.width, super.height);
				numStart = (_position - delta) / _step;
				while (fieldIndex < recicledFields.length)
				{
					recicledFields[fieldIndex].x = fieldIndex * _step * _ratio - delta;
					recicledFields[fieldIndex].y = super.height - 15;
					recicledFields[fieldIndex].text = (numStart + fieldIndex * _ratio).toString();
					fieldIndex++;
				}
				_textHolder.scrollRect = textBounds;
			}
		}
		
		protected function createTextField(where:Sprite):TextField
		{
			var field:TextField = new TextField();
			field.defaultTextFormat = _textFormat;
			field.width = 1;
			field.height = 1;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.selectable = false;
			return where.addChild(field) as TextField;
		}
	}
	
}