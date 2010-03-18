package org.wvxvws.signals 
{
	//{ imports
	
	//}
	
	/**
	 * SignalTemplate class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SignalTemplate
	{
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _slots:Vector.<Function> = new <Function>[];
		protected var _params:Vector.<Class>;
		protected var _stopped:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SignalTemplate(params:Vector.<Class>) 
		{
			super();
			if (params)
			{
				if (params.indexOf(null) > -1) throw new ArgumentError();
				this._params = params.concat();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function bind(slot:Function):void
		{
			var i:int = this._slots.indexOf(slot);
			if (i > -1) this._slots.push(this._slots.splice(i, 1)[0]);
			else this._slots.push(slot);
		}
		
		public function call(...params):void
		{
			for (var i:int = 0; i < this._slots.length && !this._stopped; i++)
			{
				this._slots[i].apply(null, params);
			}
		}
		
		public function stop():void { this._stopped = true; }
		
		public function has(slot:Function):int
		{
			return this._slots.indexOf(slot);
		}
		
		public function remove(slot:Function):void
		{
			var i:int = this._slots.indexOf(slot);
			this._slots.splice(i, 1);
		}
		
		public function toString():String
		{
			var s:String = "";
			var re:RegExp = /[\w$]+(?=\]$)/g;
			for each (var c:Class in this._params)
			{
				s += String(c).match(re)[0] + ",";
			}
			if (s.length) s = s.substr(0, s.length - 1);
			return "SignalTemplate<" + s + ">";
		}
	}
}