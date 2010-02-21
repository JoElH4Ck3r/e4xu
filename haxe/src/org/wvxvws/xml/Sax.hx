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
	NodeName(char:UInt, line:UInt);
}

class SaxIter
{
    private var _sax:Sax;

    public function new(sax:Sax) { this._sax = sax; }

    public function hasNext():Bool
	{
        return this._sax.position() < this._sax.length();
    }

    public function next():SaxEntity { return this._sax.nextEntity(); }
}

typedef SaxEntity =
{
	var name:String;
	var value:String;
	var nsURI:String;
	var nsPrefix:String;
	var type:Xml.XmlType;
}

class Sax 
{
	private static var LETTERS:String = 
		"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$";
	private static var DIGITS:String = "0123456789";
	private static var ALLOWED:String = ".:-";
	private static var WHITE:String = "\t\r\n ";
	
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
	private var _currentEntity:SaxEntity;
	private var _nsURI:String;
	private var _nsPrefix:String;
	private var _type:Xml.XmlType;
	private var _openCount:Int;
	
	public function new(source:String) 
	{
		this._source = source;
		this._lineStarted = 0;
		this._line = 0;
		this._length = source.length;
		this._xml = Xml.createDocument();
		this._current = this._xml;
		this._openCount = 0;
		this._currentEntity = cast
		{ 
			name: "",
			value: "",
			nsURI: "",
			nsPrefix: "",
			type: Xml.Document
		};
	}
	
	public function position():UInt { return this._postion; }
	
	public function length():UInt { return this._length; }
	
	public function xml():Xml { return this._xml; }
	
	public function current():Xml { return this._current; }
	
	public function currentChar():String { return this._char; }
	
	public function currentName():String { return this._name; }
	
	public function currentValue():String { return this._value; }
	
	public function iterator():SaxIter { return new SaxIter(this); }
	
	public function nextEntity():SaxEntity
	{
		if (this.read()) return this._currentEntity;
		return null;
	}
	
	//{ reading
	public function read():Bool
	{
		var hasNext:Bool;
		
		if (this._openCount < 1)
		{
			this.readChar();
			if (this._char == "<")
			{
				if (this.readTag()) this._openCount++;
			}
			else
			{
				this._postion--;
				this.readText();
			}
		}
		else
		{
			hasNext = this.readChar();
			if (this._char == "<")
			{
				if (hasNext)
				{
					this.readChar();
					if (this._char == "/")
					{
						this.readCloseTag();
						//return this.read();
					}
					else if (this.readTag()) this._openCount++;
				}
			}
			else
			{
				if (hasNext)
				{
					this._postion--;
					this.readText();
				}
			}
		}
		return this._postion <= this._length;
	}
	
	public function readChar():Bool
	{
		// TODO: Verify non-printable characters
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
			switch (this._char.toLowerCase())
			{
				case "-": // comment
					this.readChar();
					if (this._char != "-")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readComment();
				case "[": // CDATA
					this.readChar();
					if (this._char.toLowerCase() != "c")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "d")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "a")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "t")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "a")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "[")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readCData();
				case "d": // DOCTYPE
					this.readChar();
					if (this._char.toLowerCase() != "o")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "c")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "t")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "y")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "p")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readChar();
					if (this._char.toLowerCase() != "e")
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
					this.readDocType();
				default:
					throw SaxError.Tag(
						this._postion - this._lineStarted, this._line);
					return false;
			}
			
		}
		else if (pi) this.readPI();
		else
		{
			this._postion--;
			this.readNodeName();
			while (this.readChar())
			{
				if (WHITE.indexOf(this._char) < 0)
				{
					this._postion--;
					break;
				}
			}
			while (this.readAttribute()) { };
			if (this._char == ">") open = true;
			else if (this._char == "/")
			{
				while (this._char != ">")
				{
					this.readChar();
					if (WHITE.indexOf(this._char) < 0)
						throw SaxError.Tag(
							this._postion - this._lineStarted, this._line);
				}
			}
			if (!open) this._current = this._current.parent;
		}
		return open;
	}
	
	public function readNodeName():Void
	{
		var word:StringBuf = new StringBuf();
		var newCurrent:Xml;
		
		this._currentEntity = cast
		{
			name: null,
			value: "",
			nsURI: null,
			nsPrefix: null,
			type: Xml.Element
		};
		this.readChar();
		if (LETTERS.indexOf(this._char) < 0)
			throw SaxError.NodeName(
					this._postion - this._lineStarted, this._line);
		word.addChar(this._char.charCodeAt(0));
		while (this.readChar())
		{
			if (this._char == "<")
				throw SaxError.NodeName(
					this._postion - this._lineStarted, this._line);
			if (LETTERS.indexOf(this._char) > -1 || DIGITS.indexOf(this._char) > -1)
			{
				word.addChar(this._char.charCodeAt(0));
			}
			else if (ALLOWED.indexOf(this._char) > -1)
			{
				if (this._char == ":")
				{
					// TODO: handle namespaces here
				}
				word.addChar(this._char.charCodeAt(0));
			}
			else if (WHITE.indexOf(this._char) > -1)
			{
				this._currentEntity.name = word.toString();
				newCurrent = Xml.createElement(this._currentEntity.name);
				this._current.addChild(newCurrent);
				this._current = newCurrent;
				break;
			}
			else 
			{
				throw SaxError.NodeName(
					this._postion - this._lineStarted, this._line);
			}
		}
	}
	
	public function readCloseTag():Void
	{
		var name:String = this._current.nodeName;
		var i:Int = 0;
		var len:Int = name.length;
		
		while (this.readChar())
		{
			if (i < len)
			{
				if (this._char != name.charAt(i))
					throw SaxError.NodeName(
						this._postion - this._lineStarted, this._line);
				i++;
			}
			else
			{
				this._postion--;
				break;
			}
		}
		while (this.readChar())
		{
			if (WHITE.indexOf(this._char) < 0)
			{
				if (this._char != ">")
					throw SaxError.NodeName(
						this._postion - this._lineStarted, this._line);
				else break;
			}
		}
		this._openCount--;
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
		var buf:StringBuf = new StringBuf();
		var firstBracket:Bool = false;
		var secondBracket:Bool = false;
		
		// TODO: Add verification for nested CDATA
		this._name = null;
		this._currentEntity = cast
		{
			name: null,
			value: "",
			nsURI: null,
			nsPrefix: null,
			type: Xml.CData
		};
		while (this.readChar())
		{
			if (this._char == "]")
			{
				if (firstBracket)
				{
					if (secondBracket)
						buf.addChar(this._char.charCodeAt(0));
					secondBracket = true;
				}
				else firstBracket = true;
			}
			else if (firstBracket && secondBracket && this._char == ">")
			{
				this._value = buf.toString();
				this._currentEntity.value = this._value;
				this._current.addChild(
						Xml.createCData(this._value));
				break;
			}
			else
			{
				if (secondBracket)
				{
					buf.add("]]");
					secondBracket = false;
					firstBracket = false;
				}
				else if (firstBracket)
				{
					buf.addChar(93); //]
					firstBracket = false;
				}
				buf.addChar(this._char.charCodeAt(0));
			}
		}
	}
	
	public function readDocType():Void
	{
		var buf:StringBuf = new StringBuf();
		
		this._name = null;
		this._currentEntity = cast
		{
			name: null,
			value: "",
			nsURI: null,
			nsPrefix: null,
			type: Xml.DocType
		};
		while (this.readChar())
		{
			if (this._char == ">")
			{
				this._value = buf.toString();
				this._currentEntity.value = this._value;
				this._current.addChild(
						Xml.createDocType(this._value));
				break;
			}
			else buf.addChar(this._char.charCodeAt(0));
		}
	}
	
	public function readPI():Void
	{
		var wasQestion:Bool = false;
		var buf:StringBuf = new StringBuf();
		
		this._currentEntity = cast
		{
			name: null,
			value: "",
			nsURI: null,
			nsPrefix: null,
			type: Xml.Prolog
		};
		this._name = null;
		while (this.readChar())
		{
			if (wasQestion && this._char == ">")
			{
				this._value = buf.toString();
				this._currentEntity.value = this._value;
				this._current.addChild(
					Xml.createProlog("<?" + this._value + ">"));
				break;
			}
			else if (this._char == "?") wasQestion = true;
			buf.addChar(this._char.charCodeAt(0));
		}
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
		var ent:SaxEntity = null;
		
		// TODO: Add verification for >, &
		// TODO: add entity type - attribute
		while (this.readChar())
		{
			if (!nameStarted && this._char == ">")
				return false;
			else if (!nameStarted && this._char == "/")
				startsWithSlash = true;
			else if (!nameStarted && this._char == ">" && startsWithSlash)
				return false;
			if (WHITE.indexOf(this._char) > -1)
			{
				if (nameStarted) nameHasSpace = true;
				if (!found) continue;
			}
			chr = this._char.charCodeAt(0);
			switch (this._char)
			{
				case "=":
					if (!nameStarted)
						throw SaxError.Attribute(
							this._postion - this._lineStarted, this._line);
					if (name)
						throw SaxError.Attribute(
							this._postion - this._lineStarted, this._line);
					else
					{
						name = true;
						this._name = word.toString();
						//ent.name = this._name;
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
				if ((!nameStarted && LETTERS.indexOf(this._char) < 0) ||
					nameStarted && (LETTERS.indexOf(this._char) < 0 && 
					DIGITS.indexOf(this._char) < 0 && ALLOWED.indexOf(this._char) < 0)) 
				{
					if (WHITE.indexOf(this._char) > -1)
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
					{
						throw SaxError.Attribute(
							this._postion - this._lineStarted, this._line);
					}
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
					//if (this._currentEntity != ent)
					//{
						//ent = cast
						//{
							//name: this._name,
							//value: this._value,
							//nsURI: this._nsURI,
							//nsPrefix: this._nsPrefix,
							//type: this._type
						//};
						//this._currentEntity = ent;
					//}
					word.addChar(chr);
				}
			}
		}
		if (!success)
			throw SaxError.Attribute(this._postion - this._lineStarted, this._line);
		this._value = valueWord.toString();
		//ent.value = valueWord.toString();
		this._current.set(this._name, this._value);
		return this._postion <= this._length;
	}
	
	public function readText():Bool
	{
		var word:StringBuf = new StringBuf();
		this._type = Xml.PCData;
		this._currentEntity = cast
		{
			name: null,
			value: "",
			nsURI: null,
			nsPrefix: null,
			type: this._type
		};
		while (this.readChar())
		{
			if (this._char == "<")
			{
				this._postion--;
				break;
			}
			word.addChar(this._char.charCodeAt(0));
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
			this._currentEntity.value = this._value;
			this._current.addChild(Xml.createPCData(this._value));
		}
		else
		{
			this._value = word.toString();
			this._currentEntity.value = this._value;
			this._current.addChild(Xml.createPCData(this._value));
		}
		return this._postion <= this._length;
	}
	//}
}