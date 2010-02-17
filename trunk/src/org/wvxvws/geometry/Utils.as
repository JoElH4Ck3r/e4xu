package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Utils
	{
		public function Utils() { super(); }
		
		public static function intersectionPoint(p0:Point, p1:Point, 
												p2:Point, p3:Point):Point
		{
			var rX:Number = ((p0.x * p1.y - p0.y * p1.x) * (p2.x - p3.x) - 
				(p0.x - p1.x) * (p2.x * p3.y - p2.y * p3.x)) /
				((p0.x - p1.x) * (p2.y - p3.y) - (p0.y - p1.y) * (p2.x - p3.x));
			var rY:Number = ((p0.x * p1.y - p0.y * p1.x) * (p2.y - p3.y) - 
				(p0.y - p1.y) * (p2.x * p3.y - p2.y * p3.x)) /
				((p0.x - p1.x) * (p2.y - p3.y) - (p0.y - p1.y) * (p2.x - p3.x));
			return new Point(rX, rY);
		}
	}
}