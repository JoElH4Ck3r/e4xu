package org.wvxvws.gui.controls 
{
	//{ imports
	import flash.display.DisplayObject;
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
		
		public function get skin():Vector.<ISkin> { return _skin; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (_skin === value) return;
			_skin = value;
			if (_openClose && super.contains(_openClose))
			{
				super.removeChild(_openClose);
				_openClose = null;
			}
			if (_skin && _skin.length)
			{
				_openClose = _skin[0].produce(this) as StatefulButton;
				if (_openClose) _openClose.initialized(this, "_openClose");
			}
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		public function get dataProvider():DataSet { return _list.dataProvider; }
		
		public function set dataProvider(value:DataSet):void 
		{
			_list.dataProvider = value;
		}
		
		public function get closed():Boolean { return _closed; }
		
		public function set closed(value:Boolean):void 
		{
			if (_closed === value) return;
			_closed = value;
			if (_closed)
			{
				
			}
			else
			{
				
			}
		}
		
		public function get openClose():StatefulButton { return _openClose; }
		
		public function set openClose(value:StatefulButton):void 
		{
			_openClose = value;
		}
		
		public function get listHeight():int { return _listHeight; }
		
		public function set listHeight(value:int):void 
		{
			_listHeight = value;
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
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
			var dob:DisplayObject;
			if (!_ilabel)
			{
				_ilabel = new SPAN();
				super.addChildAt(_ilabel as DisplayObject, 0);
			}
			dob = _ilabel as DisplayObject;
			if (_openClose)
				_openClose.width = Math.max(_bounds.x, _openClose.width);
			if (!_openClose) dob.width = _bounds.x;
			else dob.width = _bounds.x - _openClose.width;
			dob.height = _bounds.y;
		}
	}
}