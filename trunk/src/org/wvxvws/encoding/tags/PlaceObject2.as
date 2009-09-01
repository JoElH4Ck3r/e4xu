package org.wvxvws.encoding.tags 
{
	import flash.utils.ByteArray;
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class PlaceObject2 extends SWFTag
	{
		//{ flags
		/**
		 * UB[1] SWF 5 or later: has clip actions (sprite characters only).
		 * Otherwise: always 0.
		 */
		public var placeFlagHasClipActions:Boolean;
		
		/**
		 * UB[1] Has clip depth.
		 */
		public var placeFlagHasClipDepth:Boolean;
		
		/**
		 * UB[1] Has name.
		 */
		public var placeFlagHasName:Boolean;
		
		/**
		 * UB[1] Has ratio.
		 */
		public var placeFlagHasRatio:Boolean;
		
		/**
		 * UB[1] Has color transform.
		 */
		public var placeFlagHasColorTransform:Boolean;
		
		/**
		 * UB[1] Has matrix.
		 */
		public var placeFlagHasMatrix:Boolean;
		
		/**
		 * UB[1] Places a character.
		 */
		public var placeFlagHasCharacter:Boolean;
		
		/**
		 * UB[1] Defines a character to be moved.
		 */
		public var placeFlagMove:Boolean;
		//}
		
		/**
		 * UI16 Depth of character.
		 */
		public var depth:uint;
		
		//{ optional
		/**
		 * If PlaceFlagHasCharacter UI16 ID of character to place.
		 */
		public var characterId:uint;
		
		/**
		 * If PlaceFlagHasMatrix MATRIX Transform matrix data.
		 */
		public var matrix:ByteArray;
		
		/**
		 * If PlaceFlagHasColorTransform CXFORMWITHALPHA Color transform data.
		 */
		public var colorTransform:ByteArray;
		
		/**
		 * If PlaceFlagHasRatio UI16 Name If PlaceFlagHasName STRING Name of character.
		 */
		public var ratio:uint;
		
		/**
		 * If PlaceFlagHasName STRING Name of character.
		 */
		public var name:String;
		
		/**
		 * If PlaceFlagHasClipDepth UI16 Clip depth (see Clipping layers).
		 */
		public var clipDepth:uint;
		
		/**
		 * If PlaceFlagHasClipActions CLIPACTIONS SWF 5 or later: Clip Actions Data.
		 */
		public var clipActions:ByteArray;
		//}
		
		public function PlaceObject2()  { super(26); }
		
		// |                          |          |          |                | (a=1, b=0, c=0, d=1,  |                  |
		// |                          | 00000110 |          |                | tx=159.95000000000002,|                  |
		// |                          |          |          |                | ty=120)               |                  |
		// |--------------------------|----------|----------|----------------|-----------------------|------------------|
		// |         \x8A\x06         |   \x06   | \x01\x00 |    \x01\x00    | \x1A\xC7\xF4\xB0\x00  |                  |
		// |--------------------------|----------|----------|----------------|-----------------------|------------------|
		// |                          |          |          |                |(a=0.7071075439453125, |                  |
		// |                          |          |          |                | b=0.7071075439453125, |                  |
		// |                          |          |          |                | c=-0.7071075439453125,|                  |
		// |                          | 00100110 |          |                | d=0.7071075439453125, |                  |
		// |                          |          |          |                | tx=291.7,             |                  |
		// |                          |          |          |                | ty=42.050000000000004)|                  |
		// |--------------------------|----------|----------|----------------|-----------------------|------------------|
		// | \xBF\x06\x18\x00\x00\x00 |   \x26   | \x01\x00 |    \x01\x00    | \xC5\x6A\x0A\xB5\x05  | \x66\x6F\x6F\x00 |
		// |                          |          |          |                | \xC5\x6A\x0B\x4A\xFB  |                  |
		// |                          |          |          |                | \x72\xD9\x41\xA4\x80  |                  |
		// |--------------------------|----------|----------|----------------|-----------------------|------------------|
		// |                          |          |          |                | (a=1, b=0, c=0, d=-2, |                  |
		// |                          |          |          |                | tx=159.95000000000002,|                  |
		// |                          |          |          |                | ty=480)               |                  |
		// |--------------------------|----------|----------|----------------|-----------------------|------------------|
		// | \xBF\x06\x13\x00\x00\x00 |   \x26   | \x01\x00 |    \x01\x00    | \xCC\x80\x00\x60\x00  | \x66\x6F\x6F\x00 |
		// |                          |          |          |                | \x03\xC6\x3F\xA5\x80  |                  |
		// |                          |          |          |                |                       |                  |
		// |                          |          |          |                |                       |                  |
		// |------- define tag -------|- flags  -|-- depth -|- character id -|------- matrix --------|------ name ------|
		// |---------------------------------------------|
		// | MATRIX                                      |
		// |         a                 d                 |
		// | 1 10001 01011010100000101 01011010100000101 |
		// |         b                 c                 |
		// | 1 10001 01011010100000101 10100101011111011 |
		// |         tx                ty                |
		// | 01110   01011011001010    00001101001001    | remainder: 0000000
		// |---------------------------------------------|
		// | MATRIX                                            |
		// |         a=1                   d=-2                |
		// | 1 10011 0010000000000000000   1100000000000000000 |
		// |         b=0                   c=0                 |
		// | 0                                                 |
		// |         tx=159.95000000000002 ty=480              |
		// | 01111   000110001111111       010010110000000     |
		protected override function compileTagParams():void
		{
			var flags:int = (((((((((((((int(placeFlagHasClipActions) << 1) | 
										int(placeFlagHasClipDepth)) << 1) | 
										int(placeFlagHasName)) << 1) | 
										int(placeFlagHasRatio)) << 1) | 
										int(placeFlagHasColorTransform)) << 1) | 
										int(placeFlagHasMatrix)) << 1) | 
										int(placeFlagHasCharacter)) << 1) | 
										int(placeFlagMove);
			
			_data.writeByte(flags);
			_data.writeShort(depth);
			
			if (placeFlagHasCharacter) _data.writeShort(characterId);
			if (placeFlagHasMatrix) _data.writeBytes(matrix);
			if (placeFlagHasColorTransform) _data.writeBytes(colorTransform);
			if (placeFlagHasRatio) _data.writeShort(ratio); //*
			if (placeFlagHasName)
			{
				_data.writeUTFBytes(name);
				_data.writeByte(0);
			}
			if (placeFlagHasClipDepth) _data.writeShort(clipDepth);
			if (placeFlagHasClipActions) _data.writeBytes(clipActions);
		}
	}

}