package org.wvxvws.gui.styles 
{
	
	/**
	* CSSClassTable class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class CSSClassTable 
	{
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _instance:CSSClassTable;
		private static var _tables:Object = {};
		private static var _definitions:Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function CSSClassTable(initializer:CSSClass) 
		{
			super();
			if (!initializer) 
				throw new ArgumentError("Argument <initializer> must not be null!");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function getClass(className:String, 
												definition:ICSSDefinition):ICSSClass
		{
			return (definition as CSSDefinition).getClass(className);
		}
		
		public static function registerDefinition(stringCSS:String):ICSSDefinition
		{
			_definitions.push(CSSParser.parseStylesCSS(stringCSS));
			return _definitions[_definitions.length - 1];
		}
		
		public static function get definitions():Array
		{
			return _definitions.slice();
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
	}
}
/**
* CSSParser class.
* @author wvxvw
* @langVersion 3.0
* @playerVersion 10.0.12.36
*/
internal final class CSSParser 
{
	//--------------------------------------------------------------------------
	//
	//  Public properties
	//
	//--------------------------------------------------------------------------
	
	public static const STYLE_RE:RegExp = /([^:\s]+)\s*:\s*([^;]+)\s*(;|$)/g;
	public static const CLASS_RE:RegExp = /(\w*)\s*\{([^\}]*?)\}/g;
	
	public var currentProps:AlphaProps;
	//--------------------------------------------------------------------------
	//
	//  Private properties
	//
	//--------------------------------------------------------------------------
	
	private var _definition:CSSDefinition;
	private var _source:XML;
	private var _sourceCSS:String;
	private var _styleDeclaration:AlphaProps;
	private var _cssClasses:Array;
	
	private static var _isAppending:Boolean;
	private static var _staticInstance:CSSParser;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function CSSParser(source:XML = null) 
	{
		super();
		if (source !== null) parseXML(source);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public methods
	//
	//--------------------------------------------------------------------------
	
	public static function parseRawClass(classSource:String, 
					definition:ICSSDefinition, props:AlphaProps):CSSDefinition
	{
		if (!_staticInstance) _staticInstance = new CSSParser();
		_staticInstance.definition = definition;
		_staticInstance.currentProps = props;
		_staticInstance.parseRaw(classSource);
		return _staticInstance.definition as CSSDefinition;
	}
	
	public final function parseRaw(source:String):void
	{
		source.replace(STYLE_RE, classBuilderHelper);
		trace("currentProps.toString()", currentProps.toString());
	}
	
	private function classBuilderHelper(...rest):String
	{
		currentProps.setStyle(rest[1], rest[2]);
		return rest[0];
	}
	
	public static function parseStylesXML(source:XML, 
		definition:ICSSDefinition = null, tokenize:Boolean = false):ICSSDefinition
	{
		if (!_staticInstance) _staticInstance = new CSSParser();
		if (definition)
		{
			_isAppending = true;
			_staticInstance.definition = definition;
		}
		_staticInstance.parseXML(source, tokenize);
		return _staticInstance.definition;
	}
	
	public final function parseXML(source:XML, tokenize:Boolean = false):void
	{
		_source = source;
		if (!_isAppending)
		{
			_definition = new CSSDefinition(new Date().time.toString(32));
			_isAppending = false;
		}
		if (tokenize)
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
	
	public static function parseStylesCSS(cssSource:String, 
							definition:ICSSDefinition = null):ICSSDefinition
	{
		if (!_staticInstance) _staticInstance = new CSSParser();
		if (definition)
		{
			_isAppending = true;
			_staticInstance.definition = definition;
		}
		_staticInstance.parseCSS(cssSource.replace(/[\r\n]*/g, ""));
		return _staticInstance.definition;
	}
	
	public final function parseCSS(cssSource:String):void
	{
		_sourceCSS = cssSource;
		if (!_isAppending)
		{
			_definition = new CSSDefinition(new Date().time.toString(32));
			_isAppending = false;
		}
		_cssClasses = [];
		_sourceCSS.replace(CLASS_RE, classReplaceHelper);
	}
	
	private function classReplaceHelper(...rest):String
	{
		_cssClasses.push(new CSSClass(rest[1], rest[2], _definition));
		return rest[0];
	}
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
		if (!_definition[token])
		{
			_definition[token] = _styleDeclaration;
		}
		return token;
	}
	
	private function replaceHelper(...rest):String
	{
		_styleDeclaration[rest[1]] = rest[2];
		return rest[0];
	}
	
	public function get definition():ICSSDefinition { return _definition; }
	
	public function get source():XML { return _source; }
	
	public function set definition(value:ICSSDefinition):void 
	{
		_definition = value as CSSDefinition;
	}
}

import org.wvxvws.gui.styles.ICSSClass;
import org.wvxvws.gui.styles.ICSSStyle;

/**
* AlphaProps class.
* @author wvxvw
* @langVersion 3.0
* @playerVersion 10.0.12.36
*/
internal final class CSSClass implements ICSSClass
{
	private var _theClass:AlphaProps = new AlphaProps();
	private var _modifications:AlphaProps;
	private var _combined:AlphaProps;
	private var _parentDefinition:CSSDefinition;
	private var _name:String;
	
	public function CSSClass(className:String, definition:String, parent:CSSDefinition)
	{
		super();
		_parentDefinition = 
			CSSParser.parseRawClass(definition, parent, _theClass) as CSSDefinition;
		_parentDefinition.addClass(className, this);
		_name = className;
	}
	
	public final function getStyle(property:String):*
	{
		if (!_combined)
		{
			_combined = _theClass.clone().merge(_modifications);
		}
		return _combined[property];
	}
	
	public final function getCombinedStyle():AlphaProps
	{
		if (!_modifications)
		{
			return _theClass;
		}
		else
		{
			_combined = _theClass.clone().merge(_modifications);
		}
		return _combined;
	}
	
	public final function setImplicitStyle(property:String, value:*):void
	{
		_theClass.setStyle(property, value);
		_combined = _theClass.clone().merge(_modifications);
	}
	
	public final function setStyle(property:String, value:*):void
	{
		if (!_modifications) _modifications = new AlphaProps();
		_modifications.setStyle(property, value);
		_combined = _theClass.clone().merge(_modifications);
	}
	
	public final function appendModifications(style:ICSSStyle):void
	{
		if (!_modifications) _modifications = new AlphaProps();
		_modifications.merge(style as AlphaProps);
		_combined = _theClass.clone().merge(_modifications);
	}
	
	public final function get clasName():String { return _name; }
	
	public final function get parentDefinition():ICSSDefinition
	{
		return _parentDefinition;
	}
	
	public function toString():String
	{
		if (!_theClass) return _name + "{}";
		return _name + "{" + _theClass.toString() + "}";
	}
	
	public function toCombinedString():String
	{
		if (!_combined)
		{
			_combined = _theClass.clone().merge(_modifications);
		}
		return _combined.toString();
	}
}

import org.wvxvws.gui.styles.ICSSDefinition;

/**
* AlphaProps class.
* @author wvxvw
* @langVersion 3.0
* @playerVersion 10.0.12.36
*/
internal final class CSSDefinition implements ICSSDefinition
{
	private var _classes:Object = { };
	private var _styles:Object = { };
	private var _identifier:String;
	
	public function CSSDefinition(identifier:String)
	{
		super();
		_identifier = identifier;
	}
	
	public final function appendClass(classObject:CSSClass):void
	{
		_classes[classObject.clasName] = classObject;
	}
	
	public final function addClass(className:String,
												classObject:CSSClass):void
	{
		_classes[className] = classObject;
	}
	
	public final function appendStyle(style:ICSSStyle, toClass:String = null):void
	{
		if (!toClass && style is AlphaProps)
		{
			_styles[(style as AlphaProps).token] = style;
		}
		else if (toClass && (toClass in _classes) && style is AlphaProps)
		{
			(_classes[toClass] as CSSClass).appendModifications(style);
		}
	}
	
	public final function hasClass(className:String):Boolean
	{
		return (className in _classes);
	}
	
	public final function get classes():Array
	{
		var temp:Array = [];
		for (var p:String in _classes)
		{
			temp.push(_classes[p]);
		}
		return temp;
	}
	
	public final function getNameForClass(theClass:CSSClass):String
	{
		for each(var p:String in _classes)
		{
			if (_classes[p] === theClass) return p;
		}
		return "";
	}
	
	public final function getClass(className:String):ICSSClass
	{
		return _classes[className];
	}
	
	public final function get identifier():String { return _identifier; }
}

import flash.utils.Proxy;
import flash.utils.flash_proxy;
import org.wvxvws.gui.styles.ICSSStyle;

/**
* AlphaProps class.
* @author wvxvw
* @langVersion 3.0
* @playerVersion 10.0.12.36
*/
internal dynamic final class AlphaProps extends Proxy implements ICSSStyle
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
	//  Constructor
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
		for (var p:String in _props) r += p + ":" + _props[p] + "; ";
		return r;
	}
	
	public function merge(style:AlphaProps):AlphaProps
	{
		trace("--merge--");
		for (var p:String in style) _props[p] = style[p];
		return this;
	}
	
	public function clone():AlphaProps
	{
		//trace("--clone--");
		var ret:AlphaProps = new AlphaProps();
		for (var p:String in _props) ret[p] = _props[p];
		return ret;
	}
	
	public function getStyle(property:String):*
	{
		return _props[property];
	}
	
	public function setStyle(property:String, value:*):void
	{
		trace(property, value, _props);
		_props[property] = value;
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
		if (chklt > 31) throw new Error("SPAN to long.");
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