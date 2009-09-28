package org.wvxvws.automation 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class State extends Dictionary
	{
		protected var _validationStartPoints:Vector.<IAUClient>;
		
		public function State() { super(); }
		
		public function setRoot(client:IAUClient):void
		{
			var v:Vector.<IAUClient>;
			for (var obj:Object in this)
			{
				v.push(obj as IAUClient);
			}
			while (v.length)
			{
				delete this[v.pop()];
			}
			_validationStartPoints = descendants(client);
			if (!_validationStartPoints) _validationStartPoints = new <IAUClient>[client];
		}
		
		public function commit():void
		{
			
		}
		
		protected function descendants(client:IAUClient):Vector.<IAUClient>
		{
			var v:Vector.<IAUClient>;
			var c:Vector.<IAUClient> = client.auChildren;
			var t:Vector.<IAUClient>;
			var td:Vector.<IAUClient>;
			if (c)
			{
				v = new <IAUClient>[];
				for each (var cd:IAUClient in c)
				{
					if (cd && !cd.auChildren && !this[cd])
					{
						this[cd] = true;
						v.push(cd);
					}
					else if (cd && cd.auChildren)
					{
						td = cd.auChildren;
						for each (var cdd:IAUClient in td)
						{
							t = descendants(cdd);
							if (t) v = v.concat(t);
						}
					}
				}
			}
			return v;
		}
	}

}