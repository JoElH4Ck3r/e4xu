/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.gui;

import flash.display.DisplayObject;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.geom.Transform;
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
		this._transform = new Transform(value);
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
	private var _scrollX:Float;
	private var _scrollY:Float;
	private var _state:String;
	private var _rotation:Float;
	private var _matrix:Matrix;
	private var _transform:Transform;
	
	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	
	public function new(where:DisplayObject) 
	{
		super();
		this._where = where;
		this._alpha = 1.0;
		this._position = new Dot(0, 0);
		this._size = new Dot(1, 1);
		this._scrollX = 0.0;
		this._scrollY = 0.0;
		this._rotation = 0.0;
		this._transform = new Transform(where);
	}
	
	public function setMatrix(? size:Dot, ? position:Dot, ? rotation:Float):Void
	{
		trace(size);
		trace(position);
		trace(rotation);
	}
	
	public function setScroll(valueX:Float, valueY:Float):Void
	{
		
	}
	
	public function setBackground(color:UInt, alpha:Float):Void
	{
		
	}
	
	// TODO: Maybe not a string.
	public function setState(value:String):Void
	{
		
	}
}