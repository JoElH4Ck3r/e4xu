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
	import mx.core.IMXMLObject;
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
		
		public function get classAlias():String { return _classAlias; }
		
		public function set classAlias(value:String):void
		{
			_classAlias = value;
		}
		
		/* INTERFACE org.wvxvws.gui.IPreloader */
		
		public function set target(value:IEventDispatcher):void
		{
			if (_target === value) return;
			if (_target)
			{
				_target.removeEventListener(
					ProgressEvent.PROGRESS, this.progressHandler);
				_target.removeEventListener(Event.COMPLETE, super.dispatchEvent);
			}
			_target = value;
			if (_target)
			{
				_target.addEventListener(
					ProgressEvent.PROGRESS, this.progressHandler);
				_target.addEventListener(Event.COMPLETE, super.dispatchEvent);
			}
			super.invalidate("_target", _target, false);
		}
		
		public function get target():IEventDispatcher { return _target; }
		
		public function set percent(value:int):void
		{
			if (_percent == value) return;
			_percent = value;
			super.invalidate("_percent", _percent, false);
		}
		
		public function get percent():int { return _percent; }
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin> { return _skin; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (_skin === value) return;
			_skin = value;
			if (_skin && _skin.length)
				_progressSkin = _skin[0].produce(this) as IProgress;
			super.invalidate("_progressSkin", _progressSkin, false);
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
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
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
			_isPlaying = true;
			super.addEventListener(
				Event.ENTER_FRAME, this.progressHandler, false, 0, true);
		}
		
		public function stop():void
		{
			_isPlaying = false;
			super.removeEventListener(Event.ENTER_FRAME, this.progressHandler);
		}
		
		public override function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			this.start();
		}
		
		public override function validate(properties:Object):void 
		{
			var skinChanged:Boolean = ("_progressSkin" in properties);
			super.validate(properties);
			if (skinChanged)
			{
				if (_progressSkin)
				{
					if (_progressSkin is DisplayObject)
					{
						(_progressSkin as DisplayObject).width = super.width;
						(_progressSkin as DisplayObject).height = super.height;
					}
					(_progressSkin as IMXMLObject).initialized(this, "_progressSkin");
				}
			}
			if (_isPlaying) this.start();
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
				if (_progressSkin)
				{
					_progressSkin.percent = 
						(event as ProgressEvent).bytesLoaded * 100 / 
						(event as ProgressEvent).bytesTotal;
						return;
				}
			}
			if (_target && _progressSkin)
			{
				if (_target is DisplayObject)
				{
					_progressSkin.percent = 
						(_target as DisplayObject).loaderInfo.bytesLoaded * 100 / 
						(_target as DisplayObject).loaderInfo.bytesTotal;
						return;
				}
				else if (_target is LoaderInfo)
				{
					_progressSkin.percent = 
						(_target as LoaderInfo).bytesLoaded * 100 / 
						(_target as LoaderInfo).bytesTotal;
						return;
				}
				_progressSkin.percent = 0;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}