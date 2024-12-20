# Overall Game Concept

Roguelite -> Meta Fortschritt, Runs welche man abschließt, \
Orientierung an Hades \ Binding of Isaac \ Dead Cells \ Risk of Rain 2

## Game Leitlinie:

**Das feeling der Berliner U8 rüberzubringen** - das Gefühl, dass jederzeit die randomsten Dinge passieren - dass alle möglichen Personen mit verschiedensten Eigenschaften zusammenkommen

## Game Aufbau:

2 verschiedene 'Locations'

### Der Bahnsteig ( Home Bahnsteig \ HUB )

- Fungiert als Base des Spielers (ähnlich wie das Zuhause in Hades)
- Hier gibt es verschiedene Gebäude, welche Angangs noch eine Baustelle sind
  - werden erst im Laufe des spielens durch bestimmte Dinge freigeschalten
- Ganz links gibt es den 'Ausgang' -> fungiert als Save and Exit
- Bahnsteig Schilder auf denen in RL Dinge wie Busse, Straßen, etc. angezeigt werden verweisen auf Gebäude \ den Ausgang
- Hier auch Meta Fortschritt Inhalte zugänglich - upgradebar
- Die U8 steht die gesamte Zeit über am Bahnsteig - Beim betreten geht ein neuer Run los

### Die Bahn

- Hier finden die eigentlichen Runs statt
- Von Links nach Rechts
- Es gibt eine große Vielzahl an Wagon - Themen, welche wiederum prozedural generiert werden
- Verschiedenste Encounter mit NPCs - auch abhängig vom Wagon
- Combat teilweise - nicht hauptsächlich -> dann wie in Oktopath Travaler
- Keine time pressure - also kein side scrolling oder sonstiges
- Events \ encounter werden beim vorbeigehen getriggert
- Man muss bis ans Ende des Wagons, um das level abzuschließen
- Am Ende werden Inputs disabled und es kommt ne mini animation wie die U Bahn anhählt und die Türen aufgehen
- Danach geht man quasi nach unten aus der Tür raus und landet auf nem zwischenbahnsteig - nicht der HUB
- Hier gibts Shops nochmal Shops oder so
- Außerdem kann man sich aussuchen in welchen Wagon der U-Bahn man einsteigen möchte (äußerlich sichtbar welcher Wagon Typ)

## Inventar

- Besteht aus 4x4 Kacheln (wird größer durch verschiedenste Dinge, prob Meta Fortschritt)
- Items haben verschiedene größen
- Items die Stats geben (maybe nen Pullover (Rüstung)) müssen nur im Inventar liegen und geben die Stats -> es gibt keine Equipment Slots

## Anderes Zeug

- Alle Zahlen immer abrunden

## Rüstungsformel

Rüstung blockt nach dieser Formel Schaden ab: \
(1 + 1 / c) x - a ln(ℯ^(x / a) + ℯ^b) + a b

mit \
a = 5 \
b = 5 \
c = 23,4

(abrunden nicht vergessen)

Beispiel: \
Gegner macht 10 Schaden. \
Spieler hat 5 Rüstung. \
5 Rüstung bockt 5,12... -> 5 dmg ab. \
Spieler bekommt 10 - 5 = 5 Schaden.

ca. 15 Rüstung SC und 30 Rüstung HC

## Hitbox

Der Spieler als auch herumlaufende NPC's haben eine visuelle Hitbox auf dem Boden. \
Es sind essentialy 2 Kreise. Einen äußeren und einen inneren. \
Wenn sich mind. zwei äußere Kreise beruehren sind beide Personen langsamer. \
Wenn sich mind. zwei innere Kreise beruehren sind sie halt stuck. Als wäre es ne Wand oder so. \

## Run Stages

Alle Bosse aufm Bahnsteig \
Jede Stage (Zeitraum bevor Boss Nummer x) hat mind. 1, max. 2 Shops \
Die sind dann einfach aufm Bahnsteig \
Auf den restlichen Bahnsteigen ist sonst erstmal einfach nichts i would say

---

1.  Wittenau -> HUB
    - Wagen
2.  Rathaus Reinickendorf
    - Wagen
3.  Karl-Bonhoeffer-Nervenklinik
    - Wagen
4.  Lindauer Allee
    - Wagen
5.  Paracelsus-Bad
    - Wagen
6.  Residenzstr.
    - Boss 1
    ***
    - Wagen
7.  Franz-Neumann-Platz
    - Wagen
8.  Osloer Str.
    - Wagen
9.  Pankstr.
    - Wagen
10. Gesundbrunnen
    - Wagen
11. Voltastr.
    - Wagen
12. Bernauer Str.
    - Boss 2
    ***
    - Wagen
13. Rosenthaler Platz
    - Wagen
14. Weinmeisterstr.
    - Wagen
15. Alexanderplatz
    - Wagen
16. Jannowitzbrücke
    - Wagen
17. Heinrich-Heine-Str.
    - Wagen
18. Moritzplatz (lul, ich will da ein NPC sein - oder der boss :) )
    - Boss 3
    ***
    - Wagen
19. Kottbusser Tor
    - Wagen
20. Schönleinstr.
    - Wagen
21. Hermannplatz
    - Wagen
22. Boddinstr.
    - Wagen
23. Leinestr.
    - Wagen
24. Hermannstr.
    - Endboss

## Wagon Auswahl

Der Spieler kann sich den naechsten Wagon selbst aussuchen.
Wenn kein Shop/Boss nach einem Wagon ist, kommt der Spieler in eine herausgeszoomte und verinfachte Ansicht der U Bahn mit 4 Wagons. \
Man kann sich dann entscheiden in welchen Wagon man moechte (mit nem grossen Pfeil darueber oder so) \
Der 4. Wagon ist immer Random (halt maybe bisschen Grau mit nem Fragezeichen drauf) \
Man verdient während dieses Wagons zudem 10% mehr Euronen.
