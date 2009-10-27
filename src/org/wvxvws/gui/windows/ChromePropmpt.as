package org.wvxvws.gui.windows 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.containers.ChromeWindow;
	import org.wvxvws.gui.renderers.ILabel;
	
	/**
	 * ChromePropmpt class.
	 * @author wvxvw
	 */
	public class ChromePropmpt extends ChromeWindow
	{
		protected var _userActionHandler:Function;
		protected var _fields:Vector.<ILabel> = new <ILabel>[];
		
		public function ChromePropmpt(inputs:Vector.<ILabel> = null, 
										actionHandler:Function = null) 
		{
			super();
		}
		
		public static function show(inputs:Vector.<ILabel>, 
									actionHandler:Function = null,
									context:DisplayObjectContainer, 
									metrics:Rectangle):ChromePropmpt
		{
			var p:ChromePropmpt = new ChromePropmpt(inputs, actionHandler);
			if (!metrics) metrics = new Rectangle(0, 0, 400, 200);
			return WindowManager.append(p, context, metrics) as ChromeAlert;
		}
		
		public override function created():void 
		{
			super.x = (super.parent.width - super.width) >> 1;
			super.y = (super.parent.height - super.height) >> 1;
		}
		
	}

}