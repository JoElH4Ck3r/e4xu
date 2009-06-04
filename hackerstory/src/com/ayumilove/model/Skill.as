package com.ayumilove.model 
{
	
	//{imports
	
	//}
	/**
	* Skill class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Skill 
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
		public function Skill() 
		{
			super();
			
		}
		
		private var skillDefinition : Object = 
		{	
			"Improving HP Recovery" : [	"16", 
										"Passive",
										"None",
										"0",
										"Recover additional HP every 10 sec. while standing still.",
										"Level AA: Recover additional +BB HP ",
										"1"]
			"Improving Max HP Increase" : [	"10",
											"Passive",
											"Improving HP Recovery",
											"5",
											"This skill boosts up the amount of increase on MaxHP after each Level UP, or AP used on MaxHP.",
											"Level AA: If Level UP, +BB more; if AP applied, +CC more on top on MaxHP",
											"2"]
			"Endure" : ["8",
						"Passive",
						"Improving Max HP Increase",
						"3",
						"Even when hanging on the rope or ladder, you'll be able to recover some HP after a certain amount of time.",
						"Level AA: Recover HP every BB seconds",
						"1"],
			"Iron Body" : [	"20",
							"Supportive",
							"Endure",
							"3",
							"Temporarily increases your weapon defense. ",
							"Level AA: MP BB; Weapon def. +CC for DD seconds.",
							"3" ],
			"Power Strike" : [	"20",
								"Active",
								"None",
								"0",
								"Use MP to deliver a killer blow to the monsters with a sword.",
								"Level AA: MP BB; Sword damage CC%",
								"2"], 
			"Slash Blast" : [	"20",
								"Active",
								"Power Strike",
								"1",
								"Use HP and MP to attack every enemy around you with a sword.",
								"Level AA: HP BB; MP CC, damage DD%",
								"3"] 
		}
		
		private var skillData : Object = 
		{
			"Improving HP Recovery" : [ [3], [6], [9], [12], [15], [18], [21], [24], [27], 
										[30], [33], [36], [39], [42], [45], [50] ],
			"Improving Max HP Increase" : [ [4, 3], [8, 6], [12, 9], [16, 12], [20, 15], [24, 18], 
											[28, 21], [32, 24], [36, 27], [40, 30] ],
			"Endure" : [ [31], [28], [25], [22], [19], [16], [13], [10] ],
			"Iron Body" : [ [-8, 2, 75], [-8, 4, 85], [-8, 6, 95], [-8, 8, 105], [-9, 10, 120],
							[-9, 12, 130], [-9, 14, 140], [-10, 16, 155], [-10, 18, 165], [-10, 20, 175],
							[-11, 22, 190], [-11, 24, 200], [-12, 26, 215], [-12, 28, 225], [-13, 30, 240],
							[-13, 32, 250], [-14, 34, 265], [-14, 36, 275], [-15, 38, 290], [-15, 40, 300] ],
			"Power Strike" : [ [-4, 114], [-4, 120], [-4, 126], [-4, 132], [-5, 142], [-5, 148], [-5, 154],
							[-6, 164], [-6, 170], [-7, 180], [-7, 186], [-8, 196], [-8, 202], [-9, 212], [-9, 218],
							[-10, 228], [-10, 234], [-11, 244], [-11, 250], [-12, 260]], 
			"Slash Blast" : [ [-8, -6, 57], [-8, -6, 60], [-8, -6, 63], [-8, -6, 66], [-9, -7, 71], [-9, -7, 74], [-9, -7, 77],
							[-10, -8, 82], [-10, -8, 85], [-11, -9, 90], [-11, -9, 93], [-12, -10, 98], [-12, -10, 101],
							[-13, -11, 106], [-13, -11, 109], [-14, -12, 114], [-14, -12, 117], [-15, -13, 122], 
							[-15, -13, 125], [-16, -14, 130] ]
		}

		public function Skill()  
		{
			trace(extractSkillData("Iron Body", 0));	
		}
		
		public function extractSkillData ( arg0 : String, arg1 : int ) : Array
		{
			return skillsData [ arg0 ][ arg1 ];
		}
		
		public function extractSkillDefinition (arg0 : String, arg1 :int):String 
		{
			return skillsDefinition [ arg0 ][ arg1 ];
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}