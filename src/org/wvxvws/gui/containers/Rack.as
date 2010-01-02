package org.wvxvws.gui.containers 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.layout.Constraints;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.Invalides;
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
		public function get direction():Boolean { return this._direction; }
		
		public function set direction(value:Boolean):void 
		{
			if (this._direction === value) return;
			this._direction = value;
			this.invalidate(Invalides.DIRECTION, false);
			if (super.hasEventListener(EventGenerator.getEventType("direction")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public function get distribute():Number { return this._distribute; }
		
		public function set distribute(value:Number):void 
		{
			if (this._distribute === value || value > 1 || value < 0) return;
			this._distribute = value;
			super.invalidate(Invalides.BOUNDS, false);
			if (super.hasEventListener(EventGenerator.getEventType("distribute")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public function get padding():Rectangle { return this._padding; }
		
		public function set padding(value:Rectangle):void 
		{
			if (this._padding === value || value && this._padding && 
				this._padding.equals(value))
				return;
			this._padding = value ? value.clone() : null;
			super.invalidate(Invalides.BOUNDS, false);
			if (super.hasEventListener(EventGenerator.getEventType("padding")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public function get gutterH():int { return this._gutterH; }
		
		public function set gutterH(value:int):void 
		{
			if (this._gutterH === value) return;
			this._gutterH = value;
			super.invalidate(Invalides.BOUNDS, false);
			if (super.hasEventListener(EventGenerator.getEventType("gutterH")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public function get gutterV():int { return this._gutterV; }
		
		public function set gutterV(value:int):void 
		{
			if (this._gutterV === value) return;
			this._gutterV = value;
			super.invalidate(Invalides.BOUNDS, false);
			if (super.hasEventListener(EventGenerator.getEventType("gutterV")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public function get allowOverlap():Boolean { return this._allowOverlap; }
		
		public function set allowOverlap(value:Boolean):void 
		{
			if (this._allowOverlap === value) return;
			this._allowOverlap = value;
			super.invalidate(Invalides.BOUNDS, false);
			if (super.hasEventListener(EventGenerator.getEventType("allowOverlap")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get children():Vector.<DisplayObject> { return this._children.concat(); }
		
		public function set children(value:Vector.<DisplayObject>):void 
		{
			if (this._children === value) return;
			if (this._children.length)
			{
				for each (var d:DisplayObject in this._children)
				{
					if (super.contains(d)) super.removeChild(d);
				}
			}
			this._children.length = 0;
			var i:int;
			var j:int = (value) ? value.length : 0;
			while (i < j)
			{
				this._children.push(value[i]);
				this.addChildAt(value[i], i);
				i++;
			}
			if (this._performLayout) this.constrain();
		}
		
		public function get performLayout():Boolean { return this._performLayout; }
		
		public function set performLayout(value:Boolean):void 
		{
			if (this._performLayout == value) return;
			this._performLayout = value;
			super.invalidate(Invalides.NULL, false);
			if (super.hasEventListener(EventGenerator.getEventType("performLayout")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		protected var _mxmlChild:DisplayObject;
		
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
			var lc:ILayoutClient;
			var i:int = super.numChildren;
			super.validate(properties);
			if (this._performLayout) this.constrain();
			else
			{
				while (i--)
				{
					lc = super.getChildAt(i) as ILayoutClient;
					if (lc) lc.validate(lc.invalidProperties);
				}
			}
		}
		
		public override function addChild(child:DisplayObject):DisplayObject 
		{
			if (this._mxmlChild === child) return super.addChild(child);
			return this.addChildAt(child, this._children.length);
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			var child:DisplayObject;
			if (child.parent) child.parent.removeChild(child);
			if (child is IMXMLObject)
			{
				this._mxmlChild = child;
				(child as IMXMLObject).initialized(this, "chid" + index);
			}
			else 
			{
				this._mxmlChild = null;
				child = super.addChildAt(child, index);
			}
			var i:int = this._children.indexOf(child);
			if (i > -1) this._children.splice(i, 1);
			this._children.splice(index, 0, child);
			if (this._performLayout) this.constrain();
			return child;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject 
		{
			var child:DisplayObject = super.removeChild(child);
			this._children.pop();
			if (this._performLayout) this.constrain();
			return child;
		}
		
		public override function removeChildAt(index:int):DisplayObject 
		{
			var child:DisplayObject = super.removeChildAt(index);
			this._children.splice(index, 1);
			if (this._performLayout) this.constrain();
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
				if (this._children.indexOf(child) > -1)
				{
					i++;
					continue;
				}
				this._children.splice(i, 0, child);
				i++;
			}
			this._layoutRect.width = super._bounds.x;
			this._layoutRect.height = super._bounds.y;
			Constraints.constrain(this._children, this._distribute, 
				this._direction, this._gutterH, this._gutterV, 
				this._padding, this._layoutRect);
			i = 0;
			j = this._children.length;
			while (i < j)
			{
				child = this._children[i];
				if (child.parent !== this)
				{
					if (child.parent) child.parent.removeChild(child);
					this.addChildAt(child, i);
				}
				i++;
			}
		}
	}
}