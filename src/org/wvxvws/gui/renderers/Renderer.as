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
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	
	[Skin("org.wvxvws.skins.LabelSkin")]
	
	/**
	* Renderer class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Renderer extends Sprite implements IRenderer, ISkinnable
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
			this.drawBackground();
		}
		
		public function get isValid():Boolean
		{
			if (!this._data) return false;
			return this._field.text == this._data.toString();
		}
		
		public function get data():Object { return this._data; }
		
		public function set data(value:Object):void 
		{
			if (this.isValid && this._data === value) return;
			this._data = value;
			if (!this._data) return;
			this.renderText();
		}
		
		public function get labelSkin():ISkin { return this._labelSkin; }
		
		public function set labelSkin(value:ISkin):void 
		{
			if (this._labelSkin === value) return;
			this._labelSkin = value;
			if (this._data) this.renderText();
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin>
		{
			return new <ISkin>[this._labelSkin];
		}
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (value && value.length && this._labelSkin === value[0]) return;
			if (value && value.length) this._labelSkin = value[0];
			else this._labelSkin = null;
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data:Object;
		protected var _field:TextField = new TextField();
		protected var _document:Object;
		protected var _id:String;
		protected var _width:int;
		protected var _backgroundColor:uint = 0xFFFFFF;
		protected var _backgroundAlpha:Number = 1;
		protected var _textFormat:TextFormat = new TextFormat("_sans", 11);
		protected var _labelSkin:ISkin;
		protected var _skins:Vector.<ISkin>;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Renderer() 
		{
			super();
			super.addChild(this._field);
			this._skins = SkinManager.getSkin(this);
			if (this._skins && this._skins.length) this._labelSkin = this._skins[0];
			this._field.selectable = false;
			this._field.autoSize = TextFieldAutoSize.LEFT;
			this._field.width = 1;
			this._field.height = 1;
			this._field.defaultTextFormat = this._textFormat;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function initialized(document:Object, id:String):void
		{
			this._document = document;
			this._id = id;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function renderText():void
		{
			if (!this._data) return;
			this._field.defaultTextFormat = this._textFormat;
			if (this._labelSkin) 
				this._field.text = this._labelSkin.produce(this._data) as String;
			else this._field.text = this._data.toString();
			this.drawBackground();
		}
		
		protected function drawBackground():void
		{
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(this._backgroundColor, this._backgroundAlpha);
			g.drawRect(0, 0, this._width, this._field.height);
			g.endFill();
		}
	}
}
