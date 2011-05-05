package org.wvxvws.automation.language
{
	
	/**
	 * TODO: must also have nicknames.
	 * 
	 * TODO: For rewrite: these must be the methods and variables:
	 * 
	 * TODO: very important: use-package - like prototype inheritance / decorator
	 * we also need a list of all symbols known in this package which have been
	 * declared elsewhere.
	 * 
	 * TODO: -- Every package has a list of shadowing symbols. A shadowing symbol 
	 * takes precedence over any other symbol of the same name that would otherwise 
	 * be accessible in the package. A name conflict involving a shadowing symbol 
	 * is always resolved in favor of the shadowing symbol, without signaling an 
	 * error (except for one exception involving import). See shadow and 
	 * shadowing-import. 
	 * The functions use-package, import, and export check for name conflicts.
	 * 
	 * *modules*            import                     provide           
	 * *package*            in-package                 rename-package    
	 * defpackage           intern                     require           
	 * do-all-symbols       list-all-packages          shadow            
	 * do-external-symbols  make-package               shadowing-import  
	 * do-symbols           package-name               unexport          
	 * export               package-nicknames          unintern          
	 * find-all-symbols     package-shadowing-symbols  unuse-package     
	 * find-package         package-use-list           use-package       
	 * find-symbol          package-used-by-list    
	 * 
	 * http://www.lispworks.com/documentation/HyperSpec/Body/11_aa.htm
	 * 
	 * @author wvxvw
	 * 
	 */
	public class ParensPackage
	{
		public function get name():String { return this._name; }
		
		private var _name:String;
		
		private const _internal:Object = { };
		
		private const _external:Object = { };
		
		public function ParensPackage(name:String)
		{
			super();
			this._name = name;
		}
		
		public function intern(name:String, value:*):void
		{
			this._internal[name] = value;
		}
		
		public function extern(name:String, value:*):void
		{
			this.intern(name, value);
			this._external[name] = value;
		}
		
		public function get(name:String, pack:ParensPackage = null):*
		{
			var result:*;
			
			if (pack === this) result = this._internal[name];
			else result = this._external[name];
			return result;
		}
		
		public function has(name:String, pack:ParensPackage = null):Boolean
		{
			var result:Boolean;
			
			if (pack === this) result = name in this._internal;
			else result = name in this._external;
			return result;
		}
	}
}