package org.wvxvws.automation.syntax
{
	import flash.utils.ByteArray;
	
	import org.wvxvws.automation.language.Atom;
	import org.wvxvws.automation.language.Cons;
	import org.wvxvws.automation.types.numeric.$Fixnum;
	import org.wvxvws.automation.types.numeric.$Float;
	import org.wvxvws.automation.types.numeric.$Ratio;

	public class Reader
	{
		private static const _values:Values = new Values();
		
		private static const _steps:Vector.<Function> =
			new <Function>[step2, step3, step4, step5, step6, step7];
		
		private static const _atoms:Vector.<Atom> = new <Atom>[];
		
		public static var table:DispatchTable = new CommonTable();
		
		public static var currentInputRadix:int = 10;
		
		/**
		 * character  syntax type                 character  syntax type             
		 * Backspace  constituent                 0--9       constituent             
		 * Tab        whitespace[2]               :          constituent             
		 * Newline    whitespace[2]               ;          terminating macro char  
		 * Linefeed   whitespace[2]               &lt;          constituent             
		 * Page       whitespace[2]               =          constituent             
		 * Return     whitespace[2]               &gt;          constituent             
		 * Space      whitespace[2]               ?          constituent&#42;            
		 * !          constituent*                &#64;          constituent             
		 * "          terminating macro char      A--Z       constituent             
		 * #          non-terminating macro char  [          constituent&#42;            
		 * $          constituent                 \          single escape           
		 * %          constituent                 ]          constituent&#42;            
		 * &amp;          constituent                 ^          constituent             
		 * '          terminating macro char      _          constituent             
		 * (          terminating macro char      `          terminating macro char  
		 * )          terminating macro char      a--z       constituent             
		 * &#42;          constituent                 {          constituent&#42;            
		 * +          constituent                 |          multiple escape         
		 * ,          terminating macro char      }          constituent&#42;            
		 * -          constituent                 ~          constituent             
		 * .          constituent                 Rubout     constituent             
		 * /          constituent                 
		 * 
		 * 
		 */
		public function Reader() { super(); }
		
		/**
		 * 1. If at end of file, end-of-file processing is performed as specified 
		 * in read. Otherwise, one character, x, is read from the input stream, 
		 * and dispatched according to the syntax type of x to one of steps 2 to 7.
		 * 
		 * 2. If x is an invalid character, an error of type reader-error is 
		 * signaled.
		 * 
		 * 3. If x is a whitespace[2] character, then it is discarded and step 1 
		 * is re-entered.
		 * 
		 * 4. If x is a terminating or non-terminating macro character then its 
		 * associated reader macro function is called with two arguments, 
		 * the input stream and x.
		 * 
		 *     The reader macro function may read characters from the input stream;
		 * if it does, it will see those characters following the macro character. 
		 * The Lisp reader may be invoked recursively from the reader macro 
		 * function.
		 * 
		 *     The reader macro function must not have any side effects other than 
		 * on the input stream; because of backtracking and restarting of the read 
		 * operation, front ends to the Lisp reader (e.g., ``editors'' and 
		 * ``rubout handlers'') may cause the reader macro function to be called 
		 * repeatedly during the reading of a single expression in which x only 
		 * appears once.
		 * 
		 *     The reader macro function may return zero values or one value. 
		 * If one value is returned, then that value is returned as the result of 
		 * the read operation; the algorithm is done. If zero values are returned, 
		 * then step 1 is re-entered.
		 * 
		 * 5. If x is a single escape character then the next character, y, is read, 
		 * or an error of type end-of-file is signaled if at the end of file. y is 
		 * treated as if it is a constituent whose only constituent trait is 
		 * alphabetic[2]. y is used to begin a token, and step 8 is entered.
		 * 
		 * 6. If x is a multiple escape character then a token (initially 
		 * containing no characters) is begun and step 9 is entered.
		 * 
		 * 7. If x is a constituent character, then it begins a token. After 
		 * the token is read in, it will be interpreted either as a Lisp object 
		 * or as being of invalid syntax. If the token represents an object, 
		 * that object is returned as the result of the read operation. If the 
		 * token is of invalid syntax, an error is signaled. If x is a character 
		 * with case, it might be replaced with the corresponding character of 
		 * the opposite case, depending on the readtable case of the current 
		 * readtable, as outlined in Section 23.1.2 (Effect of Readtable Case on 
		 * the Lisp Reader). X is used to begin a token, and step 8 is entered.
		 * 
		 * 8. At this point a token is being accumulated, and an even number of 
		 * multiple escape characters have been encountered. If at end of file, 
		 * step 10 is entered. Otherwise, a character, y, is read, and one of the 
		 * following actions is performed according to its syntax type:
		 * 
		 *     &#42; If y is a constituent or non-terminating macro character:
		 * 
		 *         -- If y is a character with case, it might be replaced with the 
		 * corresponding character of the opposite case, depending on the readtable 
		 * case of the current readtable, as outlined in Section 23.1.2 (Effect of 
		 * Readtable Case on the Lisp Reader).
		 *         -- Y is appended to the token being built.
		 *         -- Step 8 is repeated.
		 * 
		 *     &#42; If y is a single escape character, then the next character, z, is 
		 * read, or an error of type end-of-file is signaled if at end of file. 
		 * Z is treated as if it is a constituent whose only constituent trait is 
		 * alphabetic[2]. Z is appended to the token being built, and step 8 is 
		 * repeated.
		 * 
		 *     &#42; If y is a multiple escape character, then step 9 is entered.
		 * 
		 *     &#42; If y is an invalid character, an error of type reader-error is 
		 * signaled.
		 * 
		 *     &#42; If y is a terminating macro character, then it terminates the token. 
		 * First the character y is unread (see unread-char), and then step 10 is 
		 * entered.
		 * 
		 *     &#42; If y is a whitespace[2] character, then it terminates the token. 
		 * First the character y is unread if appropriate (see 
		 * read-preserving-whitespace), and then step 10 is entered.
		 * 
		 * 9. At this point a token is being accumulated, and an odd number of 
		 * multiple escape characters have been encountered. If at end of file, 
		 * an error of type end-of-file is signaled. Otherwise, a character, y, 
		 * is read, and one of the following actions is performed according to its 
		 * syntax type:
		 * 
		 *     &#42; If y is a constituent, macro, or whitespace[2] character, y is 
		 * treated as a constituent whose only constituent trait is alphabetic[2]. 
		 * Y is appended to the token being built, and step 9 is repeated.
		 * 
		 *     &#42; If y is a single escape character, then the next character, z, is 
		 * read, or an error of type end-of-file is signaled if at end of file. 
		 * Z is treated as a constituent whose only constituent trait is 
		 * alphabetic[2]. Z is appended to the token being built, and step 9 is 
		 * repeated.
		 * 
		 *     &#42; If y is a multiple escape character, then step 8 is entered.
		 * 
		 *     &#42; If y is an invalid character, an error of type reader-error is 
		 * signaled.
		 * 
		 * 10. An entire token has been accumulated. The object represented by 
		 * the token is returned as the result of the read operation, or an error 
		 * of type reader-error is signaled if the token is not of valid syntax. 
		 * 
		 * @param from
		 * @return 
		 * 
		 */
		public static function read(from:ByteArray):Atom
		{
			var token:Token = new Token();
			var keepGoing:Boolean = true;
			var reenter:Boolean;
			
//			while (keepGoing)
//			{
//				switch (true)
//				{
//					case step1(from, token):
//						
//						break;
//					case step2(from, token):
//					case step3(from, token):
//					case step4(from, token):
//					case step5(from, token):
//					case step6(from, token):
//					case step7(from, token):
//						reenter = true;
//						break;
//				}
//			}
			step1(from, token);
			if (token.error) throw token.error;
			return token.value;
		}
		
		public static function push(token:Atom):Atom
		{
			_atoms.push(token);
			return token;
		}
		
		public static function pop():Atom { return _atoms.pop(); }
		
		public static function last():Atom
		{
			var result:Atom;
			if (_atoms.length) _atoms[_atoms.length];
			return result;
		}
		
		private static function eofHandle(token:Token):String
		{
			return token.error = "end-of-file";
		}
		
		private static function readerErrorHandle(token:Token):String
		{
			return token.error = "reader-error";
		}
		
		private static function dispatch(from:ByteArray, token:Token):void
		{
			/* don't know yet */
//			if (token.token)
//			{
//				if (token.cons is Cons)
//				{
//					
//				}
//			}
		}
		
		public static function readCharacter(from:ByteArray):String
		{
			return String.fromCharCode(from.readUnsignedByte());
		}
		//--------------------------------- steps ----------------------------------
		private static function step1(from:ByteArray, token:Token):Boolean
		{
			var result:Boolean;
			if (from.bytesAvailable)
			{
				token.current = readCharacter(from);
				result = true;
				var i:int;
				while ((i < 7) && _steps[i](from, token) && !token.error) i++;
			}
			else eofHandle(token);
			trace("step 1", token.token, token.current);
			return result;
		}
		
		private static function step2(from:ByteArray, token:Token):Boolean
		{
			var result:Boolean;
			if (!table.isValid(token.current)) readerErrorHandle(token);
			else result = true;
			trace("step 2", token.token, token.current);
			return result;
		}
		
		private static function step3(from:ByteArray, token:Token):Boolean
		{
			var result:Boolean;
			if (table.isWhite(token.current))
			{
				dispatch(from, token);
				step1(from, token);
			}
			else result = true;
			trace("step 3", token.token, token.current);
			return result;
		}
		
		private static function step4(from:ByteArray, token:Token):Boolean
		{
			var result:Boolean;
			var tableHandler:Function;
			
			if (table.isMacroCharacter(token.current))
			{
				tableHandler = 
					table.nextReader(token.current);
				from.position--;
				token.value = tableHandler(token.current, from);
				if (!token.value) step1(from, token);
			}
			else result = true;
			trace("step 4", token.token, token.current);
			return result;
		}
		
		private static function step5(from:ByteArray, token:Token):Boolean
		{
			var result:Boolean;
			if (table.isSingleEscape(token.current))
			{
				token.canBeNumber = false;
				if (from.bytesAvailable)
				{
					token.current = readCharacter(from);
					step8(from, token);
				}
				else eofHandle(token);
			}
			else result = true;
			trace("step 5", token.token, token.current);
			return result;
		}
		
		private static function step6(from:ByteArray, token:Token):Boolean
		{
			var result:Boolean;
			if (table.isMultiEscape(token.current))
			{
				token.canBeNumber = false;
				if (from.bytesAvailable)
				{
					token.current = "";
					step9(from, token);
				}
				else eofHandle(token);
			}
			else result = true;
			trace("step 6", token.token, token.current);
			return result;
		}
		
		private static function step7(from:ByteArray, token:Token):Boolean
		{
			token.token = table.toTableCase(token.current);
			step8(from, token);
			trace("step 7", token.token, token.current);
			return false;
		}
		
		private static function step8(from:ByteArray, token:Token):Boolean
		{
			var next:String = table.toTableCase(readCharacter(from));
			
			if (table.isConstitutent(next) || 
				(table.isMacroCharacter(next) && !table.isTerminating(next)))
			{
				token.token += next;
				step8(from, token);
			}
			else if (table.isSingleEscape(next))
			{
				token.canBeNumber = false;
				if (from.bytesAvailable)
				{
					token.token += table.toTableCase(readCharacter(from));
				}
				else eofHandle(token);
			}
			else if (table.isMultiEscape(next))
			{
				token.canBeNumber = false;
				step9(from, token);
			}
			else if (!table.isValid(next)) readerErrorHandle(token);
			else if (table.isTerminating(next))
			{
				from.position--;
				step10(from, token);
			}
			else if (table.isWhite(next))
			{
				// TODO: there should be a switch regarding whitespace handling.
				from.position--;
				step10(from, token);
			}
			trace("step 8", token.token, token.current);
			return false;
		}
		
		private static function step9(from:ByteArray, token:Token):Boolean
		{
			var next:String = table.toTableCase(readCharacter(from));
			
			if (table.isSingleEscape(next))
			{
				if (from.bytesAvailable)
				{
					token.token += table.toTableCase(readCharacter(from));
				}
				else eofHandle(token);
			}
			else if (table.isMultiEscape(next)) step8(from, token);
			else if (!table.isValid(next)) readerErrorHandle(token);
			else 
			{
				token.token += next;
				step9(from, token);
			}
			trace("step 9", token.token, token.current);
			return false;
		}
		
		private static function step10(from:ByteArray, token:Token):Boolean
		{
			switch (true)
			{
				case NumberReader.isInteger(token.token):
					// NOTE: fixnum is a particular case. will need something like
					// $Integer.makeInteger() to return different kinds of integers.
					token.value = new $Fixnum(token.token);
					break;
				case NumberReader.isRatio(token.token):
					token.value = new $Ratio(token.token);
					break;
				case NumberReader.isFloat(token.token):
					// NOTE: there should be 3 kinds of floats, float is too generic.
					token.value = new $Float(token.token);
					break;
				default:
					token.value = new Atom(token.token, null);
			}
			trace("step 10", token.token, token.current);
			return false;
		}
	}
}