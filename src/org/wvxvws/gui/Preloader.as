////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

package org.wvxvws.gui 
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	
	[Event(name="complete", type="flash.events.Event")]
	
	[Skin("org.wvxvws.skins.PreloaderSkin")]
	
	/**
	* Preloader class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Preloader extends DIV implements IPreloader, ISkinnable
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.IPreloader */
		
		public function get classAlias():String { return this._classAlias; }
		
		public function set classAlias(value:String):void
		{
			_classAlias = value;
		}
		
		/* INTERFACE org.wvxvws.gui.IPreloader */
		
		public function set target(value:IEventDispatcher):void
		{
			if (this._target === value) return;
			if (this._target)
			{
				this._target.removeEventListener(
					ProgressEvent.PROGRESS, this.progressHandler);
				this._target.removeEventListener(Event.COMPLETE, super.dispatchEvent);
			}
			this._target = value;
			if (this._target)
			{
				this._target.addEventListener(
					ProgressEvent.PROGRESS, this.progressHandler);
				this._target.addEventListener(Event.COMPLETE, super.dispatchEvent);
			}
			super.invalidate(Invalides.TARGET, false);
		}
		
		public function get target():IEventDispatcher { return this._target; }
		
		public function set percent(value:int):void
		{
			if (this._percent === value) return;
			this._percent = value;
			super.invalidate(Invalides.STATE, false);
		}
		
		public function get percent():int { return this._percent; }
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return this._skin; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (this._skin === value) return;
			this._skin = value;
			if (this._skin && this._skin.length)
				this._progressSkin = this._skin[0].produce(this) as IProgress;
			super.invalidate(Invalides.SKIN, false);
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _target:IEventDispatcher;
		protected var _classAlias:String;
		protected var _skin:Vector.<ISkin>;
		protected var _isPlaying:Boolean;
		protected var _progressSkin:IProgress;
		protected var _percent:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Preloader()
		{
			super();
			this.skin = SkinManager.getSkin(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function start():void
		{
			this._isPlaying = true;
			super.addEventListener(
				Event.ENTER_FRAME, this.progressHandler, false, 0, true);
		}
		
		public function stop():void
		{
			this._isPlaying = false;
			super.removeEventListener(Event.ENTER_FRAME, this.progressHandler);
		}
		
		public override function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			this.start();
		}
		
		public override function validate(properties:Dictionary):void 
		{
			var skinChanged:Boolean = (Invalides.SKIN in properties);
			super.validate(properties);
			if (skinChanged)
			{
				if (this._progressSkin)
				{
					if (this._progressSkin is DisplayObject)
					{
						(this._progressSkin as DisplayObject).width = super.width;
						(this._progressSkin as DisplayObject).height = super.height;
					}
					(_progressSkin as IMXMLObject).initialized(this, "_progressSkin");
				}
			}
			if (this._isPlaying) this.start();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function progressHandler(event:Event):void 
		{
			if (event is ProgressEvent)
			{
				if (this._progressSkin)
				{
					this._progressSkin.percent = 
						(event as ProgressEvent).bytesLoaded * 100 / 
						(event as ProgressEvent).bytesTotal;
						return;
				}
			}
			if (this._target && this._progressSkin)
			{
				if (this._target is DisplayObject)
				{
					this._progressSkin.percent = 
						(_target as DisplayObject).loaderInfo.bytesLoaded * 100 / 
						(_target as DisplayObject).loaderInfo.bytesTotal;
						return;
				}
				else if (this._target is LoaderInfo)
				{
					this._progressSkin.percent = 
						(_target as LoaderInfo).bytesLoaded * 100 / 
						(_target as LoaderInfo).bytesTotal;
						return;
				}
				this._progressSkin.percent = 0;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}