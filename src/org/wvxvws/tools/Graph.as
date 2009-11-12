package org.wvxvws.tools 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.skins.LineStyle;
	
	[DefaultProperty("valueAt")]
	
	/**
	 * Graph class.
	 * @author wvxvw
	 */
	public class Graph extends DIV
	{
		public function get valueAt():Function { return _valueAt; }
		
		public function set valueAt(value:Function):void 
		{
			if (_valueAt === value) return;
			super.invalidate("_valueAt", _valueAt, false);
			_valueAt = value;
			super.dispatchEvent(new Event("valueAtChange"));
		}
		
		public function get step():int { return _step; }
		
		public function set step(value:int):void 
		{
			if (_step === value) return;
			super.invalidate("_step", _step, false);
			_step = value;
			super.dispatchEvent(new Event("stepChange"));
		}
		
		public function get backgroundPattern():BitmapData { return _backgroundPattern; }
		
		public function set backgroundPattern(value:BitmapData):void 
		{
			if (_backgroundPattern === value) return;
			super.invalidate("_backgroundPattern", _backgroundPattern, false);
			_backgroundPattern = value;
			super.dispatchEvent(new Event("_backgroundPatternChange"));
		}
		
		public function get translation():Point { return _translation; }
		
		public function set translation(value:Point):void 
		{
			if (_translation === value) return;
			super.invalidate("_translation", _translation, false);
			_translation = value;
			super.dispatchEvent(new Event("translationChange"));
		}
		
		public function get lineStyle():LineStyle { return _lineStyle; }
		
		public function set lineStyle(value:LineStyle):void 
		{
			if (_lineStyle === value) return;
			super.invalidate("_lineStyle", _lineStyle, false);
			_lineStyle = value;
			super.dispatchEvent(new Event("lineStyleChange"));
		}
		
		protected var _step:int = 2;
		protected var _valueAt:Function;
		protected var _hRange:Point = new Point();
		protected var _vRange:Point = new Point();
		protected var _backgroundPattern:BitmapData;
		protected var _smooth:Boolean;
		protected var _translation:Point = new Point();
		protected var _lineStyle:LineStyle = new LineStyle();
		
		public function Graph() { super(); }
		
		protected override function drawBackground():void 
		{
			var rect:Rectangle;
			var realColor:uint = 
				((0xFF & (_backgroundAlpha * 0xFF)) << 24) | _backgroundColor;
			var complementColor:uint = 0xFF000000 | _backgroundColor;
			if (!_backgroundPattern)
			{
				_backgroundPattern = 
					new BitmapData(_step * 2, _step, true, realColor);
				_backgroundPattern.fillRect(
					new Rectangle(0, 0, _step, _step), complementColor);
			}
			var m:Matrix = new Matrix();
			m.translate(_translation.x % _step, _translation.y % _step);
			_background.clear();
			_background.beginBitmapFill(_backgroundPattern, m);
			_background.drawRect(0, 0, _bounds.x, _bounds.y);
			_background.endFill();
			this.drawGraph();
			if (super.scrollRect) rect = super.scrollRect;
			else rect = new Rectangle();
			rect.width = _bounds.x;
			rect.height = _bounds.y;
			super.scrollRect = rect;
		}
		
		protected function drawGraph():void
		{
			if (_valueAt === null) return;
			var len:int = _bounds.x / _step;
			var start:int = _hRange.x * _step;
			var top:int = _vRange.x * _step;
			var bottom:int = _vRange.y * _step;
			var tx:int = _translation.x;
			var ty:int = _bounds.y + _translation.y;
			_background.lineStyle(	_lineStyle.width, _lineStyle.color, 
									_lineStyle.alpha, _lineStyle.pixelHinting, 
									_lineStyle.scaleMode, _lineStyle.caps, 
									_lineStyle.joints, _lineStyle.miterLimit);
			_background.moveTo(tx, ty);
			while (len--)
			{
				_background.lineTo(tx + len * _step, ty - _valueAt(len) * _step);
			}
		}
	}
}