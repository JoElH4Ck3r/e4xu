package org.wvxvws.gui 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * SkinnableControl class.
	 * @author wvxvw
	 */
	public class SkinnableControl extends Control
	{
		protected var _skin:Skin;
		
		public function SkinnableControl() { super(); }
		
		public function setSkin(skin:Skin):void
		{
			if (_skin === skin) return;
			_skin = skin;
			isInvalidLayout = true;
		}
	}
}