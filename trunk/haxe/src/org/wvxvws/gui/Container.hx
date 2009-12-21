/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.gui;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.Lib;
import haxe.FastList;
import org.wvxvws.gui.layouts.Invalides;
import org.wvxvws.gui.layouts.Layout;

class Container extends Div
{
	//------------------------------------------------------------------------------
	// Public properties
	//------------------------------------------------------------------------------
	
	public override var where(getWhere, setWhere):DisplayObject;
	public var layout(getLayout, setLayout):Layout;
	
	//------------------------------------------------------------------------------
	// Getters | Setters
	//------------------------------------------------------------------------------
	
	private override function getWhere():DisplayObject { return _where; }
	
	private override function setWhere(value:DisplayObject):DisplayObject 
	{
		_where = cast(value, DisplayObjectContainer);
		return _where;
	}
	
	private function getLayout():Layout { return _layout; }
	
	private function setLayout(value:Layout):Layout 
	{
		return _layout = value;
	}
	
	//------------------------------------------------------------------------------
	// Private properties
	//------------------------------------------------------------------------------
	
	private var _elements:FastList<Div>;
	private var _layout:Layout;
	private var _layoutSuspended:Bool;
	private var _numElements:Int;
	
	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	
	public function new(where:DisplayObjectContainer = null) 
	{
		super(where);
		this._elements = new FastList<Div>();
	}
	
	//------------------------------------------------------------------------------
	// Public methods
	//------------------------------------------------------------------------------
	
	public function suspendLayout():Void { _layoutSuspended = true; }
	
	public function performLayout():Void
	{
		var e:Invalides;
		_layoutSuspended = false;
		var iter:Iterator<Invalides>;
		if (this._layout.invalidProperties != null)
		{
			iter = this._layout.invalidProperties.iterator();
			while (iter.hasNext())
			{
				e = iter.next();
				if (this._layout.invalidProperties.get(e))
					continue;
				switch (e)
				{
					case Invalides.BACKGROUND:
						super.setBackground(this._color, this._alpha);
					case Invalides.CHILDREN:
						this.setChildren();
					case Invalides.POSITION:
						super.setPosition(this._position);
					case Invalides.SCROLL:
						super.setScroll(this._scroll);
					case Invalides.SIZE:
						super.setSize(this._size);
					case Invalides.STATE:
						super.setState(this._state);
					case Invalides.TEXT:
				}
				this._layout.invalidProperties.set(e, true);
			}
		}
	}
	
	public function addElement(element:Div):Div
	{
		this._elements.add(element);
		this._numElements++;
		if (this._where != null && !_layoutSuspended)
		{
			cast(this._where, DisplayObjectContainer).addChild(element.where);
		}
		return element;
	}
	
	public function removeElement(element:Div):Div
	{
		var b:Bool = this._elements.remove(element);
		if (b) this._numElements--;
		if (this._where != null && 
			cast(this._where, DisplayObjectContainer).contains(element.where))
		{
			cast(this._where, DisplayObjectContainer).removeChild(element.where);
		}
		if (b) return element;
		else return null;
	}
	
	//------------------------------------------------------------------------------
	// Private methods
	//------------------------------------------------------------------------------
	
	private function setChildren():Void
	{
		
	}
	
}