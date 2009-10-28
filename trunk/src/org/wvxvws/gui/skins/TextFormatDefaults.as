package org.wvxvws.gui.skins 
{
	import flash.text.TextFormat;
	
	/**
	 * TextFormatDefaults class.
	 * @author wvxvw
	 */
	public class TextFormatDefaults
	{
		public static function get backgroundColor():uint
		{
			return 0xA0A0A0;
		}
		
		public static function get defaultUpColor():uint
		{
			return 0xE0E0E0;
		}
		
		public static function get defaultOverColor():uint
		{
			return 0xD0D0D0;
		}
		
		public static function get defaultDownColor():uint
		{
			return 0xC0C0C0;
		}
		
		public static function get defaultSelectedColor():uint
		{
			return 0x6090F0;
		}
		
		public static function get foreColor():uint
		{
			return 0xF0F0F0;
		}
		
		public static function get defaultTextColor():uint
		{
			return 0x101010;
		}
		
		public static function get defaultChromeBack():uint
		{
			return 0x606060;
		}
		
		public static function get defaultChromeFore():uint
		{
			return 0x909090;
		}
		
		public static function get defaultBorderColor():uint
		{
			return 0x303030;
		}
		
		public static function get defaultFormat():TextFormat
		{
			return new TextFormat("_sans", 11, defaultTextColor);
		}
		
		public function TextFormatDefaults() { super(); }
		
	}

}