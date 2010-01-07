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

package org.wvxvws.gui.renderers 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.StatefulButton;
	
	/**
	 * ToolStripRenderer class.
	 * @author wvxvw
	 */
	public class ToolStripRenderer extends StatefulButton 
									implements IRenderer, ILayoutClient
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public override function set width(value:Number):void 
		{
			if (this._width === (value >> 0)) return;
			this._width = value;
			this.invalidate(Invalides.BOUNDS, false);
		}
		
		public override function set height(value:Number):void 
		{
			if (this._height === (value >> 0)) return;
			this._height = value;
			this.invalidate(Invalides.BOUNDS, false);
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function get isValid():Boolean
		{
			if (!this._data) return false;
			return this._invalidLayout;
		}
		
		public function set labelSkin(value:ISkin):void
		{
			if (this._labelSkin === value) return;
			this._labelSkin = value;
			this.invalidate(Invalides.SKIN, false);
		}
		
		public function get data():Object { return this._data; }
		
		public function set data(value:Object):void
		{
			if (this.isValid && this._data === value) return;
			this._data = value;
			this.invalidate(Invalides.DATAPROVIDER, false);
		}
		
		public function get label():String { return this._label; }
		
		public function set label(value:String):void 
		{
			if (this._label == value) return;
			this._label = value;
			this.invalidate(Invalides.SKIN, false);
		}
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return this._validator; }
		
		public function get invalidProperties():Dictionary
		{
			return this._invalidProperties;
		}
		
		public function get layoutParent():ILayoutClient
		{
			return this._layoutParent;
		}
		
		public function set layoutParent(value:ILayoutClient):void
		{
			this._layoutParent = value;
			if (value) this._validator = this._layoutParent.validator;
			else this._validator = null;
			this._validator.append(this, this._layoutParent);
		}
		
		public function get childLayouts():Vector.<ILayoutClient> { return null; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data:Object;
		protected var _labelSkin:ISkin;
		protected var _validator:LayoutValidator;
		protected var _layoutParent:ILayoutClient;
		protected var _invalidProperties:Dictionary = new Dictionary();
		protected var _invalidLayout:Boolean;
		protected var _labelTXT:TextField;
		protected var _label:String;
		protected var _labelFormat:TextFormat = new TextFormat("_sans", 11);
		protected var _width:int = -1;
		protected var _height:int = -1;
		protected var _backgroundColor:uint;
		protected var _backgroundAlpha:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ToolStripRenderer()
		{
			super();
			this._labelTXT = new TextField();
			this._labelTXT.defaultTextFormat = this._labelFormat;
			this._labelTXT.autoSize = TextFieldAutoSize.LEFT;
			this._labelTXT.width = 1;
			this._labelTXT.height = 1;
			this._labelTXT.selectable = false;
			super.addChild(this._labelTXT);
			super.mouseChildren = false;
			super.tabChildren = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function invalidate(property:Invalides, validateParent:Boolean):void
		{
			this._invalidProperties[property] = true;
			if (!this._validator)
			{
				if (super.parent && super.parent is ILayoutClient)
				{
					this._layoutParent = super.parent as ILayoutClient;
					this._validator = this._layoutParent.validator;
					if (this._validator)
						this._validator.append(this, this._layoutParent);
				}
			}
			if (this._validator)
			this._validator.requestValidation(this, validateParent);
			this._invalidLayout = true;
		}
		
		public function validate(properties:Dictionary):void 
		{
			var explicitHeight:int = this._height;
			var explicitWidth:int = this._width;
			if (!this._data && !(Invalides.SKIN in properties))
				properties[Invalides.SKIN] = "";
			else
			{
				if (this._labelSkin) 
					properties[Invalides.SKIN] = this._labelSkin.produce(this._data);
			}
			this._label = properties[Invalides.SKIN];
			if (this._labelTXT.text !== this._label)
			{
				this._labelTXT.text = this._label || "";
				this._height = Math.max(super.height, this._height);
				this._labelTXT.y = (this._height - this._labelTXT.height) >> 1;
				this._width = Math.max(super.width, this._width);
				this._labelTXT.x = (this._width - this._labelTXT.width) >> 1;
				
				this._height = explicitHeight;
				this._width = explicitWidth;
				
				if (this._labelTXT.x < 0)
				{
					this._labelTXT.x = 0;
					if (super.numChildren > 1)
					{
						this._width = super.width - 2;
						this._height = super.height - 2;
						this._labelTXT.scrollRect = 
							new Rectangle(0, 0, this._width, this._height);
					}
				}
				if (this._labelTXT.y < 0) this._labelTXT.y = 0;
			}
			this.drawBackground();
			this._invalidProperties = new Dictionary();
			this._invalidLayout = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function drawBackground():void
		{
			var explicitHeight:int = this._height;
			var explicitWidth:int = this._width;
			this._width = Math.max(this._width, super.width);
			this._height = Math.max(super.height, this._height);
			this._backgroundAlpha = 1;
			this._backgroundColor = 0xFF8000;
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(this._backgroundColor, this._backgroundAlpha);
			g.drawRect(0, 0, this._width, this._height);
			g.endFill();
			this._height = explicitHeight;
			this._width = explicitWidth;
		}
	}
}