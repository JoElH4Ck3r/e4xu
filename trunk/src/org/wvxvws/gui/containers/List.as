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
	//{ imports
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.data.DataSet;
	import org.wvxvws.data.SetEvent;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.repeaters.IRepeater;
	import org.wvxvws.gui.repeaters.IRepeaterHost;
	import org.wvxvws.gui.repeaters.ListRepeater;
	import org.wvxvws.gui.ScrollPane;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	//}
	
	[Skin("org.wvxvws.skins.ListSkin")]
	[Skin("org.wvxvws.skins.renderers.ListRendererSkin")]
	
	[DefaultProperty("dataProvider")]
	
	// TODO: Requires some profiling, it seems like we have an 
	// insignificant, although persistent leak here.
	// However, it might been the test example that's leaking.
	// TODO: Highlight selected renderer.
	
	/**
	 * List class.
	 * @author wvxvw
	 */
	public class List extends DIV implements ISkinnable, IRepeaterHost
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return this._skins; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		/* INTERFACE org.wvxvws.gui.repeaters.IRepeaterHost */
		
		public function get factory():ISkin { return this._factory; }
		
		public function set factory(value:ISkin):void
		{
			if (this._factory === value) return;
			this._factory = value;
			super.invalidate(Invalides.DATAPROVIDER, false);
			if (super.hasEventListener(EventGenerator.getEventType("factory")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get dataProvider():DataSet { return this._dataProvider; }
		
		public function set dataProvider(value:DataSet):void
		{
			if (this._dataProvider === value) return;
			if (this._dataProvider)
			{
				this._dataProvider.removeEventListener(
					SetEvent.ADD, this.provider_addHandler);
				this._dataProvider.removeEventListener(
					SetEvent.CHANGE, this.provider_changeHandler);
				this._dataProvider.removeEventListener(
					SetEvent.REMOVE, this.provider_removeHandler);
				this._dataProvider.removeEventListener(
					SetEvent.SORT, this.provider_sortHandler);
			}
			this._dataProvider = value;
			if (_dataProvider)
			{
				this._dataProvider.addEventListener(
					SetEvent.ADD, this.provider_addHandler);
				this._dataProvider.addEventListener(
					SetEvent.CHANGE, this.provider_changeHandler);
				this._dataProvider.addEventListener(
					SetEvent.REMOVE, this.provider_removeHandler);
				this._dataProvider.addEventListener(
					SetEvent.SORT, this.provider_sortHandler);
			}
			super.invalidate(Invalides.DATAPROVIDER, false);
			if (super.hasEventListener(EventGenerator.getEventType("dataProvider")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get labelSkin():ISkin { return this._labelSkin; }
		
		public function set labelSkin(value:ISkin):void 
		{
			if (this._labelSkin === value) return;
			this._labelSkin = value;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("labelSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function set poolSize(value:int):void 
		{
			this._poolSize = value;
			while (this._pool.length > value) this._pool.shift();
		}
		
		public function get pool():Vector.<Object> { return this._pool; }
		
		[Bindable("scrollPaneChanged")]
		public function get scrollPane():ScrollPane { return this._scrollPane; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _skins:Vector.<ISkin>;
		protected var _skin:ISkin;
		protected var _dataProvider:DataSet;
		protected var _factory:ISkin;
		protected var _repeater:IRepeater;
		protected var _direction:Boolean;
		protected var _scrollPane:ScrollPane = new ScrollPane();
		protected var _position:int;
		protected var _cumulativeSize:int;
		protected var _calculatedSize:int;
		protected var _rendererSize:Point = new Point();
		protected var _pool:Vector.<Object> = new <Object>[];
		protected var _poolSize:int = 100;
		protected var _labelSkin:ISkin;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function List() 
		{
			super();
			this._skins = SkinManager.getSkin(this);
			if (this._skins)
			{
				if (this._skins.length > 0) this._skin = this._skins[0];
				if (this._skins.length > 1) this._factory = this._skins[1];
			}
			this._repeater = new ListRepeater(this);
			super.addChild(_scrollPane);
			this._scrollPane.addEventListener(
				GUIEvent.SCROLLED.type, this.scrollPane_scrolledHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function validate(properties:Dictionary):void 
		{
			var sizeChanged:Boolean = (Invalides.BOUNDS in properties);
			var needLayoutChildren:Boolean = 
						(Invalides.DATAPROVIDER in properties) || sizeChanged ||
						(Invalides.SKIN in properties);
			super.validate(properties);
			if (sizeChanged)
			{
				if (this._scrollPane.scrollRect)
				{
					this._scrollPane.scrollRect.width = this._bounds.x;
					this._scrollPane.scrollRect.height = this._bounds.y;
				}
				else
				{
					this._scrollPane.removeEventListener(
						GUIEvent.SCROLLED.type, this.scrollPane_scrolledHandler);
					this._scrollPane.scrollRect = 
						new Rectangle(0, 0, super._bounds.x, super._bounds.y);
					this._scrollPane.addEventListener(
						GUIEvent.SCROLLED.type, this.scrollPane_scrolledHandler);
				}
			}
			if (needLayoutChildren) this.layoutChildren();
		}
		
		/* INTERFACE org.wvxvws.gui.repeaters.IRepeaterHost */
		
		public function repeatCallback(currentItem:Object, index:int):Boolean
		{
			var renderer:IRenderer = currentItem as IRenderer;
			var dobj:DisplayObject = currentItem as DisplayObject;
			var ret:Boolean = true;
			if (!this._dataProvider) return false;
			if (index >= this._dataProvider.length) return false;
			if (this._direction)
			{
				dobj.x = this._position + this._cumulativeSize;
				dobj.height = this._rendererSize.y;
				this._scrollPane.addChild(dobj);
				if (this._cumulativeSize > this._bounds.y) ret = false; // + dobj.height
				if (renderer)
				{
					if (this._labelSkin) renderer.labelSkin = this._labelSkin;
					renderer.data = this._dataProvider.at(index);
				}
				this._cumulativeSize += dobj.width;
				if (!ret)
				{
					this._scrollPane.realHeight = super._bounds.y;
					this._scrollPane.realWidth = 
						this._dataProvider.length * dobj.width;
					if (this._scrollPane.scrollRect)
					{
						this._scrollPane.scrollRect.width = super._bounds.x;
						this._scrollPane.scrollRect.height = super._bounds.y;
					}
					else
					{
						this._scrollPane.removeEventListener(
							GUIEvent.SCROLLED.type, this.scrollPane_scrolledHandler);
						this._scrollPane.scrollRect = 
							new Rectangle(0, 0, super._bounds.x, super._bounds.y);
						this._scrollPane.addEventListener(
							GUIEvent.SCROLLED.type, this.scrollPane_scrolledHandler);
					}
				}
			}
			else
			{
				dobj.y = this._position + this._cumulativeSize;
				dobj.width = this._rendererSize.x;
				this._scrollPane.addChild(dobj);
				if (this._cumulativeSize > this._bounds.y) ret = false; // + dobj.height
				if (renderer)
				{
					if (this._labelSkin) renderer.labelSkin = this._labelSkin;
					renderer.data = this._dataProvider.at(index);
				}
				this._cumulativeSize += dobj.height;
				if (!ret)
				{
					this._scrollPane.realWidth = super._bounds.x;
					this._scrollPane.realHeight = 
						this._dataProvider.length * dobj.height;
					if (this._scrollPane.scrollRect)
					{
						this._scrollPane.scrollRect.width = super._bounds.x;
						this._scrollPane.scrollRect.height = super._bounds.y;
					}
					else
					{
						this._scrollPane.removeEventListener(
							GUIEvent.SCROLLED.type, this.scrollPane_scrolledHandler);
						this._scrollPane.scrollRect = 
							new Rectangle(0, 0, super._bounds.x, super._bounds.y);
						this._scrollPane.addEventListener(
							GUIEvent.SCROLLED.type, this.scrollPane_scrolledHandler);
					}
				}
			}
			return ret;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function layoutChildren():void
		{
			var d:Object = { };
			var size:int;
			if (this._direction) this._rendererSize.y = super._bounds.y;
			else this._rendererSize.x = super._bounds.x;
			while (this._scrollPane.numChildren)
			{
				d = this._scrollPane.removeChildAt(0);
				if (this._pool.indexOf(d) < 0 && this._pool.length < this._poolSize)
					this._pool.push(d);
			}
			this._cumulativeSize = 0;
			if (_direction) size = d.width;
			else size = d.height;
			this._position = ((this._position / size) >> 0) * size;
			if (this._factory) this._repeater.begin(this._position / size);
		}
		
		protected function scrollPane_scrolledHandler(event:GUIEvent):void 
		{
			if (this._direction) this._position = this._scrollPane.scrollRect.x;
			else this._position = this._scrollPane.scrollRect.y;
			this.layoutChildren();
		}
		
		protected function provider_sortHandler(event:SetEvent):void 
		{
			this.layoutChildren();
		}
		
		protected function provider_removeHandler(event:SetEvent):void 
		{
			this.layoutChildren();
		}
		
		protected function provider_changeHandler(event:SetEvent):void 
		{
			this.layoutChildren();
		}
		
		protected function provider_addHandler(event:SetEvent):void 
		{
			this.layoutChildren();
		}
	}
}