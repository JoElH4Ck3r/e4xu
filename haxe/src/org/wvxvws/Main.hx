package org.wvxvws;

import flash.display.Sprite;
import flash.Lib;
import org.wvxvws.gui.Container;

/**
 * ...
 * @author wvxvw
 */

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
    }
}