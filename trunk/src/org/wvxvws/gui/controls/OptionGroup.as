package org.wvxvws.gui.controls 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.GUIEvent;
	
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	
	[DefaultProperty("options")]
	
	/**
	 * OptionGroup class.
	 * @author wvxvw
	 */
	public class OptionGroup extends EventDispatcher implements IMXMLObject
	{
		//------------------------------------
		//  Public property options
		//------------------------------------
		
		[Bindable("optionsChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>optionsChanged</code> event.
		*/
		public function get options():Vector.<Option> { return this._options.concat(); }
		
		public function set options(value:Vector.<Option>):void 
		{
			if (this._options === value) return;
			this._options.length = 0;
			var i:int;
			var j:int;
			var opt:Option;
			if (value)
			{
				j = value.length;
				while (i < j)
				{
					opt = value[i];
					if (!opt) 
					{
						i++;
						continue;
					}
					if (this._options.indexOf(opt) < 0)
					{
						this._options.push(opt);
						opt.addEventListener(GUIEvent.SELECTED.type, 
							this.option_selectedHandler, false, 0, true);
					}
					i++;
				}
			}
			if (this._document) this.reparentOptions();
			if (super.hasEventListener(EventGenerator.getEventType("options")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get selectedOtion():Option { return this._selected; }
		
		protected function option_selectedHandler(event:GUIEvent):void 
		{
			if (this._selected && event.currentTarget !== this._selected)
				this._selected.selected = false;
			this._selected = event.currentTarget as Option;
			super.dispatchEvent(event);
		}
		
		protected var _options:Vector.<Option> = new <Option>[];
		protected var _document:DisplayObjectContainer;
		protected var _id:String;
		protected var _selected:Option;
		
		public function OptionGroup() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			this._document = document as DisplayObjectContainer;
			this._id = id;
			if (this._document) this.reparentOptions();
		}
		
		public function dispose():void { }
		
		protected function reparentOptions():void
		{
			for each (var opt:Option in _options)
			{
				//if (opt.parent && opt.parent !== _document)
				//{
					//opt.parent.removeChild(opt);
				//}
				if (!opt.parent)
				{
					opt.initialized(this._document, 
						"option" + this._options.indexOf(opt));
				}
			}
		}
	}
}