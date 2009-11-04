package org.wvxvws.rendering 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * SlaveSlide class.
	 * @author wvxvw
	 */
	public class SlaveSlide extends Slide
	{
		public function get masterSlide():Slide { return _masterSlide; }
		
		public function set masterSlide(value:Slide):void 
		{
			if (_masterSlide === value) return;
			_masterSlide = value;
			super.valid = false;
		}
		
		public function get keypoints():Vector.<int> { return _keypoints.concat(); }
		
		public function set keypoints(value:Vector.<int>):void 
		{
			if (_keypoints === value) return;
			_keypoints.length = 0;
			var j:int;
			if (value)
			{
				j = value.length;
				for (var i:int; i < j; i++) 
				{
					_keypoints.push(value[i]);
				}
			}
			super.valid = false;
		}
		
		protected var _masterSlide:Slide;
		protected var _keypoints:Vector.<int> = new <int>[];
		
		public function SlaveSlide(master:Slide) 
		{
			super();
			_masterSlide = master;
			_masterSlide.addEventListener(
				Renderable.CHANGE_PROPERTY, masterChangeHandler, false, 0, true);
			//_color = 0xFF;
			_alpha = .5;
		}
		
		protected override function drawTrimmed():void {}
		
		protected function masterChangeHandler(event:Event):void
		{
			super.x = _masterSlide.x;
			super.width = _masterSlide.width;
		}
		
	}

}