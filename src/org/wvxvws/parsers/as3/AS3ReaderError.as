package org.wvxvws.parsers.as3 
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class AS3ReaderError extends Error
	{
		public function get line():int { return this._line; }
		
		public function get column():int { return this._column; }
		
		private var _line:int;
		private var _column:int;
		
		public function AS3ReaderError(message:String, line:int, column:int)
		{
			super(message.replace(/%line%/g, line).replace(/%column%/g, column));
			this._column = column;
			this._line = line;
		}
	}
}