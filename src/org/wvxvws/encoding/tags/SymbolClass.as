package org.wvxvws.encoding.tags 
{
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * SymbolClass class.
	 * @author wvxvw
	 */
	public class SymbolClass extends SWFTag
	{
		public var numSymbols:uint;
		public var tagIDs:Array /* of uint */;
		public var classNames:Array /* of String */;
		
		public function SymbolClass() { super(76); }
		
		override protected function compileTagParams():void 
		{
			var i:int;
			var il:int = tagIDs.length;
			_data.writeShort(numSymbols);
			for (i = 0; i < il; i++)
			{
				_data.writeShort(tagIDs[i]);
				_data.writeUTFBytes(classNames[i]);
			}
		}
	}
	
}