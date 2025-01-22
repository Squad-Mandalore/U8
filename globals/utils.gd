extends Node

const LIGHT_BLUE: Color = Color("79B8FF")
const RED: Color = Color("FF4346")
const GREEN: Color = Color("71F87A")
const WHITE: Color = Color("FFFFFF")
const PINK: Color = Color("fa71ff")
const MAGENTA: Color = Color("e20074")
const YELLOW: Color = Color("f1c40f")

const ATTACK_DICT = {
    "Attraktiviät": PINK,
    "Stärke": RED,
    "Coolness": YELLOW,
    "Intelligenz": LIGHT_BLUE,
    "Kreativität": MAGENTA
}

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
