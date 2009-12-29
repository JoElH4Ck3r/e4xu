package org.wvxvws.gui.layout 
{
	//{ imports
	import org.wvxvws.utils.EnumError;
	//}
	
	/**
	 * Invalides class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class Invalides 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const TRANSFORM:Invalides = new Invalides("transform");
		public static const BOUNDS:Invalides = new Invalides("bounds");
		public static const COLOR:Invalides = new Invalides("color");
		public static const CHILDREN:Invalides = new Invalides("children");
		public static const SCROLL:Invalides = new Invalides("scroll");
		public static const SKIN:Invalides = new Invalides("skin");
		public static const TEXT:Invalides = new Invalides("text");
		public static const AUTOSIZE:Invalides = new Invalides("autosize");
		public static const STATE:Invalides = new Invalides("state");
		public static const STYLE:Invalides = new Invalides("style");
		public static const NULL:Invalides = new Invalides("null");
		public static const TEXTFORMAT:Invalides = new Invalides("textformat");
		public static const DIRECTION:Invalides = new Invalides("direction");
		public static const TARGET:Invalides = new Invalides("target");
		
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
		public function Invalides(num:String)
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
import org.wvxvws.gui.layout.Invalides;
Invalides.lockUp();