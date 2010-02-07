package org.wvxvws.mapping 
{
	//{ imports
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.wvxvws.mapping.IEDContainer;
	import mx.core.IMXMLObject;
	//}
	
	/**
	 * EDContainer class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class EDContainer extends EventDispatcher implements IEDContainer, IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get parent():IEventDispatcher { return _parent; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _parent:IEventDispatcher;
		protected var _id:String;
		protected var _children:Vector.<IEventDispatcher> = new <IEventDispatcher>[];
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function EDContainer() { super(); }
		
		/* INTERFACE org.wvxvws.mapping.IEDContainer */
		
		public function get children():Vector.<IEventDispatcher>
		{
			return _children.concat();
		}
		
		public function addChild(child:IEventDispatcher):IEventDispatcher
		{
			_children.push(child);
		}
		
		public function addChildAt(child:IEventDispatcher, index:uint):IEventDispatcher
		{
			_children.splice(index, 0, child);
			return child;
		}
		
		public function removeChild(child:IEventDispatcher):IEventDispatcher
		{
			var i:int = _children.indexOf(child);
			_children.splice(i, 1);
			return child;
		}
		
		public function removeChildAt(index:uint):IEventDispatcher
		{
			_children.splice(index, 1);
			return child;
		}
		
		public function childIndex(child:IEventDispatcher):uint
		{
			return _children.indexOf(child);
		}
		
		public function childAt(index:uint):IEventDispatcher
		{
			return _children[index];
		}
		
		public function contains(child:IEventDispatcher):Boolean
		{
			var b:Boolean;
			if (_children.indexOf(child) > -1) return true;
			for each (var c:IEventDispatcher in _children)
			{
				if (c is IEDContainer) b = (c as IEDContainer).contains(child);
				if (b) return true;
			}
			return false;
		}
		/*
		public override function addEventListener(type:String, listener:Function, 
									useCapture:Boolean = false, priority:int = 0, 
									useWeakReference:Boolean = false):void
		{
			
		}
		
		public override function dispatchEvent(event:Event):Boolean
		{
			
		}
		
		public override function hasEventListener(type:String):Boolean
		{
			
		}
		
		public override function removeEventListener(type:String, listener:Function, 
											useCapture:Boolean = false):void
		{
			
		}
		
		public override function willTrigger(type:String):Boolean
		{
			
		}
		*/
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			if (!this._parent) this._parent = document as IEventDispatcher;
			this._id = id;
		}
		
		public function dispose():void { }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
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