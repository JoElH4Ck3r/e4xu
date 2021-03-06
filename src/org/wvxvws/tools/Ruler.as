﻿////////////////////////////////////////////////////////////////////////////////
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

package org.wvxvws.tools 
{
	//{ imports
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.layout.Invalides;
	//}
	
	/**
	 * Ruler class.
	 * @author wvxvw
	 */
	public class Ruler extends DIV
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get ratio():uint { return this._ratio; }
		
		public function set ratio(value:uint):void
		{
			var temp:Number = Math.max(1, value);
			if (temp === this._ratio) return;
			super.invalidate(Invalides.STYLE, false);
			this._ratio = temp;
			if (super.hasEventListener(EventGenerator.getEventType("ratio")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get step():uint { return this._step; }
		
		public function set step(value:uint):void 
		{
			var temp:Number = Math.max(2, value);
			if (temp === this._step) return;
			super.invalidate(Invalides.STYLE, false);
			this._step = value;
			if (super.hasEventListener(EventGenerator.getEventType("step")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get position():int { return this._position; }
		
		public function set position(value:int):void 
		{
			if (this._position === value) return;
			super.invalidate(Invalides.STYLE, false);
			this._position = value;
			if (super.hasEventListener(EventGenerator.getEventType("position")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get direction():Boolean { return this._direction; }
		
		public function set direction(value:Boolean):void 
		{
			if (this._direction === value) return;
			super.invalidate(Invalides.DIRECTION, false);
			this._direction = value;
			if (super.hasEventListener(EventGenerator.getEventType("direction")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get zoom():Number { return _zoom; }
		
		public function set zoom(value:Number):void 
		{
			if (this._zoom === value) return;
			super.invalidate(Invalides.STYLE, false);
			this._zoom = value;
			if (super.hasEventListener(EventGenerator.getEventType("zoom")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _ratio:uint = 10;
		protected var _step:uint = 2;
		protected var _position:int;
		protected var _bitmapData:BitmapData;
		protected var _textFormat:TextFormat = new TextFormat("_sans", 10);
		protected var _textHolder:Sprite;
		protected var _direction:Boolean;
		protected var _numbersDown:Boolean;
		protected var _bigDivision:uint = 15;
		protected var _smallDivision:uint = 10;
		protected var _zoom:Number = 1;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Ruler() { super(); }
		
		public override function validate(properties:Dictionary):void 
		{
			var ratioChanged:Boolean = 
				(Invalides.STYLE in properties) || 
				(Invalides.DIRECTION in properties) || !_bitmapData;
			var needRedraw:Boolean = 
				ratioChanged || (Invalides.TRANSFORM in properties) || 
				(Invalides.BOUNDS in properties);
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
			var localIterator:uint;
			var prevField:TextField;
			if (ratioChanged)
			{
				if (_bitmapData) _bitmapData.dispose();
				localBackgroundColor = 
					(((super._backgroundAlpha * 0xFF) & 0xFF) << 24) | 
					super._backgroundColor;
				if (_direction)
				{
					_bitmapData = new BitmapData(super.width, 
										_step * _ratio * _zoom, true, localBackgroundColor);
					localWidth = _step * _ratio * _zoom;
					localStep = _step * _zoom;
					if (localStep < 2) localStep = 2;
					localIterator = localStep;
					divisionBig = new Rectangle(0, 0, _bigDivision, 1);
					divisionSmall = new Rectangle(0, 0, _smallDivision, 1);
					_bitmapData.fillRect(divisionBig, 0xFF000000);
					while (localStep < localWidth)
					{
						divisionSmall.y = localStep;
						_bitmapData.fillRect(divisionSmall, 0xFF000000);
						localStep += localIterator;
					}
				}
				else
				{
					_bitmapData = new BitmapData(_step * _ratio * _zoom, 
										super.height, true, localBackgroundColor);
					localWidth = _step * _ratio * _zoom;
					localStep = _step * _zoom;
					if (localStep < 2) localStep = 2;
					localIterator = localStep;
					divisionBig = new Rectangle(0, 0, 1, _bigDivision);
					divisionSmall = new Rectangle(0, 0, 1, _smallDivision);
					_bitmapData.fillRect(divisionBig, 0xFF000000);
					while (localStep < localWidth)
					{
						divisionSmall.x = localStep;
						_bitmapData.fillRect(divisionSmall, 0xFF000000);
						localStep += localIterator;
					}
				}
				
			}
			if (needRedraw)
			{
				delta = _position % (_step * _ratio);
				if (_direction) m.translate(0, delta * -1);
				else m.translate(delta * -1, 0);
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
				if (_direction)
				{
					while (recicledFields.length > 
						super.height / (_step * _ratio * _zoom) && 
						_textHolder.numChildren)
					{
						recicledFields.pop();
						if (_textHolder.numChildren)
							_textHolder.removeChildAt(_textHolder.numChildren - 1);
					}
					while (recicledFields.length <= 
						super.height / (_step * _ratio * _zoom))
					{
						recicledFields.push(createTextField(_textHolder));
					}
				}
				else
				{
					while (recicledFields.length > 
						super.width / (_step * _ratio * _zoom) && 
						_textHolder.numChildren)
					{
						recicledFields.pop();
						if (_textHolder.numChildren)
							_textHolder.removeChildAt(_textHolder.numChildren - 1);
					}
					while (recicledFields.length <= 
						super.width / (_step * _ratio * _zoom))
					{
						recicledFields.push(createTextField(_textHolder));
					}
				}
				fieldIndex = 0;
				textBounds = new Rectangle(0, 0, super.width, super.height);
				numStart = (_position - delta) / _step;
				while (fieldIndex < recicledFields.length)
				{
					if (_direction)
					{
						recicledFields[fieldIndex].y = 
									fieldIndex * _step * _ratio * _zoom - delta;
						recicledFields[fieldIndex].x = _bigDivision;
					}
					else
					{
						recicledFields[fieldIndex].x = 
									fieldIndex * _step * _ratio * _zoom - delta;
						recicledFields[fieldIndex].y = _bigDivision;
					}
					recicledFields[fieldIndex].text = 
							(numStart + fieldIndex * _ratio * _step).toString();
					if (prevField && prevField.hitTestObject(recicledFields[fieldIndex]))
					{
						if (_textHolder.contains(recicledFields[fieldIndex]))
						{
							_textHolder.removeChild(recicledFields[fieldIndex]);
						}
					}
					else
					{
						if (!_textHolder.contains(recicledFields[fieldIndex]))
						{
							_textHolder.addChild(recicledFields[fieldIndex]);
						}
					}
					if (_textHolder.contains(recicledFields[fieldIndex]))
					{
						prevField = recicledFields[fieldIndex];
					}
					fieldIndex++;
				}
				_textHolder.scrollRect = textBounds;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
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