# Alternativ installation af QGIS

Dette projekt beskriver en metode til installation og drift af QGIS, hvor QGIS benytter en simpel tekst fil (ini-fil) til opbevaring af opsætningsparametre for programmet. Standard Windows installationen af QGIS benytter registry til opbevaring af opsætningsparametre. Ved at fjerne afhængigheden af registry for QGIS opnåes en række fordele:

- En lokal installation kan reduceres til at kopiere to mapper til pc'en og oprette en genvej til QGIS på brugerens skrivebord. Man behøver altså ikke at generere komplicerede msi scripts til installationen.
- Alternative installationer, såsom placering af QGIS programmet på et net-drev eller tilpasning til et Citrix miljø er trivielle tilretninger af den føromtalte, lokale installation.
- Alle opsætningsparametre samles i en ini fil, som er nem at inspicere/rette vha en simpel tekst-editor.
- Ved at placercere program-mappe uden for "c:\program files" eller tilsvarende kan man gennemføre installationen uden "Local Admin" rettigheder. Dette kan benyttes f.eks. af QGIS instruktører til en hurtig installation af QGIS på en række pc'ere, hvor man kun har alm. bruger-rettigheder til.

Ulemper ved metoden:

- Metoden kræver lidt mere forabejde i forhold til en manuel standard-installation på en enkelt pc.


### Grundlæggende metode

Ved den normale installation placeres dele af QGIS installationen på forskellige steder:

- Programdele placeres i en program-mappe, f.eks under "C:\Program Files", f.eks. "C:\Program Files\QGIS Lyon" for QGIS ver. 2.12. Denne program mappe indeholder selve hovedprogrammet, alle underptrogrammer og muligvis også en række eksterne programmer såsom GRASS, SAGA, ORFEUS o.lign. Mappe indeholder ingen opsætnings parametre eller bruger specifikke dele. Programmappens placering er afhængig om QGIS er installeret via den alm. stand-alone installation eller via OSGEO4W installationen (Hvis du ikke kender forskellen på de to installationstyper, kan du studere QGIS.ORG web-siden for download af programmet: [http://qgis.org/en/site/forusers/download.html](http://qgis.org/en/site/forusers/download.html))
- En undermappe ".qgis2" placeret i brugerens hjemmemappe, f.eks "C:\Brugere\bvt\.qgis2" for bruger "bvt" af pc'en. Denne mappe indeholder eks. mapper med plads til temporære data fra "processing", farve paletter, skabeloner til projekt stryring, samt alle python plugins installeret af bruger o.a. Denne mapper er personlig for den enkelte bruger.
- En eller flere "grene" i registry, f.eks: "HKEY_CURRENT_USER\Software\QGIS". Registry indeholder alle opsætnings parametre for QGIS.

Metoden går ud på at få udskiftet placeringen af opsætningsparametre fra registry til en fil placeret i brugermappen .qgis2 (".qgis\QGIS\QGIS2.ini")

QGIS opstartes via en opstartsfil "qgis.bat", som opsætter en række parametre og afslutter med den egentlige opstart af QGIS. Denne kommandoprocedure hedder "qgis.bat" og er placeret i mappe "bin" under programmappen, f.eks "C:\Program Files\QGIS Lyon\bin\qgis.bat"

For at få QGIS til at læse sine opsætningsparametre gøres følgende:

1. Lav en sikkerheds kopi af "qgis.bat", f.eks "qgis.org.bat" (hvis du nu laver ged i det!).

2. "qgis.bat" i mapper "bin" redigeres vha. en simpel teksteditor, som f.eks notepad.

3. Sidste linie i filen har følgende udseende:
```
start "QGIS" /B "%OSGEO4W_ROOT%"\bin\qgis-bin.exe %*
```

4. Tilret den til følgende udseende:
```
start "QGIS" /B "%OSGEO4W_ROOT%"\bin\qgis-bin.exe --configpath %USERPROFILE%\.qgis2 %*
```
dvs. tilføj "--configpath %USERPROFILE%\.qgis2" til linien som næst-sidste parameter.

5. Gem den rettede fil under samme navn.

6. Start QGIS op og genetabler alle opsætninger. Dette kan være en større opgave, da QGIS2.ini pt. kun indeholder et absolut minimum af stadard indstillinger (Der er ikke taget noget med fra registry): Installation af plugins, opsætning af alle bruger preferencer mht. digitalisering, snap, selektion osv. osv. Og ikke mindst: For at processing til at fungere korrekt, skal man under options for processing angive hvor mapperne for hhv. GRASS, SAGA, ORFEUS osv er placeret.

That's it! Næste gang, du starter QGIS op, vil QGIS hente sine parametre fra QGIS2.ini filen i stedet for registry.

Hvis du vil flytte installationen over til en anden pc kan du nøjes med at kopiere program mappen samt brugermappen til samme lokation på den nye pc og oprette en genvej qgis.bat på skrivebordet.