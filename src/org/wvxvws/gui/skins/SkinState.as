package org.wvxvws.gui.skins
{
	/**
	 * SkinState enum.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SkinState
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const UP:SkinState = new SkinState("up");
		
		public static const OVER:SkinState = new SkinState("over");
		
		public static const DOWN:SkinState = new SkinState("down");
		
		public static const DISABLED:SkinState = new SkinState("disabled");
		
		public static const SELECTED:SkinState = new SkinState("selected");
		
		public static const DISABLED_SELECTED:SkinState = 
										new SkinState("disabledSelected");
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _lockUp:Boolean;
		private var _num:String;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * All instance of this enum are created at the application initialization time.
		 * Users should not create additional instances.
		 * 
		 * @param	num		The string key to represent this instance.
		 */
		public function SkinState(num:String)
		{
			super();
			if (_lockUp) 
				throw new Error("This application domain already initialized this enum.");
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
import org.wvxvws.gui.skins.SkinState;
SkinState.lockUp();