/**
 * AVM1Protocol class.
 * @author wvxvw
 * @langVersion 2.0
 * @playerVersion 10.0.12.36
 */
class org.wvxvws.lcbridge.AVM1Protocol 
{
	//------------------------------------------------------------------------------
	//
	//  Public properties
	//
	//------------------------------------------------------------------------------
	
	/**
	 * Refers to <code>_root</code>. Note that depending on your _lockroot settings
	 * the methods of the loaded clip may or may not be accessible though <code>_root</code>
	 */
	public static var ROOT:String = "_root";
	
	/**
	 * Refers to <code>_global</code>. Use this if you want to refer to global variables
	 * or classes, which are also stored in <code>_global</code> object.
	 */
	public static var GLOBAL:String = "_global";
	
	/**
	 * Refers to the AVM1 LocalConnection client.
	 */
	public static var THIS:String = "this";
	
	/**
	 * Refers to the content loaded inside the AVM1 LocalConnection client.
	 */
	public static var CONTENT:String = "content";
	
	/**
	 * A null-scope, use this when calling static methods or methods that do not
	 * require context.
	 */
	public static var NULL:String = "";
	
	//------------------------------------------------------------------------------
	//
	//  Private properties
	//
	//------------------------------------------------------------------------------
	
	//------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//------------------------------------------------------------------------------
	
	public function AVM1Protocol() { super(); }
	
	//------------------------------------------------------------------------------
	//
	//  Public methods
	//
	//------------------------------------------------------------------------------
	
	//------------------------------------------------------------------------------
	//
	//  Private methods
	//
	//------------------------------------------------------------------------------
}