; Diacritice ersetzen

; BOM UTF-8: EF BB BF
            
; Zeichen                     UTF-8 (HEX)   Unicode code point          Block
; Ș	S cu virgulă (majusculă)	   C8 98            U+0218        \
; ș	s cu virgulă (minusculă)	   C8 99            U+0219          > Latin Extended-B
; Ț	T cu virgulă (majusculă)	   C8 9A            U+021A         |
; ț	t cu virgulă (minusculă)  	 C8 9B            U+021B        /
; Ă	A cu breve (majusculă)	     C4 82            U+0102        \
; ă	a cu breve (minusculă)	     C4 83            U+0103         |
; Â	A cu circumflex (majusculă)	 C3 82            U+00C2          > Latin-1 Supplement
; â	a cu circumflex (minusculă)	 C3 A2            U+00E2         |
; Î	I cu circumflex (majusculă)	 C3 8E            U+00CE         |
; î	i cu circumflex (minusculă)	 C3 AE            U+00EE        /

; https://www.utf8-chartable.de/unicode-utf8-table.pl

Enumeration
  #readfile
  #writefile
EndEnumeration

;Texte:
CompilerIf #sprache="deutsch"
  #info$ = "Information"
  #txt1$ = "Datei aus Explorer übergeben: "+#CRLF$
  #txt2$ = #CRLF$+"ist schon im Unicode-Format (UTF-8)"
  #txt3$ = #CRLF$+"ins Unicode-Format (UTF-8) umwandel?"
  #txt4$ = " Zeichen umgewandelt und Datei gespeichert!"
  #txt5$ = "Konnte Datei nicht Schreiben!"
  #txt6$ = "Löschen der alten Datei und/oder das Umbenennen" +
           " der neuen Datei fehlgeschlagen! Überprüfen Sie," +
           " ob die Datei schreibgeschützt, in einem anderen" +
           "Programm geöffnet ist oder keine Schreibberechtigung hat!"
  #txt7$ = "Konnte Datei nicht öffnen!"
  #txt8$ = "Keine Datei aus Explorer übergeben!"
CompilerElseIf #sprache="rumaenisch"
  #info$ = "Avertisment"
  #txt1$ = "Fișierul din Explorer a fost trimis: "+#CRLF$
  #txt2$ = #CRLF$+"este deja în format Unicode (UTF-8)"
  #txt3$ = #CRLF$+"în format Unicode (UTF-8) de convertit?"
  #txt4$ = " caractere au fost convertit și fișierul a fost salvat!"
  #txt5$ = "Nu s-a putut salva fișierul!"
  #txt6$ = "Ștergerea fișierului vechi și/sau redenumirea fișierului" +
           " nou a eșuat! Vă rugăm să verificați dacă fișierul este" +
           " protejat la scriere, este deschis într-un alt program" +
           " sau dacă nu aveți permisiuni de scriere!"
  #txt7$ = "Nu s-a putut deschide fișierul!"
  #txt8$ = "Nu s-a putut trimite niciun fișier din Explorer!"
CompilerEndIf

;Ruft das erste Kommandozeilenargument ab (Index 0)
DateiPfad.s = ProgramParameter(0)
zaehler = 0
erfolg = 0

If Len(DateiPfad) > 0 ;Überprüft, ob ein Dateipfad übergeben wurde
  If ReadFile(#readfile, DateiPfad)
    DateiFormat = ReadStringFormat(#readfile)
    If DateiFormat = #PB_UTF8
      ;Datei aus Explorer übergeben: [datei] ist schon im Unicode-Format (UTF-8):
      MessageRequester(#info$, #txt1$ + DateiPfad + #txt2$, #PB_MessageRequester_Ok)
      End
    ElseIf DateiFormat = #PB_Ascii
      ;Datei aus Explorer übergeben: [datei] ins Unicode-Format (UTF-8) umwandel?:
      Resultat = MessageRequester(#info$, #txt1$ + DateiPfad + #txt3$, #PB_MessageRequester_YesNo)
      If Resultat = #PB_MessageRequester_No
        End
      EndIf
    EndIf
    If CreateFile(#writefile, DateiPfad + ".neu", #PB_UTF8)
      WriteStringFormat(#writefile, #PB_UTF8) ;schreibe BOM an den Anfang
      While Not Eof(#readfile)
        zeichen = ReadCharacter(#readfile, DateiFormat)
        zaehler + 1 ;Vorläufiges Inkrementieren
        Select zeichen
          Case 227 ;Asc("ã")
            ;Die PureBasic-Funktion WriteCharacter() erwartet den Unicode-Code-Point des Zeichens,
            ;das geschrieben werden soll, nicht die UTF-8-kodierte Byte-Sequenz.
            ;Der Code-Point für "ă" (a mit Breve) ist U+0103.
            ;$C483 ist die UTF-8-Kodierung des Zeichens, nicht der Code-Point selbst.
            ;WriteCharacter() übernimmt die Konvertierung von Unicode nach UTF-8!
            WriteCharacter(#writefile, $0103, #PB_UTF8) ;ă
            ;Alternativ, Little Endian:
            ;WriteUnicodeCharacter(#writefile, $83C4)
          Case 195 ;Asc("Ã")
            WriteCharacter(#writefile, $0102, #PB_UTF8) ;Ă
            ;WriteUnicodeCharacter(#writefile, $82C4)
          Case 186 ;Asc("º")
            WriteCharacter(#writefile, $0219, #PB_UTF8) ;ș
            ;WriteUnicodeCharacter(#writefile, $99C8)
          Case 254 ;Asc("þ")
            WriteCharacter(#writefile, $021B, #PB_UTF8) ;ț
            ;WriteUnicodeCharacter(#writefile, $9BC8)
          Case 238 ;Asc("î")
            WriteCharacter(#writefile, $00EE, #PB_UTF8) ;î
            ;WriteUnicodeCharacter(#writefile, $AEC3)
          Case 226 ;Asc("â")
            WriteCharacter(#writefile, $00E2, #PB_UTF8) ;â
            ;WriteUnicodeCharacter(#writefile, $A2C3)
          Case 206 ;Asc("Î")
            WriteCharacter(#writefile, $00CE, #PB_UTF8) ;Î
            ;WriteUnicodeCharacter(#writefile, $8EC3)
          Case 194 ;Asc("Â")
            WriteCharacter(#writefile, $00C2, #PB_UTF8) ;Â
            ;WriteUnicodeCharacter(#writefile, $82C3)
          Case 170 ;Asc("ª")
            WriteCharacter(#writefile, $0218, #PB_UTF8) ;Ș
            ;WriteUnicodeCharacter(#writefile, $98C8)
          Case 222 ;Asc("Þ")
            WriteCharacter(#writefile, $021A, #PB_UTF8) ;Ț
            ;WriteUnicodeCharacter(#writefile, $9AC8)
          Default
            WriteCharacter(#writefile, zeichen, #PB_Ascii)
            zaehler - 1 ;wenn kein Zeichen gewandelt wieder neutralisieren
        EndSelect
      Wend
      CloseFile(#writefile)
      erfolg = 1
      ;...Zeichen umgewandelt und Datei gespeichert!
      MessageRequester(#info$, Str(zaehler) + #txt4$, #PB_MessageRequester_Ok)
    Else
      ;Konnte Datei nicht Schreiben!:
      MessageRequester(#info$, #txt5$, #PB_MessageRequester_Ok)
    EndIf
    CloseFile(#readfile)
    If erfolg
      If Not DeleteFile(DateiPfad)
        erfolg = 0
      EndIf
      If Not RenameFile(DateiPfad + ".neu", DateiPfad)
        erfolg = 0
      EndIf
      If  erfolg
        ;Löschen der alten Datei und/oder das Umbenennen der neuen Datei fehlgeschlagen!
        MessageRequester(#info$, #txt6$, #PB_MessageRequester_Ok|#PB_MessageRequester_Error)
      EndIf
    EndIf
  Else
    ;Konnte Datei nicht öffnen!
    MessageRequester(#info$, #txt7$, #PB_MessageRequester_Ok)
  EndIf
  
Else
  MessageRequester(#info$, #txt8$, #PB_MessageRequester_Ok)
EndIf
End

; IDE Options = PureBasic 6.21 (Windows - x86)
; CursorPosition = 25
; Folding = -
; EnableXP
; DPIAware
; UseIcon = diacritice.ico
; Executable = Diacritice.exe
; CommandLine = \\DS216J\work\Projekte\Diacritice_ersetzen\Test[ANSI].srt
; ConstantOff = #sprache=rumaenisch
; Constant = #sprache=deutsch
; IncludeVersionInfo
; VersionField17 = 0807 German (Switzerland)