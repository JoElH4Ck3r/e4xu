package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.Border;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.SPAN;
	import org.wvxvws.gui.windows.ChromeBar;
	import org.wvxvws.gui.windows.IPane;
	
	[DefaultProperty("children")]
	
	[Skin(part="close", type="org.wvxvws.skins.CloseSkin")]
	[Skin(part="dock", type="org.wvxvws.skins.DockSkin")]
	[Skin(part="expand", type="org.wvxvws.skins.ExpandSkin")]
	
	/**
	 * ChromeWindow class.
	 * @author wvxvw
	 */
	public class ChromeWindow extends DIV implements IPane, ISkinnable
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property width
		//------------------------------------
		
		public override function set width(value:Number):void 
		{
			if (value < _minWidth) value = _minWidth;
			super.width = value;
		}
		
		//------------------------------------
		//  Public property width
		//------------------------------------
		
		public override function set height(value:Number):void 
		{
			if (value < _minHeight) value = _minHeight;
			super.height = value;
		}
		
		//------------------------------------
		//  Public property modal
		//------------------------------------
		
		[Bindable("modalChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>modalChanged</code> event.
		*/
		public function get modal():Boolean { return _modal; }
		
		public function set modal(value:Boolean):void
		{
			if (_modal === value) return;
			_modal = value;
			super.invalidate("_modal", _modal, false);
			if (super.hasEventListener(EventGenerator.getEventType("modal")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property resizable
		//------------------------------------
		
		[Bindable("modalChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>resizableChanged</code> event.
		*/
		public function get resizable():Boolean { return _resizable; }
		
		public function set resizable(value:Boolean):void
		{
			if (_resizable === value) return;
			_resizable = value;
			super.invalidate("_resizable", _resizable, false);
			if (super.hasEventListener(EventGenerator.getEventType("resizable")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property titleBar
		//------------------------------------
		
		[Bindable("titleBarChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>titleBarChanged</code> event.
		*/
		public function get titleBar():ChromeBar { return _titleBar; }
		
		public function set titleBar(value:ChromeBar):void 
		{
			if (_titleBar === value) return;
			if (_titleBar && super.contains(_titleBar)) 
				super.removeChild(_titleBar);
			_titleBar = value;
			super.invalidate("_titleBar", _titleBar, false);
			if (super.hasEventListener(EventGenerator.getEventType("titleBar")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property resizable
		//------------------------------------
		
		[Bindable("statusBarChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>statusBarChanged</code> event.
		*/
		public function get statusBar():SPAN { return _statusBar; }
		
		public function set statusBar(value:SPAN):void 
		{
			if (_statusBar === value) return;
			if (_statusBar && super.contains(_statusBar)) 
				super.removeChild(_statusBar);
			_statusBar = value;
			super.invalidate("_statusBar", _statusBar, false);
			if (super.hasEventListener(EventGenerator.getEventType("statusBar")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property closeSkin
		//------------------------------------
		
		[Bindable("closeSkinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>closeSkinChanged</code> event.
		*/
		public function get closeSkin():ISkin { return _closeSkin; }
		
		public function set closeSkin(value:ISkin):void 
		{
			if (_closeSkin === value) return;
			_closeSkin = value;
			super.invalidate("_closeSkin", _closeSkin, false);
			if (super.hasEventListener(EventGenerator.getEventType("closeSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property dockSkin
		//------------------------------------
		
		[Bindable("dockSkinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>dockSkinChanged</code> event.
		*/
		public function get dockSkin():ISkin { return _dockSkin; }
		
		public function set dockSkin(value:ISkin):void 
		{
			if (_dockSkin === value) return;
			_dockSkin = value;
			super.invalidate("_dockSkin", _dockSkin, false);
			if (super.hasEventListener(EventGenerator.getEventType("dockSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property expandSkin
		//------------------------------------
		
		[Bindable("expandSkinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>expandSkinChanged</code> event.
		*/
		public function get expandSkin():ISkin { return _expandSkin; }
		
		public function set expandSkin(value:ISkin):void 
		{
			if (_expandSkin === value) return;
			_expandSkin = value;
			super.invalidate("_expandSkin", _expandSkin, false);
			if (super.hasEventListener(EventGenerator.getEventType("expandSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property border
		//------------------------------------
		
		[Bindable("borderChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>borderChanged</code> event.
		*/
		public function get border():Border { return _border; }
		
		public function set border(value:Border):void 
		{
			if (_border === value) return;
			_border = value;
			super.invalidate("_border", _border, false);
			if (super.hasEventListener(EventGenerator.getEventType("border")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property children
		//------------------------------------
		
		public function get children():Vector.<DisplayObject> { return _contentPane.children; }
		
		public function set children(value:Vector.<DisplayObject>):void 
		{
			if (_contentPane.children === value) return;
			_contentPane.children = value;
			super.invalidate("_contentPane", _contentPane, false);
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return null; }
		
		public function set skin(value:Vector.<ISkin>):void { }
		
		public function get parts():Object
		{
			return { close: _closeSkin, dock: _dockSkin, expand: _expandSkin }
		}
		
		public function set parts(value:Object):void
		{
			if (value)
			{
				_closeSkin = value["close"];
				_dockSkin = value["dock"];
				_expandSkin = value["expand"];
			}
			else
			{
				_closeSkin = null;
				_dockSkin = null;
				_expandSkin = null;
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _titleBar:ChromeBar;
		protected var _statusBar:SPAN;
		
		protected var _closeBTN:InteractiveObject;
		protected var _dockBTN:InteractiveObject;
		protected var _expandBTN:InteractiveObject;
		
		protected var _closeSkin:ISkin;
		protected var _dockSkin:ISkin;
		protected var _expandSkin:ISkin;
		
		protected var _border:Border;
		protected var _contentPane:Rack = new Rack();
		
		protected var _floating:Boolean;
		protected var _resizable:Boolean;
		protected var _expandable:Boolean;
		protected var _closable:Boolean;
		protected var _modal:Boolean;
		
		protected var _minWidth:int;
		protected var _minHeight:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ChromeWindow() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Object):void 
		{
			var titleChanged:Boolean = (("_titleBar" in properties) || 
									("_transformMatrix" in properties) ||
									("_bounds" in properties)) && _titleBar;
			var borderChanged:Boolean = (("_border" in properties) ||
									("_bounds" in properties) || 
									("_transformMatrix" in properties)) && _border;
			var statusChanged:Boolean = (("_statusBar" in properties)) || 
									("_transformMatrix" in properties ||
									("_bounds" in properties)) && _statusBar;
			var paneChanged:Boolean = ("_contentPane" in properties) || 
									titleChanged || borderChanged || statusChanged;
			var chromeHeight:int;
			var chromeBounds:Rectangle = new Rectangle();
			var controlsChanged:Boolean = ("_transformMatrix" in properties) ||
											("_expandSkin" in properties) ||
											("_dockSkin" in properties) ||
											("_closeSkin" in properties);
			super.validate(properties);
			if (titleChanged)
			{
				if (!super.contains(_titleBar)) super.addChild(_titleBar);
				var i:int = super.numChildren;
				var a:int = 1;
				var d:DisplayObject;
				while (i--)
				{
					d = super.getChildAt(i);
					if (d === _titleBar) break;
					else if (d === _closeBTN || d === _dockBTN || d === _expandBTN)
					{
						a++;
					}
				}
				super.setChildIndex(_titleBar, super.numChildren - a);
				_titleBar.width = _bounds.x;
			}
			if (borderChanged)
			{
				if (!super.contains(_border)) super.addChildAt(_border, 0);
				_border.width = _bounds.x;
				_border.height = _bounds.y;
			}
			if (statusChanged)
			{
				if (_border)
				{
					_statusBar.width = super._bounds.x - 
										(_border.left + _border.right);
					_statusBar.x = _border.left;
					_statusBar.y = super._bounds.y - 
									(_statusBar.height + _border.bottom);
				}
				else
				{
					_statusBar.width = super._bounds.x;
					_statusBar.y = super._bounds.y - _statusBar.height;
				}
				if (!super.contains(_statusBar)) super.addChild(_statusBar);
			}
			if (paneChanged)
			{
				if (_titleBar)
				{
					_contentPane.y = _titleBar.y + _titleBar.height;
					chromeHeight += _titleBar.height;
				}
				if (_border)
				{
					_contentPane.width = super._bounds.x - (_border.left + _border.right);
					_contentPane.x = _border.left;
				}
				else _contentPane.width = super._bounds.x;
				if (_statusBar) chromeHeight += _statusBar.height;
				if (_border) chromeHeight += _border.bottom;
				_contentPane.height = super._bounds.y - chromeHeight;
				if (!super.contains(_contentPane))
					_contentPane.initialized(this, "contentPane");
				chromeBounds.width = _contentPane.width;
				chromeBounds.height = _contentPane.height;
				_contentPane.validate(_contentPane.invalidProperties);
				_contentPane.scrollRect = chromeBounds;
			}
			if (controlsChanged && (_closeBTN || _dockBTN || _expandBTN))
				this.drawControlButtons();
		}
		
		protected function drawControlButtons():void
		{
			if (_closeBTN && super.contains(_closeBTN))
				super.removeChild(_closeBTN);
			if (_closeBTN)
			{
				_closeBTN = _closeSkin.produce(this) as InteractiveObject;
				_closeBTN.x = super.width - (_closeBTN.width + _border.right + 2);
				super.addChild(_closeBTN);
			}
		}
		
		/* INTERFACE org.wvxvws.gui.windows.IPane */
		
		public function created():void
		{
			
		}
		
		public function destroyed():void
		{
			
		}
		
		public function expanded():void
		{
			
		}
		
		public function collapsed():void
		{
			
		}
		
		public function choosen():void
		{
			
		}
		
		public function deselected():void
		{
			
		}
	}
}