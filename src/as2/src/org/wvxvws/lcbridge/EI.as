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

import flash.external.ExternalInterface;
import org.wvxvws.lcbridge.AVM1Command;
import org.wvxvws.lcbridge.AVM1Protocol;

/**
 * org.wvxvws.lcbridge.EI class. This class provides the wrapper for 
 * AS2 content that needs to communicate to AS3 content.
 * @author wvxvw
 * @langVersion 2.0
 * @playerVersion 10.0.12.36
 */
class org.wvxvws.lcbridge.EI extends LocalConnection
{
	private static var _avaliable:Boolean = ExternalInterface.available;
	
	//Events
	public static var ON_ERROR:String = "onError";
	public static var ON_STATUS:String = "onStatus";
	
	private var _messageCommand:String = "";
	private var _messageContext:Object = { };
	private var _messageFunction:Function = null;
	private var _messageArguments:Array = [];
	private var _messageKind:Number = -1;
	private var _file:String = "";
	private var _clipLoader:MovieClipLoader;
	private var _loaderContent:MovieClip;
	private var _prop:String = "";
	
	//------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//------------------------------------------------------------------------------
	
	public function LC()
	{
		super();
		_global.AsBroadcaster.initialize(this);
		_receivingConnection = LC_NAME;
		_clipLoader = new MovieClipLoader();
		_clipLoader.addListener(this);
		this.connect(LC_NAME);
	}
	
	//------------------------------------------------------------------------------
	//
	//  Private methods
	//
	//------------------------------------------------------------------------------
	
	private function parseMethod(command:AVM1Command):Void
	{
		var scope:Object = getScope(command.scope);
		var method:Function;
		
		if (scope) method = scope[command.method];
		else method = eval(command.method);
		if (method != null)
		{
			command.operationResult = method.apply(scope, command.methodArguments);
		}
		command.type = AVM1Command.NOOP;
		var reply:AVM1Command = new AVM1Command(AVM1Command.NOOP, AVM1Protocol.NULL, 
									command.method, command.property, 
									command.propertyValue, command.methodArguments, 
									command.contentURL);
		reply.operationResult = command.operationResult;
		this.send(reply);
		broadcastMessage(ON_STATUS);
	}
	
	private function loadContent(which:String):Void
	{
		if (!_loaderContent._width)
		{
			_loaderContent = _root.createEmptyMovieClip("_loaderContent", 0);
		}
		_clipLoader.loadClip(which, _loaderContent);
	}
	
	private function parseProperty(command:AVM1Command):Void
	{
		var scope:Object = getScope(command.scope);
		var property:String;
		if (!scope) return;
		scope[command.property] = command.propertyValue;
		broadcastMessage(ON_STATUS);
	}
	
	private function getScope(scope:String):Object
	{
		switch (scope)
		{
			case AVM1Protocol.CONTENT:
				return _loaderContent;
			case AVM1Protocol.GLOBAL:
				return _global;
			case AVM1Protocol.NULL:
				return null;
			case AVM1Protocol.ROOT:
				return _root;
			case AVM1Protocol.THIS:
				return this;
			default:
				return eval(scope);
		}
		return null;
	}
	
	//------------------------------------------------------------------------------
	//
	//  Overloaded methods
	//
	//------------------------------------------------------------------------------
	
	public function send(command:AVM1Command):Boolean
	{
		return super.send(_receivingConnection, "as3recieve", command.toAMF0Object());
	}
	
	//------------------------------------------------------------------------------
	//
	//  Public methods
	//
	//------------------------------------------------------------------------------
	
	public function as2recieve(message:Object):Void
	{
		var command:AVM1Command = AVM1Command.parseFromAMF0(message);
		
		switch (command.type)
		{
			case AVM1Command.CALL_METHOD:
				parseMethod(command);
				break;
			case AVM1Command.SET_PROPERTY:
				parseProperty(command);
				break;
			case AVM1Command.LOAD_CONTENT:
				loadContent(command.contentURL);
			case AVM1Command.ERROR:
				broadcastMessage(ON_ERROR);
				break;
			case AVM1Command.NOOP:
			default:
				broadcastMessage(ON_STATUS);
				break;
		}
	}
	
	public function broadcastMessage(message:String):Void { };
	
	public function addListener(listener:Object):Void { };
	
	public function removeListener(listener:Object):Void { };
	
	public function onLoadError(clip:MovieClip, errorText:String, 
												errorNumber:Number):Void
	{
		this.send(new AVM1Command(AVM1Command.ERROR, AVM1Protocol.NULL));
	}
	
	public function onLoadInit(clip:MovieClip):Void
	{
		this.send(new AVM1Command(AVM1Command.LOAD_CONTENT, AVM1Protocol.NULL));
	}
	
	public function toString():String { return "[EI]"; }
}