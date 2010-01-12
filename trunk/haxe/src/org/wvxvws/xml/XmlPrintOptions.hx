/**
 * ...
 * @author wvxvw
 */
package org.wvxvws.xml;

class XmlPrintOptions 
{
	public var indent:UInt;
	public var lineEnd:Int;
	public var indentChar:Int;
	public var lineMaxLength:Int;
	public var attributeSorting:Int;
	public var attributesOnNewLine:Bool;
	public var gtOnNewLine:Int;
	public var ignorePIs:Bool;
	public var ignoreComments:Bool;
	public var unicodeToCodepoints:Bool;
	public var outputXmlNsSettings:Bool;
	public var ignoreXmlSettings:Bool;
	public var outputProlog:Bool;
	public var xmlVersion:String;
	public var xmlEncoding:String;
	public var useSingleQuotes:Bool;
	public var wrapEqWithSpaces:Bool;
	
	public function new() 
	{
		this.indent = 1;
		this.lineEnd = 13;
		this.indentChar = 9;
		this.lineMaxLength = -1;
		this.attributeSorting -1;
		this.attributesOnNewLine = false;
		this.gtOnNewLine = false;
		this.ignorePIs = false;
		this.ignoreComments = false;
		this.unicodeToCodepoints = false;
		this.outputXmlNsSettings = false;
		this.ignoreXmlSettings = true;
		this.outputProlog = false;
		this.xmlVersion = "1.0";
		this.xmlEncoding = "UTF-8";
		this.useSingleQuotes = false;
		this.wrapEqWithSpaces = false;
	}
}