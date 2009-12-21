/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.gui;

import flash.display.DisplayObject;
import flash.events.EventDispatcher;
import org.wvxvws.gui.measurements.Dot;

class Div extends EventDispatcher
{
	//------------------------------------------------------------------------------
	// Public properties
	//------------------------------------------------------------------------------
	
	public var where(getWhere, setWhere):DisplayObject;
	
	//------------------------------------------------------------------------------
	// Getters | Setters
	//------------------------------------------------------------------------------
	
	private function getWhere():DisplayObject { return _where; }
	
	private function setWhere(value:DisplayObject):DisplayObject 
	{
		return _where = value;
	}
	
	//------------------------------------------------------------------------------
	// Private properties
	//------------------------------------------------------------------------------
	
	private var _where:DisplayObject;
	private var _color:UInt;
	private var _alpha:Float;
	private var _position:Dot;
	private var _size:Dot;
	private var _scroll:Float;
	private var _state:String;
	
	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	
	public function new(where:DisplayObject) 
	{
		super();
		this._alpha = 1.0;
		this._position = new Dot(0, 0);
		this._size = new Dot(1, 1);
	}
	
	public function setSize(value:Dot):Void { }
	
	public function setPosition(value:Dot):Void { }
	
	public function setScroll(value:Float):Void { }
	
	public function setBackground(color:UInt, alpha:Float):Void
	{
		
	}
	
	// TODO: Maybe not a string.
	public function setState(value:String):Void
	{
		
	}
}