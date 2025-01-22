extends Node

const LIGHT_BLUE: Color = Color("79B8FF")
const RED: Color = Color("FF4346")
const GREEN: Color = Color("71F87A")
const WHITE: Color = Color("FFFFFF")
const PINK: Color = Color("fa71ff")

const STATS_DICT = {
    "max_health": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Maximale Gesundheit"
    },
    "health": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Gesundheit"
    },
    "armor": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Rüstung"
    },
    "initiative": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Initiative"
    },
    "dodge_chance": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Ausweichchance"
    },
    "strength": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Stärke"
    },
    "coolness": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Coolness"
    },
    "attractiveness": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Attraktivität"
    },
    "intelligence": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Intelligenz"
    },
    "creativity": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Kreativität"
    },
    "luck": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Glück"
    },
    "poison_resistance": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Giftresistenz"
    },
    "bleed_resistance": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Blutungsresistenz"
    },
    "drug_resistance": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Drogenresistenz"
    },
    "poison_level": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Giftlevel"
    },
    "bleed_level": {
        "texture": "res://ui/hud/assets/coin.svg",
        "display_name": "Blutungslevel"
    },
    "drug_level": {
        "texture": "res://ui/hud/assets/ck_3_bar.svg",
        "display_name": "Drogenlevel"
    }
}

func remove_all_children(parent: Node):
    for child in parent.get_children():
        child.queue_free()
