package org.wvxvws.gui.skins 
{
	import flash.display.LineScaleMode;
	/**
	 * LineStyle class.
	 * @author wvxvw
	 */
	public class LineStyle
	{
		public var width:Number;
		public var alpha:Number;
		public var color:uint;
		public var pixelHinting:Boolean = true;
		public var scaleMode:String = LineScaleMode.NORMAL;
		public var caps:String;
		public var joints:String;
		public var miterLimit:Number = 3;
		
		public function LineStyle(width:Number = 1, alpha:Number = 1, color:uint = 0) 
		{
			super();
			this.width = width;
			this.alpha = alpha;
			this.color = color;
		}
		
	}

}