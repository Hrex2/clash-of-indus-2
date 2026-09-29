extends Node

var abilities = [

	{
		"name": "POWER STRIKE",
		"cost": 2,
		"type": "DAMAGE",
		"target": "SINGLE",
		"power": 30,
		"cooldown": 2,
		"description": "Deals heavy damage to one enemy.",
		"image":"res://assets/abilities/power_strike.png",
	},

	{
		"name": "SHIELD WALL",
		"cost": 2,
		"type": "DEFENSE",
		"target": "SELF",
		"power": 40,
		"cooldown": 3,
		"description": "Reduces incoming damage by 40%.",
		"image": "res://assets/abilities/shield_wall.png"
	},

	{
		"name": "HEALING HERBS",
		"cost": 2,
		"type": "HEAL",
		"target": "ALLY",
		"power": 25,
		"cooldown": 2,
		"description": "Restores 25 HP to one ally.",
		"image": "res://assets/abilities/healing_herbs.png"
	},

	{
		"name": "WAR CRY",
		"cost": 3,
		"type": "BUFF",
		"target": "ALL_ALLIES",
		"power": 20,
		"cooldown": 4,
		"description": "Increases attack of all allies by 20%.",
		"image": "res://assets/abilities/war_cry.png"
	},

	{
		"name": "PIERCING SHOT",
		"cost": 2,
		"type": "DAMAGE",
		"target": "SINGLE",
		"power": 25,
		"cooldown": 2,
		"description": "Deals damage while ignoring 20% defense.",
		"image": "res://assets/abilities/piercing_shot.png"
	},

	{
		"name": "QUICK MOVE",
		"cost": 1,
		"type": "UTILITY",
		"target": "SELF",
		"power": 1,
		"cooldown": 2,
		"description": "Reduces the hero's ability cooldown.",
		"image": "res://assets/abilities/quick_move.png"
	}
]
