////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.Border;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.layout.Invalides;
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
			if (value < this._minWidth) value = this._minWidth;
			super.width = value;
		}
		
		//------------------------------------
		//  Public property width
		//------------------------------------
		
		public override function set height(value:Number):void 
		{
			if (value < this._minHeight) value = this._minHeight;
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
		public function get modal():Boolean { return this._modal; }
		
		public function set modal(value:Boolean):void
		{
			if (this._modal === value) return;
			this._modal = value;
			super.invalidate(Invalides.STATE, false);
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
		public function get resizable():Boolean { return this._resizable; }
		
		public function set resizable(value:Boolean):void
		{
			if (this._resizable === value) return;
			this._resizable = value;
			super.invalidate(Invalides.STATE, false);
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
		public function get titleBar():ChromeBar { return this._titleBar; }
		
		public function set titleBar(value:ChromeBar):void 
		{
			if (this._titleBar === value) return;
			if (this._titleBar && super.contains(this._titleBar)) 
				super.removeChild(this._titleBar);
			this._titleBar = value;
			super.invalidate(Invalides.CHILDREN, false);
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
		public function get statusBar():SPAN { return this._statusBar; }
		
		public function set statusBar(value:SPAN):void 
		{
			if (this._statusBar === value) return;
			if (this._statusBar && super.contains(this._statusBar)) 
				super.removeChild(_statusBar);
			this._statusBar = value;
			super.invalidate(Invalides.CHILDREN, false);
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
		public function get closeSkin():ISkin { return this._closeSkin; }
		
		public function set closeSkin(value:ISkin):void 
		{
			if (this._closeSkin === value) return;
			this._closeSkin = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get dockSkin():ISkin { return this._dockSkin; }
		
		public function set dockSkin(value:ISkin):void 
		{
			if (this._dockSkin === value) return;
			this._dockSkin = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get expandSkin():ISkin { return this._expandSkin; }
		
		public function set expandSkin(value:ISkin):void 
		{
			if (this._expandSkin === value) return;
			this._expandSkin = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get border():Border { return this._border; }
		
		public function set border(value:Border):void 
		{
			if (this._border === value) return;
			this._border = value;
			super.invalidate(Invalides.CHILDREN, false);
			if (super.hasEventListener(EventGenerator.getEventType("border")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property children
		//------------------------------------
		
		public function get children():Vector.<DisplayObject>
		{
			return this._contentPane.children;
		}
		
		public function set children(value:Vector.<DisplayObject>):void 
		{
			if (this._contentPane.children === value) return;
			this._contentPane.children = value;
			super.invalidate(Invalides.CHILDREN, false);
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return null; }
		
		public function set skin(value:Vector.<ISkin>):void { }
		
		public function get parts():Object
		{
			return { close: this._closeSkin,
					dock: this._dockSkin,
					expand: this.expandSkin }
		}
		
		public function set parts(value:Object):void
		{
			if (value)
			{
				this._closeSkin = value["close"];
				this._dockSkin = value["dock"];
				this._expandSkin = value["expand"];
			}
			else
			{
				this._closeSkin = null;
				this._dockSkin = null;
				this._expandSkin = null;
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
		
		public override function validate(properties:Dictionary):void 
		{
			var titleChanged:Boolean = ((Invalides.CHILDREN in properties) || 
									(Invalides.TRANSFORM in properties) ||
									(Invalides.BOUNDS in properties)) && _titleBar;
			var borderChanged:Boolean = ((Invalides.CHILDREN in properties) ||
									(Invalides.BOUNDS in properties) || 
									(Invalides.TRANSFORM in properties)) && _border;
			var statusChanged:Boolean = ((Invalides.CHILDREN in properties)) || 
									(Invalides.TRANSFORM in properties ||
									(Invalides.BOUNDS in properties)) && _statusBar;
			var paneChanged:Boolean = (Invalides.CHILDREN in properties) || 
									titleChanged || borderChanged || statusChanged;
			var chromeHeight:int;
			var chromeBounds:Rectangle = new Rectangle();
			var controlsChanged:Boolean = (Invalides.TRANSFORM in properties) ||
											(Invalides.SKIN in properties);
			super.validate(properties);
			if (titleChanged)
			{
				if (!super.contains(_titleBar)) super.addChild(this._titleBar);
				var i:int = super.numChildren;
				var a:int = 1;
				var d:DisplayObject;
				while (i--)
				{
					d = super.getChildAt(i);
					if (d === this._titleBar) break;
					else if (d === this._closeBTN || d === this._dockBTN || 
						d === this._expandBTN)
					{
						a++;
					}
				}
				super.setChildIndex(this._titleBar, super.numChildren - a);
				this._titleBar.width = super._bounds.x;
			}
			if (borderChanged)
			{
				if (!super.contains(_border)) super.addChildAt(this._border, 0);
				this._border.width = this._bounds.x;
				this._border.height = this._bounds.y;
			}
			if (statusChanged)
			{
				if (this._border)
				{
					this._statusBar.width = super._bounds.x - 
										(this._border.left + this._border.right);
					this._statusBar.x = this._border.left;
					this._statusBar.y = super._bounds.y - 
									(this._statusBar.height + this._border.bottom);
				}
				else
				{
					this._statusBar.width = super._bounds.x;
					this._statusBar.y = super._bounds.y - this._statusBar.height;
				}
				if (!super.contains(this._statusBar)) super.addChild(this._statusBar);
			}
			if (paneChanged)
			{
				if (this._titleBar)
				{
					this._contentPane.y = this._titleBar.y + this._titleBar.height;
					chromeHeight += this._titleBar.height;
				}
				if (this._border)
				{
					this._contentPane.width = super._bounds.x - 
						(this._border.left + this._border.right);
					this._contentPane.x = this._border.left;
				}
				else this._contentPane.width = super._bounds.x;
				if (this._statusBar) chromeHeight += this._statusBar.height;
				if (this._border) chromeHeight += this._border.bottom;
				this._contentPane.height = super._bounds.y - chromeHeight;
				if (!super.contains(this._contentPane))
					this._contentPane.initialized(this, "contentPane");
				chromeBounds.width = this._contentPane.width;
				chromeBounds.height = this._contentPane.height;
				this._contentPane.validate(this._contentPane.invalidProperties);
				this._contentPane.scrollRect = chromeBounds;
			}
			if (controlsChanged && (this._closeBTN || this._dockBTN || this._expandBTN))
				this.drawControlButtons();
		}
		
		protected function drawControlButtons():void
		{
			if (this._closeBTN && super.contains(this._closeBTN))
				super.removeChild(this._closeBTN);
			if (this._closeBTN)
			{
				this._closeBTN = this._closeSkin.produce(this) as InteractiveObject;
				this._closeBTN.x = super.width - 
					(this._closeBTN.width + this._border.right + 2);
				super.addChild(this._closeBTN);
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