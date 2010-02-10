package org.wvxvws.signals 
{
	/**
	 * SignalError class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SignalError extends Error
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Abstract class.
		 */
		public static const ABSTRACT_CLASS:SignalError = 
			new SignalError("Abstract class.");
		
		/**
		 * Signal type not found.
		 */
		public static const NO_TYPE:SignalError = 
			new SignalError("Signal type not found.");
		
		/**
		 * Attempting to call slot with wrong signature.
		 */
		public static const WRONG_SIGNATURE:SignalError = 
			new SignalError("Attempting to call slot with wrong signature.");
		
		/**
		 * This kind has already been used.
		 */
		public static const KIND_REGISTERED:SignalError = 
			new SignalError("This kind has already been used.");
			
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _lockUp:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * All instance of this enum are created at the application initialization time.
		 * Users should not create additional instances.
		 *  
		 * @param	num		The string key to represent this instance.
		 */
		public function SignalError(message:String)
		{
			super(message);
			if (_lockUp) throw new Error("Illegal enumerator instance.");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function lockUp():void { _lockUp = true; }
		
		/**
		 * Decorates this enumerator with the name assigned to it.
		 * 
		 * @return the name assigned to this enumerator.
		 */
		public function toString():String { return super.message; }
		
		/**
		 * We may need to compare enums to their string represenation using non-strict equality.
		 * This will allow non-strict comparison to succeed.
		 * 
		 * @return the string value wrapped by this enum instance.
		 */
		public function valueOf():Object { return super.message; }
	}
}
import org.wvxvws.signals.SignalError;
SignalError.lockUp();