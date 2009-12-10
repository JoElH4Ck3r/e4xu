package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.describeType;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.data.DataSet;
	import org.wvxvws.data.SetEvent;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.repeaters.IRepeater;
	import org.wvxvws.gui.repeaters.IRepeaterHost;
	import org.wvxvws.gui.repeaters.ListRepeater;
	import org.wvxvws.gui.ScrollPane;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	
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
			super.invalidate("_factory", _factory, false);
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
		
		public function get labelSkin():ISkin { return _labelSkin; }
		
		public function set labelSkin(value:ISkin):void 
		{
			if (_labelSkin === value) return;
			_labelSkin = value;
			super.invalidate("_labelSkin", _dataProvider, false);
			if (super.hasEventListener(EventGenerator.getEventType("labelSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function set poolSize(value:int):void 
		{
			_poolSize = value;
			while (_pool.length > value) _pool.shift();
		}
		
		public function get pool():Vector.<Object> { return _pool; }
		
		protected var _skins:Vector.<ISkin>;
		protected var _skin:ISkin;
		protected var _dataProvider:DataSet;
		protected var _factory:ISkin;
		protected var _repeater:IRepeater;
		protected var _direction:Boolean;
		protected var _scrollPane:ScrollPane = new ScrollPane();
		protected var _position:int;
		protected var _cumulativeSize:int;
		protected var _calculatedSize:int;
		protected var _rendererSize:Point = new Point();
		protected var _pool:Vector.<Object> = new <Object>[];
		protected var _poolSize:int = 100;
		protected var _labelSkin:ISkin;
		
		public function List() 
		{
			super();
			this._skins = SkinManager.getSkin(this);
			if (this._skins)
			{
				if (this._skins.length > 0) _skin = this._skins[0];
				if (this._skins.length > 1) _factory = this._skins[1];
			}
			_repeater = new ListRepeater(this);
			super.addChild(_scrollPane);
			_scrollPane.addEventListener(
				GUIEvent.SCROLLED, this.scrollPane_scrolledHandler);
		}
		
		public override function validate(properties:Object):void 
		{
			var needLayoutChildren:Boolean = ("_dataProvider" in properties) || 
						("_factory" in properties) || ("_bounds" in properties) || 
						("_labelSkin" in properties);
			super.validate(properties);
			if (needLayoutChildren) this.layoutChildren();
		}
		
		/* INTERFACE org.wvxvws.gui.repeaters.IRepeaterHost */
		
		public function repeatCallback(currentItem:Object, index:int):Boolean
		{
			var renderer:IRenderer = currentItem as IRenderer;
			var dobj:DisplayObject = currentItem as DisplayObject;
			var ret:Boolean = true;
			if (_direction)
			{
				dobj.x = _position + _cumulativeSize;
				dobj.height = _rendererSize.y;
				_scrollPane.addChild(dobj);
				if (_cumulativeSize + dobj.height > _bounds.y) ret = false;
				if (renderer)
				{
					if (_labelSkin) renderer.labelSkin = _labelSkin;
					renderer.data = _dataProvider.at(index);
				}
				_cumulativeSize += dobj.width;
			}
			else
			{
				dobj.y = _position + _cumulativeSize;
				dobj.width = _rendererSize.x;
				_scrollPane.addChild(dobj);
				if (_cumulativeSize + dobj.height > _bounds.y) ret = false;
				if (renderer)
				{
					if (_labelSkin) renderer.labelSkin = _labelSkin;
					renderer.data = _dataProvider.at(index);
				}
				_cumulativeSize += dobj.height;
			}
			return ret && _dataProvider.length > _scrollPane.numChildren;
		}
		
		protected function layoutChildren():void
		{
			var d:Object;
			if (_direction) _rendererSize.y = _bounds.y;
			else _rendererSize.x = _bounds.x;
			while (_scrollPane.numChildren)
			{
				d = _scrollPane.removeChildAt(0);
				if (_pool.indexOf(d) < 0 && _pool.length < _poolSize) _pool.push(d);
			}
			_cumulativeSize = 0;
			// TODO: calculate starting position
			if (_factory) _repeater.begin(0);
		}
		
		protected function scrollPane_scrolledHandler(event:GUIEvent):void 
		{
			this.layoutChildren();
		}
		
		protected function provider_sortHandler(event:SetEvent):void 
		{
			this.layoutChildren();
		}
		
		protected function provider_removeHandler(event:SetEvent):void 
		{
			this.layoutChildren();
		}
		
		protected function provider_changeHandler(event:SetEvent):void 
		{
			this.layoutChildren();
		}
		
		protected function provider_addHandler(event:SetEvent):void 
		{
			this.layoutChildren();
		}
	}
}