﻿package org.wvxvws.encoding 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.wvxvws.encoding.tags.DefineSceneAndFrameLabelData;
	import org.wvxvws.encoding.tags.DefineSound;
	import org.wvxvws.encoding.tags.DoABC;
	import org.wvxvws.encoding.tags.FileAttributes;
	import org.wvxvws.encoding.tags.FrameLabel;
	import org.wvxvws.encoding.tags.ScriptLimits;
	import org.wvxvws.encoding.tags.SetBackgroundColor;
	import org.wvxvws.encoding.tags.SymbolClass;
	
	//{imports
	
	//}
	/**
	* SWFCompiler class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class SWFCompiler 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static var signature:String = "\x46\x57\x53";
		public static var version:uint = 0x9;
		public static var fileLength:uint = 0;
		public static var frameRect:String = "\x78\x00\x07\xD0\x00\x00\x17\x70\x00";
		public static var frameRate:uint = 0x1F;
		public static var frameCount:uint = 0x1;
		
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
		
		private static var defineSound:DefineSound;
		private static var defineSceneAndFrameLabelData:DefineSceneAndFrameLabelData = 
							new DefineSceneAndFrameLabelData();
		private static var doABC:DoABC = new DoABC();
		private static var fileAttributes:FileAttributes = new FileAttributes();
		private static var frameLabel:FrameLabel = new FrameLabel();
		private static var scriptLimits:ScriptLimits = new ScriptLimits();
		private static var setBackgroundColor:SetBackgroundColor = new SetBackgroundColor();
		private static var symbolClass:SymbolClass = new SymbolClass();
		private static var _generator:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SWFCompiler() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function compileMP3SWF(input:ByteArray, toFile:String):ByteArray
		{
			var swf:ByteArray = new ByteArray();
			swf.endian = Endian.LITTLE_ENDIAN;
			writeHeader(swf, toFile);
			defineSound = MP3Transcoder.transcode(input);
			doABC.embeddedSoundName = generateMP3Name();
			swf.writeBytes(doABC.compile());
			swf.writeBytes(defineSound.data);
			symbolClass.classNames = [doABC.embeddedSoundName];
			symbolClass.tagIDs = [1];
			swf.writeBytes(symbolClass.compile());
			writeEnd(swf);
			swf.position = 4;
			swf.writeUnsignedInt(swf.length);
			swf.position = 0;
			return swf;
		}
		
		private static function generateMP3Name():String
		{
			var id:String = (++_generator).toString(36).toUpperCase();
			while (id.length < 3) id = "0" + id;
			return "Sound" + id;
		}
		
		public static function writeHeader(input:ByteArray, 
											frameClassName:String):void
		{
			input.endian = Endian.LITTLE_ENDIAN;
			writeFromString(signature, input);
			input.writeByte(version);
			input.writeUnsignedInt(fileLength);
			writeFromString(frameRect, input);
			input.writeShort(frameRate);
			input.writeShort(frameCount);
			
			fileAttributes.useNetwork = 0;
			input.writeBytes(fileAttributes.compile());
			//input.writeBytes(scriptLimits.compile());
			input.writeBytes(setBackgroundColor.compile());
			frameLabel.label = "Scene 1"; // frameClassName;
			//input.writeBytes(frameLabel.compile());
			input.writeBytes(defineSceneAndFrameLabelData.compile());
		}
		
		public static function writeEnd(input:ByteArray):void
		{
			input.writeByte(0x40);
			input.writeByte(0);
			input.writeByte(0);
			input.writeByte(0);
		}
		
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
		
		private static function writeFromString(input:String, data:ByteArray):void
		{
			var i:int = -1;
			var il:int = input.length - 1;
			while (i++ < il) data.writeByte(input.charCodeAt(i));
		}
	}
	
}