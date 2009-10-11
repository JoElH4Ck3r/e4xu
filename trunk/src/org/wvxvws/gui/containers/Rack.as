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
		
		[Bindable("horizontalAlignChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>horizontalAlignChanged</code> event.
		*/
		public function get horizontalAlign():int { return _horizontalAlign; }
		
		public function set horizontalAlign(value:int):void 
		{
			if (_horizontalAlign == value || value > 2 || value < 0) return;
			_horizontalAlign = value;
			dispatchEvent(new Event("horizontalAlignChanged"));
		}
		
		//------------------------------------
		//  Public property verticalAlign
		//------------------------------------
		
		[Bindable("verticalAlignChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>verticalAlignChange</code> event.
		*/
		public function get verticalAlign():int { return _verticalAlign; }
		
		public function set verticalAlign(value:int):void 
		{
			if (_verticalAlign == value || value > 2 || value < 0) return;
			_verticalAlign = value;
			dispatchEvent(new Event("verticalAlignChange"));
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
			dispatchEvent(new Event("paddingChanged"));
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
			dispatchEvent(new Event("gutterHChanged"));
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
			dispatchEvent(new Event("gutterVChanged"));
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
			dispatchEvent(new Event("allowOverlapChanged"));
		}
		
		public function get children():Vector.<DisplayObject> { return _children.concat(); }
		
		public function set children(value:Vector.<DisplayObject>):void 
		{
			if (_children === value) return;
			if (!value) _children = new <DisplayObject>[];
			else _children = value.concat();
			constrain();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _horizontalAlign:int;
		protected var _verticalAlign:int;
		protected var _gutterH:int;
		protected var _gutterV:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _allowOverlap:Boolean;
		protected var _layoutRect:Rectangle = new Rectangle();
		protected var _children:Vector.<DisplayObject> = new <DisplayObject>[];
		
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
		
		public override function addChild(child:DisplayObject):DisplayObject 
		{
			var child:DisplayObject = super.addChild(child);
			var i:int = _children.indexOf(child);
			if (i > -1) _children.splice(i, 1);
			_children.push(child);
			this.constrain();
			return child;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			var child:DisplayObject = super.addChildAt(child, index);
			var i:int = _children.indexOf(child);
			if (i > -1) _children.splice(i, 1);
			_children.splice(index, 0, child);
			this.constrain();
			return child;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject 
		{
			var child:DisplayObject = super.removeChild(child);
			_children.pop();
			this.constrain();
			return child;
		}
		
		public override function removeChildAt(index:int):DisplayObject 
		{
			var child:DisplayObject = super.removeChildAt(index);
			_children.splice(index, 1);
			this.constrain();
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
				if (_children.indexOf(child)) continue;
				_children.push(super.getChildAt(i));
				i++;
			}
			_layoutRect.width = _bounds.x;
			_layoutRect.width = _bounds.y;
			Constraints.constrain(_children, 0, 
						true, _gutterH, _gutterV, _padding, _layoutRect);
			i = 0;
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