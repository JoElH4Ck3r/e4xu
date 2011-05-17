package org.wvxvws.automation.types
{
	public class $Class extends $Object
	{
		public function $Class(name:String, which:Class)
		{
			super(name, $Class);
			super._value = which;
		}
		
		// This is probably not an arry. Should be cons, I think
		public function makeInstance(initFrom:Array):$Object
		{
			var instance:$Object;
			
			// This is a known problem
			switch (initFrom.length)
			{
				case 0: instance = new this._value(); break;
				case 1: instance = new this._value(parameters[0]); break;
				case 2: instance = new this._value(parameters[0], parameters[1]); break;
				case 3: instance = new this._value(parameters[0], parameters[1], parameters[2]); break;
				case 4: instance = new this._value(parameters[0], parameters[1], parameters[2], 
					parameters[3]); break;
				case 5: instance = new this._value(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4]); break;
				case 6: instance = new this._value(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5]); break;
				case 7: instance = new this._value(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6]); break;
				case 8: instance = new this._value(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]); break;
				case 9: instance = new this._value(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], 
					parameters[8]); break;
				case 10: instance = new this._value(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], 
					parameters[8], parameters[9]); break;
				case 11: instance = new this._value(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], 
					parameters[8], parameters[9], parameters[10]); break;
				case 12: instance = new this._value(parameters[0], parameters[1], parameters[2], 
					parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], 
					parameters[8], parameters[9], parameters[10], parameters[11]); break;
				default: throw "Oh shi...";
			}
			
			return instance;
		}
	}
}