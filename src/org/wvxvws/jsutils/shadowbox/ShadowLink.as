package org.wvxvws.jsutils.shadowbox
{
	import flash.external.ExternalInterface;
	
	/**
	* ShadowLink class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class ShadowLink 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		private static var _id:int;
		
		private var _rel:String = "shadowbox";
		private var _gallery:String;
		private var _options:ShadowOptions;
		private var _href:String;
		private var _title:String;
		private var _uid:String;
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function ShadowLink(href:String = null) 
		{
			super();
			_href = encodeURI(href);
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function click():void
		{
			if (!ExternalInterface.available) return;
			var script:XML = 
			<script>
				<![CDATA[
					function() {
						var lk = document.getElementById("]]>{ _uid }<![CDATA[");
						if (typeof lk.click != "undefined") { lk.click(); }
						else
						{
							var evt = document.createEvent("MouseEvents");
							evt.initMouseEvent("click", true, true, window,
								0, 0, 0, 0, 0, false, false, false, false, 0, null);
							lk.dispatchEvent(evt);
						}
					}
				]]>
			</script>;
			ExternalInterface.call(script);
		}
		
		public function toString():String
		{
			if (!_uid) _uid = idGenerator();
			return <a id={_uid} rel={rel} href={href} title={title}>link</a>.toXMLString();
		}
		
		public function get rel():String
		{
			return _rel + (gallery ? "[" + gallery + "]" : "") + (options ? ";" + options : "");
		}
		
		public function get gallery():String { return _gallery; }
		
		public function set gallery(value:String):void 
		{
			_gallery = value;
		}
		
		public function get options():ShadowOptions { return _options; }
		
		public function set options(value:ShadowOptions):void 
		{
			_options = value;
		}
		
		public function get href():String { return _href; }
		
		public function set href(value:String):void 
		{
			_href = encodeURI(value);
		}
		
		public function get title():String { return (_title ? _title : ""); }
		
		public function set title(value:String):void 
		{
			_title = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function idGenerator():String
		{
			return "sb_generated_link" + (++_id);
		}
	}
}