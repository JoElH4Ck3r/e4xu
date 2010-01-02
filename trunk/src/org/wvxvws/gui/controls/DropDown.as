package org.wvxvws.gui.controls 
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import org.wvxvws.data.DataSet;
	import org.wvxvws.gui.containers.List;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.renderers.ILabel;
	import org.wvxvws.gui.Scroller;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	import org.wvxvws.gui.SPAN;
	import org.wvxvws.gui.StatefulButton;
	//}
	
	[Skin("org.wvxvws.skins.DropDownSkin")]
	
	/**
	 * DropDown class.
	 * @author wvxvw
	 */
	public class DropDown extends DIV implements ISkinnable
	{
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return this._skin; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (this._skin === value) return;
			this._skin = value;
			if (this._openClose && super.contains(this._openClose))
			{
				super.removeChild(this._openClose);
				this._openClose = null;
			}
			if (this._skin && this._skin.length)
			{
				this._openClose = this._skin[0].produce(this) as StatefulButton;
				if (this._openClose) this._openClose.initialized(this, "openClose");
			}
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		public function get dataProvider():DataSet { return this._list.dataProvider; }
		
		public function set dataProvider(value:DataSet):void 
		{
			this._list.dataProvider = value;
		}
		
		public function get closed():Boolean { return this._closed; }
		
		public function set closed(value:Boolean):void 
		{
			if (this._closed === value) return;
			this._closed = value;
			if (this._closed)
			{
				
			}
			else
			{
				
			}
		}
		
		public function get openClose():StatefulButton { return this._openClose; }
		
		public function set openClose(value:StatefulButton):void 
		{
			this._openClose = value;
		}
		
		public function get listHeight():int { return this._listHeight; }
		
		public function set listHeight(value:int):void 
		{
			this._listHeight = value;
		}
		
		protected var _ilabel:ILabel;
		protected var _list:List = new List();
		protected var _scroller:Scroller;
		protected var _openClose:StatefulButton;
		protected var _skin:Vector.<ISkin>;
		protected var _closed:Boolean;
		protected var _listHeight:int = -1;
		
		public function DropDown()
		{
			super();
			this.skin = SkinManager.getSkin(this);
		}
		
		public override function validate(properties:Dictionary):void 
		{
			super.validate(properties);
			var dob:DisplayObject;
			if (!this._ilabel)
			{
				this._ilabel = new SPAN();
				super.addChildAt(this._ilabel as DisplayObject, 0);
			}
			dob = this._ilabel as DisplayObject;
			if (this._openClose)
				this._openClose.width = Math.max(_bounds.x, this._openClose.width);
			if (!this._openClose) dob.width = this._bounds.x;
			else dob.width = this._bounds.x - this._openClose.width;
			dob.height = this._bounds.y;
		}
	}
}