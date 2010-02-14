/**
 * ...
 * @author wvxvw
 */
package org.wvxvws.xml;

enum SaxError
{
	Attribute(char:UInt, line:UInt);
	Tag(char:UInt, line:UInt);
	Comment(char:UInt, line:UInt);
}

class Sax 
{
	public var removeWhite:Bool;
	
	private var _source:String;
	private var _postion:UInt;
	private var _length:UInt;
	private var _xml:Xml;
	private var _char:String;
	private var _current:Xml;
	private var _line:UInt;
	private var _lineStarted:UInt;
	private var _name:String;
	private var _value:String;
	
	public function new(source:String) 
	{
		this._source = source;
		this._lineStarted = 0;
		this._line = 0;
		this._length = source.length;
		this._xml = Xml.createDocument();
	}
	
	public function position():UInt { return this._postion; }
	
	public function xml():Xml { return this._xml; }
	
	public function current():Xml { return this._current; }
	
	public function currentChar():String { return this._char; }
	
	public function currentName():String { return this._name; }
	
	public function currentValue():String { return this._value; }
	
	//{ reading
	public function read():Bool
	{
		if (this._current == null)
		{
			// TODO: figure the type first
			this._current = Xml.createElement("$");
			this._xml.addChild(this._current);
		}
		return this._postion <= this._length;
	}
	
	public function readChar():Bool
	{
		this._char = this._source.charAt(this._postion);
		this._postion++;
		if (this._char == "\r" || this._char == "\n")
		{
			this._lineStarted = this._postion;
			this._line++;
		}
		return this._postion <= this._length;
	}
	
	public function readNode():Bool
	{
		
		return this._postion <= this._length;
	}
	
	public function readTag():Bool
	{
		var open:Bool = false;
		var excl:Bool = false;
		var pi:Bool = false;
		var elem:Bool = false;
		var firstChar:UInt = 0;
		var chr:String = "";
		
		this.readChar();
		firstChar = this._char.charCodeAt(0);
		if ((firstChar > 64 && firstChar < 91)
			|| (firstChar > 96 && firstChar < 123) // letter
			|| firstChar == 36 || firstChar == 95) // $_
		{
			elem = true;
		}
		else
		{
			switch (firstChar)
			{
				case 33: // !
					excl = true;
				case 63: // ?
					pi = true;
			}
		}
		if (!excl && !pi && !elem)
		{
			throw SaxError.Tag(this._postion - this._lineStarted, this._line);
			return false;
		}
		if (excl)
		{
			this.readChar();
			switch (this._char)
			{
				case "-": // comment
					this.readChar();
					if (this._char != "-")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readComment();
				case "C": // CDATA
					this.readCData();
				case "c": // CDATA
					this.readCData();
				case "D": // DOCTYPE
					this.readDocType();
				case "d": // DOCTYPE
					this.readDocType();
				default:
					throw SaxError.Tag(
						this._postion - this._lineStarted, this._line);
					return false;
			}
			
		}
		return open;
	}
	
	public function readComment():Void
	{
		var wasDash:Bool = false;
		var was2Dash:Bool = false;
		var word:StringBuf = new StringBuf();
		while (this.readChar())
		{
			if (this._char == "-")
			{
				if (wasDash)
				{
					if (was2Dash)
						throw SaxError.Comment(
						this._postion - this._lineStarted, this._line);
					else was2Dash = true;
				}
				else wasDash = true;
			}
			else
			{
				if (was2Dash && this._char == ">")
				{
					this._value = word.toString();
					this._current.addChild(
						Xml.createComment("<!--" + this._value + "-->"));
					return;
				}
				if (was2Dash)
					throw SaxError.Comment(
						this._postion - this._lineStarted, this._line);
				if (wasDash) word.addChar(45);
				wasDash = false;
				word.add(this._char.charAt(0));
			}
		}
	}
	
	public function readCData():Void
	{
		
	}
	
	public function readDocType():Void
	{
		
	}
	
	public function readPI():Void
	{
		
	}
	
	public function readAttribute():Bool
	{
		var single:Bool = false;
		var found:Bool = false;
		var name:Bool = false;
		var nameStarted:Bool = false;
		var nameEnded:Bool = false;
		var nameHasSpace:Bool = false;
		var startsWithSlash:Bool = false;
		var nameHasSlashGt:Bool = false;
		var chr:Int = 0;
		var nameWord:StringBuf = new StringBuf();
		var valueWord:StringBuf = new StringBuf();
		var word:StringBuf = nameWord;
		var success:Bool = false;
		
		while (this.readChar())
		{
			if (!nameStarted && this._char == ">")
				return false;
			else if (!nameStarted && this._char == "/")
				startsWithSlash = true;
			else if (!nameStarted && this._char == ">" && startsWithSlash)
				return false;
			if (this._char == " " || this._char == "\t" || 
				this._char == "\r" || this._char == "\n")
			{
				if (nameStarted) nameHasSpace = true;
				if (!found) continue;
			}
			chr = this._char.charCodeAt(0);
			switch (this._char)
			{
				case "=":
					if (name)
						throw SaxError.Attribute(
							this._postion - this._lineStarted, this._line);
					else
					{
						name = true;
						word = valueWord;
					}
					continue;
				case "\"":
					if (found)
					{
						if (!name)
							throw SaxError.Attribute(
								this._postion - this._lineStarted, this._line);
						else if (!single)
						{
							success = true;
							break;
						}
					}
					else
					{
						found = true;
						continue;
					}
				case "'":
					if (found)
					{
						if (!name) 
							throw SaxError.Attribute(
								this._postion - this._lineStarted, this._line);
						else if (single)
						{
							success = true;
							break;
						}
					}
					else
					{
						found = true;
						single = true;
						continue;
					}
			}
			if (name) word.addChar(chr);
			else
			{
				if (chr < 48 || (chr > 58 && chr < 65) || 
					(chr > 90 && chr < 95) || chr == 96 || chr > 122)
				{
					if (this._char == " " || this._char == "\t" || 
						this._char == "\r" || this._char == "\n")
					{
						if (!nameEnded) nameEnded = true;
						else SaxError.Attribute(
							this._postion - this._lineStarted, this._line);
					}
					else if (this._char == "/" || this._char == ">")
					{
						nameHasSlashGt = true;
						continue;
					}
					if (!nameEnded)
						throw SaxError.Attribute(
							this._postion - this._lineStarted, this._line);
				}
				else
				{
					if (nameHasSpace)
						throw SaxError.Attribute(
							this._postion - this._lineStarted, this._line);
					if (nameHasSlashGt)
						throw SaxError.Attribute(
							this._postion - this._lineStarted, this._line);
					nameStarted = true;
					word.addChar(chr);
				}
			}
		}
		if (!success)
			throw SaxError.Attribute(this._postion - this._lineStarted, this._line);
		this._name = nameWord.toString();
		this._value = valueWord.toString();
		this._current.set(this._name, this._value);
		return this._postion <= this._length;
	}
	
	public function readText():Bool
	{
		var word:StringBuf = new StringBuf();
		
		while (this.readChar())
		{
			if (this._char == "<") break;
			word.add(this._char.charCodeAt(0));
		}
		if (removeWhite)
		{
			var spaced:String = word.toString();
			var i:Int = 0;
			var j:Int = spaced.length;
			var c:String;
			var buf:StringBuf = new StringBuf();
			var state:Bool = true;
			var start:Int = 0;
			
			while (i < j)
			{
				c = spaced.charAt(i);
				if (c == " " && start != i - 1)
				{
					buf.add(spaced.substr(start, i - start));
					start = i;
				}
				else if (c == " ") start++;
				i++;
			}
			if (spaced.charAt(spaced.length - 1) == " ") buf.addChar(32);
			this._value = buf.toString();
			this._current.addChild(Xml.createPCData(this._value));
		}
		else
		{
			this._value = word.toString();
			this._current.addChild(Xml.createPCData(this._value));
		}
		return this._postion <= this._length;
	}
	//}
}