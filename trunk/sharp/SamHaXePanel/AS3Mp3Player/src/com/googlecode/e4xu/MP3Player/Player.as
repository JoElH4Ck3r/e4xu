package com.googlecode.e4xu.MP3Player 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	[SWF(width="100", height="100", backgroundColor="0xFFFFFF", frameRate="31")]
	
	/**
	 * MP3 Player class to be embedded in FlashDevelop SamHaXe plugin.
	 * @author wvxvw
	 */
	public class Player extends Sprite
	{
		private var _sound:Sound = new Sound();
		private var _button:Sprite = new Sprite();
		private var _playing:Boolean;
		private var _channel:SoundChannel;
		private var _wasError:Boolean;
		private var _url:String;
		
		public function Player() 
		{
			super();
			if (super.stage) this.init();
			else super.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		private function init(event:Event = null):void
		{
			super.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			this._button.addEventListener(MouseEvent.CLICK, this.clickHandler);
			this._sound.addEventListener(Event.OPEN, this.openHandler);
			this._sound.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
			this._url = super.loaderInfo.parameters.sound;
			this._button.buttonMode = true;
			super.addChild(this._button);
			if (this._url) this._sound.load(new URLRequest(this._url));
			this.drawPlayButton();
		}
		
		private function completeHandler(event:Event):void 
		{
			this.clickHandler();
		}
		
		private function errorHandler(event:ErrorEvent):void
		{
			this._wasError = true;
		}
		
		private function openHandler(event:Event):void 
		{
			this._channel = this._sound.play();
			this._channel.stop();
		}
		
		private function clickHandler(event:MouseEvent = null):void
		{
			if (this._wasError) return;
			if (!this._playing)
			{
				if (this._url)
				{
					if (this._channel)
					{
						this._channel.removeEventListener(
						Event.SOUND_COMPLETE, this.completeHandler);
					}
					this._channel = this._sound.play();
					this._channel.addEventListener(
						Event.SOUND_COMPLETE, this.completeHandler);
				}
				this.drawStopButton();
			}
			else 
			{
				if (this._channel) this._channel.stop();
				this.drawPlayButton();
			}
			this._playing = !this._playing;
		}
		
		private function drawPlayButton():void
		{
			var g:Graphics = this._button.graphics;
			g.clear();
			g.beginFill(0xFFFFFF);
			g.drawRect(0, 0, 100, 100);
			g.beginFill(0);
			g.drawCircle(50, 50, 50);
			g.drawCircle(50, 50, 45);
			g.moveTo(30, 20);
			g.lineTo(85, 50);
			g.lineTo(30, 80);
			g.lineTo(30, 20);
			g.endFill();
		}
		
		private function drawStopButton():void
		{
			var g:Graphics = this._button.graphics;
			g.clear();
			g.beginFill(0xFFFFFF);
			g.drawRect(0, 0, 100, 100);
			g.beginFill(0);
			g.drawCircle(50, 50, 50);
			g.drawCircle(50, 50, 45);
			g.drawRect(25, 25, 50, 50);
			g.endFill();
		}
	}
}