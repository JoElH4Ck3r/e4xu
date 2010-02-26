package org.wvxvws.css
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class CSSError extends Error
	{
		public static const INVALID_NAME:CSSError = new CSSError("Invalid name");
		public static const INVALID_IMPORT:CSSError = new CSSError("Invalid import");
		
		public function CSSError(message:String) { super(message); }
		
	}
}