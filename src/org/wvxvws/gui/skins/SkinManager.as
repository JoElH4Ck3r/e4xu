package org.wvxvws.gui.skins 
{
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
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
				s = node.@value;
				trace("SkinManager", node.@value);
				if (!v) v = new <ISkin>[];
				if (ApplicationDomain.currentDomain.hasDefinition(s))
				{
					c = ApplicationDomain.currentDomain.getDefinition(s) as Class;
					ic = new c() as ISkin;
					if (ic) 
					{
						ic.host = forClient;
						v.push(ic);
					}
				}
			}
			return v;
		}
	}

}