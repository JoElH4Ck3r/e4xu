package org.wvxvws.gui.containers 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.events.Event;
	import org.wvxvws.gui.DIV;
	//}
	
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
		
		public static const MAX:int = 2;
		public static const MIDDLE:int = 1;
		public static const MIN:int = 0;
		
		//------------------------------------
		//  Public property horizontalAlign
		//------------------------------------
		
		[Bindable("horizontalAlignChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>horizontalAlignChange</code> event.
		*/
		public function get horizontalAlign():int { return _horizontalAlign; }
		
		public function set horizontalAlign(value:int):void 
		{
			if (_horizontalAlign == value || value > 2 || value < 0) return;
			_horizontalAlign = value;
			dispatchEvent(new Event("horizontalAlignChange"));
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
		
		[Bindable("paddingChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>paddingChange</code> event.
		*/
		public function get padding():int { return _padding; }
		
		public function set padding(value:int):void 
		{
			if (_padding == value) return;
			_padding = value;
			dispatchEvent(new Event("paddingChange"));
		}
		
		//------------------------------------
		//  Public property gutter
		//------------------------------------
		
		[Bindable("gutterChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>gutterChange</code> event.
		*/
		public function get gutter():int { return _gutter; }
		
		public function set gutter(value:int):void 
		{
			if (_gutter == value) return;
			_gutter = value;
			dispatchEvent(new Event("gutterChange"));
		}
		
		//------------------------------------
		//  Public property allowOverlap
		//------------------------------------
		
		[Bindable("allowOverlapChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>allowOverlapChange</code> event.
		*/
		public function get allowOverlap():Boolean { return _allowOverlap; }
		
		public function set allowOverlap(value:Boolean):void 
		{
			if (_allowOverlap == value) return;
			_allowOverlap = value;
			dispatchEvent(new Event("allowOverlapChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _horisontalAlign:int;
		protected var _verticalAlign:int;
		protected var _gutter:int;
		protected var _padding:int;
		protected var _allowOverlap:Boolean;
		
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
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			var child:DisplayObject = super.addChild(child);
			constrain();
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			var child:DisplayObject = super.addChildAt(child, index);
			constrain();
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			var child:DisplayObject = super.removeChild(child);
			constrain();
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			var child:DisplayObject = super.removeChildAt(index);
			constrain();
			return child;
		}
		
		public function constrain():void
		{
			var minHeight:int;
			var minWidth:int;
			var maxHeight:int;
			var maxWidth:int;
			var totalWidth:int;
			var totalHeight:int;
			var children:Array = [];
			var child:DisplayObject;
			var lastChild:DisplayObject;
			var toBeX:int;
			var toBeY:int;
			var i:int;
			while (i < numChildren)
			{
				child = super.getChildAt(i);
				children.push(child);
				minHeight = Math.min(minHeight, Math.abs(child.height));
				minWidth = Math.min(minWidth, Math.abs(child.width));
				maxHeight = Math.max(maxHeight, Math.abs(child.height));
				maxWidth = Math.max(maxWidth, Math.abs(child.width));
				totalWidth += Math.abs(child.width) + _gutter;
				totalHeight += Math.abs(child.height) + _gutter;
				i++;
			}
			if (_allowOverlap)
			{
				
			}
			else
			{
				for each (child in children)
				{
					switch (_horisontalAlign)
					{
						case 0:
							toBeX = 0;
							if (lastChild) toBeX += lastChild.x + Math.abs(child.width) + _gutter;
							break;
						case 1:
							toBeX = (maxWidth - Math.abs(child.width)) / 2;
							break;
						case 2:
							toBeX = totalWidth - Math.abs(child.width);
							if (lastChild) toBeX -= (lastChild.x + _gutter);
							break;
					}
					switch (_verticalAlign)
					{
						case 0:
							toBeY = 0;
							if (lastChild) toBeY += lastChild.y + Math.abs(child.height) + _gutter;
							break;
						case 1:
							toBeY = (maxHeight - Math.abs(child.height)) / 2;
							break;
						case 2:
							toBeY = totalHeight - Math.abs(child.height);
							if (lastChild) toBeY -= (lastChild.y + _gutter);
							break;
					}
					child.x = toBeX;
					child.y = toBeY;
					lastChild = child;
				}
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