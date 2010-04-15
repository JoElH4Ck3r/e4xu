package org.wvxvws.profiler 
{
	/**
	 * LibEntery class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class LibEntry
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public var pos:int;
		public var id:int;
		public var used:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function LibEntry(pos:int, id:int)
		{
			super();
			this.pos = pos;
			this.id = id;
		}
	}
}