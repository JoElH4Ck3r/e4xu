package org.wvxvws.automation.types
{
	import flash.utils.ByteArray;
	
	import org.wvxvws.automation.language.Atom;
	
//	 It is probably not atom, I'll need to find out which one it is.
	
//	(sb-mop:class-direct-superclasses (class-of #*10101))
//	(#<BUILT-IN-CLASS BIT-VECTOR> #<BUILT-IN-CLASS SIMPLE-ARRAY>)
//	
//	(class-of #*10101)
//	#<BUILT-IN-CLASS SIMPLE-BIT-VECTOR>
//	
//	(sb-mop:class-direct-superclasses (find-class 'simple-array))
//	(#<BUILT-IN-CLASS ARRAY>)
//	
//	(sb-mop:class-direct-superclasses (find-class 'array))
//	(#<BUILT-IN-CLASS T>)
//	
//	(sb-mop:class-direct-superclasses (find-class 'bit-vector))
//	(#<BUILT-IN-CLASS VECTOR>)
//	
//	(sb-mop:class-direct-superclasses (find-class 'vector))
//	(#<BUILT-IN-CLASS ARRAY> #<BUILT-IN-CLASS SEQUENCE>)
//	
//	(sb-mop:class-direct-superclasses (find-class 'sequence))
//	(#<BUILT-IN-CLASS T>)

	public class $BitVector extends Atom
	{
		private static const _zeros:String = "00000000";
		
		public function $BitVector(parseFrom:String)
		{
			super(parseFrom, $BitVector, makeVector(parseFrom));
		}
		
		private static function makeVector(parseFrom:String):ByteArray
		{
			var result:ByteArray = new ByteArray();
			var remainder:int = parseFrom.length - ((parseFrom.length >>> 3) << 3);
			var i:int;
			
			if (remainder)
			{
				result.writeByte(parseInt(parseFrom.substr(0, remainder), 2));
				parseFrom = parseFrom.substr(remainder);
			}
			while (i < parseFrom.length)
			{
				result.writeByte(parseInt(parseFrom.substr(i, 8), 2));
				i += 8;
			}
			return result;
		}
		
		public override function toString():String
		{
			var result:String = "";
			var len:int = (this._value as ByteArray).length;
			var filler:String;
			
			if (len)
			{
				result = this._value[0].toString(2);
				for (var i:int = 1; i < len; i++)
				{
					filler = this._value[i].toString(2);
					if (filler.length < 8)
						result += _zeros.substr(8 - filler.length) + filler;
					else result += filler;
				}
			}
			return "#*" + result;
		}
	}
}