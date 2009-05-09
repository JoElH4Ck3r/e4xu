package view.skins.scroller 
{
	//{imports
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	//}
	
	/**
	* HandleUP class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class HandleOVER extends Shape
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function HandleOVER() 
		{
			super();
			handleAdded(null);
			addEventListener(Event.ADDED, handleAdded);
		}
		
		private function handleAdded(event:Event):void 
		{
			var localXScale:Number = 1;
			var localYScale:Number = 1;
			var afterScaleWidth:int = 10;
			var afterScaleHeight:int = 10;
			if (event && parent)
			{
				localXScale = 1 / parent.scaleX;
				localYScale = 1 / parent.scaleY;
				//afterScaleWidth = 10 * parent.scaleX - 2;
				//afterScaleHeight = 10 * parent.scaleY - 2;
			}
			trace(afterScaleWidth, afterScaleHeight);
			super.graphics.clear();
			super.graphics.beginFill(0xFF00FF, 0);
			super.graphics.drawRect(0, 0, afterScaleWidth, afterScaleHeight);
			super.graphics.endFill();
			super.graphics.beginFill(0xCBB48D);
			super.graphics.drawRoundRect(localXScale, localYScale, 
				afterScaleWidth - localXScale * 2, afterScaleHeight - localYScale * 2,
				4 * localXScale, 4 * localYScale);
			super.graphics.endFill();
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}