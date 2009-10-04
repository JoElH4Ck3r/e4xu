package org.wvxvws.mapping 
{
	//{ imports
	
	//}
	/**
	 * Delegate class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class Delegate
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _argumentTypes:Vector.<Class>;
		protected var _returnType:Class;
		protected var _delegate:Function;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function Delegate(delegate:Function, 
								argumentTypes:Vector.<Class>, returnType:Class) 
		{
			super();
			_argumentTypes = argumentTypes.concat();
			_returnType = returnType;
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function toFunction():Function { return _delegate; }
		
		public static function toDelegate(delegate:Function, 
								argumentTypes:Vector.<Class>, returnType:Class, 
								delegateClass:Class):Delegate
		{
			return new delegateClass(delegate, argumentTypes, returnType);
		}
		
		public function call(context:Object, ...args):*
		{
			return _delegate.apply(context, args);
		}
		
		public function apply(context:Object, args:Array):*
		{
			return _delegate.apply(context, args);
		}
		
		public function get argumentTypes():Vector.<Class>
		{
			return _argumentTypes.concat();
		}
		
		public function get returnType():Class { return _returnType; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}