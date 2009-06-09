package org.wvxvws.encoding 
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * SWFTagReader class.
	 * @author wvxvw
	 */
	public class SWFTagReader 
	{
		private static const TWIPS_TO_PIXELS:Number = 0.05;
		private static const TYPES:Object =
		{
			"0" : "End",
			"1" : "ShowFrame",
			"2" : "DefineShape",
			"4" : "PlaceObject",
			"5" : "RemoveObject",
			"6" : "DefineBits",
			"7" : "DefineButton",
			"8" : "JPEGTables",
			"9" : "SetBackgroundColor",
			"10" : "DefineFont",
			"11" : "DefineText",
			"12" : "DoAction",
			"13" : "DefineFontInfo",
			"14" : "DefineSound",
			"15" : "StartSound",
			"17" : "DefineButtonSound",
			"18" : "SoundStreamHead",
			"19" : "SoundStreamBlock",
			"20" : "DefineBitsLossless",
			"21" : "DefineBitsJPEG2",
			"22" : "DefineShape2",
			"23" : "DefineButtonCxform",
			"24" : "Protect",
			"26" : "PlaceObject2",
			"28" : "RemoveObject2",
			"32" : "DefineShape3",
			"33" : "DefineText2",
			"34" : "DefineButton2",
			"35" : "DefineBitsJPEG3",
			"36" : "DefineBitsLossless2",
			"37" : "DefineEditText",
			"39" : "DefineSprite",
			"43" : "FrameLabel",
			"45" : "SoundStreamHead2",
			"46" : "DefineMorphShape",
			"48" : "DefineFont2",
			"56" : "ExportAssets",
			"57" : "ImportAssets",
			"58" : "EnableDebugger",
			"59" : "DoInitAction",
			"60" : "DefineVideoStream",
			"61" : "VideoFrame",
			"62" : "DefineFontInfo2",
			"64" : "EnableDebugger2",
			"65" : "ScriptLimits",
			"66" : "SetTabIndex",
			"69" : "FileAttributes",
			"70" : "PlaceObject3",
			"71" : "ImportAssets2",
			"73" : "DefineFontAlignZones",
			"74" : "CSMTextSettings",
			"75" : "DefineFont3",
			"76" : "SymbolClass",
			"77" : "Metadata",
			"78" : "DefineScalingGrid",
			"82" : "DoABC",
			"83" : "DefineShape4",
			"84" : "DefineMorphShape2",
			"86" : "DefineSceneAndFrameLabelData",
			"87" : "DefineBinaryData",
			"88" : "DefineFontName",
			"89" : "StartSound2"
		}
		
		private static var _report:XML;
		private static var _meta:String;
		private static var _bitPosition:int;
		private static var _currentByte:int;
		private static var _bytes:ByteArray;
		
		public function SWFTagReader() { super(); }
		
		public static function readTag(swf:ByteArray, position:uint, onTag:Function = null):uint
		{
			swf.position = position;
			var tagN:uint = swf.readShort();
			var tagID:uint = tagN >> 6;
			var tagShortLNT:uint = tagN & 63;
			var tagLongLNT:uint;
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			if (tagShortLNT >= 63)
			{
				tagLongLNT = swf.readUnsignedInt();
				if (onTag != null)
				{
					swf.readBytes(data, 0, tagLongLNT);
					onTag(tagID, tagLongLNT, position + tagLongLNT + 6, data);
				}
			}
			else
			{
				if (onTag != null)
				{
					swf.readBytes(data, 0, tagShortLNT);
					onTag(tagID, tagShortLNT, position + tagShortLNT + 2, data);
				}
			}
			return position + tagLongLNT + 2 + (tagLongLNT ? 4 : tagShortLNT);
		}
		
		private static function readRect():uint
		{
			nextBitByte();
			var rect:Rectangle = new Rectangle();
			var dataSize:uint = readBits(5);
			rect.left = readBits(dataSize, true) * TWIPS_TO_PIXELS;
			rect.right = readBits(dataSize, true) * TWIPS_TO_PIXELS;
			rect.top = readBits(dataSize, true) * TWIPS_TO_PIXELS;
			rect.bottom = readBits(dataSize, true) * TWIPS_TO_PIXELS;
			//trace(rect);
			var ret:uint;
			do
			{
				if (_bytes.readUnsignedByte() !== 0)
				{
					ret = _bytes.position;
					break;
				}
			}
			while (true);
			return ret;
		}
		
		static private function nextBitByte():void
		{
			_currentByte = _bytes.readByte();
			_bitPosition = 0;
		}

		
		static private function readBits(numBits:uint, signed:Boolean = false):Number
		{
			var value:Number = 0; // int or uint
			var remaining:uint = 8 - _bitPosition;
			var mask:uint;
			
			if (numBits <= remaining)
			{
				mask = (1 << numBits) - 1;
				value = (_currentByte >> (remaining - numBits)) & mask;
				if (numBits == remaining) nextBitByte();
				else _bitPosition += numBits;
			}
			else
			{
				mask = (1 << remaining) - 1;
				var firstValue:uint	= _currentByte & mask;
				var over:uint = numBits - remaining;
				nextBitByte();
				value = (firstValue << over) | readBits(over);
			}
			if (signed && value >> (numBits - 1) == 1)
			{
				remaining = 32 - numBits; // 32-bit uint
				mask = (1 << remaining) - 1;
				return int(mask << numBits | value);
			}
			return uint(value);
		}
		
		public static function readMetaData(swf:ByteArray):String
		{
			var position:uint = 8;
			_meta = "";
			_bytes = swf;
			_bytes.position = position;
			position += readRect();
			do
			{
				try
				{
					position = readTag(swf, position, checkForMeta);
				}
				catch (error:Error)
				{
					//trace("Was not able to read the tag at position", position);
					break;
				}
				if (_meta) break;
			}
			while (position < swf.length);
			return _meta;
		}
		
		private static function checkForMeta(id:int, length:int, position:int, data:ByteArray):void
		{
			if (id != 77) return;
			_meta = data.readUTFBytes(length - 1);
		}
		
		public static function generateReport(swf:ByteArray):XML
		{
			var position:uint = 8;
			_report = <report/>;
			_bytes = swf;
			_bytes.position = position;
			position += readRect();
			do
			{
				try
				{
					position = readTag(swf, position, onTagCallback);
				}
				catch (error:Error)
				{
					//trace("Was not able to read the tag at position", position);
					break;
				}
			}
			while (position < swf.length);
			return _report;
		}
		
		static private function onTagCallback(id:int, length:int, position:int, data:ByteArray):void
		{
			//trace(TYPES[id], id);
			_report.appendChild(<tag id={ TYPES[id] ? TYPES[id] : id } position={ position } lenght={ length }/>);
		}
	}
	
}