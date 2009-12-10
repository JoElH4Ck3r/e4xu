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
			if (_width === (value >> 0)) return;
			_width = value;
			this.drawBackground();
		}
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _field.text == _data.toString();
		}
		
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void 
		{
			if (isValid && _data === value) return;
			_data = value;
			if (!_data) return;
			this.renderText();
		}
		
		public function get labelSkin():ISkin { return _labelSkin; }
		
		public function set labelSkin(value:ISkin):void 
		{
			if (_labelSkin === value) return;
			_labelSkin = value;
			if (_data) this.renderText();
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return new <ISkin>[_labelSkin]; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (value && value.length && _labelSkin === value[0]) return;
			if (value && value.length) _labelSkin = value[0];
			else _labelSkin = null;
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
		
		public function Renderer() 
		{
			super();
			super.addChild(_field);
			_field.selectable = false;
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.width = 1;
			_field.height = 1;
			_field.defaultTextFormat = _textFormat;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function renderText():void
		{
			if (!_data) return;
			_field.defaultTextFormat = _textFormat;
			if (_labelSkin) 
				_field.text = _labelSkin.produce(_data) as String;
			else _field.text = _data.toString();
			this.drawBackground();
		}
		
		protected function drawBackground():void
		{
			trace("drawBackground", _field.height, _field.text);
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(_backgroundColor, _backgroundAlpha);
			g.drawRect(0, 0, _width, _field.height);
			g.endFill();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}
