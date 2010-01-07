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
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.renderers.IMenuRenderer;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.SkinManager;
	import org.wvxvws.skins.Skin;
	import org.wvxvws.utils.KeyUtils;
	//}
	
	[DefaultProperty("dataProvider")]
	
	[Skin("org.wvxvws.skins.MenuSkin")]
	[Skin("org.wvxvws.skins.LabelSkin")]
	
	/**
	* Menu class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Menu extends Pane
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const CHECK:String = "check";
		public static const CONTAINER:String = "container";
		public static const RADIO:String = "radio";
		public static const SEPARATOR:String = "separator";
		public static const NONE:String = "";
		
		//------------------------------------
		//  Public property hasMouse
		//------------------------------------
		
		public function get hasMouse():Boolean
		{
			var rect:Rectangle = 
				new Rectangle(super.x, super.y, 
				this._cumulativeWidth, this._cumulativeHeight);
			var p:Point = new Point(super.mouseX, super.mouseY);
			return rect.containsPoint(p);
		}
		
		//------------------------------------
		//  Public property dataProvider
		//------------------------------------
		
		public override function set dataProvider(value:XML):void 
		{
			super.dataProvider = value;
			if (this._isDeferredKeyInit) this.initiKeyListener();
		}
		
		public function get borderWidth():Number { return this._borderWidth; }
		
		public function set borderWidth(value:Number):void 
		{
			this._borderWidth = value;
		}
		
		public function get borderColor():uint { return this._borderColor; }
		
		public function set borderColor(value:uint):void 
		{
			this._borderColor = value;
		}
		
		public function get itemClickHandler():Function { return this._itemClickHandler; }
		
		public function set itemClickHandler(value:Function):void 
		{
			this._itemClickHandler = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _groups:Vector.<Vector.<IMenuRenderer>>;
		protected var _iconProducer:ISkin;
		protected var _iconField:String = "@icon";
		protected var _hotkeysField:String = "@hotkeys";
		protected var _kindField:String = "@kind";
		protected var _enabledField:String = "@enabled";
		protected var _lastGroup:Vector.<IMenuRenderer>;
		protected var _cumulativeHeight:int;
		protected var _cumulativeWidth:int;
		protected var _nextY:int;
		protected var _borderWidth:Number;
		protected var _borderColor:uint;
		protected var _openedItem:IMenuRenderer;
		protected var _itemClickHandler:Function;
		protected var _childMenu:Menu;
		protected var _parentMenu:Menu;
		protected var _isRootMenu:Boolean;
		protected var _isDeferredKeyInit:Boolean;
		protected var _keyListenersMap:Dictionary = new Dictionary();
		protected var _cellHeight:int = 24;
		
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
		
		public function Menu()
		{
			var skins:Vector.<ISkin>;
			super();
			skins = SkinManager.getSkin(this);
			if (skins && skins.length) super._rendererSkin = skins[0];
			super.addEventListener(GUIEvent.OPENED.type, this.openedHandler);
			super.addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
			super.addEventListener(Event.ADDED_TO_STAGE, this.atsHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function collapseChildMenu():void
		{
			if (this._childMenu && super.contains(this._childMenu))
			{
				this._openedItem = null;
				super.removeChild(this._childMenu);
				this._childMenu = null;
			}
		}
		
		public override function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			if (document is Menu) this._parentMenu = document as Menu;
			else this.initiKeyListener();
		}
		
		public function initiKeyListener():void
		{
			this._isRootMenu = true;
			var hkList:XMLList;
			var compositeKey:Vector.<int>;
			if (this._dataProvider)
			{
				hkList = _dataProvider..*.(hasOwnProperty(this._hotkeysField));
				for each (var node:XML in hkList)
				{
					if (!node[this._hotkeysField].toString().length) continue;
					compositeKey = Vector.<int>(node[_hotkeysField].toString().split("|"));
					this._keyListenersMap[node] = KeyUtils.keysToKey(compositeKey);
					KeyUtils.registerHotKeys(compositeKey, this.defaultKeyHandler);
				}
			}
			else this._isDeferredKeyInit = true;
		}
		
		private function defaultKeyHandler(event:KeyboardEvent):void
		{
			var sequenceCode:uint = KeyUtils.currentCombination;
			if (this._itemClickHandler !== null)
			{
				for (var obj:Object in this._keyListenersMap)
				{
					if (this._keyListenersMap[obj] === sequenceCode)
					{
						this._itemClickHandler(obj);
					}
				}
			}
		}
		
		public override function validate(properties:Dictionary):void 
		{
			super.validate(properties);
			this.drawIconBG();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function layOutChildren():void 
		{
			this._cumulativeHeight = 0;
			this._cumulativeWidth = 0;
			this._nextY = 0;
			if (this._childMenu && contains(this._childMenu))
				super.removeChild(this._childMenu);
			super.layOutChildren();
			super._bounds.x = this._cumulativeWidth;
			super._bounds.y = this._cumulativeHeight;
			var i:int = super.numChildren;
			var child:DisplayObject;
			while (i--)
			{
				child = super.getChildAt(i);
				child.width = this._cumulativeWidth;
			}
			if (this._childMenu) super.addChild(this._childMenu);
		}
		
		protected override function createChild(xml:XML):DisplayObject 
		{
			var child:IMenuRenderer = super.createChild(xml) as IMenuRenderer;
			if (!child) return null;
			var childWidth:int;
			child.iconProducer = _iconProducer;
			if (xml[this._hotkeysField].toString().length)
			{
				child.hotKeys = 
					Vector.<int>(xml[this._hotkeysField].toString().split("|"));
			}
			if (xml.hasSimpleContent()) child.kind = xml[this._kindField].toString();
			child.enabled = xml[this._enabledField] != "false";
			if (child.kind !== SEPARATOR)
			{
				if (!this._groups)
					this._groups = new Vector.<Vector.<IMenuRenderer>>(0, false);
				if (!this._lastGroup)
					this._lastGroup = new Vector.<IMenuRenderer>(0, false);
				this._lastGroup.push(child);
				this._groups.push(this._lastGroup);
			}
			else
			{
				this._lastGroup = new Vector.<IMenuRenderer>(0, false);
				this._lastGroup.push(child);
				this._groups.push(this._lastGroup);
			}
			(child as DisplayObject).height = this._cellHeight;
			(child as DisplayObject).y = this._nextY;
			if (child.kind == SEPARATOR) this._nextY += 4;
			else this._nextY += this._cellHeight;
			if (child is ILayoutClient)
			{
				(child as ILayoutClient).validate(
					(child as ILayoutClient).invalidProperties);
			}
			if (child is IMenuRenderer)
			{
				(child as IMenuRenderer).clickHandler = this._itemClickHandler;
				childWidth = (child as IMenuRenderer).desiredWidth;
			}
			else
			{
				childWidth = (child as DisplayObject).width + 
							(child as DisplayObject).x;
			}
			this._cumulativeWidth = Math.max(this._cumulativeWidth, childWidth);
			this._cumulativeHeight = this._nextY;
			return child as DisplayObject;
		}
		
		protected function drawIconBG():void
		{
			var g:Graphics = super.graphics;
			g.clear();
			g.lineStyle(this._borderWidth, this._borderColor);
			g.beginFill(super._backgroundColor, super._backgroundAlpha);
			g.drawRect(0, 0, this._cumulativeWidth, this._cumulativeHeight);
			g.endFill();
			g.beginFill(0xD0D0D0);
			g.drawRect(0, 0, 20, this._cumulativeHeight);
			g.endFill();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function atsHandler(event:Event):void 
		{
			super.removeEventListener(Event.ADDED_TO_STAGE, this.atsHandler);
			KeyUtils.obtainStage(stage);
		}
		
		private function rollOutHandler(event:MouseEvent):void 
		{
			if (this._parentMenu && event.target is Menu)
				this._parentMenu.collapseChildMenu();
		}
		
		private function selectedHandler(node:XML):void 
		{
			if (this._itemClickHandler !== null) this._itemClickHandler(node);
		}
		
		private function openedHandler(event:GUIEvent):void 
		{
			event.stopImmediatePropagation();
			if (this._openedItem === event.target) return;
			this._openedItem = event.target as IMenuRenderer;
			if (this._childMenu && super.contains(this._childMenu))
			{
				if (!this._childMenu.hasMouse) this.collapseChildMenu();
			}
			if (!this._openedItem) return;
			if (this._openedItem.kind !== CONTAINER || !this._openedItem.enabled)
				return;
			this._childMenu = new Menu();
			this._childMenu.backgroundAlpha = this._backgroundAlpha;
			this._childMenu.backgroundColor = this._backgroundColor;
			this._childMenu.borderWidth = this._borderWidth;
			this._childMenu.borderColor = this._borderColor;
			this._childMenu.skin = this._skin;
			this._childMenu.dataProvider = this._openedItem.data as XML;
			this._childMenu.x = (this._openedItem as DisplayObject).x + 
							(this._openedItem as DisplayObject).width;
			this._childMenu.y = (this._openedItem as DisplayObject).y;
			this._childMenu.visible = false;
			this._childMenu.itemClickHandler = this._itemClickHandler;
			this._childMenu.initialized(this, "_childMenu");
			this._childMenu.validate(this._childMenu.invalidProperties);
			this._childMenu.visible = true;
		}
	}
}