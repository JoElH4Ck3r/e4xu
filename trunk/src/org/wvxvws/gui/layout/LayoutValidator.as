package org.wvxvws.gui.layout 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	//}
	
	/**
	* LayoutValidator class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class LayoutValidator extends Dictionary
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _chainRoot:ILayoutClient;
		protected var _initializer:DisplayObject;
		protected var _hasDirtyClients:Boolean;
		
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
		
		public function LayoutValidator() { super(true); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function append(client:ILayoutClient, toClient:ILayoutClient = null):void
		{
			if (!this._chainRoot && !client.layoutParent) this._chainRoot = client;
			else if (this._chainRoot && !client.layoutParent)
			{
				if (toClient && this[toClient] !== undefined)
				{
					client.layoutParent = toClient;
				}
				else if (toClient && this[toClient] === undefined)
				{
					client.layoutParent = this._chainRoot;
				}
			}
			if (!this._initializer)
			{
				this._initializer = new Shape();
				this._initializer.addEventListener(Event.ENTER_FRAME, validationLoop);
			}
			this[client] = true;
		}
		
		public function exclude(client:ILayoutClient):void
		{
			delete this[client];
			for (var obj:Object in this) return;
			// TODO: this shouldn't happen normally. Need to investigate.
			if (!this._initializer) return;
			this._initializer.removeEventListener(Event.ENTER_FRAME, this.validationLoop)
			this._initializer = null;
		}
		
		public function requestValidation(client:ILayoutClient, affectParent:Boolean):void
		{
			if (!this[client]) return;
			this[client] = false;
			if (client.layoutParent) this[client.layoutParent] = !affectParent;
			this._hasDirtyClients = true;
		}
		
		public function processValidation():void
		{
			var topDirty:ILayoutClient;
			var suspect:ILayoutClient;
			var suspectParent:ILayoutClient;
			var bottomDirty:ILayoutClient;
			for (var obj:Object in this)
			{
				if (!this[obj])
				{
					topDirty = obj as ILayoutClient;
					suspectParent = this.findDirtyParent(topDirty);
					if (suspectParent) topDirty = suspectParent;
					this.validateChildrenOf(topDirty);
				}
			}
			if (topDirty) processValidation();
		}
		
		private function findDirtyParent(dirtyChild:ILayoutClient):ILayoutClient
		{
			var suspect:ILayoutClient = dirtyChild.layoutParent;
			var dirtyParent:ILayoutClient;
			if (!suspect) return null;
			if (!this[suspect]) dirtyParent = suspect;
			while (suspect)
			{
				suspect = suspect.layoutParent;
				if (!suspect) return dirtyParent;
				if (!this[suspect]) dirtyParent = suspect;
			}
			return null;
		}
		
		private function validateChildrenOf(dirtyParent:ILayoutClient):void
		{
			for each (var client:ILayoutClient in dirtyParent.childLayouts)
			{
				this.validateChildrenOf(client);
			}
			dirtyParent.validate(dirtyParent.invalidProperties);
			this[dirtyParent] = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function validationLoop(event:Event = null):void
		{
			if (_hasDirtyClients) 
			{
				this._hasDirtyClients = false;
				this.processValidation();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}