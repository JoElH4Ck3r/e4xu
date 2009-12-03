package org.wvxvws.gui.skins 
{
	//{ imports
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	//}
	
	/**
	 * SkinManager class.
	 * @author wvxvw
	 */
	public class SkinManager
	{
		
		public function SkinManager() { super(); }
		
		public static function getSkin(forClient:ISkinnable):Vector.<ISkin>
		{
			var meta:XMLList = 
				describeType(forClient).metadata.(valueOf().@name == "Skin").arg;
			var v:Vector.<ISkin>;
			var c:Class;
			var s:String;
			var ic:ISkin;
			for each (var node:XML in meta)
			{
				if (node.@key.toString() !== "") continue;
				s = node.@value;
				if (ApplicationDomain.currentDomain.hasDefinition(s))
				{
					c = ApplicationDomain.currentDomain.getDefinition(s) as Class;
					ic = new c() as ISkin;
					if (ic) 
					{
						if (!v) v = new <ISkin>[];
						ic.host = forClient;
						v.push(ic);
					}
				}
			}
			return v;
		}
		
		public static function getSkinParts(forClient:ISkinnable):Object
		{
			var meta:XMLList = 
				describeType(forClient).metadata.(valueOf().@name == "Skin");
			var o:Object;
			var c:Class;
			var s:String;
			var ic:ISkin;
			var part:String;
			for each (var node:XML in meta)
			{
				part = node.arg.(valueOf().@key.toString() === "part")[0].@value;
				s = node.arg.(valueOf().@key.toString() === "type")[0].@value;
				if (ApplicationDomain.currentDomain.hasDefinition(s))
				{
					c = ApplicationDomain.currentDomain.getDefinition(s) as Class;
					ic = new c() as ISkin;
					if (ic) 
					{
						if (!o) o = { };
						ic.host = forClient;
						o[part] = ic;
					}
				}
			}
			return o;
		}
	}
}