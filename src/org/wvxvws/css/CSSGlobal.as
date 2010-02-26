package org.wvxvws.css
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class CSSGlobal implements ICSSClient
	{
		private var _className:String;
		private var _styles:Object;
		private var _children:Vector.<ICSSClient>;
		private var _pseudoClasses:Vector.<String>;
		
		public function CSSGlobal()
		{
			super();
			this._className = getQualifiedClassName(this);
		}
		
		/* INTERFACE org.wvxvws.css.ICSSClient */
		
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
		
		public function pseudoClasses():Vector.<String>
		{
			return this._pseudoClasses;
		}
	}
}