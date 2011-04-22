package org.wvxvws.parsers.as3
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	[Event(type="flash.events.Event", name="complete")]
	
	[Event(type="flash.events.IOErrorEvent", name="ioError")]
	
	[Event(type="flash.events.SecurityErrorEvent", name="securityError")]
	
	[Event(type="flash.events.OutputProgressEvent", name="outputProgress")]
	
	[Event(type="flash.events.ProgressEvent", name="progress")]
	
	public class AS3AIRReader extends AS3Reader implements IEventDispatcher
	{
		public function get parsedText():String { return this._parsedText; }
		
		public function get parsedXML():XML { return this._parsedXML; }
		
		protected var _dispatcher:EventDispatcher;
		
		protected var _parsedText:String;
		
		protected var _parsedXML:XML;
		
		protected var _stream:FileStream;
		
		public function AS3AIRReader()
		{
			super();
			this._dispatcher = new EventDispatcher(this);
		}
		
		public function readFromFile(fileName:String):void
		{
			var fileContent:String;
			var saveFile:File = new File(fileName);
			
			this.cleanup();
			
			this._stream = new FileStream();
			this._stream.addEventListener(
				Event.COMPLETE, this.completeHandler);
			this._stream.addEventListener(
				IOErrorEvent.IO_ERROR, this._dispatcher.dispatchEvent);
			this._stream.addEventListener(
				OutputProgressEvent.OUTPUT_PROGRESS, this._dispatcher.dispatchEvent);
			this._stream.addEventListener(
				ProgressEvent.PROGRESS, this._dispatcher.dispatchEvent);
			this._stream.addEventListener(
				SecurityErrorEvent.SECURITY_ERROR, this._dispatcher.dispatchEvent);
			this._stream.openAsync(saveFile, FileMode.READ);
		}
		
		public function addEventListener(type:String, listener:Function, 
			useCapture:Boolean = false, priority:int = 0, 
			useWeakReference:Boolean = false):void
		{
			this._dispatcher.addEventListener(type, listener, 
				useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, 
			useCapture:Boolean = false):void
		{
			this._dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return this._dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return this._dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return this._dispatcher.willTrigger(type);
		}
		
		protected function cleanup():void
		{
			if (this._stream)
			{
				this._stream.close();
				this._stream.removeEventListener(
					Event.COMPLETE, this.completeHandler);
				this._stream.removeEventListener(
					IOErrorEvent.IO_ERROR, this._dispatcher.dispatchEvent);
				this._stream.removeEventListener(
					OutputProgressEvent.OUTPUT_PROGRESS, this._dispatcher.dispatchEvent);
				this._stream.removeEventListener(
					ProgressEvent.PROGRESS, this._dispatcher.dispatchEvent);
				this._stream.removeEventListener(
					SecurityErrorEvent.SECURITY_ERROR, this._dispatcher.dispatchEvent);
			}
		}
		
		protected function completeHandler(event:Event):void
		{
			var before:Object = XML.settings();
			XML.prettyIndent = 0;
			XML.prettyPrinting = false;
			this._parsedText = 
				super.readAsXML(this._stream.readUTFBytes(
					this._stream.bytesAvailable)).toXMLString();
			XML.setSettings(before);
			this.cleanup();
			this._dispatcher.dispatchEvent(event);
		}
	}
}