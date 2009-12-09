package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.data.DataSet;
	import org.wvxvws.data.SetEvent;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.repeaters.IRepeater;
	import org.wvxvws.gui.repeaters.IRepeaterHost;
	import org.wvxvws.gui.repeaters.ListRepeater;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	
	[Skin("org.wvxvws.skins.ListSkin")]
	[Skin("org.wvxvws.skins.renderers.ListRendererSkin")]
	
	[DefaultProperty("dataProvider")]
	
	/**
	 * List class.
	 * @author wvxvw
	 */
	public class List extends DIV implements ISkinnable, IRepeaterHost
	{
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return _skins; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		/* INTERFACE org.wvxvws.gui.repeaters.IRepeaterHost */
		
		public function get factory():ISkin { return _factory; }
		
		public function set factory(value:ISkin):void
		{
			if (_factory === value) return;
			_factory = value;
			super.invalidate("_factory", _padding, false);
			if (super.hasEventListener(EventGenerator.getEventType("factory")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get dataProvider():DataSet { return _dataProvider; }
		
		public function set dataProvider(value:DataSet):void
		{
			if (_dataProvider === value) return;
			if (_dataProvider)
			{
				_dataProvider.removeEventListener(
					SetEvent.ADD, this.provider_addHandler);
				_dataProvider.removeEventListener(
					SetEvent.CHANGE, this.provider_changeHandler);
				_dataProvider.removeEventListener(
					SetEvent.REMOVE, this.provider_removeHandler);
				_dataProvider.removeEventListener(
					SetEvent.SORT, this.provider_sortHandler);
			}
			_dataProvider = value;
			if (_dataProvider)
			{
				_dataProvider.addEventListener(
					SetEvent.ADD, this.provider_addHandler);
				_dataProvider.addEventListener(
					SetEvent.CHANGE, this.provider_changeHandler);
				_dataProvider.addEventListener(
					SetEvent.REMOVE, this.provider_removeHandler);
				_dataProvider.addEventListener(
					SetEvent.SORT, this.provider_sortHandler);
			}
			super.invalidate("_dataProvider", _dataProvider, false);
			if (super.hasEventListener(EventGenerator.getEventType("dataProvider")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		protected var _skins:Vector.<ISkin>;
		protected var _skin:ISkin;
		protected var _dataProvider:DataSet;
		protected var _factory:ISkin;
		protected var _repeater:IRepeater;
		protected var _renderersPool:Vector.<DisplayObject> = new <DisplayObject>[];
		protected var _renderersInUse:Vector.<DisplayObject> = new <DisplayObject>[];
		
		public function List() 
		{
			super();
			_repeater = new ListRepeater(this);
		}
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
		}
		
		/* INTERFACE org.wvxvws.gui.repeaters.IRepeaterHost */
		
		public function repeatCallback(currentItem:Object, index:int):Boolean
		{
			
		}
		
		protected function provider_sortHandler(event:SetEvent):void 
		{
			super.invalidate("_dataProvider", _dataProvider, false);
		}
		
		protected function provider_removeHandler(event:SetEvent):void 
		{
			super.invalidate("_dataProvider", _dataProvider, false);
		}
		
		protected function provider_changeHandler(event:SetEvent):void 
		{
			super.invalidate("_dataProvider", _dataProvider, false);
		}
		
		protected function provider_addHandler(event:SetEvent):void 
		{
			super.invalidate("_dataProvider", _dataProvider, false);
		}
		
	}
}