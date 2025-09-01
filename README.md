# Diacritice
Create a context-menu in Windows-Explorer for translate ANSII-text-files to UTF-8 formattet text with the corected romanian Diacritics

### Symbol in das Kontextmenü einfügen

Sie können Ihrem Kontextmenü-Eintrag im Windows Explorer ein Symbol (Icon) hinzufügen, indem Sie die Windows-Registrierungsdatenbank (Registry) entsprechend anpassen.

---

### 1. Registrierungsschlüssel für Ihre Anwendung

Erstellen Sie einen neuen Schlüssel direkt unter **`HKEY_CLASSES_ROOT\*\shell`**. Diesen Schlüssel benennen Sie, wie Sie möchten, zum Beispiel `IhreAnwendung`.

<pre>
HKEY_CLASSES_ROOT
├── *
│   └── shell
│       └── IhreAnwendung  (<- Das ist der erste Schlüssel, den Sie erstellen)
</pre>

Dieser Schlüssel repräsentiert Ihre Anwendung im Kontextmenü. Sein **Standardwert** legt den Text fest, der im Kontextmenü angezeigt wird, z. B. "Öffnen mit PureBasic".

---

### 2. Befehlsschlüssel

Innerhalb des gerade erstellten Schlüssels (`IhreAnwendung`) müssen Sie einen weiteren Unterschlüssel namens **`command`** erstellen. Dieser Schlüssel enthält den eigentlichen Befehl, der ausgeführt wird, wenn der Benutzer auf Ihren Menüpunkt klickt.

<pre>
HKEY_CLASSES_ROOT
├── *
│   └── shell
│       └── IhreAnwendung
│           └── command   (<- Das ist der zweite Schlüssel)
</pre>

Der **Standardwert** des `command`-Schlüssels muss den Pfad zu Ihrer ausführbaren Datei (`.exe`) und den Platzhalter `"%1"` enthalten.

---

### 3. Icon-Eintrag hinzufügen

Innerhalb des gleichen `IhreAnwendung`-Schlüssels, aber außerhalb des `command`-Unterschlüssels, erstellen Sie einen neuen **Zeichenfolgenwert** mit dem Namen **`Icon`**.

- **Schlüssel:** `HKEY_CLASSES_ROOT\*\shell\IhreAnwendung`
- **Name:** `Icon`
- **Wert:** `"C:\Pfad\Zu\Ihrer\Icon-Datei.ico"`

---

### Zusammenfassung der Struktur

Ihre Registry-Struktur sollte am Ende so aussehen:

**Schlüssel:** `HKEY_CLASSES_ROOT\*\shell\IhreAnwendung`
- **Name:** `(Standard)`
- **Wert:** `"Öffnen mit PureBasic"` (oder ein anderer gewünschter Text)
- **Name:** `Icon`
- **Wert:** `"C:\Pfad\Zu\Ihrer\Anwendung.exe"` (oder `.ico`)

**Schlüssel:** `HKEY_CLASSES_ROOT\*\shell\IhreAnwendung\command`
- **Name:** `(Standard)`
- **Wert:** `"C:\Pfad\Zu\Ihrer\Anwendung.exe" "%1"`
