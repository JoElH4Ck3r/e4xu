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
		public static const INVALID_DEFINE:CSSError = new CSSError("Invalid define");
		public static const INVALID_KEYWORD:CSSError = new CSSError("Invalid keyword");
		
		public function CSSError(message:String) { super(message); }
		
	}
}