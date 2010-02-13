package signals 
{
	//{ imports
	import flash.display.Sprite;
	import org.wvxvws.signals.ISemaphore;
	import org.wvxvws.signals.SignalError;
	import org.wvxvws.signals.Signals;
	//}
	
	/**
	 * TestAsteriscNamespace class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SignalsExample extends Sprite implements ISemaphore
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const FOO:Vector.<Class> = new <Class>[int];
		public static const BAR:Vector.<Class> = new <Class>[String, int];
		
		/* INTERFACE org.wvxvws.signals.ISemaphore */
		
		public function get signals():Signals { return this._signals; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _signals:Signals;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SignalsExample() 
		{
			super();
			this._signals = new Signals(this);
			this._signals.add(FOO, this.slotTest3);
			this._signals.add(BAR, this.slotTest);
			this._signals.add(BAR, this.slotTest2);
			this._signals.call(BAR, "Foo", 100);
			this._signals.call(FOO, 200);
			try
			{
				this._signals.call(FOO, "Foo", 100);
			}
			catch (error:SignalError)
			{
				// Attempting to call slot with wrong signature.
				trace(error.message);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.signals.ISemaphore */
		
		public function signalTypes():Vector.<Vector.<Class>>
		{
			return new <Vector.<Class>>[FOO, BAR];
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function slotTest(par0:String, par1:int):void
		{
			trace("slotTest called", par0, par1);
		}
		
		private function slotTest2(par0:String, par1:int):void
		{
			trace("slotTest2 called", par0, par1);
		}
		
		private function slotTest3(par1:int):void
		{
			trace("slotTest3 called", par1);
		}
	}
}