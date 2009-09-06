import org.wvxvws.lcbridge.AVM1Protocol;

/**
* AVM2Command class.
* @author wvxvw
* @langVersion 2.0
* @playerVersion 10.0.12.36
*/
class org.wvxvws.lcbridge.AVM1Command
{
	public static var ERROR:Number = -1;
	public static var NOOP:Number = 0;
	public static var CALL_METHOD:Number = 1;
	public static var SET_PROPERTY:Number = 2;
	public static var LOAD_CONTENT:Number = 3;
	
	//------------------------------------------------------------------------------
	//
	//  Public properties
	//
	//------------------------------------------------------------------------------
	
	/**
	 * Type of this command, either <code>AVM2Command.CALL_METHOD</code> or
	 * <code>AVM2Command.SET_PROPERTY</code>.
	 */
	public function get type():Number { return _type; }
	
	/**
	 * The AVM2 context, where the method will be called or the property
	 * will be set.
	 * You can use <code>AVM1Protocol.GLOBAL</code>, <code>AVM1Protocol.THIS</code>, 
	 * <code>AVM1Protocol.ROOT</code>, <code>AVM1Protocol.CONTENT</code>, 
	 * <code>AVM1Protocol.NULL</code> as well as any string that may be evaluated 
	 * to object in the AVM2Movie using <code>eval()</code>.
	 * The <code>eval()</code> will assume the context to be 
	 * <code>AVM1Protocol.CONTENT</code>.
	 */
	public function get scope():String { return _scope; }
	
	public function set scope(value:String):Void { _scope = value; }
	
	/**
	 * The name of the method to call on <code>scope</code> in the AVM2Movie.
	 */
	public function get method():String { return _method; }
	
	public function set method(value:String):Void { _method = value; }
	
	/**
	 * The name of the property to set on the <code>scope</code> in the AVM2Movie.
	 */
	public function get property():String { return _property; }
	
	public function set property(value:String):Void { _property = value; }
	
	/**
	 * The arguments to pass to the <code>method</code> in the AVM2Movie.
	 */
	public function get methodArguments():Array { return _methodArguments; }
	
	public function set methodArguments(value:Array):Void 
	{
		_methodArguments = value;
	}
	
	/**
	 * If execution of the command will return an object, this property will
	 * reference it.
	 * This property is <code>undefined</code> until the <cod>Event.COMPLETE</code>
	 * is dispatched.
	 */
	public function get operationResult():Object { return _operationResult; }
	
	public function set operationResult(value:Object):Void 
	{
		_operationResult = value;
	}
	
	/**
	 * The value you want to set the <code>property</code> in the AVM2Movie.
	 */
	public function get propertyValue():Object { return _propertyValue; }
	
	public function set propertyValue(value:Object):Void { _propertyValue = value; }
	
	/**
	 * The URL of the AVM1Movie Loaded with the AVM1Loader 
	 * which establishes communication.
	 */
	public function get contentURL():String { return _contentURL; }
	
	public function set contentURL(value:String):Void { _contentURL = value; }
	
	//------------------------------------------------------------------------------
	//
	//  private properties
	//
	//------------------------------------------------------------------------------
	
	private var _type:Number;
	private var _scope:String;
	private var _method:String;
	private var _property:String;
	private var _methodArguments:Array;
	private var _propertyValue:Object;
	private var _operationResult:Object;
	private var _contentURL:String;
	
	//------------------------------------------------------------------------------
	//
	//  Contstructor
	//
	//------------------------------------------------------------------------------
	
	/**
	 * Creates new <code>AVM2Command</code>.
	 * 
	 * @param	type			Type of this command, either 
	 * 							<code>AVM2Command.CALL_METHOD</code> or
	 * 							<code>AVM2Command.SET_PROPERTY</code>.
	 * 
	 * @param	scope			The AVM2 context, where the method will be 
	 * 							called or the property will be set.
	 * 							You can use <code>AVM1Protocol.GLOBAL</code>, 
	 * 							<code>AVM1Protocol.THIS</code>, 
	 * 							<code>AVM1Protocol.ROOT</code>, 
	 * 							<code>AVM1Protocol.CONTENT</code>, 
	 * 							<code>AVM1Protocol.NULL</code>
	 * 							as well as any string that may be evaluated to 
	 * 							object in the AVM2Movie using <code>eval()</code>.
	 * 							The <code>eval()</code> will assume the context 
	 * 							to be <code>AVM1Protocol.CONTENT</code>.
	 * 
	 * @param	method			The name of the method to call on 
	 * 							<code>scope</code> in the AVM2Movie.
	 * @default <code>""</code>
	 * 
	 * @param	property		The name of the property to set on the 
	 * 							<code>scope</code> in the AVM2Movie.
	 * @default <code>""</code>
	 * 
	 * @param	propertyValue	The value you want to set the 
	 * 							<code>property</code> in the AVM2Movie.
	 * @default <code>undefined</code>
	 * 
	 * @param	methodArguments	The arguments to pass to the 
	 * 							<code>method</code> in the AVM2Movie.
	 * @default <code>null</code>
	 * 
	 * @throws <code>Error</code> "Must specify either method or property."
	 */
	public function AVM1Command(type:Number, scope:String, method:String, 
							property:String, propertyValue:Object, 
							methodArguments:Array, contentURL:String) 
	{
		super();
		_global.AsBroadcaster.initialize(this);
		if (!method && !property && (type == 1 || type == 2))
		{
			throw new Error("Must specify either method or property.");
		}
		_type = type;
		_scope = scope;
		_method = method;
		_property = property;
		_propertyValue = propertyValue;
		_methodArguments = methodArguments;
		_contentURL = contentURL;
	}
	
	//------------------------------------------------------------------------------
	//
	//  Public methods
	//
	//------------------------------------------------------------------------------
	
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
	 * This object will be sent to the AVM2 LocalConnection.
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
		switch (_type)
		{
			case CALL_METHOD:
				o.m = _method;
				if (_methodArguments) o.a = _methodArguments;
				return o;
			case SET_PROPERTY:
				o.p = _property;
				o.v = _propertyValue;
				return o;
			case LOAD_CONTENT:
				o.u = _contentURL;
				return o;
			case NOOP:
			case ERROR:
				o.m = _method;
				if (_methodArguments) o.a = _methodArguments;
				o.p = _property;
				o.v = _propertyValue;
				o.u = _contentURL;
				return o;
		}
		return o;
	}
	
	public function broadcastMessage(message:String):Void { };
	
	public function addListener(listener:Object):Void { };
	
	public function removeListener(listener:Object):Void { };
	
	//------------------------------------------------------------------------------
	//
	//  Private methods
	//
	//------------------------------------------------------------------------------
}