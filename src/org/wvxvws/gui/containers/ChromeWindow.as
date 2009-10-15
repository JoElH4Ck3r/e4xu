package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.Border;
	import org.wvxvws.gui.ChromeBar;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	import org.wvxvws.gui.skins.SkinProducer;
	import org.wvxvws.gui.SPAN;
	import org.wvxvws.gui.windows.IPane;
	
	[DefaultProperty("children")]
	
	/**
	 * ChromeWindow class.
	 * @author wvxvw
	 */
	public class ChromeWindow extends DIV implements IPane
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
			super.dispatchEvent(new Event("modalChanged"));
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
			super.dispatchEvent(new Event("resizableChanged"));
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
			super.dispatchEvent(new Event("titleBarChanged"));
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
			super.dispatchEvent(new Event("statusBarChanged"));
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
		public function get closeSkin():ButtonSkinProducer { return _closeSkin; }
		
		public function set closeSkin(value:ButtonSkinProducer):void 
		{
			if (_closeSkin === value) return;
			_closeSkin = value;
			super.invalidate("_closeSkin", _closeSkin, false);
			super.dispatchEvent(new Event("closeSkinChanged"));
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
		public function get dockSkin():ButtonSkinProducer { return _dockSkin; }
		
		public function set dockSkin(value:ButtonSkinProducer):void 
		{
			if (_dockSkin === value) return;
			_dockSkin = value;
			super.invalidate("_dockSkin", _dockSkin, false);
			super.dispatchEvent(new Event("dockSkinChanged"));
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
		public function get expandSkin():ButtonSkinProducer { return _expandSkin; }
		
		public function set expandSkin(value:ButtonSkinProducer):void 
		{
			if (_expandSkin === value) return;
			_expandSkin = value;
			super.invalidate("_expandSkin", _expandSkin, false);
			super.dispatchEvent(new Event("expandSkinChanged"));
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
			super.dispatchEvent(new Event("borderChanged"));
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
		
		protected var _closeSkin:ButtonSkinProducer;
		protected var _dockSkin:ButtonSkinProducer;
		protected var _expandSkin:ButtonSkinProducer;
		
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
									("_transformMatrix" in properties)) && _titleBar;
			var borderChanged:Boolean = ("_border" in properties) && _border;
			var statusChanged:Boolean = ("_statusBar" in properties) && _statusBar;
			var paneChanged:Boolean = ("_contentPane" in properties) || 
									titleChanged || borderChanged || statusChanged;
			var chromeHeight:int;
			var chromeBounds:Rectangle = new Rectangle();
			super.validate(properties);
			if (titleChanged)
			{
				if (!super.contains(_titleBar)) super.addChild(_titleBar);
				_titleBar.width = super._bounds.x;
			}
			if (borderChanged)
			{
				if (!super.contains(_border)) 
				{
					super.addChildAt(_border, 0);
				}
				_border.width = super._bounds.x;
				_border.height = super._bounds.y;
			}
			if (statusChanged)
			{
				if (_border)
				{
					_statusBar.width = super._bounds.x - (_border.left + _border.right);
					_statusBar.x = _border.left;
					_statusBar.y = super._bounds.y - (_statusBar.height + _border.bottom);
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
				if (!super.contains(_contentPane)) super.addChild(_contentPane);
				chromeBounds.width = _contentPane.width;
				chromeBounds.height = _contentPane.height;
				_contentPane.validate(_contentPane.invalidProperties);
				_contentPane.scrollRect = chromeBounds;
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