package 
{
	import com.ayumilove.model.Formula;
	import com.ayumilove.model.Player;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import com.ayumilove.screen.NewGameScreen;
	import com.ayumilove.screen.LoginScreen;
	import com.ayumilove.screen.Menu;
	import com.ayumilove.events.GameEvent;

	public class Game extends MovieClip
	{

		private static var _menu:Menu;
		public static var main:Game;
		public static var screens:Array; //this array stores display objects.
		public static var screenList: Object = {newgameScreen:NewGameScreen, loginScreen:LoginScreen};
		public static var player:Array; //stores a list of players
		private var _currentWindow:int;
		private static var _screensContainer:Sprite = new Sprite();
		private static var _menuContainer:Sprite = new Sprite();
		private var _player:Player;
		private var _formula:Formula;
		
	
		public function Game()
		{
			//constructor
			main = this;
			main.addChild(_screensContainer);
			main.addChild(_menuContainer);
			trace("hello world");
			addEventListener(GameEvent.LOAD_MONSTER_DATA, loadMonsterHandler);
			openScreen(LoginScreen);
		}
		
		private function loadMonsterHandler(event:GameEvent):void 
		{
			event.stopImmediatePropagation();
			trace("New Game button pressed");
			_player = new Player();
			_formula = new Formula();
			_formula.addEventListener(GameEvent.UPDATE_PLAYER_STATS, formula_updateHandler);
		}
		
		private function formula_updateHandler(event:GameEvent):void 
		{
			_formula.removeEventListener(GameEvent.UPDATE_PLAYER_STATS, formula_updateHandler);
			trace("we loaded the monster data and are set to go");
		}
		
		public static function addMenu():Menu
		{
			_menu = new Menu();
			_menuContainer.addChild(_menu);
			main.addEventListener(GameEvent.UPDATE_PLAYER_STATS, _menu.gameHandler);
			return _menu;
		}

		public static function openScreen (screenClass : Class) : DisplayObject
		{
			if (!screenClass)
			{
				trace("cannot instantiate null");
				return null;
			}
			if (_screensContainer.numChildren && _screensContainer.getChildAt( 0 ) is LoginScreen && !_menu) addMenu();
			//describeType outputs an XML. So we used factory.@type to specify that we only want to see name, not everything.
			//factory is the node of the XML.
			var newscreenClassName : String = describeType( screenClass ).factory.@type;
			var currentscreenClassName : String;
			for each (var d : DisplayObject in screens)
			{
				//getQualifiedClassName is faster , and it takes in - an instance of the class
				currentscreenClassName = getQualifiedClassName( d );
				if (_screensContainer.contains( d ) && currentscreenClassName != newscreenClassName)
				{
					main.removeChild( d );
				}
				else if (currentscreenClassName != newscreenClassName)
				{
					Game.screens.push(d);
					return d;
				}
			}
			return _screensContainer.addChild( new screenClass() as DisplayObject );
		}
	}
}
			
/*

26 May 2009
Discussed with Oleg about the slowness game progress.
Oleg does the Sprite/Graphic + inventory part while I do the formula and others.

1. Make a small mini sample of creating a sound system first.

////////////////////////////////////////////////////////////////////////////////


25May2009
- List of Things that needs to be done/bugging me...
1. Screen System Done
2. Layer System - [Where the sprite should be added/SpellEffect/Damage Number pop up]
3. Character System - stats build up.
4. 
5. Character/Sprite Display


20th May 2009
- Underscore naming convention for private/protected variables. Not for public.

15 May 2009
- Internal Preloader is better than external preloader
- Need to learn how to use bulkloader as preloader and to load all the necessary items
- OLEG: To manage bulk of equipments = compile Level 1-10 equipments into 1 .fla , use BulkLoader to load them into Main.fla

14 May 2009
- Setup essential screens for HackerStory

1. CashShop 
- the place where hackers can temporarily hide from other people view
- Allows players to buy cash items for their character.

2. Freemarket 
- Sell items at higher/lower price compare to NPC.
- Depends on number of players visiting. More players in freemarket, the faster response you get.
- Different timezone/timing will have different amount of people in freemarket.
- Determined by probability, player would need to wait around 10 seconds to 30 seconds for buyer.

3. battleWindow 
- The area where player fight against monsters.
- The area where hackers are vulnerable [caught in hacking action by passerby or GM -game masters]
- Player can afk there if they deactivate their hack tools.

4. townWindow  
- Buy potions from NPC Shop or instantly sell items for a static price to NPC Shop.
- Talk to NPC to do quest.

5. shipWindow
- Travel delay from 1 continent to the other continent [30 seconds]
- This can act as a preloader to load other information.

6. loginWindow
- player inputs their account name, no password required. 
- this function allows player to have multiple accounts, each catering 1 job.
- similar to save file.

*/