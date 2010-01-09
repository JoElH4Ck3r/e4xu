package org.wvxvws.data 
{
	//{ imports
	import org.wvxvws.utils.EnumError;
	//}
	
	/**
	 * SetEventType class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion $(playerVersion)
	 */
	public class SetEventType 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const ADD:SetEventType = new SetEventType("add");
		public static const REMOVE:SetEventType = new SetEventType("remove");
		public static const CHANGE:SetEventType = new SetEventType("change");
		public static const SORT:SetEventType = new SetEventType("sort");
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _num:String;
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
		public function SetEventType(num:String)
		{
			super();
			if (_lockUp) throw new EnumError();
			this._num = num;
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
		public function toString():String { return this._num; }
		
		/**
		 * We may need to compare enums to their string represenation using non-strict equality.
		 * This will allow non-strict comparison to succeed.
		 * 
		 * @return the string value wrapped by this enum instance.
		 */
		public function valueOf():Object { return this._num; }
	}
}
import org.wvxvws.data.SetEventType;
SetEventType.lockUp();