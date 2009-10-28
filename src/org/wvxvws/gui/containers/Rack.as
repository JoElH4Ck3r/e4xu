package org.wvxvws.gui.containers 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.layout.Constraints;
	//}
	
	[DefaultProperty("children")]
	
	/**
	* Rack class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Rack extends DIV
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property horizontalAlign
		//------------------------------------
		
		[Bindable("directionChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>directionChanged</code> event.
		*/
		public function get direction():Boolean { return _direction; }
		
		public function set direction(value:Boolean):void 
		{
			if (_direction === value) return;
			_direction = value;
			this.invalidate("_direction", _direction, false);
			super.dispatchEvent(new Event("directionChanged"));
		}
		
		//------------------------------------
		//  Public property distribute
		//------------------------------------
		
		[Bindable("distributeChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>distributeChange</code> event.
		*/
		public function get distribute():Number { return _distribute; }
		
		public function set distribute(value:Number):void 
		{
			if (_distribute == value || value > 1 || value < 0) return;
			_distribute = value;
			super.invalidate("_distribute", _distribute, false);
			super.dispatchEvent(new Event("distributeChange"));
		}
		
		//------------------------------------
		//  Public property padding
		//------------------------------------
		
		[Bindable("paddingChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>paddingChanged</code> event.
		*/
		public function get padding():Rectangle { return _padding; }
		
		public function set padding(value:Rectangle):void 
		{
			if (_padding == value || value && _padding && _padding.equals(value))
				return;
			_padding = value ? value.clone() : null;
			super.invalidate("_padding", _padding, false);
			super.dispatchEvent(new Event("paddingChanged"));
		}
		
		//------------------------------------
		//  Public property gutterH
		//------------------------------------
		
		[Bindable("gutterHChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>gutterHChanged</code> event.
		*/
		public function get gutterH():int { return _gutterH; }
		
		public function set gutterH(value:int):void 
		{
			if (_gutterH == value) return;
			_gutterH = value;
			super.invalidate("_gutterH", _gutterH, false);
			super.dispatchEvent(new Event("gutterHChanged"));
		}
		
		//------------------------------------
		//  Public property gutterV
		//------------------------------------
		
		[Bindable("gutterVChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>gutterVChanged</code> event.
		*/
		public function get gutterV():int { return _gutterV; }
		
		public function set gutterV(value:int):void 
		{
			if (_gutterV == value) return;
			_gutterV = value;
			super.invalidate("_gutterV", _gutterV, false);
			super.dispatchEvent(new Event("gutterVChanged"));
		}
		
		//------------------------------------
		//  Public property allowOverlap
		//------------------------------------
		
		[Bindable("allowOverlapChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>allowOverlapChanged</code> event.
		*/
		public function get allowOverlap():Boolean { return _allowOverlap; }
		
		public function set allowOverlap(value:Boolean):void 
		{
			if (_allowOverlap == value) return;
			_allowOverlap = value;
			super.invalidate("_allowOverlap", _allowOverlap, false);
			super.dispatchEvent(new Event("allowOverlapChanged"));
		}
		
		public function get children():Vector.<DisplayObject> { return _children.concat(); }
		
		public function set children(value:Vector.<DisplayObject>):void 
		{
			if (_children === value) return;
			if (!value) _children = new <DisplayObject>[];
			else _children = value.concat();
			if (_performLayout) this.constrain();
		}
		
		public function get performLayout():Boolean { return _performLayout; }
		
		public function set performLayout(value:Boolean):void 
		{
			if (_performLayout == value) return;
			_performLayout = value;
			super.invalidate("_performLayout", _performLayout, false);
			super.dispatchEvent(new Event("performLayoutChanged"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _distribute:Number = 0;
		protected var _direction:Boolean;
		protected var _gutterH:int;
		protected var _gutterV:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _allowOverlap:Boolean;
		protected var _layoutRect:Rectangle = new Rectangle();
		protected var _children:Vector.<DisplayObject> = new <DisplayObject>[];
		protected var _performLayout:Boolean;
		
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
		
		public function Rack() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
			if (_performLayout) this.constrain();
		}
		
		public override function addChild(child:DisplayObject):DisplayObject 
		{
			var child:DisplayObject = super.addChild(child);
			var i:int = _children.indexOf(child);
			if (i > -1) _children.splice(i, 1);
			_children.push(child);
			if (_performLayout) this.constrain();
			return child;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			var child:DisplayObject = super.addChildAt(child, index);
			var i:int = _children.indexOf(child);
			if (i > -1) _children.splice(i, 1);
			_children.splice(index, 0, child);
			if (_performLayout) this.constrain();
			return child;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject 
		{
			var child:DisplayObject = super.removeChild(child);
			_children.pop();
			if (_performLayout) this.constrain();
			return child;
		}
		
		public override function removeChildAt(index:int):DisplayObject 
		{
			var child:DisplayObject = super.removeChildAt(index);
			_children.splice(index, 1);
			if (_performLayout) this.constrain();
			return child;
		}
		
		public function constrain():void
		{
			var i:int;
			var j:int = super.numChildren;
			var child:DisplayObject;
			while (i < j)
			{
				child = super.getChildAt(i);
				if (_children.indexOf(child) > -1)
				{
					i++;
					continue;
				}
				_children.splice(i, 0, super.getChildAt(i));
				i++;
			}
			_layoutRect.width = _bounds.x;
			_layoutRect.height = _bounds.y;
			Constraints.constrain(_children, _distribute, 
						_direction, _gutterH, _gutterV, _padding, _layoutRect);
			i = 0;
			j = _children.length;
			while (i < j)
			{
				child = _children[i];
				if (!super.contains(child)) super.addChildAt(child, i);
				i++;
			}
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