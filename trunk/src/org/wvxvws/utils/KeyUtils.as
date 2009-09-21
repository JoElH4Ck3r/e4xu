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

package org.wvxvws.utils 
{
	//{imports
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	//}
	
	/**
	* KeyUtils class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class KeyUtils 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static function get currentCombination():uint
		{
			return keysToKey(_keySequence);
		}
		
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
		
		private static var _stage:Stage;
		private static var _listeners:Dictionary = new Dictionary();
		private static var _keySequence:Vector.<int> = new Vector.<int>(0, false);
		private static var _lastPressed:uint;
		
		private static const _keyNamesWinUSqwerty:Object =
		{
			"192" : "`",
			"49" : "1",
			"50" : "2",
			"51" : "3",
			"52" : "4",
			"53" : "5",
			"54" : "6",
			"55" : "7",
			"56" : "8",
			"57" : "9",
			"48" : "0",
			"189" : "-",
			"187" : "=",
			"8" : "Backspace",
			"9" : "Tab",
			"81" : "Q",
			"87" : "W",
			"69" : "E",
			"82" : "R",
			"84" : "T",
			"89" : "Y",
			"85" : "U",
			"73" : "I",
			"79" : "O",
			"80" : "P",
			"219" : "[",
			"221" : "]",
			"13" : "Enter",
			"20" : "Caps Lock",
			"65" : "A",
			"83" : "S",
			"68" : "D",
			"70" : "F",
			"71" : "G",
			"72" : "H",
			"74" : "J",
			"75" : "K",
			"76" : "L",
			"186" : ";",
			"222" : "'",
			"220" : "\\",
			"16" : "Shift",
			"90" : "Z",
			"88" : "X",
			"67" : "C",
			"86" : "V",
			"66" : "B",
			"78" : "N",
			"77" : "M",
			"188" : ",",
			"190" : ".",
			"191" : "/",
			"17" : "Ctrl",
			"91" : "Start",
			"32" : "Space",

			// Ins - Pgd
			"45" : "Ins",
			"36" : "Home",
			"33" : "PgUp",
			"46" : "Del",
			"35" : "End",
			"34" : "PgDn",

			// ESC + Fn
			"27" : "ESC",
			"112" : "F1",
			"113" : "F2",
			"114" : "F3",
			"115" : "F4",
			"116" : "F5",
			"116" : "F6",
			"117" : "F7",
			"118" : "F8",
			"119" : "F9",
			"120" : "F10",

			// arrows
			"38" : "Up",
			"37" : "Left",
			"40" : "Down",
			"39" : "Right",

			// numlock
			"144" : "Num Lock",
			"111" : "Num /",
			"106" : "Num *",
			"109" : "Num -",
			"107" : "Num +",
			"12" : "Num 5"
		};
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function KeyUtils() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function obtainStage(stage:Stage):void
		{
			_stage = stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
		}
		
		private static function keyDownHandler(event:KeyboardEvent):void 
		{
			if (_lastPressed) 
			{
				if (_lastPressed === event.keyCode) return;
			}
			_lastPressed = event.keyCode;
			_keySequence.push(event.keyCode);
			var listKey:uint;
			var seqInt:uint = keysToKey(_keySequence);
			var listener:Dictionary;
			for (var obj:Object in _listeners)
			{
				listKey = _listeners[obj];
				if (listKey === seqInt)
				{
					obj.f(event);
				}
				else
				{
					if (isBinMatch(listKey, seqInt))
					{
						obj.f(event);
					}
				}
			}
		}
		
		private static function isBinMatch(key:uint, mask:uint):Boolean
		{
			while (mask >= key)
			{
				if (key == mask) return true;
				mask >>>= 8;
			}
			return false;
		}
		
		static private function keyUpHandler(event:KeyboardEvent):void 
		{
			var index:int = _keySequence.indexOf(event.keyCode);
			if (index < 0) return;
			if (_lastPressed === event.keyCode) _lastPressed = 0;
			_keySequence.splice(index, 1);
		}
		
		public static function registerHotKeys(keys:Vector.<int>, handler:Function):void
		{
			//var kl:Dictionary = new Dictionary();
			//new Dictionary(true)
			// NOTE: if set to use weak keys, will not work
			// so far no way to store a weak reference to the method...
			//kl[handler] = true;
			_listeners[{ f: handler }] = keysToKey(keys);
		}
		
		public static function keysToKey(keys:Vector.<int>):uint
		{
			var i:int = Math.min(3, keys.length - 1) + 1;
			var ret:uint;
			var k:int;
			while (k < i)
			{
				ret = (ret << 8) | keys[k];
				k++;
			}
			return ret;
		}
		
		public static function keyToString(key:int):String
		{
			// TODO: figure out what other layouts look like.
			if (Capabilities.os.indexOf("Win") > -1)
			{
				return _keyNamesWinUSqwerty[key];
			}
			return "";
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