package org.wvxvws.encoding.tags 
{
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * SetBackgroundColor class.
	 * @author wvxvw
	 */
	public class SetBackgroundColor extends SWFTag
	{
		public var color:uint; //U24
		
		public function SetBackgroundColor() { super(9); }
		
	}
	
}