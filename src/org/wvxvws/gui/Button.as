package org.wvxvws.gui 
{
	//{ imports
	import flash.events.Event;
	import flash.text.TextField;
	import mx.core.IMXMLObject;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.skins.SkinProducer;
	//}
	
	/**
	 * Button class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class Button extends SimpleButton implements IMXMLObject, ILayoutClient
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property label
		//------------------------------------
		
		[Bindable("labelChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelChanged</code> event.
		*/
		public function get label():String { return _label.text; }
		
		public function set label(value:String):void 
		{
			if (_label.text == value) return;
			_label.text = value;
			this.invalidate("_label", _label.text, false);
			super.dispatchEvent(new Event("labelChanged"));
		}
		
		//------------------------------------
		//  Public property upProducer
		//------------------------------------
		
		[Bindable("upProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>upProducerChanged</code> event.
		*/
		public function get upProducer():SkinProducer { return _upProducer; }
		
		public function set upProducer(value:SkinProducer):void 
		{
			if (_upProducer == value) return;
			_upProducer = value;
			this.invalidate("_upProducer", _upProducer, false);
			super.dispatchEvent(new Event("upProducerChanged"));
		}
		
		//------------------------------------
		//  Public property overProducer
		//------------------------------------
		
		[Bindable("overProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>overProducerChanged</code> event.
		*/
		public function get overProducer():SkinProducer { return _overProducer; }
		
		public function set overProducer(value:SkinProducer):void 
		{
			if (_overProducer == value) return;
			_overProducer = value;
			this.invalidate("_overProducer", _overProducer, false);
			super.dispatchEvent(new Event("overProducerChanged"));
		}
		
		//------------------------------------
		//  Public property downProducer
		//------------------------------------
		
		[Bindable("downProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>downProducerChanged</code> event.
		*/
		public function get downProducer():SkinProducer { return _downProducer; }
		
		public function set downProducer(value:SkinProducer):void 
		{
			if (_downProducer == value) return;
			_downProducer = value;
			this.invalidate("_downProducer", _downProducer, false);
			super.dispatchEvent(new Event("downProducerChanged"));
		}
		
		//------------------------------------
		//  Public property hitProducer
		//------------------------------------
		
		[Bindable("hitProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>hitProducerChanged</code> event.
		*/
		public function get hitProducer():SkinProducer { return _hitProducer; }
		
		public function set hitProducer(value:SkinProducer):void 
		{
			if (_hitProducer == value) return;
			_hitProducer = value;
			this.invalidate("_hitProducer", _hitProducer, false);
			super.dispatchEvent(new Event("hitProducerChanged"));
		}
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return _validator; }
		
		public function get invalidProperties():Object { return _invalidProperties; }
		
		public function get layoutParent():ILayoutClient { return _layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void
		{
			if (_layoutParent === value) return;
			_layoutParent = value;
			if (_layoutParent)
			{
				_validator = _layoutParent.validator;
				if (_validator) _validator.append(this, _layoutParent);
			}
		}
		
		public function get childLayouts():Vector.<ILayoutClient> { return null; }
		
		public function get currentState():DisplayObject
		{
			var cs:DisplayObject = super.upState;
			if (cs && cs.parent) return cs;
			cs = super.overState;
			if (cs && cs.parent) return cs;
			cs = super.downState;
			if (cd && cs.parent) return cs;
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _label:TextField = new TextField();
		protected var _validator:LayoutValidator;
		protected var _layoutParent:ILayoutClient;
		protected var _invalidProperties:Object = { };
		protected var _upProducer:SkinProducer;
		protected var _overProducer:SkinProducer;
		protected var _downProducer:SkinProducer;
		protected var _hitProducer:SkinProducer;
		protected var _invalidLayout:Boolean;
		
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
		
		public function Button(	upState:DisplayObject = null, 
								overState:DisplayObject = null, 
								downState:DisplayObject = null, 
								hitTestState:DisplayObject = null) 
		{
			super(upState, overState, downState, hitTestState);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		public function validate(properties:Object):void
		{
			
		}
		
		public function invalidate(property:String, cleanValue:*, 
														validateParent:Boolean):void
		{
			_invalidProperties[property] = cleanValue;
			if (_validator) _validator.requestValidation(this, validateParent);
			_invalidLayout = true;
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
	}
	
}