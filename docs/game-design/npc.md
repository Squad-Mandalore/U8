# NPC
Es gibt NPC Bundles.
- NPC's treten wenn dann immer zusammen in einem Run auf
- Dadurch kann man die soveränität einer questline gewährleisten
- Maybe haben dann manche NPC Bundles noch Quests mit andern NPC Bundles, die dann aber quasi ranndom autreten
- NPC Bundles können auch nur aus einem NPC bestehen

Im folgenden bitte NPC's als Bundles auflisten

## Bundle Radikalität
### Greta Thunberg
- Setzt Radikalitätsorientierung auf Links

### Tino Chrupalla
- Setzt Radikalitätsorientierung auf Rechts

## Bundle Dishonest Brothers
Sind Brüder und Taschendiebe. \
Cross Bundle Interaktion mit Polizisten 

### Chris
- Junger Bruder
- Etwas tolpatschig
- Klaut 10% Euronen

### Andreas
- Älterer und erfahrener Bruder
- Krasser macher - übel cool
- Klaut 30% Euronen
- Wird bei mind. 15 Intelligenz erwischt

### Questline
1. Chris versucht zu klauen
    ```
    Wenn Intelligenz < 6:
        - Chris klaut 10% Euronen

    Sonst:
        - Spieler bekommt Chris's Raub mit [1]
        
        Mögliche Reaktionen:
            Wenn Stärke > 4:
                - Verprügeln [2]
                - Bekommt X Euronen
            Wenn Coolnes > 4:
                - Chris beeindrucken [3]
            Immer:
                - Chris machen lassen
            
            TODO - mehr shit
    ```
2. Andreas versucht zu klauen
    ```
    Wenn [2]:
        - Andreas erinerrt sich an Chris's erzählungen von dir
        -> Combat mit Andreas
    Sonst:
        Wenn Intelligenz < 12:
            Wenn [3]:
                - Andreas erinnert sich an Chris's erzählungen und respektiert dich
                - Andreas klaut 15% Euronen
            Sonst: 
                - Andreas klaut 30% Euronen
        Sonst:
            Mögliche Reaktionen:
                Wenn Stärke > 9:
                    - Verprügeln [4]
                    - Bekommt X Euronen
                Wenn Coolnes > 9:
                    - Andreas beeindrucken
                    - Andreas schenkt item
                Immer:
                    - Andreas machen lassen

                TODO - mehr shit
    ```

    TODO - mehr shit \
    waren erstmal nur Grobe Ideen, man kann noch ne Menge draus machen

    Wegen Cross Bundle mit Polizisten - man soll irgendwie die Dishonest Brothers verpetzen können und dann werden die verhaftet oder so

