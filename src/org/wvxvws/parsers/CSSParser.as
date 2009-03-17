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
								styleObject:StyleObject = null):StyleObject
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
			instance.parseXML(source);
			return instance.declarations;
		}
		
		public function parseXML(source:XML):void
		{
			_source = source;
			_source..*.@style.(parseDeclaration(toXMLString()));
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
		
		private function parseDeclaration(decl:String):void
		{
			_styleDeclaration = new AlphaProps();
			decl.replace(STYLE_RE, replaceHelper);
			if (!_declarations[_styleDeclaration.toString()])
			{
				_declarations[_styleDeclaration.toString()] = _styleDeclaration;
			}
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
	//  Private properties
	//
	//--------------------------------------------------------------------------
	
	private var _keys:Array = [];
	private var _props:Object = { };
	
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
}
