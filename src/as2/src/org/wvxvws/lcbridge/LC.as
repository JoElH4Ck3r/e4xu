import org.wvxvws.lcbridge.LCMessage;
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

/**
 * org.wvxvws.lcbridge.LC class. This class provides the wrapper for 
 * AS2 content that needs to communicate to AS3 content.
 * @author wvxvw
 * @langVersion 2.0
 * @playerVersion 10.0.12.36
 */
class org.wvxvws.lcbridge.LC extends LocalConnection
{
	public static var LC_CONNECTED:String = "lcConnected";
	public static var LC_FAILED:String = "lcFailed";
	public static var LC_NAME:String = "__LC645F8553-33B1-47D1-996F-5EDFB4863061";
	
	public static var COLON:String = ":";
	public static var COMA:String = ",";
	public static var LP:String = "(";
	public static var RP:String = ")";
	public static var DOT:String = ".";
	public static var SPACE:String = " ";
	public static var EQUALS:String = "=";
	public static var PIPE:String = "|";
	
	// Commands
	public static var LD:String = "ld";
	public static var INTERNAL:String = "internal";
	public static var GLOBAL:String = "global";
	public static var ROOT:String = "root";
	public static var SET:String = "set";
	public static var CALLBACK:String = "callback";
	public static var RETURN:String = "return";
	public static var ERROR:String = "error";
	
	public function broadcastMessage() { };
	public function addListener() { };
	public function removeListener() { };
	
	private var _receivingConnection:String;
	private var _sendingConnection:String;
	
	private var _messageCommand:String = "";
	private var _messageContext:Object = { };
	private var _messageFunction:Function = null;
	private var _messageArguments:Array = [];
	private var _messageKind:Number = -1;
	private var _file:String = "";
	private var _clipLoader:MovieClipLoader;
	private var _loaderContent:MovieClip;
	private var _prop:String = "";
	private var _itr:Number = 0;
	
	public function LC()
	{
		super();
		_global.AsBroadcaster.initialize(this);
		_receivingConnection = LC_NAME;
		_clipLoader = new MovieClipLoader();
		_clipLoader.addListener(this);
		this.connect(LC_NAME);
	}
	
	public function connect(s:String):Void
	{
		if (super.connect(s))
		{
			broadcastMessage(LC_CONNECTED);
		}
		else
		{
			broadcastMessage(LC_FAILED);
			trace("AS2 connection to: " + s + " failed!");
		}
	}
	
	public function send():Void
	{
		trace("AS2 sending attempt " + _receivingConnection + " :: " + arguments);
		var message:LCMessage = new LCMessage(_messageKind, null, arguments);
		super.send(_receivingConnection, "as3recieve", message);
	}
	
	public function as2recieve(message:Object):Void
	{
		var s:String = message.data;
		trace("AS2 recieved >>> " + message.kind);
		var code:Number;
		for (var i:Number = 0; i < LCMessage.codes.length; i++)
		{
			//trace([LCMessage.codes[i], message.kind]);
			if (LCMessage.codes[i] == message.kind)
			{
				code = i;
				break;
			}
		}
		switch (code)
		{
			case LCMessage.LC_COMMAND:
				parseCommand(message.data);
				break;
			case LCMessage.LC_CUSTOM:
			case LCMessage.LC_ERROR:
			case LCMessage.LC_LOAD_START:
			case LCMessage.LC_LOADED:
			case LCMessage.LC_READY:
			case LCMessage.LC_RECEIVED:
				break;
			case LCMessage.LC_RECONNECT:
				reconnect(message.data);
				break;
			case LCMessage.LC_RETURN:
			
				break;
			default:
				_messageKind = LCMessage.LC_ERROR;
				this.send("1 Protocol error: " + code);
				break;
		}
	}
	
	private function parseCommand(input:String):Void
	{
		var parts:Array = input.split("|");
		_messageCommand = parts[0];
		if (!_messageCommand)
		{
			_messageKind = LCMessage.LC_ERROR;
			this.send("2 Protocol Error: " + input);
			return;
		}
		_messageContext = eval(parts[1]);
		_messageFunction = eval(parts[1] + "." + parts[2]);
		_messageArguments = parseArguments(parts[3]);
		
		switch (_messageCommand)
		{
			case LD:
				loadContent(parts[1]);
				break;
			case INTERNAL:
			case GLOBAL:
			case ROOT:
			case SET:
			case CALLBACK:
			case RETURN:
			case ERROR:
				break;
			default:
				_messageKind = LCMessage.LC_ERROR;
				this.send("3 Protocol Error: " + input);
				break;
		}
	}
	
	private function parseArguments(input:String):Array
	{
		// TODO: Need real eval
		var temp:Array = input.split(",");
		return temp;
	}
	
	private function buildEval(s:String, flag:String):Boolean
	{
		switch (flag)
		{
			case COLON:
				if (_messageCommand == "") _messageCommand = s;
				switch(s)
				{
					case INTERNAL:
						_messageContext = this;
						break;
					case GLOBAL:
						_messageContext = _global;
						break;
					case ROOT:
						if (!_loaderContent._width) 
							_loaderContent = 
							_root.createEmptyMovieClip("_loaderContent", 0);
						_messageContext = _loaderContent;
						break;
					case SET:
						if (!_loaderContent._width) 
							_loaderContent = 
							_root.createEmptyMovieClip("_loaderContent", 0);
						_messageContext = _loaderContent;
						break;
					case LD:
						_loaderContent.removeMovieClip();
						_loaderContent = 
						_root.createEmptyMovieClip("_loaderContent", 0);
						return false;
					case RETURN:
						if (!_loaderContent._width) 
							_loaderContent = 
							_root.createEmptyMovieClip("_loaderContent", 0);
						_messageContext = _loaderContent;
						break;
				}
				break;
			case DOT:
				if (_messageCommand != LD) _messageContext = this;
				else _messageContext = _messageContext[s];
				break;
			case LP:
				_messageFunction = _messageContext[s];
				break;
			case RP:
			case COMA:
				_messageArguments.push(s);
				break;
			case EQUALS:
				_prop = s;
				break;
		}
		return true;
	}
	
	private function exec(command:String):Void
	{
		switch (_messageCommand)
		{
			case LD:
				loadContent(command);
				break;
			case SET:
				_messageContext[_prop] = _messageArguments[0];
				break;
			case RETURN:
				this.send(_messageContext[_messageArguments[0]]);
				break;
			default:
				_messageFunction.apply(_messageContext, _messageArguments);
				break;
		}
	}
	
	private function loadContent(which:String):Void
	{
		if (!_loaderContent._width)
		{
			_loaderContent = 
							_root.createEmptyMovieClip("_loaderContent", 0);
		}
		_clipLoader.loadClip(which, _loaderContent);
	}
	
	public function onLoadError(mc:MovieClip, s:String, n:Number):Void
	{
		arguments.unshift(ERROR);
		arguments.push(_file);
		_messageKind = LCMessage.LC_ERROR;
		this.send(arguments);
	}
	
	public function onLoadStart(mc:MovieClip, s:String, n:Number):Void
	{
		arguments.unshift("loadStart");
		arguments.push(_file);
		_messageKind = LCMessage.LC_LOAD_START;
		this.send(arguments);
	}
	
	public function onLoadInit(mc:MovieClip):Void
	{
		trace("AS2 content loaded");
		arguments.push(_file);
		_messageKind = LCMessage.LC_LOADED;
		this.send(arguments);
	}
	
	public function reconnect(s:String):Void
	{
		trace("AS2 reconnecting " + s);
		super.close();
		_messageKind = LCMessage.LC_READY;
		var names:Array = s.split(PIPE);
		_receivingConnection = names[1];
		_sendingConnection = names[0];
		super.connect(_sendingConnection);
		this.send();
	}
	
	public function toMyString():String { return "[LC]"; }
}