extends Node

const BLUE: Color = Color("79B8FF")
const RED: Color = Color("FF4346")
const GREEN: Color = Color("71F87A")
const WHITE: Color = Color("FFFFFF")
const PINK: Color = Color("FA71FF")
const MAGENTA: Color = Color("E20074")
const YELLOW: Color = Color("F1C40F")
const GREY: Color = Color("DEDEDE")
const DARK_GREY: Color = Color("414141")

enum AttackTypes {
    Attraktiv,
    Stark,
    Cool,
    Intelligent,
    Kreativ,
    Null = -1
}

const ATTACK_DICT = {
    "Attraktiv": {
        "color": PINK,
        "texture": preload("res://ui/combat/assets/stance_token_pink.svg")
    },
    "Stark": {
        "color": RED,
        "texture": preload("res://ui/combat/assets/stance_token_red.svg")
    },
    "Cool": {
        "color": YELLOW,
        "texture": preload("res://ui/combat/assets/stance_token_yellow.svg")
    },
    "Intelligent": {
        "color": BLUE,
        "texture": preload("res://ui/combat/assets/stance_token_blue.svg")
    },
    "Kreativ": {
        "color": MAGENTA,
        "texture": preload("res://ui/combat/assets/stance_token_magenta.svg")
    },
    "Null": {
        "color": WHITE,
        "texture": preload("res://ui/combat/assets/stance_token_white.svg")
    }
};

const STATS_DICT = {
    "max_health": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Maximale Gesundheit"
    },
    "health": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Gesundheit"
    },
    "armor": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Rüstung"
    },
    "initiative": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Initiative"
    },
    "dodge_chance": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Ausweichchance"
    },
    "strength": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Stärke"
    },
    "coolness": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Coolness"
    },
    "attractiveness": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Attraktivität"
    },
    "intelligence": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Intelligenz"
    },
    "creativity": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Kreativität"
    },
    "luck": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Glück"
    },
    "poison_resistance": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Giftresistenz"
    },
    "bleed_resistance": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Blutungsresistenz"
    },
    "drug_resistance": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Drogenresistenz"
    },
    "poison_level": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Giftlevel"
    },
    "bleed_level": {
        "texture": preload("res://ui/hud/assets/coin.svg"),
        "display_name": "Blutungslevel"
    },
    "drug_level": {
        "texture": preload("res://ui/hud/assets/ck_3_bar.svg"),
        "display_name": "Drogenlevel"
    }
}

func remove_all_children(parent: Node):
    for child in parent.get_children():
        child.queue_free()
