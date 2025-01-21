# U8

## Install

## Docs
- The initial concept meeting is transcribed [in the concept file](docs/concept.md).

## Directory Structure

```
├── addons
├── characters
│   ├── npcs
│   └── player
│       └── classes
├── globals
├── items
│   ├── armor
│   ├── consumables
│   ├── meta
│   └── weapons
├── scenes
│   ├── assets
│   ├── combats
│   ├── stations
│   │   ├── 01_wittenau
│   │   │   ├── assets
│   │   │   ├── subscenes
│   │   │   └── wittenau.tscn
│   │   └── assets
│   └── trains
│       ├── assets
│       └── basic_train
└── ui
    ├── assets
    ├── combat
    ├── dialogue
    ├── inventory
    ├── main_menu
    │   └── assets
    ├── notifications
    ├── pause_menu
    └── shop
```

### General
All file names are lowercase and snake_case. Umlaute are expanded. Hyphens (-) are sustituted to underscore (_).

### Assets
The assets are as local to the used scene as possible. If an asset is used by multiple scenes it MUST be in the parent's assets directory.

### Stations
The stations are numbered in order of the line wittenau -> herrmannstrasse.
The main scene of the station is directly in the corresponding station directory. All subscenes are in the subscenes directory.

## Code Convention

### Naming conventions

These naming conventions follow the Godot Engine style. Breaking these
will make your code clash with the built-in naming conventions, leading
to inconsistent code. As a summary table:

| Type         | Convention    | Example                     |
|--------------|---------------|-----------------------------|
| File names   | snake_case    | `yaml_parser.gd`            |
| Class names  | PascalCase    | `class_name YAMLParser`     |
| Node names   | PascalCase    | `Camera3D`, `Player`        |
| Functions    | snake_case    | `func load_level():`        |
| Variables    | snake_case    | `var particle_effect`       |
| Signals      | snake_case    | `signal door_opened`        |
| Constants    | CONSTANT_CASE | `const MAX_SPEED = 200`     |
| Enum names   | PascalCase    | `enum Element`              |
| Enum members | CONSTANT_CASE | `{EARTH, WATER, AIR, FIRE}` |

[GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)

## License
This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## EidolonAI Setup
0. Docker required (for example docker desktop)
1. Run the following command to build a docker image based on the contents of the folder:
  ```bash
  docker build -t godot-agent ./eidolon
  ```
2. Create and run docker container using your openai apikey
  ```bash
  docker run -p 8080:8080 -e OPENAI_API_KEY=<YOUR OPENAI API KEY> godot-agent
  ```
