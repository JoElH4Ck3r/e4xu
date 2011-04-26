package org.wvxvws.automation.language
{
	public class List extends Cons
	{
		public function List() { super("LIST", this); }
		
		public static function list(array:Array):Cons
		{
			var list:Cons = new Cons();
			var cdr:Atom;
			
			for each (var atom:Atom in array)
			{
				if (!list._car)
					list._car = cdr = Cons.cons(atom, null);
				else cdr = Cons.cons(atom, cdr);
			}
			return list;
		}
		
		public function nth(index:uint, list:Cons):Atom
		{
			var result:Cons;
			while (index-- > 0) result = Cons.cdr(result);
			return result;
		}
	}
}