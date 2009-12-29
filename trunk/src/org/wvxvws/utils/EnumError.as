package org.wvxvws.utils 
{
	/**
	 * EnumError class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class EnumError extends Error
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function EnumError() { super("This enum vas already initialized"); }
	}
}