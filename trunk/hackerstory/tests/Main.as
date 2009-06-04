package 
{
	import com.ayumilove.assets.SpriteSheet;
	import com.ayumilove.assets.SpriteSheetEvent;
	import com.ayumilove.assets.SpriteSheetLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[SWF(frameRate="25")]
	
	/**
	 * entry point
	 * @author wvxvw
	 */
	public class Main extends Sprite 
	{
		
		private var _testLoader:SpriteSheetLoader = new SpriteSheetLoader();
		private var _testSS:SpriteSheet;
		private var _cloneSS:SpriteSheet;
		private var _testXML:XML =
		<d src="img/pink-wizard.png" monster="PinkWizard">
			<attack range="6-9" frameSize="56:52"/>
			<stand range="0-5" frameSize="56:52"/>
			<walk range="10-15" frameSize="56:52"/>
		</d>;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_testSS = new SpriteSheet(_testXML);
			addChild(_testSS);
			_testSS.addEventListener(SpriteSheetEvent.READY, readyHandler);
		}
		
		private function readyHandler(event:SpriteSheetEvent):void 
		{
			_cloneSS = _testSS.clone(false, "attack");
			_cloneSS.x = 60;
			addChild(_cloneSS);
			addEventListener(Event.ENTER_FRAME, playWizardAnimation);
		}
		
		private function loader_completeHandler(event:Event):void 
		{
			trace(_testLoader.bitmapData);
		}
		
		private function playWizardAnimation(event:Event):void 
		{
			if (_testSS.totalFrames > _testSS.currentFrame)
			{
				_testSS.showFrame(_testSS.currentFrame + 1);
			}
			else
			{
				_testSS.showFrame(0);
			}
			if (_cloneSS.totalFrames > _cloneSS.currentFrame)
			{
				_cloneSS.showFrame(_cloneSS.currentFrame + 1);
			}
			else
			{
				_cloneSS.showFrame(0);
			}
		}
		
	}
	
}