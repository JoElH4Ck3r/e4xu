package org.wvxvws.gui 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	
	[Skin("org.wvxvws.skins.BorderSkin")]
	
	/**
	 * Border class.
	 * @author wvxvw
	 */
	public class Border extends DIV implements ISkinnable
	{
		public static const PATTERN:String = "pattern";
		public static const CORNER_PATTERN:String = "cornerPattern";
		public static const SIDES:String = "sides";
		public static const CORNERS:String = "corners";
		
		//------------------------------------
		//  Public property top
		//------------------------------------
		
		[Bindable("topChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>topChanged</code> event.
		*/
		public function get top():uint { return _thikness.top; }
		
		public function set top(value:uint):void 
		{
			if (_thikness.top === value) return;
			_thikness.top = value;
			super.invalidate(Invalides.BOUNDS, false);
			if (super.hasEventListener(EventGenerator.getEventType("top")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property left
		//------------------------------------
		
		[Bindable("leftChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>leftChanged</code> event.
		*/
		public function get left():uint { return _thikness.left; }
		
		public function set left(value:uint):void 
		{
			if (_thikness.left === value) return;
			_thikness.left = value;
			super.invalidate(Invalides.BOUNDS, false);
			if (super.hasEventListener(EventGenerator.getEventType("left")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property bottom
		//------------------------------------
		
		[Bindable("bottomChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>bottomChanged</code> event.
		*/
		public function get bottom():uint { return _thikness.bottom; }
		
		public function set bottom(value:uint):void 
		{
			if (_thikness.bottom === value) return;
			_thikness.bottom = value;
			super.invalidate(Invalides.BOUNDS, false);
			if (super.hasEventListener(EventGenerator.getEventType("bottom")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property right
		//------------------------------------
		
		[Bindable("rightChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>rightChanged</code> event.
		*/
		public function get right():uint { return _thikness.right; }
		
		public function set right(value:uint):void 
		{
			if (_thikness.right === value) return;
			_thikness.right = value;
			super.invalidate(Invalides.BOUNDS, false);
			if (super.hasEventListener(EventGenerator.getEventType("right")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property pattern
		//------------------------------------
		
		[Bindable("patternChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>patternChanged</code> event.
		*/
		public function get pattern():BitmapData { return _pattern; }
		
		public function set pattern(value:BitmapData):void 
		{
			if (_pattern === value) return;
			if (_pattern) _pattern.dispose();
			_pattern = value;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("pattern")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property cornerPattern
		//------------------------------------
		
		[Bindable("cornerPatternChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>cornerPatternChanged</code> event.
		*/
		public function get cornerPattern():BitmapData { return _cornerPattern; }
		
		public function set cornerPattern(value:BitmapData):void 
		{
			if (_cornerPattern === value) return;
			if (_cornerPattern) _cornerPattern.dispose();
			_cornerPattern = value;
			super.invalidate(Invalides.SKIN, true);
			if (super.hasEventListener(EventGenerator.getEventType("cornerPattern")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property repeatChanged
		//------------------------------------
		
		[Bindable("repeatChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>repeatChanged</code> event.
		*/
		public function get repeat():Boolean { return _repeat; }
		
		public function set repeat(value:Boolean):void 
		{
			if (_repeat === value) return;
			_repeat = value;
			super.invalidate(Invalides.SKIN, true);
			if (super.hasEventListener(EventGenerator.getEventType("repeat")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property repeatChanged
		//------------------------------------
		
		[Bindable("smoothChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>smoothChanged</code> event.
		*/
		public function get smooth():Boolean { return _smooth; }
		
		public function set smooth(value:Boolean):void 
		{
			if (_smooth === value) return;
			_smooth = value;
			super.invalidate(Invalides.SKIN, true);
			if (super.hasEventListener(EventGenerator.getEventType("smooth")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return _skin; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			var bd:BitmapData;
			if (_skin === value) return;
			_skin = value;
			if (_skin)
			{
				_pattern = _skin[0].produce(this, PATTERN) as BitmapData;
				_cornerPattern = _skin[0].produce(this, CORNER_PATTERN) as BitmapData;
				_corners = _skin[0].produce(this, CORNERS) as Vector.<BitmapData>;
				_sides = _skin[0].produce(this, SIDES) as Vector.<BitmapData>;
				trace(this, _pattern, "skin set");
			}
			else
			{
				for each (bd in _sides) bd.dispose();
				for each (bd in _corners) bd.dispose();
				_sides.length = 0;
				_corners.length = 0;
				if (_pattern) _pattern.dispose();
				if (_cornerPattern) _cornerPattern.dispose();
				_pattern = null;
				_cornerPattern = null;
			}
			super.invalidate(Invalides.SKIN, true);
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		protected var _thikness:Rectangle = new Rectangle(1, 1, 0, 0);
		protected var _pattern:BitmapData;
		protected var _cornerPattern:BitmapData;
		protected var _repeat:Boolean;
		protected var _smooth:Boolean;
		protected var _drawBack:Boolean;
		protected var _sides:Vector.<BitmapData>;
		protected var _corners:Vector.<BitmapData>;
		protected var _skin:Vector.<ISkin>;
		
		public function Border()
		{
			super();
			this.skin = SkinManager.getSkin(this);
		}
		
		public override function validate(properties:Dictionary):void 
		{
			_drawBack = ("_pattern" in properties) || 
						("_cornerPattern" in properties) || 
						("_thikness" in properties) ||
						("_repeat" in properties) ||
						("_smooth" in properties);
			super.validate(properties);
			if (_drawBack) drawBackground();
		}
		
		protected override function drawBackground():void 
		{
			super.drawBackground();
			if (!_pattern) return;
			this.drawBorder();
		}
		
		protected function drawBorder():void
		{
			var m:Matrix = new Matrix();
			var patWidth:int = _pattern.width;
			var patHeight:int = _pattern.height;
			if (!_cornerPattern) _cornerPattern = _pattern.clone();
			// top
			m.d = _thikness.top / patHeight;
			if (!_repeat) 
				m.a = (_bounds.x - (_thikness.left + _thikness.right)) / patWidth;
			m.tx = _thikness.left;
			_background.beginBitmapFill(_pattern, m, _repeat, _smooth);
			_background.drawRect(_thikness.left, 0, 
					_bounds.x - (_thikness.left + _thikness.right), _thikness.top);
			_background.endFill();
			
			// bottom
			m.d = _thikness.bottom / patHeight;
			if (!_repeat) 
				m.a = (_bounds.x - (_thikness.left + _thikness.right)) / patWidth;
			m.rotate(Math.PI);
			m.ty = _bounds.y;
			m.tx = _bounds.x - _thikness.right;
			_background.beginBitmapFill(_pattern, m, _repeat, _smooth);
			_background.drawRect(_thikness.left, _bounds.y - _thikness.bottom, 
								_bounds.x - (_thikness.left + _thikness.right),
								_thikness.bottom);
			_background.endFill();
			
			// left
			m = new Matrix();
			m.d = _thikness.left / patHeight;
			if (!_repeat) 
				m.a = (_bounds.y - (_thikness.top + _thikness.bottom)) / patWidth;
			m.rotate(Math.PI * -0.5);
			m.ty = _bounds.y - _thikness.bottom;
			_background.beginBitmapFill(_pattern, m, _repeat, _smooth);
			_background.drawRect(0, _thikness.top, _thikness.left, 
				_bounds.y - (_thikness.top + _thikness.bottom));
			_background.endFill();
			
			// right
			m = new Matrix();
			m.d = _thikness.right / patHeight;
			if (!_repeat) 
				m.a = (_bounds.y - (_thikness.top + _thikness.bottom)) / patWidth;
			m.rotate(Math.PI * 0.5);
			m.tx = _bounds.x;
			m.ty = _thikness.top;
			_background.beginBitmapFill(_pattern, m, _repeat, _smooth);
			_background.drawRect(_bounds.x - _thikness.right, _thikness.top, 
								_thikness.right, 
								_bounds.y - (_thikness.top + _thikness.bottom));
			_background.endFill();
			
			// corners
			patWidth = _cornerPattern.width;
			patHeight = _cornerPattern.height;
			
			// TL corner
			m = new Matrix();
			m.a = _thikness.left / patWidth;
			m.d = _thikness.top / patHeight;
			_background.beginBitmapFill(_cornerPattern, m, _repeat, _smooth);
			_background.drawRect(0, 0, _thikness.left, _thikness.top);
			_background.endFill();
			
			// TR corner
			m = new Matrix();
			m.d = _thikness.right / patWidth;
			m.a = _thikness.top / patHeight;
			m.rotate(Math.PI * 0.5);
			m.tx = _bounds.x;
			_background.beginBitmapFill(_cornerPattern, m, _repeat, _smooth);
			_background.drawRect(_bounds.x - _thikness.right, 0, 
								_thikness.right, _thikness.top);
			_background.endFill();
			
			// BR corner
			m = new Matrix();
			m.a = _thikness.right / patWidth;
			m.d = _thikness.bottom / patHeight;
			m.rotate(Math.PI);
			m.tx = _bounds.x;
			m.ty = _bounds.y;
			_background.beginBitmapFill(_cornerPattern, m, _repeat, _smooth);
			_background.drawRect(_bounds.x - _thikness.right, 
								_bounds.y - _thikness.bottom, 
								_thikness.right, _thikness.bottom);
			_background.endFill();
			
			// BL corner
			m = new Matrix();
			m.d = _thikness.left / patWidth;
			m.a = _thikness.bottom / patHeight;
			m.rotate(Math.PI * 1.5);
			m.ty = _bounds.y;
			_background.beginBitmapFill(_cornerPattern, m, _repeat, _smooth);
			_background.drawRect(0, _bounds.y - _thikness.bottom, 
								_thikness.left, _thikness.bottom);
			_background.endFill();
			
			_drawBack = false;
		}
	}
}