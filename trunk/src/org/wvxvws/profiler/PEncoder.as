package org.wvxvws.profiler 
{
	//{ imports
	import flash.utils.ByteArray;
	//}
	
	/**
	 * PEncoder class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class PEncoder
	{
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private const A:String = 
		".1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		
		private var _s:ByteArray = new ByteArray();
		private var _st:Object = { };
		private var _sh:Object = { };
		private var _si:int;
		
		private var _p:int;
		private var _bp:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PEncoder()
		{
			super();
			for (var i:int; i < 63; i++) this._st[A.charAt(i)] = i;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function write(mes:PMessage):ByteArray
		{
			this.eUInt29(mes.size);
			this.eUInt29(mes.mem);
			this.eStr6(mes.type);
			this._s.position = 0;
			return this._s;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function eStr6(input:String):void
		{
			var c:int;
			var len:int;
			var rel:int;
			var b:int;
			var shift:int;
			input = input.replace(/[^\.\$\w]+/g, ".");
			
			if (input in this._sh)
			{
				this._s.writeShort(0);
				this.eUInt29(this._sh[input]);
			}
			else
			{
				len = input.length;
				// no point in aliasing short strings
				if (len > 2) this._sh[input] = ++this._si;
				len *= 6;
				for (var i:int; i < len; i += 6)
				{
					shift = i % 8;
					c = this._st[input.charAt(int(i / 6))];
					switch (shift)
					{
						case 0:
							b = c << 2;
							this._s.writeByte(b);
							break;
						case 2:
							this._s.writeByte(b | c);
							break;
						case 4:
							this._s.writeByte(b | (c >>> 2));
							b = (c & 3) << 6;
							break;
						case 6:
							this._s.position--;
							this._s.writeByte(b | (c >>> 4));
							b = (c & 0xF) << 4;
							break;
					}
				}
			}
		}
		
		private function eUInt29(input:int):void
		{
			switch (true)
			{
				case (!(input & 0xFFFFFF80)): // 1 byte
					this._s.writeByte(input); // writing bits 1-7
					break;
				case (!(input & 0xFFFFC000)): // 2 bytes
					this._s.writeByte(0x80 | int(input >>> 7)); // writing bits 1-7
					this._s.writeByte(input & 0x7F); // writing bits 8-14
					break;
				case (!(input & 0xFFE00000)): // 3 bytes
					this._s.writeByte(0x80 | int(input >>> 14)); // writing bits 1-7
					this._s.writeByte(0x80 | int(int(input >>> 7) & 0x7F)); // writing bits 8-14
					this._s.writeByte(input & 0x7F); // writing bits 15-21
					break;
				case (!(input & 0xE0000000)): // 4 bytes
					this._s.writeByte(0x80 | int(input >>> 22)); // writing bits 1-7
					this._s.writeByte(0x80 | int(int(input >>> 15) & 0x7F)); // writing bits 8-14
					this._s.writeByte(0x80 | int(int(input >>> 8) & 0x7F)); // writing bits 15-21
					this._s.writeByte(input & 0xFF); // writing bits 22-29
					break;
				default: throw "Max length exceeded!";
			}
		}
	}
}