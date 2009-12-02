package org.wvxvws.gui 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ScrollPane class.
	 * @author wvxvw
	 */
	public class ScrollPane extends Sprite
	{
		public override function get width():Number { return _realWidth; }
		
		public override function get height():Number { return _realHeight; }
		
		public function set realWidth(value:int):void { _realWidth = value; }
		
		public function set realHeight(value:int):void { _realHeight = value; }
		
		protected var _realWidth:int;
		protected var _realHeight:int;
		
		public function ScrollPane() { super(); }
	}
}