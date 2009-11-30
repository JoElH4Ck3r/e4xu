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
				trace(node.@key, node.@value);
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
				describeType(forClient).metadata.(valueOf().@name == "Skin").arg;
			var o:Object;
			var c:Class;
			var s:String;
			var ic:ISkin;
			var k:String;
			for each (var node:XML in meta)
			{
				k = node.@key.toString();
				switch (k)
				{
					case "part":
						s = node.@value;
						break;
					case "type":
						if (!o) o = { };
						if (ApplicationDomain.currentDomain.hasDefinition(
							node.@value.toString()))
						{
							c = ApplicationDomain.currentDomain.getDefinition(
								node.@value.toString()) as Class;
							ic = new c() as ISkin;
							if (ic) 
							{
								ic.host = forClient;
								o[s] = ic;
							}
						}
						s = node.@value;
						break;
				}
			}
			return o;
		}
	}
}