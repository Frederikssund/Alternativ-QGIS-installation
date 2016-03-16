# Alternativ installation af QGIS

Dette projekt beskriver en metode til installation og drift af QGIS, hvor QGIS benytter en simpel tekst fil (ini-fil) til opbevaring af opsætningsparametre for programmet. Standard Windows installationen af QGIS benytter registry til opbevaring af opsætningsparametre. 

Ved at fjerne afhængigheden af registry for QGIS opnås en række fordele:

- En lokal installation kan reduceres til at kopiere to mapper til pc'en og oprette en genvej til QGIS på brugerens skrivebord. Man behøver altså ikke at generere komplicerede msi scripts til installationen.
- Alternative installationer, såsom placering af QGIS programmet på et net-drev eller tilpasning til et Citrix miljø er trivielle tilretninger af den føromtalte, lokale installation.
- Alle opsætningsparametre samles i en ini fil, som er nem at inspicere/rette vha. en simpel tekst-editor.
- Ved at placercere program-mappe *uden* for "C:\\Program Files" eller tilsvarende kan man gennemføre installationen uden "Local Admin" rettigheder. Dette kan benyttes f.eks. af QGIS instruktører til en hurtig installation af QGIS på et større antal pc'ere, som instruktøren kun har alm. bruger-rettigheder til. Eller lave en installation af QGIS på mange pc'er som alle skal have den eksakt samme opsætning.

Ulemper ved metoden:

- Metoden kræver mere forarbejde i forhold til en manuel standard-installation på en enkelt pc.


### Grundlæggende metode

Ved den normale installation placeres dele af QGIS installationen på forskellige steder på pc'en:

- Programdele placeres i en program-mappe - "C:\Program Files", f.eks. "C:\Program Files\QGIS Lyon" for QGIS ver. 2.12. Denne program mappe indeholder selve hovedprogrammet, alle underprogrammer og muligvis en række eksterne programmer såsom GRASS, SAGA, ORFEUS o.lign. Mappen indeholder ingen opsætningsparametre eller brugerspecifikke data. Program-mappens placering er afhængig af installationsmetode (Hvis du ikke kender de forskellige installationsmetoder, kan du læse QGIS.ORG web-siden for download af programmet: [http://qgis.org/en/site/forusers/download.html](http://qgis.org/en/site/forusers/download.html))
- En mappe ".qgis2", normalt placeret i brugerens hjemmemappe, f.eks "C:\Brugere\bvtho\.qgis2" for bruger "bvtho" af pc'en. Denne mappe indeholder bl.a. mapper med plads til temporære data fra "processing", farve paletter, skabeloner til projekt styring, samt alle non-"core" plugins. Denne mappe er personlig for den enkelte bruger.
- En eller flere "grene" i registry, primært "HKEY_CURRENT_USER\Software\QGIS". Registry indeholder alle opsætningsparametre for QGIS.

Metoden går ud på at få udskiftet placeringen af opsætningsparametre fra registry til en fil placeret i brugermappen .qgis2 (".qgis2\QGIS\QGIS2.ini")

Dette sker i to faser:
- "PREPARE" fasen, hvor GIS administrator forbereder en alm. QGIS installation, således den er klar til installation hos slutbruger.

- "RUN" fasen, hvor den tilrettede program-mappe kopieres ud til slutbruger, hvorefter slutbruger foretager den endelige installation ved første opstart af QGIS på hans/hendes pc.

For at få QGIS til at skrive/læse sine opsætningsparametre fra en ini-fil i stedet for registry gøres følgende:

#####PREPARE fase

1. Installér en ordinær udgave af QGIS på din pc. Den bør **ikke** installeres i "Program Files" eller "Programmer", fordi der løbende vil blive tilføjet nye filer og tilrettet eksisterende filer i "PREPARE" fasen. Standard sikkerhedsregler i "Progam Files" kan genere eller helt forhindre denne proces.

1. Find placering af opstartsfilen "qgis.bat" (Filen *kan* have et andet navn, afhængig af version og installationsmetode)
QGIS opstartes via denne opstartsfil, som forbereder en række parametre og afsluttes med den egentlige opstart af QGIS. 
Opstartsfilen er placeret i mappe "bin" under QGIS program-mappen, f.eks "C:\Program Files\QGIS Lyon\bin\qgis.bat"

2. Lav en kopi af "qgis.bat" med navn "qgis-start.bat" og placér filen i samme mappe som originalen.

3. "qgis-start.bat" redigeres vha. en simpel teksteditor, f.eks notepad:

4. Sidste linie i filen har følgende udseende:
   ```
   start "QGIS" /B "%OSGEO4W_ROOT%"\bin\qgis-bin.exe %*
   ```

5. Tilføj ny linie og tilret eksisterende til følgende udseende:
   ```
   call "%OSGEO4W_ROOT%\bin\qgis-prepare.bat"
   start "QGIS" /B "%OSGEO4W_ROOT%"\bin\qgis-bin.exe --configpath "%QGIS_UDIR%" %*
   ```
6. Gem den rettede fil. I GitHub distributionen er der et eksempel på den rettede fil. Du bør dog ikke bruge den direkte, men kun som en guide, da der kan være mindre forskelle mellem forskellige QGIS installationer.

7. Kopier "qgis-prepare.bat" fra github distributionsmappen til samme mappe som qgis-start.bat.

8. Start QGIS ved fra stifinder at dobbeltklikke på "**qgis-start.bat**" (**ikke** qgis.bat). 
Rettelserne i "qgis.bat" samt brugen af den tilføjede fil "qgis-prepare.bat" betyder, at der 1) oprettes en ny bruger-mappe i qgis *program-mappen* ved navn ".qgis-template" og 2) Alle opsætningsparametre gemmes i en ini-fil  "QGIS2.ini" placeret i en undermappe til brugermappe ".qgis-template".

9. (Gen)-etablér alle opsætninger. Dette kan være en større opgave, da "QGIS2.ini" pt. kun indeholder et absolut minimum af standard indstillinger (Der er ikke taget noget med fra registry): Så opsætning omfatter bl.a. installation af plugins, opsætning af alle bruger preferencer mht. digitalisering, snap, selektion osv. osv. Og ikke mindst: For at processing til at fungere korrekt, skal man under options for processing angive hvor mapperne for hhv. GRASS, SAGA, ORFEUS osv er placeret. Gå ikke videre til næste punkt, før du har din "perfekte" opsætning af QGIS kørende!!

10. Tilret slutteligt "qgis-start.bat" med følgende

    Linie:
    ```
    call "%OSGEO4W_ROOT%\bin\qgis-prepare.bat"
    ```
    rettes til:
    ```
    call "%OSGEO4W_ROOT%\bin\qgis-prepare.bat" RUN
    ```
    Og slet evt. den originale qgis.bat, således en bruger ikke kommer til at bruge den af vanvare. Efter denne ændring må du ikke foretage flere ændringer i opsætningen af QGIS.

#####RUN fase

1. Nu er du klar til at distibuere... Kopiér den tilrettede QGIS program mappe ud på brugerens pc (zip den og distribuer zip-filen)

2. Bed brugeren om at starte QGIS ved at dobbeltklikke på [QGIS programmappe]\bin\qgis-start.bat

3. Opstartfilen vil herefter automatisk oprette brugermappen som en kopi af ".qgs-template", etablere en genvej på skrivebordet og oprette en fil-association mellem .qgs filer og den nyinstallerede qgis. Endeligt vil alle fil referencer i "qgis2.ini" tilpasses den nye placering.

4. Ved efterfølgende kald vil QGIS starte almindeligt. 
Funktionerne beskrevet i pkt. 3 & 4 udføres i script "qgis-prepare.bat". Man kan evt. studere dette, hvis man ønsker et dybere kendskab til funktionaliteten.


### Alternative installationer

Udgaven af filen "qgis-prepare.bat", som forefindes på GitHub, vil placere brugermappen i en undermappe ".qgis_214" til brugerens hjemmemappe, f.eks. "C:\Users\bvtho\.qgis_214" hvis brugerinitialer er "bvtho" på en Windows7 baseret pc. Dette er meget tæt på den originale standard placering, hvor mappen hedder ".qgis2"

Det er muligt at benytte andre placeringer ved at rette på en enkelt linie i "qgis-prepare.bat". 

Find linien:
    ```
    REM Path to user directory (with no trailing backslash).. only used in RUN mode
    set "QGIS_UDIR=%USERPROFILE%\.qgis_214"
    ```
og tilpas "%USERPROFILE%\\.qgis_214" til det ønskede. (%USERPROFILE% er en environment variabel, som peger på brugerens
hjemmemappe)

#### Use Case: Installation af QGIS på en fremmed kursus-pc, hvortil man ikke har "Local Admin" privilegier.

Dette kan gennemføres uden rettelser af "qgis-prepare,bat" filen. Man skal blot kopiere QGIS program-mappen til en placering, hvor en alm. bruger har skrive rettigheder, f.eks. et sted i brugerens hjemme mappe.

#### Use Case: Central installation af QGIS på et netværksdrev

I stedet for at placere QGIS program mappen på et lokalt drev på brugerens pc kan man placere denne mappe på en netværksbaseret drev, f.eks. "x:\\programmer\\qgis". Resten af installations processen er uændret
Da QGIS ikke skriver/opdaterer opsætnings data i program-mappen kan denne deles af mange brugere. Den eneste ulempe er en evt. længere opstartstid, fordi netdrevet er langsommere en et lokalt drev.

#### Use Case: Installation af QGIS på CITRIX

På de fleste CITRIX installationer har de enkelte brugere en personlig net baseret mappe, f.eks. "M:\personlig". Så i stedet for at placere QGIS brugermappen på et for CITRIX serveren lokalt drev kan man placere brugermappen på brugerens personlige drev. Da installationen ikke gør brug af registry indeholder den enkelte CITRIX server ingen QGIS opsætningsdata, som er brugerrelateret - kun programmer og hjælpefiler. Dette forsimpler og smidiggør signifikant QGIS installationen i en CITRIX serverfarm - miljø.

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

Og QGIS program mappen placeres samme med de øvrige programmer, som udstilles via CITRIX.

#### Use Case: Installation af 2 forskellige QGIS versioner på samme pc med hver sin bruger opsætning

Man kan have 

- En eksisterende "drift" opsætning af QGIS som ikke må ændres (Vi kalder den QGIS 2.8)
- Samtidig ønsker at have en alternativ installation (Vi kalder den QGIS 2.14)
- De to installationer må ikke interferere med hinanden, dvs ikke dele opsætning eller plugins.

Dette kan gøres ved følgende (Vi går ud fra, at QGIS 2.8 er standard installeret, dvs. bruger registry og gemmer andre brugerdata i mappe ".qgs2" i brugerens hjemmemappe).  

1. Installér QGIS 2.14 på en "frisk" pc, dvs. uden en eksisterende QGIS installation, som de initiale installation af QGIS 2.14 vil overskrive eller lave andre ændringer på.
2. Gennemfør "PREPARE" fasen med denne nye installation, og sørg for, at QGIS brugermappen for QGIS 2.14 **ikke** er ".qgis2" men f.eks. ".qgis_214"
3. Kopier den nye program mappe over på drifts-pc'en, og sørg for at program mappen **ikke** er der samme, som den eksisterende QGIS 2.8.

Ved første opstart af den nye QGIS 2.14 oprettes den nye brugermappe ".qgis_214". Den eksisterende brugermappe for QGIS 2.8 bliver ikke berørt. Og da den nye installation ikke benytter registry, vil denne opsætningsdel af QGIS 2.8 heller ikke blive ændret.

Processen kan i øvrigt gennemføres med andre versioner/nyere versioner af QGIS. QGIS 2.16/".qgis_216", QGIS 2.18/".qgis_218" osv.






