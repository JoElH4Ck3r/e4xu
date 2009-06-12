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

package org.wvxvws.gui.styles 
{
	
	//{imports
	import flash.events.IEventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	//}
	
	/**
	* CSSParser class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class CSSParser 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const conversionTable:Object =
		{
			"Array" : Array,
			"Boolean" : Boolean,
			"Class" : Class,
			"flash.geom::ColorTransform" : ColorTransform,
			"int" : int,
			"Number" : Number,
			"flash.geom::Matrix" : Matrix,
			"flash.geom::Point" : Point,
			"flash.geom::Rectangle" : Rectangle,
			"flash.text::TextFormat" : TextFormat,
			"uint" : uint
		}
		
		public static function get parsed():Boolean { return Boolean(_table); }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static const DECLARATION:RegExp = /(\.)?(\w+(\-\w)?\w*)+\s*\{([^\}]*)\}/g;
		private static const PROPERTIES:RegExp = /([^:]+)\:([^;]+)(;|$)/g;
		private static const WHITESPACE:RegExp = /[\r\n\t]|(\s\s+)/g;
		private static const TRIM:RegExp = /^\s*(.+)\s*$/;
		
		private static var _declarations:Array;
		private static var _currentRawClass:Object;
		private static var _table:CSSTable;
		private static var _pending:Dictionary = new Dictionary();
		private static var _iterator:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function CSSParser() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function parse(source:String):CSSTable
		{
			if (!_table) _table = new CSSTable();
			source = source.replace(WHITESPACE, "");
			_declarations = [];
			source.replace(DECLARATION, declarationsHelper);
			var o:Object;
			for each (o in _declarations)
			{
				_currentRawClass = { };
				o.properties.replace(PROPERTIES, propertiesHelper);
				_table.addClass(o.className, _currentRawClass);
			}
			for (o in _pending) processClient(o as ICSSClient);
			_pending = new Dictionary();
			return _table;
		}
		
		public static function stringToType(input:String, type:Class):Object
		{
			var ret:Object;
			switch (type)
			{
				case int:
					ret = parseInt(input) as Object;
					break;
				case uint:
					ret = parseInt(input, 16) as Object;
					break;
				case Number:
					ret = parseFloat(input) as Object;
					break;
				case Boolean:
					ret = (input == "true" ? true : false) as Object;
					break;
				case Array:
					ret = parseArray(input);
					break;
				case Class:
					ret = getDefinitionByName(input);
					break;
				case Point:
					ret = parsePoint(input);
					break;
				case Rectangle:
					ret = parseRectangle(input);
					break;
				case Matrix:
					ret = parseMatrix(input);
					break;
				case ColorTransform:
					ret = parseColorTransform(input);
					break;
				case TextFormat:
					ret = parseTextFormat(input);
					break;
				case String:
				default:
					ret = input;
					break;
			}
			return ret;
		}
		
		public static function applyMetaData(client:Object, style:Object):void
		{
			if (!style) return;
			var applicableStyles:XMLList = 
				describeType(client).*.(localName().match(/(^accessor$)|(^variable$)/) &&
				valueOf().hasOwnProperty("@access") && @access == "readwrite" && 
				canBeStyled(@type) && style.hasOwnProperty(@name));
			var description:XML;
			var type:Class;
			for (var p:String in style)
			{
				if (client.hasOwnProperty(p))
				{
					description = applicableStyles.(@name == p)[0];
					type = conversionTable[description.@type.toString()];
					client[p] = stringToType(style[description.@name.toString()], type);
				}
			}
		}
		
		static private function canBeStyled(className:String):Boolean
		{
			return (className in conversionTable);
		}
		
		public static function processClient(client:ICSSClient):void
		{
			var style:IEventDispatcher = _table.getClass(client.className);
			client.style = style;
			applyMetaData(client, style);
			//client.refreshStyles();
		}
		
		public static function addPendingClient(client:ICSSClient):void
		{
			_pending[client] = ++_iterator;
		}
		
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
		
		private static function parseTextFormat(input:String):Object
		{
			var tf:Array = input.split(",");
			// TODO: Parse TextFormat from string.
			return new TextFormat() as Object;
		}
		
		private static function parseColorTransform(input:String):Object
		{
			var ctt:Array = input.split(",");
			return new ColorTransform(Number(ctt[0]), Number(ctt[1]), Number(ctt[2]), 
										Number(ctt[3]), Number(ctt[4]), Number(ctt[5]), 
										Number(ctt[6]), Number(ctt[7])) as Object;
		}
		
		private static function parseMatrix(input:String):Object
		{
			var mt:Array = input.split(",");
			return new Matrix(Number(mt[0]), Number(mt[1]), Number(mt[2]), Number(mt[3]), 
												Number(mt[4]), Number(mt[5])) as Object; 
		}
		
		private static function parseRectangle(input:String):Object
		{
			var rt:Array = input.split(",");
			return new Rectangle(Number(rt[0]), Number(rt[1]), Number(rt[2]), Number(rt[3])) as Object;
		}
		
		private static function parsePoint(input:String):Object
		{
			var pt:Array = input.split(",");
			return new Point(Number(pt[0]), Number(pt[1])) as Object;
		}
		
		private static function parseArray(input:String):Object
		{
			input = input.replace(/^\[([^\]]*)\]$/, "$1");
			return input.split(",") as Object;
		}
		
		private static function propertiesHelper(match:String, propName:String, 
								propValue:String, isLast:String, index:int, all:String):void
		{
			_currentRawClass[propName.replace(TRIM, "$1")] = 
											propValue.replace(TRIM, "$1");
		}
		
		private static function declarationsHelper(match:String, dot:String, className:String, 
				hyphenated:String, properties:String, index:int, all:String):String
		{
			_declarations.push( { 	dot: dot, 
									className: className, 
									hyphenated: hyphenated, 
									properties: properties } );
			return match;
		}
	}
}