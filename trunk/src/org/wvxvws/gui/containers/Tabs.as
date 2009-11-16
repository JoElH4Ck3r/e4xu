package org.wvxvws.gui.containers 
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.renderers.TabRenderer;
	import org.wvxvws.gui.skins.SkinProducer;
	//}
	
	[DefaultProperty("documents")]
	
	/**
	 * Tabs class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class Tabs extends DIV
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property documents
		//------------------------------------
		
		[Bindable("documentsChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>documentsChanged</code> event.
		*/
		public function get documents():Vector.<DisplayObject>
		{
			return _documents.concat();
		}
		
		public function set documents(value:Vector.<DisplayObject>):void 
		{
			if (_documents === value) return;
			var i:int;
			var d:DisplayObject
			for each (d in _documents)
			{
				if (super.contains(d)) super.removeChild(d);
				super.removeChild(_tabs[i]);
			}
			if (value) _documents = value.concat();
			else _documents = [];
			if (_tabProducer)
			{
				for each (d in _documents)
				{
					_currentDocument = d;
					_tabs[i] = _tabProducer.produce(this) as InteractiveObject;
					if (_labelFactory !== null)
				}
			}
			super.invalidate("_documents", _documents, false);
			if (super.hasEventListener(EventGenerator.getEventType("documents")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property currentDocument
		//------------------------------------
		
		public function get currentDocument():DisplayObject { return _currentDocument; }
		
		//------------------------------------
		//  Public property labelFactory
		//------------------------------------
		
		[Bindable("labelFactoryChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelFactoryChanged</code> event.
		*/
		public function get labelFactory():Function { return _labelFactory; }
		
		public function set labelFactory(value:Function):void 
		{
			if (_labelFactory === value) return;
			_labelFactory = value;
			super.invalidate("_labelFactory", _labelFactory, false);
			if (super.hasEventListener(EventGenerator.getEventType("labelFactory")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _currentDocument:DisplayObject;
		protected var _documents:Vector.<DisplayObject> = new <DisplayObject>[];
		protected var _tabs:Vector.<InteractiveObject> = new <InteractiveObject>[];
		protected var _tabHeight:int = 20;
		protected var _tabProducer:SkinProducer = new SkinProducer(null, tabFactory);
		protected var _labelFactory:Function;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function Tabs() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function validate(properties:Object):void 
		{
			super.validate(properties);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function tabFactory(object:Object):InteractiveObject
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}