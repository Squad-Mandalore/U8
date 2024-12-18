# NPC
Es gibt NPC Bundles.
- NPC's treten wenn dann immer zusammen in einem Run auf
- Dadurch kann man die soveränität einer questline gewährleisten
- Maybe haben dann manche NPC Bundles noch Quests mit andern NPC Bundles, die dann aber quasi ranndom autreten
- NPC Bundles können auch nur aus einem NPC bestehen

Im folgenden bitte NPC's als Bundles auflisten  

## Statisten

- Obdachlose
- Politiker
- Öko-Anhänger
- Gothic-Anhänger
- Pride-Anhänger
- Familiengruppe
- Musiker
- Sportfans (Fussball-Fan, Eishockey-Fan...)
- Junkie
- Fahrkartenkontrolleur

### Obdachlose

- Alte Zerfetzte Kleidung
- Zeitungsverkauf für Euronen
- Euronenbettler
- Laufen durch Bahn und könnten dich nerven

### Politiker

- Anzug und Aktenkoffer
- Je nach politscher Ausrichtig feindlich oder freundlich gesinnt
- (Könnten ein Gesetz für aktuellen Wagon aussprechen? -> kein Rennen, kein Geld ausgeben?)

### Anhänger

- (Öko) Vintage, Starbuckskaffe, Weltverbesserung
- (Pride) Regenbogen-Pins/Sticker, Pronomenfanatiker
- (Gothic) Schwarze Kleidung, Schwarze Stiefel

### Familiengruppe

- Eltern mit Kindern
- (Kinder) Sprinten wie Hyperaktive durch den Wagon und rempeln dich an

### Musiker

- Musikbox und Saxophon (oder andere Instrumente)
- Stehen im Weg und könnten dich blockieren beim laufen durch die Bahn

### Sportfans

- Menschengruppe welche die U-Bahn zum beben bringt
- (Eisbären Berlin, FC Bayern etc.)

### Junkie

- Redet mit sich selber
- Kann dir mit geringer Wahrscheinlichkeit Drogen geben
- Spricht dich mit hoher Wahrscheinlichkeit an, ob du Drogen hast

### Fahrkartenkontrolleur

- Event, Kontrolleur taucht auf will kontrollieren
- Keine Fahrkarte -> Strafzahlung mit Euronen
- Mögliche Aktionen: Verstecken? Verprügeln (unwahrscheinlich)? Schnell kaufen? 

## Bundle Radikalität
### Greta Thunberg
- Setzt Radikalitätsorientierung auf Links

### Maximilian Krah
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

