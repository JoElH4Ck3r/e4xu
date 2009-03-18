package org.wvxvws.parsers 
{
	
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
		
		public static const STYLE_RE:RegExp = /([^:\s]+)\s*:\s*([^;]+)\s*;/g;
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _declarations:StyleObject;
		protected var _source:XML;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _styleDeclaration:AlphaProps;
		private static var _staticInstance:CSSParser;
		private static var _instances:Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function CSSParser(source:XML = null) 
		{
			super();
			_declarations = new StyleObject(this);
			if (source !== null) parseXML(source);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function parseStylesXML(source:XML, 
				styleObject:StyleObject = null, tokenise:Boolean = false):StyleObject
		{
			var instance:CSSParser;
			if (styleObject && (styleObject.parser in _instances))
			{
				instance = _instances[_instances.indexOf(styleObject.parser)];
			}
			else if (styleObject)
			{
				_instances.push(styleObject);
				instance = styleObject.parser;
			}
			else
			{
				if (!_staticInstance) _staticInstance = new CSSParser();
				instance = _staticInstance;
				_instances.push(instance);
			}
			instance.parseXML(source, tokenise);
			return instance.declarations;
		}
		
		public function parseXML(source:XML, tokenise:Boolean = false):void
		{
			_source = source;
			if (tokenise)
			{
				_source..*.@style.(parent().@[name()] = 
					parseDeclaration(toXMLString().replace(/\r|\n|\t/g, "")));
			}
			else
			{
				_source..*.@style.(
					parseDeclaration(toXMLString().replace(/\r|\n|\t/g, "")));
			}
		}
		
		public function parseCSS(cssSource:String):void
		{
			
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
		
		private function parseDeclaration(decl:String):String
		{
			_styleDeclaration = new AlphaProps();
			decl.replace(STYLE_RE, replaceHelper);
			var token:String = _styleDeclaration.token;
			if (!_declarations[token])
			{
				_declarations[token] = _styleDeclaration;
			}
			return token;
		}
		
		private function replaceHelper(...rest):String
		{
			_styleDeclaration[rest[1]] = rest[2];
			return rest[0];
		}
		
		public function get declarations():StyleObject { return _declarations; }
		
		public function get source():XML { return _source; }
	}
}

import flash.utils.Proxy;
import flash.utils.flash_proxy;

/**
* AlphaProps class.
* @author wvxvw
* @langVersion 3.0
* @playerVersion 10.0.12.36
*/
internal dynamic final class AlphaProps extends Proxy
{
	//--------------------------------------------------------------------------
	//
	//  Public properties
	//
	//--------------------------------------------------------------------------
	
	public function get token():String
	{
		if (_needHashRegen)
		{
			_hash = hash(toString().replace(/\W+/g, ""));
			_needHashRegen = false;
		}
		return _hash;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private properties
	//
	//--------------------------------------------------------------------------
	
	private var _keys:Array = [];
	private var _props:Object = { };
	private var _needHashRegen:Boolean;
	private var _hash:String;
	
	//--------------------------------------------------------------------------
	//
	//  Cunstructor
	//
	//--------------------------------------------------------------------------
	
	public function AlphaProps() { super(); }
	
	//--------------------------------------------------------------------------
	//
	//  Public methods
	//
	//--------------------------------------------------------------------------
	
	public function toString():String
	{
		var r:String = "";
		for (var p:String in this) r += p + "=\"" + this[p] + "\" ";
		return r;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected methods
	//
	//--------------------------------------------------------------------------
	
	override flash_proxy function getProperty(name:*):* { return _props[name]; }
	
	override flash_proxy function setProperty(name:*, value:*):void 
	{
		_needHashRegen = true;
		_keys.push(name);
		_keys.sort();
		_props[name] = value;
	}
	
	override flash_proxy function nextName(index:int):String { return _keys[index - 1]; }
	
	override flash_proxy function nextNameIndex(index:int):int 
	{
		if (_keys.length > index) return index + 1;
		return 0;
	}
	
	override flash_proxy function nextValue(index:int):* { return _props[_keys[index]]; }
	
	private static function hash(input:String):String
	{
		while (input.length % 8) input += "z";
		var ilt:int = input.length;
		var chklt:int = ilt / 8;
		if (chklt > 31) throw new Error("Input to long.");
		var arr:Array = [];
		var wlt:int;
		var wsum:int;
		var i:int;
		var ix:int;
		var rs:String = "";
		var p:String;
		while (arr.length < 8)
		{
			arr.push(input.substr(chklt * arr.length, chklt));
		}
		for (ix = 0; ix < 8; ix++)
		{
			p = arr[ix];
			wlt = p.length;
			wsum = 0;
			i = 0;
			while (i < chklt)
			{
				wsum += p.charCodeAt(i);
				wsum += wsum % p.charCodeAt(i);
				i++;
			}
			rs = wsum.toString(32);
			while (rs.length < 3) rs = "0" + rs;
			arr[ix] = wlt.toString(32) + rs;
		}
		return arr.join("");
	}
}
