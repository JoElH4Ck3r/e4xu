package org.wvxvws;

import flash.display.Sprite;
import flash.geom.Point;
import flash.Lib;
import org.wvxvws.gui.Container;

/**
 * ...
 * @author wvxvw
 */
typedef Dot =
{
	var x:Float;
	var y:Float;
}

class Main extends Sprite
{
	public function new()
	{
		super();
		var c:Container = new Container(this);
	}
	
	public static function main()
    {
        flash.Lib.current.addChild(new Main());
		var scale:Float = 30.0;
        var points:Array<Dynamic> = [new Point(0.166666666, 0.166666666)];  // Array<Point> works
		var d:Dot = { x:0.166666666, y:0.166666666 };
        var points2:Array<Dynamic> = [d]; // Array<Dot> works
		var p:Dynamic<Float> = cast {};
		p.x = 0.166666666;
		p.y = 0.166666666;
        var points3:Array<Dynamic> = cast [p]; // Array<Dynamic<Float>> doesn't work
		var f:Dynamic = cast { x:0.166666666, y:0.166666666 };
        var points4:Array<Dynamic> = cast [f]; // Array<Dynamic<Float>> doesn't work
        
        var result:Float = points[0].x * scale;
        var result2:Float = points2[0].x * scale;
        var result3:Float = points3[0].x * scale;
        var result4:Float = points4[0].x * scale;
		var iter:Iterator<Null<Dynamic>> = points.iterator();
		var result5:Float = iter.next().x * scale;
		
		trace(result);
        trace(result2);
        trace(result3);
        trace(result4);
        trace(result5);
    }
}