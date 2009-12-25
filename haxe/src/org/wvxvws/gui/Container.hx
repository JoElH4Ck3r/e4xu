/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.gui;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Transform;
import flash.Lib;
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
	
	private override function setWhere(value:DisplayObject):DisplayObject 
	{
		this._where = cast(value, DisplayObjectContainer);
		this._transform = new Transform(this._where);
		return this._where;
	}
	
	private function getLayout():Layout { return this._layout; }
	
	private function setLayout(value:Layout):Layout 
	{
		return this._layout = value;
	}
	
	//------------------------------------------------------------------------------
	// Private properties
	//------------------------------------------------------------------------------
	
	private var _elements:List<Div>;
	private var _layout:Layout;
	private var _layoutSuspended:Bool;
	
	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	
	public function new(where:DisplayObjectContainer = null) 
	{
		super(where != null ? where : new Sprite());
		this._elements = new List<Div>();
		trace(this._where);
	}
	
	//------------------------------------------------------------------------------
	// Public methods
	//------------------------------------------------------------------------------
	
	public function suspendLayout():Void { _layoutSuspended = true; }
	
	public function performLayout():Void
	{
		var e:Invalides;
		this._layoutSuspended = false;
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
					case Invalides.MATRIX:
						super.setMatrix(this._size, this._position, this._rotation);
					case Invalides.SCROLL:
						super.setScroll(this._scrollX, this._scrollY);
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
		if (Lambda.has(this._elements, element)) return null;
		this._elements.add(element);
		if (this._where != null && !this._layoutSuspended)
		{
			cast(this._where, DisplayObjectContainer).addChild(element.where);
		}
		return element;
	}
	
	private function hasElement(element:Div):Bool
	{
		return Lambda.has(this._elements, element);
	}
	
	public function removeElement(element:Div):Div
	{
		var b:Bool = this._elements.remove(element);
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