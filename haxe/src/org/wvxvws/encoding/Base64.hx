/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.encoding;
import haxe.io.Bytes;
import haxe.Timer;

class Base64 
{
	private var _chars:Array<String>;
	private var _pad:String;
	private var _position:Int;
	private var _encoded:String;
	private var _timer:Timer;
	
	private var _bytes:Bytes;
	private var _bufSize:Int;
	private var _handler:String->Bool;
	
	public function new()
	{
		this._chars = 
		"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split("");
		this._position = 0;
		this._pad = "=";
		this._encoded = "";
	}
	
	public function encode(bytes:Bytes, bufferSize:Int, handler:String->Bool):Void
	{
		var len:Int = bytes.length;
		var index:Int = this._position;
		var min:Int = (bufferSize > len - index) ? len - index : bufferSize;
		var limit:Int = index + (Std.int(min * 0.3333333333333333) >>> 0) * 3;
		var buff:StringBuf = new StringBuf();
		var state:Int = 0;
		var remainder:Int = 0;
		var byte:Int;
		var enc:String;
		
		while (index < limit)
		{
			if (state == 3) state = 0;
			byte = bytes.get(index);
			switch (state)
			{
				case 0: // 2 bits left
					buff.add(this._chars[byte >>> 2]);
					remainder = byte & 3;
				case 1: // 4 bits left
					buff.add(this._chars[(remainder << 4) | byte >>> 4]);
					remainder = byte & 15;
				case 2: // 6 bits left
					buff.add(this._chars[(remainder << 2) | byte >>> 6]);
					buff.add(this._chars[byte & 63]);
			}
			state++;
			index++;
		}
		enc = buff.toString();
		this._position = index;
		switch (len - index)
		{
			case 1: // 1 byte left to encode
				byte = bytes.get(index);
				enc += this._chars[byte >>> 2];
				remainder = byte & 3;
				byte = bytes.get(index + 1);
				enc += this._chars[(remainder << 4) | byte >>> 4];
				enc += this._pad + this._pad;
				this._position++;
			case 2: // 2 bytes left to encode
				byte = bytes.get(index);
				enc += this._chars[byte >>> 2];
				remainder = byte & 3;
				byte = bytes.get(index + 1);
				enc += this._chars[(remainder << 4) | byte >>> 4];
				remainder = byte & 15;
				byte = bytes.get(index + 2);
				enc += this._chars[(remainder << 2) | byte >>> 6];
				enc += this._pad;
				this._position += 2;
			default: // we either encoded it fully, or we may need another go
		}
		this._encoded += enc;
		
		if (handler(enc))
		{
			if (this._position < len)
				this.encode(bytes, bufferSize, handler);
		}
		else
		{
			if (this._position < len)
			{
				this._bytes = bytes;
				this._bufSize = bufferSize;
				this._handler = handler;
				Timer.delay(this.timerDelay, 10);
			}
		}
	}
	
	private function timerDelay():Void
	{
		this.encode(this._bytes, this._bufSize, this._handler);
	}
	
	public function flush():String
	{
		var ret:String = this._encoded;
		this._encoded = null;
		this._position = 0;
		this._bytes = null;
		this._handler = null;
		return ret;
	}
}