package org.wvxvws.gui.skins 
{
	import flash.text.TextFormat;
	/**
	 * SkinDefaults class.
	 * @author wvxvw
	 */
	public class SkinDefaults
	{
		public static const UP_COLOR:uint = 0xB0B0B0;
		public static const OVER_COLOR:uint = 0xC0C0C0;
		public static const DOWN_COLOR:uint = 0xA0A0A0;
		public static const DISABLED_COLOR:uint = 0x808080;
		public static const SELECTED_COLOR:uint = 0x6080F0;
		public static const DISABLED_SELECTED_COLOR:uint = 0x607090;
		
		public static function get DARK_FORMAT():TextFormat
		{
			return new TextFormat("_sans", 11, 0x101010);
		}
		
		public function SkinDefaults() { super(); }
		
	}

}