package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.wvxvws.jsutils.shadowbox.ShadowBoxInterface;
	import org.wvxvws.jsutils.shadowbox.ShadowLink;
	import org.wvxvws.jsutils.shadowbox.ShadowOptions;
	
	[ExcludeClass]
	
	/**
	 * Top level.
	 * @author wvxvw
	 */
	public class Main2 extends Sprite 
	{
		public static var _tf:TextField = new TextField();
		
		public function Main2():void 
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_tf.width = stage.stageWidth;
			_tf.height = stage.stageHeight;
			_tf.multiline = true;
			addChild(_tf);
		}
		
		private function testHandler(...rest):void
		{
			_tf.text = "testHandler " + rest;
		}
		
		private function mouseDownHandler(event:MouseEvent):void 
		{
			var options:ShadowOptions = new ShadowOptions();
			options.animate = false;
			options.animSequence = ShadowOptions.HW;
			options.overlayColor = 0xFF0;
			// TODO: Refactor to string
			//options.handleUnsupported
			options.onOpen = testHandler;
			var links:Array = [];
			var link:ShadowLink;
			while (links.length < 10)
			{
				link = new ShadowLink("test.jpg");
				link.gallery = "Test gallery";
				links.push(link);
			}
			
			ShadowBoxInterface.setup(links);
			links[0].click();
			//ShadowBoxInterface.open("test.jpg", ShadowBoxInterface.IMG, 
												//"Testing Image", "", 150, 150, options);
		}
	}
	
}