package  
{
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author wvxvw
	 */
	public class TopLevelCSS implements ICSSClient
	{
		public static const global:TopLevelCSS = new TopLevelCSS();
		
		private var _className:String;
		private var _styles:Object;
		private var _children:Vector.<ICSSClient>;
		
		public function TopLevelCSS()
		{
			super();
			this._className = getQualifiedClassName(this);
		}
		
		/* INTERFACE ICSSClient */
		
		public function className():String { return this._className; }
		
		public function styleNames():Vector.<String>
		{
			var v:Vector.<String>;
			for (var p:String in this._styles)
			{
				if (!v) v = new <String>[];
				v.push(p);
			}
			return v;
		}
		
		public function parentClient():ICSSClient { return null; }
		
		public function childClients():Vector.<ICSSClient>
		{
			return this._children;
		}
		
		public function getStyle(name:String):Object
		{
			return this._styles[name];
		}
		
		public function addStyle(name:String, style:Object):void
		{
			this._styles[name] = style;
		}
	}
}