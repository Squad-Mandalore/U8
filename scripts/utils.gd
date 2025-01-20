extends Node

const light_blue: Color = Color("79B8FF")
const red: Color = Color("FF4346")
const green: Color = Color("71F87A")
const white: Color = Color("FFFFFF")

const stats_dict = {
    "max_health": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Maximale Gesundheit"
    },
    "health": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Gesundheit"
    },
    "armor": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Rüstung"
    },
    "initiative": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Initiative"
    },
    "dodge_chance": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Ausweichchance"
    },
    "strength": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Stärke"
    },
    "coolness": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Coolness"
    },
    "attractiveness": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Attraktivität"
    },
    "intelligence": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Intelligenz"
    },
    "creativity": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Kreativität"
    },
    "luck": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Glück"
    },
    "poison_resistance": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Giftresistenz"
    },
    "bleed_resistance": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Blutungsresistenz"
    },
    "drug_resistance": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Drogenresistenz"
    },
    "poison_level": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Giftlevel"
    },
    "bleed_level": {
        "texture": "res://assets/hud/coin.svg",
        "display_name": "Blutungslevel"
    },
    "drug_level": {
        "texture": "res://assets/hud/ck_3_bar.svg",
        "display_name": "Drogenlevel"
    }
}

func remove_all_children(parent: Node):
    for child in parent.get_children():
        child.queue_free()
