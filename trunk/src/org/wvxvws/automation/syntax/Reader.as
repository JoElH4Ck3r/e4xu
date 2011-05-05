package org.wvxvws.automation.syntax
{
	import flash.utils.ByteArray;
	
	import org.wvxvws.automation.language.Atom;

	public class Reader
	{
		private static const _values:Values = new Values();
		
		public static var table:DispatchTable = new DispatchTable();
		
		/**
		 * character  syntax type                 character  syntax type             
		 * Backspace  constituent                 0--9       constituent             
		 * Tab        whitespace[2]               :          constituent             
		 * Newline    whitespace[2]               ;          terminating macro char  
		 * Linefeed   whitespace[2]               <          constituent             
		 * Page       whitespace[2]               =          constituent             
		 * Return     whitespace[2]               >          constituent             
		 * Space      whitespace[2]               ?          constituent*            
		 * !          constituent*                @          constituent             
		 * "          terminating macro char      A--Z       constituent             
		 * #          non-terminating macro char  [          constituent*            
		 * $          constituent                 \          single escape           
		 * %          constituent                 ]          constituent*            
		 * &          constituent                 ^          constituent             
		 * '          terminating macro char      _          constituent             
		 * (          terminating macro char      `          terminating macro char  
		 * )          terminating macro char      a--z       constituent             
		 * *          constituent                 {          constituent*            
		 * +          constituent                 |          multiple escape         
		 * ,          terminating macro char      }          constituent*            
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
		 *     * If y is a constituent or non-terminating macro character:
		 * 
		 *         -- If y is a character with case, it might be replaced with the 
		 * corresponding character of the opposite case, depending on the readtable 
		 * case of the current readtable, as outlined in Section 23.1.2 (Effect of 
		 * Readtable Case on the Lisp Reader).
		 *         -- Y is appended to the token being built.
		 *         -- Step 8 is repeated.
		 * 
		 *     * If y is a single escape character, then the next character, z, is 
		 * read, or an error of type end-of-file is signaled if at end of file. 
		 * Z is treated as if it is a constituent whose only constituent trait is 
		 * alphabetic[2]. Z is appended to the token being built, and step 8 is 
		 * repeated.
		 * 
		 *     * If y is a multiple escape character, then step 9 is entered.
		 * 
		 *     * If y is an invalid character, an error of type reader-error is 
		 * signaled.
		 * 
		 *     * If y is a terminating macro character, then it terminates the token. 
		 * First the character y is unread (see unread-char), and then step 10 is 
		 * entered.
		 * 
		 *     * If y is a whitespace[2] character, then it terminates the token. 
		 * First the character y is unread if appropriate (see 
		 * read-preserving-whitespace), and then step 10 is entered.
		 * 
		 * 9. At this point a token is being accumulated, and an odd number of 
		 * multiple escape characters have been encountered. If at end of file, 
		 * an error of type end-of-file is signaled. Otherwise, a character, y, 
		 * is read, and one of the following actions is performed according to its 
		 * syntax type:
		 * 
		 *     * If y is a constituent, macro, or whitespace[2] character, y is 
		 * treated as a constituent whose only constituent trait is alphabetic[2]. 
		 * Y is appended to the token being built, and step 9 is repeated.
		 * 
		 *     * If y is a single escape character, then the next character, z, is 
		 * read, or an error of type end-of-file is signaled if at end of file. 
		 * Z is treated as a constituent whose only constituent trait is 
		 * alphabetic[2]. Z is appended to the token being built, and step 9 is 
		 * repeated.
		 * 
		 *     * If y is a multiple escape character, then step 8 is entered.
		 * 
		 *     * If y is an invalid character, an error of type reader-error is 
		 * signaled.
		 * 
		 * 10. An entire token has been accumulated. The object represented by 
		 * the token is returned as the result of the read operation, or an error 
		 * of type reader-error is signaled if the token is not of valid syntax. 
		 * 
		 * 
		 * We cannot have this written according to the standard. We can't have
		 * stdout and I don't really want to implement recursive reading. Let's just
		 * for this case assume it's not recursive. Maybe I'll add this later.
		 * 
		 * The receiving function should not rely on content in the Values object. 
		 * When this function is called second time it's content is repopulated. 
		 * We only need this object to be able to return multiple values, 
		 * and this is an optimization we'd need to do in such case.
		 * 
		 * @param from
		 * @return 
		 * 
		 */
		public static function read(from:ByteArray):Atom
		{
			var current:String;
			var next:String;
			var position:int = from.position;
			var inputLength:int;
			var token:Token;
			var tableHandler:Function;
			var isMacro:Boolean;
			var result:Atom;
			
			while (position < inputLength)
			{
				current = String.fromCharCode(from[position]);
				if (position - 1 < inputLength)
				{
					next = from.charAt(position + 1);
					tableHandler = table.getMacroHandler(current, next);
					isMacro = Boolean(tableHandler);
				}
				else next = null;
				if (!tableHandler) tableHandler = table.nextReader(current);
				if (!tableHandler) throw "invalid-character";
				if (isMacro) tableHandler(current, next);
				else tableHandler(current);
				position++;
			}
			
			return result;
		}
		
		private static function step1(current:String, from:ByteArray, token:Token):void
		{
			
		}
		
		private static function step2(current:String, from:ByteArray, token:Token):void
		{
			var tableHandler:Function = table.getMacroHandler(current, next);
		}
		
		private static function step4(current:String, from:ByteArray, token:Token):void
		{
			var tableHandler:Function;
			
			if (table.isMacroCharacter(current))
			{
				tableHandler = 
					table.getMacroHandler(current, 
						String.fromCharCode(from.readUnsignedByte()));
				from.position--;
				token.value = tableHandler(current, from);
			}
		}
	}
}