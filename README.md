# Small Canyon 
Teammitglieder: Jascha Sonntag(217347)

Godot Version: 4.5.1

## Inspiration

Monument Valley - https://store.steampowered.com/app/1927720/Monument_Valley/

## Bedienung

Die .exe und .pck Dateien an den gleichen Ort entzippen und die .exe starten.

Im Hauptmenü kann man mit dem Button "New Level" ein neues Level erstellen. Wenn schon Level existieren werden diese darunter angezeigt. Man kann diese dann spielen (Button mit dem Levelname), editieren (Button "Edit") oder löschen (Button "X").

Editor:
An der linken Seite kann man auswählen, was für ein Block man bauen will. Um zu bauen linksklickt man einen Block in der Mitte an und zieht in die gewünschte Richtung. Wenn man weiter von dem Block weg zieht, werden entweder mehr Blöcke gesetzt oder die Rotation des gesetzten Blocks geändert. Mit Rechtsklick kann man Blöcke wieder löschen.
Mit den Knöpfen auf er rechten Seite kann man die Farbe der gesetzten Blöcke auswählen.
WASD kann genutzt werden um die Kamera zu bewegen. Zudem kann man mit dem Mausrad die Kamera rein und raus zoomen.
Mit "3" kann man in einen 3D-Modus wechseln und mit WASD, Shift und Leertaste wie in Minecraft rumfliegen. Wenn man nochmals "3" drückt kommt man wieder in den normalen Modus.
Mit den Knöpfen unten kann zwischen dem Bau- und Editier-Modus gewechselt werden. Im Editier-Modus kann man Blöcke auswählen (ausgewählter Block wird Lila). Aktuell bringt das nur bei Türen etwas; wenn man eine Tür auswählt und dann eine weitere Tür klickt werden die beiden Türen verknüpft.
Mit dem "X" oben rechts in der Ecke kann man jederzeit das Level verlassen, speichern oder spielen. Zum Speichern muss dem Level ein Name gegeben werden.

Spielmodus:
Um die Figur zu bewegen klickt man einfach auf irgendeine Fläche. Wenn es einen Weg von der Figur dahin gibt, läuft sie dahin. Wenn die Figur in eine Tür läuft, kommt sie aus der verknüpften Tür raus. Wenn man den Zielblock erreicht, kommt ein "Level beendet"-Pop-Up.
Mit dem "X" oben rechts in der Ecke kann man jederzeit das Level verlassen oder zum Editieren wechseln.

## Herausforderungen

Navigation:
Die bei weitem größte Herausforderung war die Erkennung von möglichen Laufwegen. 
Das jetzt implementierte System erkennt anhand der Positionen der Blöcke und einigen Collidern in den Blöcken wie diese zusammenhängen. Durch Treppen, Rampen und Leitern ergeben sich mehrere verschiedene Anordnungen wie Laufflächen miteinander zusammenhängen können. 
Dazu kommt noch unmögliche Geometrie. Implementiert ist eine von zwei unmöglichen Blockübergängen: Blöcke, welche durch die Perspektive so aussehen als ob sie miteinander verbunden sind, können navigiert werden auch wenn sie eigentlich nicht verbunden sind.

Blockerweiterungen (Leiter, Start, ...):
Die Modifikation von Blöcken ergab für das Bauen sowie Speichern/Laden eine deutlich erhöhte Komplexität.

3D-Modelle für Blöcke:
Aufgrund fehlender Erfahrung mit Blender habe ich die .obj Dateien für die 3D-Modelle von Hand geschrieben. Für komplexere Formen ist dies natürlich nicht möglich. 

## Assets

Alle 3D-Objekte wurden selbst erstellt. Ansonsten wurden keine weiteren Assets benötigt bzw. die Standart-Knöpfe, -Schrift, etc. von Godot verwendet.
