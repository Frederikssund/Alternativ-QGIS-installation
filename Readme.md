# Alternativ installation af QGIS <br>(Installation of QGIS without using the registry)

(For english-speaking speaking users, see file "Readme-english.md")<br>

Dette projekt beskriver en metode til installation og drift af QGIS, hvor QGIS benytter en simpel tekst fil (ini-fil) til opbevaring af opsætningsparametre for programmet. Standard Windows installationen af QGIS benytter registry til opbevaring af opsætningsparametre. 

Ved at fjerne afhængigheden af registry for QGIS opnås en række fordele:

- En lokal installation kan reduceres til at kopiere to mapper til pc'en og oprette en genvej til QGIS på brugerens skrivebord. Man behøver altså ikke at generere komplicerede msi scripts til installationen.
- Alternative installationer, såsom placering af QGIS programmet på et net-drev eller tilpasning til et Citrix miljø er trivielle tilretninger af den føromtalte, lokale installation.
- Alle opsætningsparametre samles i en ini fil, som er nem at inspicere/rette vha. en simpel tekst-editor.
- Ved at placere program-mappe *uden* for "C:\\Program Files" eller tilsvarende kan man gennemføre installationen uden "Local Admin" rettigheder. Dette kan benyttes f.eks. af QGIS instruktører til en hurtig installation af QGIS på et større antal pc'ere, som instruktøren kun har alm. bruger-rettigheder til. Eller lave en installation af QGIS på mange pc'er som alle skal have den eksakt samme opsætning.

Ulemper ved metoden:

- Metoden kræver mere forarbejde i forhold til en manuel standard-installation på en enkelt pc.


### Grundlæggende metode

Ved den normale installation placeres dele af QGIS installationen på forskellige steder på pc'en:

- Programdele placeres i en program-mappe, f.eks. "C:\Program Files\QGIS Lyon" for QGIS ver. 2.12. Denne program mappe indeholder selve hovedprogrammet, alle underprogrammer og muligvis en række eksterne programmer såsom GRASS, SAGA, ORFEUS o.lign. Mappen indeholder ingen opsætningsparametre eller brugerspecifikke data. Program-mappens placering er afhængig af installationsmetode (Hvis du ikke kender de forskellige installationsmetoder, kan du læse QGIS.ORG web-siden for download af programmet: [http://qgis.org/en/site/forusers/download.html](http://qgis.org/en/site/forusers/download.html))
- En mappe ".qgis2", normalt placeret i brugerens hjemmemappe, f.eks "C:\Brugere\bvtho\\.qgis2" for bruger "bvtho" af pc'en. Denne mappe indeholder bl.a. mapper med plads til temporære data fra "processing", farve paletter, skabeloner til projekt styring, samt alle non-"core" plugins. Denne mappe er personlig for den enkelte bruger.
- En eller flere "grene" i registry, primært "HKEY_CURRENT_USER\Software\QGIS". Registry indeholder alle opsætningsparametre for QGIS.

Metoden går ud på at få udskiftet placeringen af opsætningsparametre fra registry til en fil placeret i brugermappen .qgis2 (".qgis2\QGIS\QGIS2.ini")

Dette sker i to faser:
- "PREPARE" fasen, hvor GIS administrator forbereder en alm. QGIS installation, således den er klar til installation hos slutbruger.

- "RUN" fasen, hvor den tilrettede program-mappe kopieres ud til slutbruger, hvorefter slutbruger foretager den endelige installation ved første opstart af QGIS på hans/hendes pc.

For at få QGIS til at skrive/læse sine opsætningsparametre fra en ini-fil i stedet for registry gøres følgende:

#####PREPARE fase

1. Installér en ordinær udgave af QGIS på din pc. Den bør **ikke** installeres i "C:\Program Files" eller "C:\Programmer", fordi der løbende vil blive tilføjet nye filer og tilrettet eksisterende filer i "PREPARE" fasen. Forskellige sikkerhedsregler i "C:\Progam Files" kan genere eller helt forhindre denne proces.

1. Find placering af opstartsfilen "qgis.bat" (Filen *kan* have et andet navn, afhængig af version og installationsmetode). Opstartsfilen er placeret i mappe "bin" under QGIS program-mappen, f.eks "C:\Program Files\QGIS Lyon\bin\qgis.bat".<br>
"qgis.bat" har til opgave at forberede en række environment parametre og slutteligt foretage den egentlige opstart af QGIS programmet.

2. Lav en kopi af "qgis.bat" med navn "qgis-start.bat" og placér filen i samme mappe som originalen.

3. "qgis-start.bat" redigeres vha. en simpel teksteditor, f.eks notepad:

4. Find sidste linie i filen, som har følgende udseende:
   ```
   start "QGIS" /B "%OSGEO4W_ROOT%"\bin\qgis-bin.exe %*
   ```
   Denne tilpasses ved at indsætte en tekstlinie før den sidste linie og selve linien tilpasses, således det rettede får følgende udseende:
   ```
   call "%OSGEO4W_ROOT%\bin\qgis-prepare.bat"
   start "QGIS" /B "%OSGEO4W_ROOT%"\bin\qgis-bin.exe --configpath "%QGIS_UDIR%" %*
   ```
   (I den sidste linie tilføjes ```--configpath "%QGIS_UDIR%"``` umiddelbart før ```%*```)
6. Gem den rettede fil. I GitHub distributionen er der et eksempel på den rettede fil. Du bør dog ikke bruge den direkte, men kun som en guide, da der kan være mindre forskelle mellem forskellige QGIS installationer.

7. Kopier "qgis-prepare.bat", "qgis.reg.tmpl" samt "minised.exe" fra github distributionsmappen til samme mappe som "qgis-start.bat".

8. Når Qgis installeres vha. den normale installation kopieres der 2 .dll filer til C:\\Windows\System32 mappen. Disse er Microsoft basis support filer, som er nødvendige for Qgis kan fungere. For at sikre, at disse filer efterfølgende også installeres sammen med de øvrige Qgis filer skal man kopiere de to filer fra C:\\Windows\\System32 til Qgis program mappen, undermappe \\bin, f.eks. "C:\Program Files\QGIS 2.18\bin\"<br><br>
Navnene på de to filer er: msvcp120.dll hhv. msvcr120.dll, hvis Qgis er version 2.18. Ved tidligere versioner af Qgis kan navnene **evt.** være msvcp110.dll hhv. msvcr110.dll eller msvcp100.dll hhv. msvcr100.dll.<br><br>NB! Hvis en Qgis 32 bit udgave forberedes på en Windows 64 bt PC, skal dll filerne kopieres fra mappe C:\\Windows\\SysWOW64 i stedet for  C:\\Windows\\System32.

8. Start QGIS ved fra stifinder at dobbeltklikke på "**qgis-start.bat**" (**ikke** qgis.bat). 
Rettelserne i "qgis-start.bat" samt brugen af den tilføjede fil "qgis-prepare.bat" betyder, at der 1) oprettes en ny bruger-mappe i qgis *program-mappen* ved navn ".qgis-template" og 2) Alle opsætningsparametre gemmes i en ini-fil  "QGIS2.ini" placeret i en undermappe til brugermappe ".qgis-template".

9. I den opstartede QGIS (gen)etableres alle opsætninger. Dette kan være en større opgave, da "QGIS2.ini" pt. kun indeholder et absolut minimum af standard indstillinger (Der er ikke taget noget med fra registry): Så opsætning omfatter bl.a. installation af plugins, opsætning af alle bruger preferencer mht. digitalisering, snap, selektion osv. osv. Og ikke mindst: For at processing til at fungere korrekt, skal man under options for processing angive hvor mapperne for hhv. GRASS, SAGA, ORFEUS osv. er placeret. NB! Ved en separat installation af disse ekstra programmer, skal de placeres under QGIS program-mappen.<br><br>NB!! Under opstart af QGIS vha. "qgis-start.bat" vil script "qgis-prepare.bat" blive udført umiddelbart før starten af selve QGIS programmet. Scriptet indeholder bl.a. kode til at "huske" placeringen af QGIS program-mappen og brugerens hjemmemappe under "PREPARE" fasen. Disse oplysninger bruges senere under "RUN" fasen. Man må derfor *ikke* ændre på placeringen af QGIS program-mappen eller skifte bruger mens man arbejder med QGIS i "PREPARE" fasen. Men du må gerne starte QGIS op flere gange i "PREPARE" fasen hvis du ikke når at gøre samtlige rettelser færdig i én QGIS-session.<br><br>Gå ikke videre til næste punkt, før du har din "perfekte" opsætning af QGIS kørende!!

10. Når du er færdig med opsætningen af QGIS tilrettes slutteligt "qgis-start.bat" med følgende

    Linie:
    ```
    call "%OSGEO4W_ROOT%\bin\qgis-prepare.bat"
    ```
    rettes til:
    ```
    call "%OSGEO4W_ROOT%\bin\qgis-prepare.bat" RUN
    ```
    Og slet evt. den originale qgis.bat, således en bruger ikke kommer til at bruge den af vanvare. Efter denne ændring må du ikke foretage flere ændringer i opsætningen af QGIS.
    
11. Dette sidste punkt skal du kun gennemføre, hvis du ønsker at ændre på standardplaceringen for QGIS bruger mappen eller ændre standardteksten på den genvej, som automatisk vil blive genereret på brugerens desktop.
<br>Udgaven af filen "qgis-prepare.bat", som forefindes på GitHub, vil placere QGIS brugermappen i en undermappe ".qgis_214" til brugerens hjemmemappe, f.eks. "C:\Users\bvtho\.qgis_214" hvis brugerinitialer er "bvtho" på en Windows7 baseret pc. Dette er meget tæt på den originale standard placering, hvor mappen hedder ".qgis2"

Det er muligt at benytte andre placeringer ved at rette på en enkelt linie i "qgis-prepare.bat". 
Find linien:

    ```
    REM Path to user directory (with no trailing backslash).. only used in RUN mode
    set "QGIS_UDIR=%USERPROFILE%\.qgis_214"
    ```

og tilpas "%USERPROFILE%\\.qgis_214" til det ønskede. (%USERPROFILE% er en environment variabel, som peger på brugerens hjemmemappe)
<br>Endvidere kan man ændre på teksten til den automatisk oprettede genvej på brugerens skrivebord:

<br>Find linien:

    ```
    REM Text for the desktop shortcut. Change for new versions
    set "QGIS_TEXT=Start QGIS 2.14"
    ```

Ret "Start QGIS 2.14" til det ønskede.
<br>NB! I begge tilfælde er det vigtigt at placere anførselstegn på samme måde som ved de original værdier

#####RUN fase

1. Nu er du klar til at distibuere...<br>Kopiér den tilrettede QGIS program mappe ud på brugerens pc (zip den og distribuer zip-filen).<br>QGIS program-mappen indeholder nu en udgave af QGIS brugermappen ("\<program-mappe\>\\.qgis-template") med alle de plugins, opsætnings-ændringer og -tilføjelser, som du lavede under "PREPARE" - samt en ini-fil med opsætningsparamtre, som ved en normal installation ville være placeret i registry.

2. Bed brugeren om at starte QGIS ved at dobbeltklikke på "\<program-mappe\>\\bin\\qgis-start.bat"

3. Opstartfilen "qgis-start.bat" vil - ved første kørsel - automatisk oprette brugermappen som en kopi af ".qgs-template", etablere en genvej på skrivebordet og oprette en fil-association mellem .qgs filer og den nye QGIS. Endeligt vil alle fil referencer i "qgis2.ini" til program- og bruger-mappe blive tilpasset de nye placeringer på brugerens pc.

4. Ved efterfølgende kald vil QGIS starte almindeligt.<br> 
Funktionerne beskrevet i pkt. 3 & 4 udføres i script "qgis-prepare.bat". Man kan evt. studere dette, hvis man ønsker et dybere kendskab til funktionaliteten.

**Hvis** din IKT afdeling ønsker at lave en .msi baseret installation, kan man pakke den forberedte program-mappe (som også indeholder skabelon til bruger-mappe) samt en genvej til opstart af QGIS (til placering på f.eks. skrivebordet).
Man skal blot tilrette "qgis-prepare.bat" ved at fjerne en enkelt kommandolinie i filen. Kommandoen har til formål at oprette en genvej på skrivebordet, men dette er overflødigt, da msi-pakken allerede vil indeholde denne genvej. Kommandolinien er tydeligt markeret vha. kommentarer i fil "gqis-prepare.bat".

Efter udrulning af msi-pakke vil 1. opstart af QGIS færdiggøre installationen som beskrevet under "RUN fase", pkt.3


### Alternative installationer

Ved at redigere i "qgis-prepare.bat" som beskrevet i pkt. 11 og flytte rundt på placeringen af QGIS program mappen, kan installationen tilpasses til en række forskellige user-cases.

#### Use Case: Installation af QGIS på en fremmed kursus-pc, hvortil man ikke har "Local Admin" privilegier.

Dette kan gennemføres uden rettelser af "qgis-prepare.bat" filen. Man skal blot kopiere QGIS program-mappen til en placering, hvor en alm. bruger har skrive-rettigheder, f.eks. et sted i brugerens hjemmemappe.

#### Use Case: Central installation af QGIS på et netværksdrev

I stedet for at placere QGIS program mappen på et lokalt drev på brugerens pc kan man placere denne mappe på en netværksbaseret drev, f.eks. "x:\\programmer\\qgis". Udover dette er det ikke nødvendigt at ændre iopsætningen.

Da QGIS ikke skriver/opdaterer opsætnings data i program-mappen kan mappen deles af mange brugere. Den eneste ulempe er en længere opstartstid, fordi netdrevet er generelt er langsommere end et lokalt drev.

#### Use Case: Installation af QGIS på CITRIX

På de fleste CITRIX installationer har de enkelte brugere en personlig net baseret mappe, f.eks. "M:\personlig". Så i stedet for at placere QGIS brugermappen på et lokalt drev for CITRIX serveren, kan man placere brugermappen på brugerens personlige drev. Da installationen ikke gør brug af registry indeholder den enkelte CITRIX server herefter ingen QGIS opsætningsdata, som er brugerrelateret - kun programmer og hjælpefiler. Dette forsimpler og smidiggør signifikant QGIS installationen og den daglige brug af QGIS i et CITRIX serverfarm - miljø.

Hedder brugerens personlige drev "M:\\personlig" gøres følgende:

I "qgis-prepare.bat" rettes linien:
```
REM Path to user directory (with no trailing backslash).. only used in RUN mode
set "QGIS_UDIR=%USERPROFILE%\.qgis_214"
```
til: 
```
REM Path to user directory (with no trailing backslash).. only used in RUN mode
set "QGIS_UDIR=M:\personlig\.qgis_214"
```

Og QGIS program mappen placeres på CITRIX serveren sammen med de øvrige programmer der benyttes via CITRIX.

#### Use Case: Installation af 2 forskellige QGIS versioner på samme pc med hver sin bruger opsætning

Man kan have 

- En eksisterende "drift" opsætning af QGIS som ikke må ændres (Vi kalder den QGIS 2.8!)
- Samtidig ønsker at have en alternativ installation (Vi kalder den QGIS 2.14!)
- De to installationer må ikke interferere med hinanden, dvs. hverken dele bruger-opsætning eller plugins.

Dette kan gøres ved følgende (Vi går ud fra, at QGIS 2.8 er standard installeret, dvs. benytter registry og gemmer andre brugerdata i mappe ".qgs2" i brugerens hjemmemappe).  

1. Installér QGIS 2.14 på en "frisk" pc, dvs. uden en eksisterende QGIS installation, som den initiale installation af QGIS 2.14 vil overskrive eller lave andre ændringer på.
2. Gennemfør "PREPARE" fasen med denne nye installation, og sørg for at QGIS brugermappen for QGIS 2.14 **ikke** bliver ".qgis2" men f.eks. ".qgis_214"
3. Kopier den nye program mappe over på drifts-pc'en, og sørg for at program-mappen **ikke** er der samme, som den eksisterende QGIS 2.8.

Ved første opstart af den nye QGIS 2.14 oprettes den nye brugermappe ".qgis_214". Den eksisterende brugermappe for QGIS 2.8 bliver ikke berørt. Og da den nye installation ikke benytter registry, vil denne opsætningsdel af QGIS 2.8 heller ikke blive ændret.

Processen kan i øvrigt gennemføres med flere versioner/nyere versioner af QGIS. QGIS 2.16/".qgis_216", QGIS 2.18/".qgis_218" osv.






