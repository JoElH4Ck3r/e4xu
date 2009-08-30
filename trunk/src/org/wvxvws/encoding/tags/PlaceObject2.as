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
			if (placeFlagHasRatio) _data.writeShort(ratio);
			if (placeFlagHasName) _data.writeUTFBytes(name); // check!
			if (placeFlagHasClipDepth) _data.writeShort(clipDepth);
			if (placeFlagHasClipActions) _data.writeBytes(clipActions);
		}
	}
	
}