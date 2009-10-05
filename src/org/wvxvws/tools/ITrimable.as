package org.wvxvws.tools 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ITrimable interface.
	 * @author wvxvw
	 */
	public interface ITrimable 
	{
		function get trimLeft():uint;
		function set trimLeft(value:uint):void;
		
		function get trimRight():uint;
		function set trimRight(value:uint):void;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function getBounds(where:DisplayObject):Rectangle;
		function globalToLocal(point:Point):Point;
	}
	
}