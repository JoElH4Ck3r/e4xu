/**
 * ...
 * @author wvxvw
 */
package org.wvxvws.encoding;
import flash.Lib;
import flash.Memory;
import haxe.io.Bytes;

class Base64 
{
	private static inline var _table:String = 
		"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@>@@@?456789:;<=@@@@@@@@" +
		"\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A" +
		"\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19@@@@@@" +
		"\x1A\x1B\x1C\x1D\x1E\x1F\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A" +
		"\x2B\x2C\x2D\x2E\x2F\x30\x31\x32\x33";
	private static inline var _base:String =
		"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	public function new() { }
	
	public static function encode(input:Bytes):String
	{
		var chunk:Int;
		var witePosition:Int = 64;
		var bytes:Bytes = 
			Bytes.alloc(Math.ceil(input.length * 0.3333333333333333) * 4 + 64);
		var readPosition:Int = bytes.length - input.length;
		var resultLength:Int = Math.floor(input.length * 0.3333333333333333) * 4;
		var tail:Int = input.length % 3;
		var bytesLength:Int = readPosition + input.length - tail;
		
		bytes.blit(0, Bytes.ofString(_base), 0, 64);
		bytes.blit(readPosition, input, 0, input.length);
		
		if (bytes.length < 1024)
		{
			bytes = Bytes.alloc(1024);
			bytes.blit(0, Bytes.ofString(_base), 0, 64);
			bytes.blit(readPosition, input, 0, input.length);
		}
		
		Memory.select(bytes.getData());
		
		while (readPosition < bytesLength)
		{
			//Lib.trace(">>" +
				//String.fromCharCode(Memory.getByte(readPosition)) +
				//String.fromCharCode(Memory.getByte(readPosition + 1)) +
				//String.fromCharCode(Memory.getByte(readPosition + 2)) +
				//String.fromCharCode(Memory.getByte(readPosition + 3))
				//);
			chunk = Memory.getByte(readPosition++) << 16;
			chunk |= (Memory.getByte(readPosition++) << 8);
			chunk |= Memory.getByte(readPosition++);

			Memory.setI32(witePosition,
				Memory.getByte(chunk >>> 18) |
				(Memory.getByte((chunk >>> 12) & 0x3F) << 8) |
				(Memory.getByte((chunk >>> 6) & 0x3F) << 16) |
				(Memory.getByte(chunk & 0x3F) << 24)
			);

			witePosition += 4;
		}
		switch (tail)
		{
			case 1:
				chunk = Memory.getByte(readPosition++);

				Memory.setByte(witePosition++, Memory.getByte(chunk >>> 2));
				Memory.setByte(witePosition++, Memory.getByte((chunk & 3) << 4));
				Memory.setByte(witePosition++, 61);
				Memory.setByte(witePosition++, 61);
				resultLength += 10;
			case 2:
				//Lib.trace(
					//String.fromCharCode(Memory.getByte(readPosition)) +
					//String.fromCharCode(Memory.getByte(readPosition + 1))
					//);
				chunk = Memory.getByte(readPosition++) << 8;
				chunk |= Memory.getByte(readPosition++);

				Memory.setByte(witePosition++, Memory.getByte(chunk >>> 10));
				Memory.setByte(witePosition++, Memory.getByte((chunk >>> 4) & 0x3F));
				Memory.setByte(witePosition++, Memory.getByte((chunk & 15) << 2));
				Memory.setByte(witePosition++, 61);
				resultLength += 10;
		}
		return bytes.readString(64, resultLength);
	}
	
	public static function decode(input:String):Bytes
	{
		var whole:UInt = 0;
		var current:Int = 0;
		var state:Int = 0;
		var inBa:Bytes = Bytes.ofString(_table + input);
		var len:Int = inBa.length;
		var outBa:Bytes;
		var writePos:Int = 123;
		while (inBa.length < 1024)
		{
			inBa = Bytes.ofString(inBa.toString() + _table);
		}
		
		Memory.select(inBa.getData());
		var len:Int = inBa.length;
		for (i in 123...len)
		{
			current = Memory.getByte(i);
			if (Memory.getByte(current) != 0x40)
			{
				switch (state)
				{
					case 0:
						whole = Memory.getByte(current) << 18;
					case 1:
						whole |= (Memory.getByte(current) << 12);
					case 2:
						whole |= (Memory.getByte(current) << 6);
					default:
						whole |= (Memory.getByte(current));
						state = -1;
						current = (whole & 0xFF) << 16;
						whole = (whole & 0xFF00) | ((whole >>> 16) & 0xFF) | current;
						Memory.setI32(writePos, whole);
						writePos += 3;
				}
				state++;
			}
		}
		
		if (state > 0)
		{
			current = (whole & 0xFF) << 16;
			whole = (whole & 0xFF00) | ((whole >>> 16) & 0xFF) | current;
		}
		switch (state)
		{
			case 1:
			case 2:
				Memory.setByte(writePos++, whole);
			case 3:
				Memory.setByte(writePos++, whole & 0xFF);
				Memory.setByte(writePos++, (whole >>> 8) & 0xFF);
		}
		outBa = inBa.sub(123, writePos - 123);
		return outBa;
	}
}