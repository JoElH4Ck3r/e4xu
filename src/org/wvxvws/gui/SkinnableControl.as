package org.wvxvws.gui 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import mx.styles.CSSStyleDeclaration;
	
	/**
	 * SkinnableDIV class.
	 * @author wvxvw
	 */
	public class SkinnableDIV extends DIV implements ISkinableDIV
	{
		protected var _skin:Skin;
		protected var _inheritingStyles:Object = {};
		protected var _nonInheritingStyles:Object = {};
		protected var _styleDeclaration:CSSStyleDeclaration;
		
		public function SkinnableDIV() { super(); }
		
		public function setSkin(skin:Skin):void
		{
			if (_skin === skin) return;
			_skin = skin;
			isInvalidLayout = true;
		}
		
		/* INTERFACE org.wvxvws.gui.ISkinableDIV */
		
		public function get className():String
		{
			return getQualifiedClassName(this);
		}
		
		public function get inheritingStyles():Object
		{
			return _inheritingStyles;
		}
		
		public function set inheritingStyles(value:Object):void
		{
			if (_inheritingStyles === value) return;
			_inheritingStyles = value;
		}
		
		public function get nonInheritingStyles():Object
		{
			return _nonInheritingStyles;
		}
		
		public function set nonInheritingStyles(value:Object):void
		{
			if (_nonInheritingStyles === value) return;
			_nonInheritingStyles = value;
		}
		
		public function get styleDeclaration():CSSStyleDeclaration
		{
			return _styleDeclaration;
		}
		
		public function set styleDeclaration(value:CSSStyleDeclaration):void
		{
			if (_styleDeclaration === value) return;
			_styleDeclaration = value;
		}
		
		public function getStyle(styleProp:String):*
		{
			return _styleDeclaration.getStyle(styleProp);
		}
		
		public function setStyle(styleProp:String, newValue:*):void
		{
			_styleDeclaration.setStyle(styleProp, newValue);
		}
		
		public function clearStyle(styleProp:String):void
		{
			_styleDeclaration.clearStyle(styleProp);
		}
		
		public function getClassStyleDeclarations():Array
		{
			return []; // TODO: find what it does
		}
		
		public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean):void
		{
			// TODO: find what it does
		}
		
		public function regenerateStyleCache(recursive:Boolean):void
		{
			// TODO: find what it does
		}
		
		public function registerEffects(effects:Array):void
		{
			// TODO: find what it does
		}
		
		public function get styleName():Object
		{
			// TODO: find what it does
		}
		
		public function set styleName(value:Object):void
		{
			// TODO: find what it does
		}
		
		public function styleChanged(styleProp:String):void
		{
			// TODO: find what it does
		}
	}
}