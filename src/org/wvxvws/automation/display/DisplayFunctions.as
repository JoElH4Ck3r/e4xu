package org.wvxvws.automation.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DisplayFunctions
	{
		public function DisplayFunctions() { super(); }
		
		private static var _stage:Stage;
		
		public static function init(stage:Stage):void { _stage = stage; }
		
		public static function click(x:int, y:int, ctrlKey:Boolean = false, 
									 altKey:Boolean = false, shiftKey:Boolean = false):void
		{
			var point:Point = new Point(x, y);
			var underPoint:Array = _stage.getObjectsUnderPoint(point);
			var displayObject:DisplayObject;
			var doc:DisplayObjectContainer;
			var potentialBackRef:Array;
			
			for (var i:int; i < underPoint.length; i++)
			{
				displayObject = underPoint[i];
				if (displayObject is InteractiveObject)
				{
					if (displayObject is DisplayObjectContainer)
					{
						doc = displayObject as DisplayObjectContainer;
						potentialBackRef = doc.getObjectsUnderPoint(doc.globalToLocal(point));
						if (doc.mouseChildren && 
							potentialBackRef.length && potentialBackRef[0] != doc)
						{
							// we should encounter the clicked child later
							trace("exited here...", potentialBackRef[0] == doc);
							continue;
						}
						else
						{
							dispatchInto(displayObject as InteractiveObject, 
								point, ctrlKey, altKey, shiftKey);
							break;
						}
					}
					else
					{
						dispatchInto(displayObject as InteractiveObject, 
							point, ctrlKey, altKey, shiftKey);
						break;
					}
				}
			}
		}
		
		private static function dispatchInto(interactive:InteractiveObject, point:Point, 
			ctrlKey:Boolean, altKey:Boolean, shiftKey:Boolean):void
		{
			var transformed:Point = interactive.globalToLocal(point);
			interactive.dispatchEvent(
				new MouseEvent(MouseEvent.CLICK, true, false, 
					transformed.x, transformed.y, 
					interactive, ctrlKey, altKey, shiftKey));
		}
	}
}