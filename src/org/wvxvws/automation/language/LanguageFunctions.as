package org.wvxvws.automation.language
{
	import org.wvxvws.automation.ParensParser;
	
	import flash.utils.Dictionary;

	public class LanguageFunctions
	{
		private const _packages:Dictionary = new Dictionary();
		
		private var _current:ParensPackage;
		
		private var _parser:ParensParser;
		
		public function LanguageFunctions(parser:ParensParser)
		{
			super();
			// Not using it yet, but will be useful later.
			this._parser = parser;
		}
		
		public function resolvePackage(name:String):ParensPackage
		{
			var value:ParensPackage;
			if (!name) value = this._current;
			else if (name.indexOf(":") < 0) value = this.getpackage(name);
			else value = this.getpackage(name.split(":")[0]);
			return value;
		}
		
		public function defpackage(name:String):void
		{
			this._packages[new ParensPackage(name)] = name;
		}
		
		public function getpackage(name:String):ParensPackage
		{
			var result:ParensPackage;
			for (var pack:Object in this._packages)
			{
				if (name == this._packages[pack])
				{
					result = pack as ParensPackage;
					break;
				}
			}
			return result;
		}
		
		public function inpackage(name:String):void
		{
			this._current = this.getpackage(name);
		}
		
		public function currentPackage():ParensPackage
		{
			return _current;
		}
		
		public function packages():Dictionary
		{
			var result:Dictionary = new Dictionary();
			
			for (var key:Object in this._packages)
				result[key] = this._packages[key];
			return result;
		}
		
		public function defvar(name:String, value:Object = null):void
		{
			var pack:ParensPackage;
			var varname:String;
			var parts:Array = name.split(":");
			
			if (parts.length > 1)
			{
				pack = this.getpackage(parts[0]);
				varname = parts[1];
			}
			else
			{
				pack = this._current;
				varname = parts[0];
			}
			
			pack.intern(varname, value);
		}
		
		public function getvar(name:String):Object
		{
			var pack:ParensPackage;
			var varname:String;
			var parts:Array = name.split(":");
			
			if (parts.length > 1)
			{
				pack = this.getpackage(parts[0]);
				varname = parts[1];
			}
			else
			{
				pack = this._current;
				varname = parts[0];
			}
			
			return pack.get(varname, this._current);
		}
		
		public function setvar(name:String, value:Object):void
		{
			var pack:ParensPackage;
			var varname:String;
			var parts:Array = name.split(":");
			
			if (parts.length > 1)
			{
				pack = this.getpackage(parts[0]);
				varname = parts[1];
			}
			else
			{
				pack = this._current;
				varname = parts[0];
			}
			
			if (pack.has(varname, this._current))
				pack.intern(varname, value);
			else throw "Undefined variable";
			// TODO: global errors
		}
	}
}