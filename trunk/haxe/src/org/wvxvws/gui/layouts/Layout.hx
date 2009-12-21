/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.gui.layouts;
import flash.utils.TypedDictionary;

class Layout 
{
	public var paddingTop:Int;
	public var paddingBottom:Int;
	public var paddingLeft:Int;
	public var paddingRigth:Int;
	
	public var gutterH:Int;
	public var gutterV:Int;
	
	public var marginTop:Int;
	public var marginBottom:Int;
	public var marginLeft:Int;
	public var marginRight:Int;
	
	public var floatV:Floats;
	public var floatH:Floats;
	
	public var invalidProperties:TypedDictionary<Invalides, Bool>;
	
	public function new() 
	{
		
	}
	
}