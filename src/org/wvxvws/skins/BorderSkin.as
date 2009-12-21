package org.wvxvws.skins 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.Border;
	import org.wvxvws.gui.skins.AbstractProducer;
	import org.wvxvws.gui.skins.SkinDefaults;
	
	/**
	 * BorderSkin skin.
	 * @author wvxvw
	 */
	public class BorderSkin extends AbstractProducer
	{
		protected var _sides:Vector.<BitmapData>;
		protected var _corners:Vector.<BitmapData>;
		protected var _pattern:BitmapData;
		protected var _cornerPattern:BitmapData;
		protected var _source:BitmapData;
		
		public function BorderSkin(sides:Vector.<BitmapData> = null,
			corners:Vector.<BitmapData> = null) 
		{
			super();
			_sides = sides;
			if (sides && sides.length) _pattern = sides[0];
			_corners = corners;
			if (corners && corners.length) _cornerPattern = corners[0];
		}
		
		protected function generateSource():void
		{
			_source = new BitmapData(9, 9, false, SkinDefaults.BORDER_OUT_COLOR);
			var rect:Rectangle = new Rectangle(1, 1, 7, 7);
			_source.fillRect(rect, SkinDefaults.BORDER_MID_COLOR);
			rect.x = rect.y = 2;
			rect.width = rect.height = 5;
			_source.fillRect(rect, SkinDefaults.BORDER_IN_COLOR);
		}
		
		public override function produce(inContext:Object, ...args):Object 
		{
			var s:String = args[0];
			var v:Vector.<BitmapData>;
			var bd:BitmapData;
			var i:int;
			var rect:Rectangle;
			var pt:Point;
			switch (s)
			{
				case Border.SIDES:
					if (_sides) return _sides;
					_sides = new Vector.<BitmapData>(4, true);
					if (!_source) this.generateSource();
					pt = new Point();
					rect = new Rectangle(3, 0, 3, 3);
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_sides[0] = bd;
					_pattern = bd;
					rect.y = 6;
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_sides[1] = bd;
					rect.y = 3;
					rect.x = 0;
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_sides[2] = bd;
					rect.x = 6;
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_sides[3] = bd;
					return _sides;
				case Border.PATTERN:
					if (_pattern) return _pattern;
					if (!_source) this.generateSource();
					pt = new Point();
					rect = new Rectangle(3, 0, 3, 3);
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_pattern = bd;
					return _pattern;
				case Border.CORNERS:
					if (_corners) return _sides;
					_corners = new Vector.<BitmapData>(4, true);
					if (!_source) this.generateSource();
					pt = new Point();
					rect = new Rectangle(0, 0, 3, 3);
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_corners[0] = bd;
					_cornerPattern = bd;
					rect.x = 6;
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_corners[1] = bd;
					rect.y = 6;
					rect.x = 0;
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_corners[2] = bd;
					rect.x = 6;
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_corners[3] = bd;
					return _corners;
				case Border.CORNER_PATTERN:
					if (_cornerPattern) return _cornerPattern;
					if (!_source) this.generateSource();
					pt = new Point();
					rect = new Rectangle(0, 0, 3, 3);
					bd = new BitmapData(3, 3);
					bd.copyPixels(_source, rect, pt);
					_cornerPattern = bd;
					return _cornerPattern;
			}
			return null;
		}
	}
}