package org.wvxvws.profiler 
{
	//{ imports
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
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
		".1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_";
		
		private var _s:ByteArray = new ByteArray();
		private var _st:Object = { };
		private var _sh:Object = { };
		private var _si:int;
		private var _libE:Object = { };
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates new encoder.<br/>
		 * <strong>Encoding Technique</strong><br/><br/>
		 * <strong><i>Integers</i></strong>
		 * <code>UI29</code>
		 * <pre>
		 * ┌─────────────────────────┬─────────────────────────────────────┐
		 * │          (hex)          │              (binary)               │
		 * ├─────────────────────────┼─────────────────────────────────────┤
		 * │ 0x00000000 - 0x0000007F │ 0xxxxxxx                            │
		 * │ 0x00000080 - 0x00003FFF │ 1xxxxxxx 0xxxxxxx                   │
		 * │ 0x00004000 - 0x001FFFFF │ 1xxxxxxx 1xxxxxxx 0xxxxxxx          │
		 * │ 0x00200000 - 0x1FFFFFFF │ 1xxxxxxx 1xxxxxxx 1xxxxxxx xxxxxxxx │
		 * │ 0x20000000 - 0xFFFFFFFF │ Not Allowed                         │
		 * └─────────────────────────┴─────────────────────────────────────┘
		 * </pre>
		 * Other integers follow regular ABNF syntax.
		 * 
		 * <strong><i>String Base6 (Str6)</i></strong>
		 * Encodes anly these characters:
		 * <code>.1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_</code>
		 * Each character is assigned an ID 0 to 111111 (binary) or 0x3F (hex). Then
		 * written in a way they may not necessary form whole bytes.
		 * Dot (000000 binary) character may occur only once sequentially. Two dots
		 * occuring in subsequence will signal the termination of the string. 
		 * Strings may not necessarilly terminate with double dots, if the length is know
		 * beforehand.
		 * <i>Example:</i>
		 * <pre>
		 * ┌──────────┬──────────┬──────────┬────────┐
		 * │ xxxxxxoo │ ooooxxxx │ xxoooooo │ xxxxxx │
		 * ├──────────┼──────────┼──────────┼────────┤
		 * │ 11001111 │ 01101011 │ 00000000 │ 111011 │
		 * ├───────┬──┴─────┬────┴───┬──────┼────────┤
		 * │   o   │    r   │    g   │   .  │    w   │
		 * └───────┴────────┴────────┴──────┴────────┘
		 * </pre>
		 * 
		 * <strong><i>Message Structure</i><strong>
		 * <i>Library</i>
		 * <i>If library is present, the message will start with 8 zero bits</i>
		 * <code>ID - UI29</code>
		 * <code>Offset (not including the library) - UI29</code>
		 * <code>UB8 - allways 0 (the end of the library)</code>
		 * <i>Messages Stack</i>
		 * <code>[Message 1] [Message 2] [Message 3] ... [Message N]</code>
		 * <i>Message</i>
		 * <code>UI29 - number of instances</code>
		 * <code>UI29 - memory usage</code>
		 * <code>Str6 or alias to Str6 - the class name</code>
		 * <i>Alias to Str6</i>
		 * <code>UI29 - the ID in the cache table</code>
		 * <code>UI29 - the offset into the message stack (not including the library)</code>
		 */
		public function PEncoder()
		{
			super();
			for (var i:int; i < 64; i++) this._st[A.charAt(i)] = i;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Adds a message to the stack of messages to be sent.
		 * 
		 * @param	mes The message to be sent. 
		 * 			<i><font color="red">Doesn't handle international 
		 * 			characters in the class names</font></i>.
		 * 
		 * @throws	<code>TypeError: Error #1009: Cannot access a property or 
		 * 			method of a null object reference.</code>
		 * 			If message is null.
		 * @throws	<code>Max length exceeded!</code> If either <code>size</code> 
		 * 			or <code>mem</code> properties of the message exceede 0-0x1FFFFFFF range.
		 */
		public function write(mes:PMessage):void
		{
			var first:Boolean = Boolean(this._s.length);
			this.eUInt29(mes.size);
			this.eUInt29(mes.mem);
			// TODO: We need to check that the class name doesn't contain $
			// or international charachters. If it does, this method will not work
			// and if it does, we should pad the content of the string by 12 zero bits
			// and put the flags in the remaining 4 bits so we know what 
			// how the content was encoded.
			this.eStr6(getQualifiedClassName(mes.type).split("::").join("."));
			if (!first) this._s.writeShort(0);
		}
		
		/**
		 * Clears the content of the encoder, adds library and all the messages
		 * currently on stack to a ByteArray and returns it.
		 * 
		 * @return	The ByteArray containing the library and messages stack.
		 */
		public function flush():ByteArray
		{
			var lba:ByteArray = new ByteArray();
			lba.writeByte(0);
			var src:ByteArray = this._s;
			var le:LibEntry;
			
			this._s = lba;
			for (var p:String in this._libE)
			{
				le = this._libE[p] as LibEntry;
				if (le.used) continue;
				le.used = true;
				this.eUInt29(le.id);
				this.eUInt29(le.pos);
			}
			lba.writeByte(0);
			lba.writeBytes(src);
			this._s = new ByteArray();
			return lba;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private	Creates new or returns an unused <code>LibEntry</code> object.
		 * 
		 * @param	pos	The offset into the messages stack body ByteArray.
		 * 
		 * @param	id	The unique identifier to be assigned to this entry.
		 * 
		 * @return	New or recycled <code>LibraryEntry</code> object.
		 */
		private function libEntry(pos:int, id:int):LibEntry
		{
			var le:LibEntry;
			for (var p:String in this._libE)
			{
				le = this._libE[p] as LibEntry;
				if (le.used)
				{
					le.pos = pos;
					le.id = id;
					le.used = false;
					return le;
				}
			}
			le = new LibEntry(pos, id);
			this._libE[id] = le;
			return le;
		}
		
		// TODO: There seems to be an issue with the last character not always fully 
		// written. However, this may be the decoder's problem.
		
		/**
		 * @private	Encodes ANSI string using 6 bits per character.
		 * 
		 * @param	input	The string to encode.
		 * 
		 * @see #PEncoder()
		 */
		private function eStr6(input:String):void
		{
			var c:int;
			var len:int;
			var rel:int;
			var b:int;
			var shift:int;
			var le:LibEntry;
			
			if (input in this._sh)
			{
				this._s.writeShort(0);
				le = this._sh[input] as LibEntry;
				this.eUInt29(le.id);
				this.eUInt29(le.pos);
			}
			else
			{
				len = input.length;
				// no point in aliasing short strings
				if (len > 3) 
					this._sh[input] = this.libEntry(this._s.position, ++this._si);
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
		
		/**
		 * @private	Encodes an integer to the variable length UI29.
		 * 
		 * @param	input	The integer to be encoded. 
		 * 			Note, signed integers are treated as unsigned.
		 * 
		 * @see	#PEncoder()
		 */
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