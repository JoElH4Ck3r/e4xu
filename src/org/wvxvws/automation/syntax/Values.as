package org.wvxvws.automation.syntax
{
	import org.wvxvws.automation.language.Atom;

	public class Values
	{
		private const _atoms:Vector.<Atom> = new <Atom>[];
		
		public function Values() { super(); }
		
		/**
		 * This is so we can cache the reference and not need to go through put()
		 * each time.
		 * 
		 * @return 
		 */
		public function put():Function { return this._atoms.push; }
		
		/**
		 * Just like put(), the caller may cache the refernce and thus avoid 
		 * repetitive calls.
		 * 
		 * @return 
		 */
		public function take():Function { return this._atoms.pop; }
		
		/**
		 * Technically, only the reader should call this function. Will remove all
		 * values in the atoms array.
		 * 
		 * @return 
		 */
		public function clean():Values
		{
			if (this._atoms.length) this._atoms.splice(0, this._atoms.length);
			return this;
		}
	}
}