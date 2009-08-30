package org.wvxvws.lcbridge 
{
	//{imports
	import flash.events.EventDispatcher;
	//}
	
	/**
	 * Dispatched when this command's <code>operationResult</code> property is set.
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	* AVM1Command class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class AVM1Command extends EventDispatcher
	{
		public static const ERROR:int = -1;
		public static const NOOP:int = 0;
		public static const CALL_METHOD:int = 1;
		public static const SET_PROPERTY:int = 2;
		public static const LOAD_CONTENT:int = 3;
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Type of this command, either <code>AVM1Command.CALL_METHOD</code> or
		 * <code>AVM1Command.SET_PROPERTY</code>.
		 */
		public function get type():int { return _type; }
		
		/**
		 * The AVM1 context, where the method will be called or the property
		 * will be set.
		 * You can use <code>AVM1Protocol.GLOBAL</code>, <code>AVM1Protocol.THIS</code>, 
		 * <code>AVM1Protocol.ROOT</code>, <code>AVM1Protocol.CONTENT</code>, 
		 * <code>AVM1Protocol.NULL</code> as well as any string that may be evaluated 
		 * to object in the AVM1Movie using <code>eval()</code>.
		 * The <code>eval()</code> will assume the context to be 
		 * <code>AVM1Protocol.CONTENT</code>.
		 */
		public function get scope():String { return _scope; }
		
		public function set scope(value:String):void { _scope = value; }
		
		/**
		 * The name of the method to call on <code>scope</code> in the AVM1Movie.
		 */
		public function get method():String { return _method; }
		
		public function set method(value:String):void { _method = value; }
		
		/**
		 * The name of the property to set on the <code>scope</code> in the AVM1Movie.
		 */
		public function get property():String { return _property; }
		
		public function set property(value:String):void { _property = value; }
		
		/**
		 * The arguments to pass to the <code>method</code> in the AVM1Movie.
		 */
		public function get methodArguments():Array { return _methodArguments; }
		
		public function set methodArguments(value:Array):void 
		{
			_methodArguments = value;
		}
		
		/**
		 * If execution of the command will return an object, this property will
		 * reference it.
		 * This property is <code>undefined</code> until the <cod>Event.COMPLETE</code>
		 * is dispatched.
		 */
		public function get operationResult():* { return _operationResult; }
		
		public function set operationResult(value:*):void 
		{
			_operationResult = value;
		}
		
		/**
		 * The value you want to set the <code>property</code> in the AVM1Movie.
		 */
		public function get propertyValue():* { return _propertyValue; }
		
		public function set propertyValue(value:*):void { _propertyValue = value; }
		
		/**
		 * The URL of the AVM1Movie Loaded with the AVM1Loader 
		 * which establishes communication.
		 */
		public function get contentURL():String { return _contentURL; }
		
		public function set contentURL(value:String):void { _contentURL = value; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _type:int;
		protected var _scope:String;
		protected var _method:String;
		protected var _property:String;
		protected var _methodArguments:Array;
		protected var _propertyValue:*;
		protected var _operationResult:*;
		protected var _contentURL:String;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates new <code>AVM1Command</code>.
		 * 
		 * @param	type			Type of this command, either 
		 * 							<code>AVM1Command.CALL_METHOD</code> or
		 * 							<code>AVM1Command.SET_PROPERTY</code>.
		 * 
		 * @param	scope			The AVM1 context, where the method will be 
		 * 							called or the property will be set.
		 * 							You can use <code>AVM1Protocol.GLOBAL</code>, 
		 * 							<code>AVM1Protocol.THIS</code>, 
		 * 							<code>AVM1Protocol.ROOT</code>, 
		 * 							<code>AVM1Protocol.CONTENT</code>, 
		 * 							<code>AVM1Protocol.NULL</code>
		 * 							as well as any string that may be evaluated to 
		 * 							object in the AVM1Movie using <code>eval()</code>.
		 * 							The <code>eval()</code> will assume the context 
		 * 							to be <code>AVM1Protocol.CONTENT</code>.
		 * 
		 * @param	method			The name of the method to call on 
		 * 							<code>scope</code> in the AVM1Movie.
		 * @default <code>""</code>
		 * 
		 * @param	property		The name of the property to set on the 
		 * 							<code>scope</code> in the AVM1Movie.
		 * @default <code>""</code>
		 * 
		 * @param	propertyValue	The value you want to set the 
		 * 							<code>property</code> in the AVM1Movie.
		 * @default <code>undefined</code>
		 * 
		 * @param	methodArguments	The arguments to pass to the 
		 * 							<code>method</code> in the AVM1Movie.
		 * @default <code>null</code>
		 * 
		 * @throws <code>ArgumentError</code> "Must specify either method or property."
		 */
		public function AVM1Command(type:int, scope:String, method:String = "", 
								property:String = "", propertyValue:* = undefined, 
								methodArguments:Array = null, contentURL:String = "") 
		{
			super();
			if (!method && !property && (type === 1 || type === 2))
			{
				throw new ArgumentError("Must specify either method or property.");
			}
			_type = type;
			_scope = scope;
			if (_type === CALL_METHOD)
			{
				_method = method;
				_methodArguments = methodArguments;
			}
			else if (_type === SET_PROPERTY)
			{
				_property = property;
				_propertyValue = propertyValue;
			}
			else if (_type === LOAD_CONTENT)
			{
				_contentURL = contentURL;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates a strongly typed object of type AVM1Command from the object passed
		 * through LocalConnection.
		 * 
		 * @param	object	The dynamic object obtained through LocalConnection.
		 * 
		 * @return	new AVM1Command constructed from dynamic object 
		 * obtained through LocalConnection.
		 */
		public static function parseFromAMF0(object:Object):AVM1Command
		{
			var cmd:AVM1Command;
			switch (object.t)
			{
				case CALL_METHOD:
					cmd = new AVM1Command(CALL_METHOD, object.s, 
												object.m, null, null, object.a);
					cmd.operationResult = object.r;
					return cmd;
				case SET_PROPERTY:
					cmd = new AVM1Command(SET_PROPERTY, object.s, 
												null, object.p, object.v);
					cmd.operationResult = object.r;
					return cmd;
				case LOAD_CONTENT:
					cmd = new AVM1Command(LOAD_CONTENT, AVM1Protocol.THIS, 
												null, null, null, null, object.u);
					cmd.operationResult = object.r;
					return cmd;
				case NOOP:
					cmd = new AVM1Command(NOOP, AVM1Protocol.NULL);
					cmd.operationResult = object.r;
					return cmd;
				case ERROR:
				default:
					return new AVM1Command(ERROR, AVM1Protocol.NULL);
			}
			return null;
		}
		
		/**
		 * This object will be sent to the AVM1 LocalConnection.
		 * 
		 * @return The object containing 
		 * mandatory fields:
		 * <ul>
		 * <li>t - type.</li>
		 * <li>s - scope.</li>
		 * </ul>
		 * optional fields:
		 * <ul>
		 * <li>m - method.</li>
		 * <li>a - methodArguments.</li>
		 * <li>p - property.</li>
		 * <li>v - propertyValue.</li>
		 * <li>u - content URL.</li>
		 * <li>r - operation result.</li>
		 * </ul>
		 */
		public function toAMF0Object():Object
		{
			var o:Object = { t: _type, s: _scope, r: _operationResult };
			if (_type == CALL_METHOD)
			{
				o.m = _method;
				if (_methodArguments)
				{
					o.a = _methodArguments;
				}
			}
			else if (_type === SET_PROPERTY)
			{
				o.p = _property;
				o.v = _propertyValue;
			}
			else if (_type === LOAD_CONTENT)
			{
				o.u = _contentURL;
			} 
			else delete o.s;
			return o;
		}
		
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