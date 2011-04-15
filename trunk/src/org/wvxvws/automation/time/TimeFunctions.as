package org.wvxvws.automation.time
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class TimeFunctions
	{
		private static const _timer:Timer = new Timer(1);

		private static const _callRecords:Dictionary = new Dictionary();
		
		public function TimeFunctions() { super(); }
		
		public static function interval(method:Function, time:int, ...values):CallRecord
		{
			if (!_timer.running)
			{
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			}
			var record:CallRecord = new CallRecord();
			record.method = method;
			record.parameters = values;
			_callRecords[record] = time;
			return record;
		}
		
		public static function stop(record:CallRecord):void
		{
			delete _callRecords[record];
		}
		
		public static function timeout(method:Function, time:int, times:int, ...values):CallRecord
		{
			var params:Array = [method, time];
			if (values) params = params.concat(values);
			var record:CallRecord = interval.apply(null, params);
			record.maxCalls = times;
			return record;
		}
		
		private static function timerHandler(event:TimerEvent):void
		{
			var cast:CallRecord;
			for (var record:Object in _callRecords)
			{
				cast = record as CallRecord;
				if (cast.callCount * _callRecords[record] < getTimer())
				{
					// Need to use LanguageFunctions here to resolve the scope correctly
					cast.callCount++;
					if (cast.parameters)
						cast.method.apply(null, cast.parameters);
					else cast.method();
					if (cast.maxCalls < cast.callCount)
						stop(cast);
				}
			}
		}
	}
}