package org.wvxvws.automation.language
{
	import flash.utils.Dictionary;
	
	import org.wvxvws.automation.ParensParser;

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
		
		public function makeInstance(ofClass:Class, ...parameters):Object
		{
			var instance:Object;
			
			// This is a known problem
			switch (parameters.length)
			{
				case 0: instance = new ofClass(); break;
				case 1: instance = new ofClass(parameters[0]); break;
				case 2: instance = new ofClass(parameters[0], parameters[1]); break;
				case 3: instance = new ofClass(parameters[0], parameters[1], parameters[2]); break;
				case 4: instance = new ofClass(parameters[0], parameters[1], parameters[2], 
					parameters[3]); break;
				case 5: instance = new ofClass(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4]); break;
				case 6: instance = new ofClass(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5]); break;
				case 7: instance = new ofClass(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6]); break;
				case 8: instance = new ofClass(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]); break;
				case 9: instance = new ofClass(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], 
					parameters[8]); break;
				case 10: instance = new ofClass(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], 
					parameters[8], parameters[9]); break;
				case 11: instance = new ofClass(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], 
					parameters[8], parameters[9], parameters[10]); break;
				case 12: instance = new ofClass(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], 
					parameters[8], parameters[9], parameters[10], parameters[11]); break;
				default: throw "Oh shi...";
			}
			
			return instance;
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
		
		public function externInCurrent(varName:String):void
		{
			this._current.extern(varName, this._current.get(varName, this._current));
		}
		
		public function defvar(name:String, value:Object = null):*
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
			return value;
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
		
		public function setvar(name:String, value:Object):*
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
			return value;
		}
	}
}