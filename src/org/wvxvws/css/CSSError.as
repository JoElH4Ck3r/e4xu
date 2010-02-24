package  
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class CSSError extends Error
	{
		public static const INVALID_NAME:CSSError = new CSSError("Invalid name");
		
		public function CSSError(message:String) { super(message); }
		
	}
}