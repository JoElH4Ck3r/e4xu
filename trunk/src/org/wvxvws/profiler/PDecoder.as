package org.wvxvws.profiler 
{
	//{ imports
	import flash.system.ApplicationDomain;
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
		".1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_";
		
		private var _s:ByteArray;
		private var _st:Array/*String*/ = [];
		private var _sh:Object = { };
		private var _si:int;
		private var _libE:Object = { };
		private var _libSize:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PDecoder() 
		{
			super();
			for (var i:int; i < 64; i++) this._st[i] = A.charAt(i);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function read(input:ByteArray):Array/*PMessage*/
		{
			this._s = input;
			var b:int = this.dUInt29();
			var size:int;
			if (b) size = b;
			else
			{
				this.dLib();
				size = this.dUInt29();
			}
			var mem:int = this.dUInt29();
			var type:String = this.dStr6();
			var m:PMessage = new PMessage(
				ApplicationDomain.currentDomain.getDefinition(
				type) as Class, size, mem);
			var ret:Array = [m];
			while (this._s.bytesAvailable > 3) ret.push(this.dMessage());
			return ret;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function dLib():void
		{
			var i:uint;
			var p:uint;
			
			while (this._s.bytesAvailable)
			{
				i = this.dUInt29();
				if (!i)
				{
					this._libSize = this._s.position;
					break;
				}
				p = this.dUInt29();
				this._libE[i] = new LibEntry(p, i);
			}
		}
		
		private function dMessage():PMessage
		{
			var size:int = this.dUInt29();
			var mem:int = this.dUInt29();
			var type:String = this.dStr6();
			return new PMessage(
				ApplicationDomain.currentDomain.getDefinition(
				type) as Class, size, mem);
		}
		
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
			var start:int;
			var word:String;
			var le:LibEntry;
			
			// TODO: We have 4 last bits of this 16-bit int to put flags for UTF-8
			// and maybe ANSI string encodings
			if (!b) // cached
			{
				c = this.dUInt29();
				this.dUInt29();
				return this._sh[c];
			}
			else
			{
				this._s.position -= 2;
				start = this._s.position - this._libSize;
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
			word = chars.join("");
			if (word.length > 2 && !this._sh[word]) // we haven't mapped this one yet
			{
				for (var p:String in this._libE)
				{
					le = this._libE[p] as LibEntry;
					if (le.pos == start)
					{
						this._sh[le.id] = word;
						break;
					}
				}
			}
			return word;
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