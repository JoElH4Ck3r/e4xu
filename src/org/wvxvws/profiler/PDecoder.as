package org.wvxvws.profiler 
{
	//{ imports
	import flash.utils.ByteArray;
	//}
	
	/**
	 * PDecoder class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class PDecoder
	{
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private const A:String = 
		".1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		
		private var _s:ByteArray;
		private var _st:Array/*String*/ = [];
		private var _sh:Object = { };
		private var _si:int;
		
		private var _p:int;
		private var _bp:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PDecoder() 
		{
			super();
			for (var i:int; i < 63; i++) this._st[i] = A.charAt(i);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function read(input:ByteArray):PMessage
		{
			this._s = input;
			var size:int = this.dUInt29();
			var mem:int = this.dUInt29();
			var type:String = this.dStr6();
			return new PMessage(type, size, mem);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function dStr6():String
		{
			var b:int = this._s.readUnsignedShort();
			var rel:int;
			var hasDot:Boolean;
			var c:int;
			var wc:int;
			var len:int;
			var chars:Array/*String*/;
			var shift:int;
			
			if (!b) // cached
			{
				chars = [];
			}
			else
			{
				this._s.position -= 2;
				len = this._s.length;
				chars = [];
				readLabel: while (this._s.bytesAvailable)
				{
					b = this._s.readUnsignedByte();
					if (hasDot && !b)
					{
						if (chars[chars.length - 1] == ".") chars.pop();
						break;
					}
					switch (shift)
					{
						case 0:
							wc = b >>> 2;
							chars.push(this._st[wc]);
							shift = 4;
							c = int(b & 3) << 4;
							break;
						case 2:
							wc = c | int(b >>> 6);
							chars.push(this._st[wc]);
							hasDot = wc == 0;
							shift = 0;
							wc = b & 0x3F;
							if (hasDot && !wc)
							{
								if (chars[chars.length - 1] == ".") chars.pop();
								break readLabel;
							}
							chars.push(this._st[wc]);
							break;
						case 4:
							wc = c | int(b >>> 4);
							chars.push(this._st[wc]);
							c = (b & 0xF) << 2;
							shift = 2;
					}
					hasDot = wc == 0;
				}
			}
			return chars.join("");
		}
		
		private function dUInt29():uint
		{
			var b:uint = this._s.readUnsignedByte();
			var sum:uint;
			// 1 byte
			if (!(b >>> 7)) return b;
			sum = b & 0x7F;
			sum <<= 7;
			b = this._s.readUnsignedByte();
			// 2 bytes
			if (!(b >>> 7))
			{
				sum |= int(b & 0x7F);
				return sum;
			}
			sum |= int(b & 0x7F);
			sum <<= 7;
			b = this._s.readUnsignedByte();
			// 3 bytes
			if (!(b >>> 7))
			{
				sum |= int(b & 0x7F);
				return sum;
			}
			// 4 bytes
			sum |= (b & 0x7F);
			sum <<= 8;
			b = this._s.readUnsignedByte();
			return sum | b;
		}
	}
}