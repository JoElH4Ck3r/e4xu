package org.wvxvws.gui.repeaters
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import mx.core.IMXMLObject;
	//}
	
	[DefaultProperty("factory")]
	
	/**
	 * Tiler class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class Tiler extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property factory
		//------------------------------------
		
		[Bindable("factoryChanged")]
		
		/**
		* Extends DisplayObject
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>factoryChanged</code> event.
		*/
		public function get factory():Class { return _factory; }
		
		public function set factory(value:Class):void 
		{
			if (_factory == value) return;
			_factory = value;
			super.dispatchEvent(new Event("factoryChanged"));
		}
		
		//------------------------------------
		//  Public property cellWidth
		//------------------------------------
		
		[Bindable("cellWidthChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>cellWidthChanged</code> event.
		*/
		public function get cellWidth():int { return _cellWidth; }
		
		public function set cellWidth(value:int):void 
		{
			if (_cellWidth == value) return;
			_cellWidth = value;
			super.dispatchEvent(new Event("cellWidthChanged"));
		}
		
		//------------------------------------
		//  Public property cellHeight
		//------------------------------------
		
		[Bindable("cellHeightChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>cellHeightChanged</code> event.
		*/
		public function get cellHeight():int { return _cellHeight; }
		
		public function set cellHeight(value:int):void 
		{
			if (_cellHeight == value) return;
			_cellHeight = value;
			super.dispatchEvent(new Event("cellHeightChanged"));
		}
		
		//------------------------------------
		//  Public property hSpace
		//------------------------------------
		
		[Bindable("hSpaceChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>hSpaceChanged</code> event.
		*/
		public function get hSpace():int { return _hSpace; }
		
		public function set hSpace(value:int):void 
		{
			if (_hSpace == value) return;
			_hSpace = value;
			super.dispatchEvent(new Event("hSpaceChanged"));
		}
		
		//------------------------------------
		//  Public property vSpace
		//------------------------------------
		
		[Bindable("vSpaceChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>vSpaceChanged</code> event.
		*/
		public function get vSpace():int { return _vSpace; }
		
		public function set vSpace(value:int):void 
		{
			if (_vSpace == value) return;
			_vSpace = value;
			super.dispatchEvent(new Event("vSpaceChanged"));
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
			if (_padding == value) return;
			_padding = value;
			super.dispatchEvent(new Event("paddingChanged"));
		}
		
		//------------------------------------
		//  Public property bounds
		//------------------------------------
		
		[Bindable("boundsChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>boundsChanged</code> event.
		*/
		public function get bounds():Point { return _bounds; }
		
		public function set bounds(value:Point):void 
		{
			if (_bounds == value) return;
			_bounds = value;
			super.dispatchEvent(new Event("boundsChanged"));
		}
		
		public function get index():int { return _index; }
		
		public function get id():String { return _id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _factory:Class;
		protected var _cellWidth:int;
		protected var _cellHeight:int;
		protected var _hSpace:int;
		protected var _vSpace:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _creationCallback:Function;
		protected var _index:int;
		protected var _bounds:Point = new Point();
		protected var _timer:Timer = new Timer(1, 1);
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _id:String;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function Tiler(host:IRepeaterHost = null)
		{
			super();
			if (host) _creationCallback = host.repeatCallback;
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function begin():void
		{
			_index = 0;
			this.createImage();
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			if (!(document is IRepeaterHost))
				throw new ArgumentError(document + " cannot host repeater.");
			_creationCallback = (host as IRepeaterHost).repeatCallback;
			_id = id;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function createImage():void
		{
			var image:DisplayObject = new _factory() as DisplayObject;
			image.width = _cellWidth;
			image.height = _cellHeight;
			var totalWidth:int = _bounds.x - (_padding.left + _padding.right);
			var cellsH:int = (totalWidth + _hSpace) / (_cellWidth + _hSpace);
			
			image.x = _padding.left + (_index % cellsH) * (_cellWidth + _hSpace)
			image.y = _padding.top + ((_index / cellsH) >> 0) * (_cellHeight + _vSpace);
			super.addChild(image);
			_index++;
			if (_index % 0xFF)
			{
				if (_creationCallback(image, _index)) this.createImage();
			}
			else 
			{
				_timer.reset();
				_timer.start();
			}
		}
		
		protected function timerHandler(event:TimerEvent):void { this.createImage(); }
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}