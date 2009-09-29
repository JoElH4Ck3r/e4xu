package org.wvxvws.gui.layout 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Constraints 
	{
		public static const WEST:int = -1;
		public static const GREENWICH:int = 0;
		public static const EAST:int = 1;
		
		public static const NORTH:int = -1;
		public static const EQUATOR:int = 0;
		public static const SOUTH:int = 1;
		
		public function Constraints() { super(); }
		
		public static function makeFlow(children:Vector.<DisplayObject>, 
			container:DisplayObjectContainer, hAlign:int, vAlign:int, 
			hSpace:int, vSpace:int, padding:Rectangle):void
		{
			
		}
		
		public static function makeRows(children:Vector.<DisplayObject>, 
			container:DisplayObjectContainer, hAlign:int, vAlign:int, 
			hSpace:int, vSpace:int, padding:Rectangle):void
		{
			
		}
		
		public static function makeColumns(children:Vector.<DisplayObject>, 
			container:DisplayObjectContainer, hAlign:int, vAlign:int, 
			hSpace:int, vSpace:int, padding:Rectangle):void
		{
			
		}
		
		public static function makeTable(children:Vector.<DisplayObject>, 
			container:DisplayObjectContainer, hAlign:int, vAlign:int, 
			hSpace:int, vSpace:int, padding:Rectangle):void
		{
			
		}
	}
	
}