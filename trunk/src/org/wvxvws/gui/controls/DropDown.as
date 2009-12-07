package org.wvxvws.gui.controls 
{
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.renderers.ILabel;
	import org.wvxvws.gui.repeaters.IRepeaterHost;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	
	/**
	 * DropDown class.
	 * @author wvxvw
	 */
	public class DropDown extends DIV implements ISkinnable, IRepeaterHost
	{
		protected var _ilabel:ILabel;
		protected var _labelProducer:ISkin;
		protected var _itemProducer:ISkin;
		
		public function DropDown() { super(); }
		
		/* INTERFACE org.wvxvws.gui.repeaters.IRepeaterHost */
		
		public function repeatCallback(currentItem:Object, index:int):Boolean
		{
			
		}
		
		public function get factory():ISkin
		{
			
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin>
		{
			
		}
		
		public function set skin(value:Vector.<ISkin>):void
		{
			
		}
		
		public function get parts():Object
		{
			
		}
		
		public function set parts(value:Object):void
		{
			
		}
		
	}

}