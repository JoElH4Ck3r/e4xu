package org.wvxvws.encoding 
{
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class SWFUtils 
	{
		
		public function SWFUtils() { super(); }
		
		/**
		 * HasScale 						UB[1] Has scale values if equal to 1.
		 * NScaleBits If HasScale = 1, 		UB[5] Bits in each scale value field.
		 * ScaleX If HasScale = 1, 			FB[NScaleBits] x scale value.
		 * ScaleY If HasScale = 1, 			FB[NScaleBits] y scale value.
		 * 
		 * HasRotate 						UB[1] Has rotate and skew values if equal to 1.
		 * NRotateBits If HasRotate = 1, 	UB[5] Bits in each rotate value field.
		 * RotateSkew0 If HasRotate = 1, 	FB[NRotateBits] First rotate and skew value.
		 * RotateSkew1 If HasRotate = 1, 	FB[NRotateBits] Second rotate and skew value.
		 * 
		 * NTranslateBits 					UB[5] Bits in each translate value field.
		 * TranslateX 						SB[NTranslateBits] x translate value in twips.
		 * TranslateY 						SB[NTranslateBits] y translate value in twips.
		 * 
		 * @param	matrix
		 * @return
		 */
		public static function writeMatrix(matrix:Matrix):ByteArray
		{
			var hasScale:Boolean = matrix.a !== 1 || matrix.d !== 1;
			var hasRotate:Boolean = matrix.c !== 0 || matrix.b !== 0;
			
			var ba:ByteArray = new ByteArray();
			//ba.endian = Endian.LITTLE_ENDIAN;
			var byteString:String = "";
			var writeHelper:int;
			var i:int;
			
			var scaleBits:int;
			var rotateBits:int;
			var translateBits:int;
			
			var scaleX:Number = matrix.a;
			var scaleXS:String = "";
			var scaleXSR:String;
			var scaleY:Number = matrix.d;
			var scaleYS:String = "";
			var scaleYSR:String;
			
			if (hasScale)
			{
				if (scaleX < 0)
				{
					scaleXS = uint(scaleX * 0x10000).toString(2)
					scaleXS = scaleXS.substr(scaleXS.length - 16);
					scaleXSR = Math.floor(Math.abs(scaleX)).toString(2);
					if (scaleXSR === "0")
					{
						scaleXS = "1" + scaleXS;
					}
					else
					{
						scaleXS = "1" + scaleXSR + scaleXS;
					}
				}
				else
				{
					scaleXS = (scaleX * 0x10000).toString(2);
					while (scaleXS.length < 16) scaleXS = "0" + scaleXS;
					scaleXS = Math.floor(scaleX).toString(2) + scaleXS;
				}
				
				if (scaleY < 0)
				{
					scaleYS = uint(scaleY * 0x10000).toString(2)
					scaleYS = scaleYS.substr(scaleYS.length - 16);
					scaleYSR = Math.floor(Math.abs(scaleY)).toString(2);
					if (scaleYSR === "0")
					{
						scaleYS = "1" + scaleYS;
					}
					else
					{
						scaleYS = "1" + scaleYSR + scaleYS;
					}
				}
				else
				{
					scaleYS = (scaleY * 0x10000).toString(2);
					while (scaleYS.length < 16) scaleYS = "0" + scaleYS;
					scaleYS = Math.floor(scaleY).toString(2) + scaleYS;
				}
				
				scaleBits = Math.max(scaleXS.length, scaleYS.length);
				
				while (scaleXS.length < scaleBits) scaleXS = "0" + scaleXS;
				while (scaleYS.length < scaleBits) scaleYS = "0" + scaleYS;
				byteString += "1" + toFixedBin(scaleBits, 5) + scaleXS + scaleYS;
			}
			else
			{
				byteString += "0";
			}
			
			var rotateSkew0:Number = matrix.b;
			var rotateSkew0S:String = "";
			var rotateSkew0SR:String;
			var rotateSkew1:Number = matrix.c;
			var rotateSkew1S:String = "";
			var rotateSkew1SR:String;
			
			if (hasRotate)
			{
				if (rotateSkew0 < 0)
				{
					rotateSkew0S = uint(rotateSkew0 * 0x10000).toString(2)
					rotateSkew0S = rotateSkew0S.substr(rotateSkew0S.length - 16);
					rotateSkew0SR = Math.floor(Math.abs(rotateSkew0)).toString(2);
					if (rotateSkew0SR === "0")
					{
						rotateSkew0S = "1" + rotateSkew0S;
					}
					else
					{
						rotateSkew0S = "1" + rotateSkew0SR + rotateSkew0S;
					}
				}
				else
				{
					rotateSkew0S = (rotateSkew0 * 0x10000).toString(2);
					while (rotateSkew0S.length < 16) rotateSkew0S = "0" + rotateSkew0S;
					rotateSkew0S = Math.floor(rotateSkew0).toString(2) + rotateSkew0S;
				}
				
				if (rotateSkew1 < 0)
				{
					rotateSkew1S = uint(rotateSkew1 * 0x10000).toString(2)
					rotateSkew1S = rotateSkew1S.substr(rotateSkew1S.length - 16);
					rotateSkew1SR = Math.floor(Math.abs(rotateSkew1)).toString(2);
					if (rotateSkew1SR === "0")
					{
						rotateSkew1S = "1" + rotateSkew1S;
					}
					else
					{
						rotateSkew1S = "1" + rotateSkew1SR + rotateSkew1S;
					}
				}
				else
				{
					rotateSkew1S = (rotateSkew1 * 0x10000).toString(2);
					while (rotateSkew1S.length < 16) rotateSkew1S = "0" + rotateSkew1S;
					rotateSkew1S = Math.floor(rotateSkew1).toString(2) + rotateSkew1S;
				}
				
				rotateBits = Math.max(rotateSkew0S.length, rotateSkew1S.length);
				
				while (rotateSkew0S.length < rotateBits) 
						rotateSkew0S = "0" + rotateSkew0S;
				while (rotateSkew1S.length < rotateBits) 
						rotateSkew1S = "0" + rotateSkew1S;
				byteString += "1" + toFixedBin(rotateBits, 5) + rotateSkew0S + rotateSkew1S;
			}
			
			var translateX:uint = matrix.tx * 20;
			var translateXS:String = "";
			var translateY:uint = matrix.ty * 20;
			var translateYS:String = "";
			if (!translateX && !translateY)
			{
				translateBits = 0;
				byteString += "0";
			}
			else
			{
				translateXS = translateX.toString(2);
				if (matrix.tx > 0 && translateXS.charAt() == "1")
				{
					translateXS = "0" + translateXS;
				}
				translateYS = translateY.toString(2);
				if (matrix.ty > 0 && translateYS.charAt() == "1")
				{
					translateYS = "0" + translateYS;
				}
				translateBits = Math.max(translateXS.length, translateYS.length);
				while (translateXS.length < translateBits)
						translateXS = "0" + translateXS;
				while (translateYS.length < translateBits)
						translateYS = "0" + translateYS;
				trace(toFixedBin(translateBits, 5) + translateXS + translateYS);
				byteString += toFixedBin(translateBits, 5) + translateXS + translateYS;
			}
			if (byteString.length < 6) ba.writeByte(0);
			else
			{
				while (byteString.length % 8) byteString += "0";
				writeHelper = byteString.length;
				while (i < writeHelper)
				{
					ba.writeByte(parseInt(byteString.substr(i, 8), 2));
					i += 8;
				}
			}
			return ba;
		}
		
		private static function toFixedBin(input:uint, size:uint):String
		{
			var s:String = input.toString(2);
			if (s.length < size) while (s.length < size) s = "0" + s;
			else s = s.substr(s.length - size);
			return s;
		}
	}
}