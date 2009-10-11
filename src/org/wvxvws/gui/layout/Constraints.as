package org.wvxvws.gui.layout 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 * Constraints class.
	 * @author wvxvw
	 */
	public class Constraints 
	{
		public static const MIN:Number = 0;
		public static const MID:Number = 0.5;
		public static const MAX:Number = 1;
		
		public function Constraints() { super(); }
		
		public static function constrain(children:Vector.<DisplayObject>,
							align:int, direction:Boolean, hSpace:int, vSpace:int, 
							padding:Rectangle, bounds:Rectangle):void
		{
			var i:int;
			var j:int = children.length;
			var tX:int;
			var tY:int;
			var child:DisplayObject;
			var lastPos:int;
			if (direction) // horizontal layout
			{
				switch (align)
				{
					default:
					case MIN:
						tY = padding.top;
						break;
					case MID:
						tY = padding.top + (bounds.height >> 1);
						break;
					case MAX:
						tY = bounds.bottom - padding.bottom;
						break;
				}
				lastPos = padding.left;
				while (i < j)
				{
					child = children[i];
					child.y = tY - (align * child.height) >> 0;
					child.x = lastPos;
					lastPos += child.width + hSpace;
					i++;
				}
			}
			else // vertical layout
			{
				switch (align)
				{
					default:
					case MIN:
						tX = padding.left;
						break;
					case MID:
						tX = padding.left + (bounds.width >> 1);
						break;
					case MAX:
						tX = bounds.right - padding.right;
						break;
				}
				lastPos = padding.top;
				while (i < j)
				{
					child = children[i];
					child.x = tX - (align * child.width) >> 0;
					child.y = lastPos;
					lastPos += child.height + vSpace;
					i++;
				}
			}
		}
		
	}
	
}