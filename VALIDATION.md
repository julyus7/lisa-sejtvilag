# Sejtvilág – kiadási ellenőrzés, 2026. október 19.

Kimenet: `dist/Sejtvilag.dc42`, 419284 bájt.
SHA256: `b09346adf146315631dadeefc5bb18031d8e9b64ec526564ed3b3e86c8cb342d`.

## Natív fordítás

Lisa Pascal 3.26, MC68000 Code Generator 3.16, Lisa Linker 3.0.
Saját gépi kód: 7820 bájt. Linkerhibák: 0.
A fejlesztői lemez M.TEXT fájlja pontosan megegyezik a helyi forrás natív
szövegformátumával. A csomagolt futtatható állomány a natív W.OBJ változatlan
másolata: 10752 bájt. Sony-címkék: mind a 800 változatlan.
Alkalmazásazonosító: 246. Lemezazonosító vége: D607.
Filer-eszközcímke és a három ikonállomány ellenőrizve.

## Szabályok és tényleges futás

605 külön szabály-/mintateszt: B3/S23 összes 512 helyi állapota,
véges táblaszélek, álló tömb, siklóeltolódás, villogó, pulzár,
közzétett RLE-vel egyező siklóágyú, valamint független sűrű és ritka
algoritmus összevetése véletlen táblákon.

67 natív futási ellenőrzés Linux LisaEm alatt, LOS 3.1-en, 1 MB RAM-mal.
Minden vizsgált generáció mind a 2048 sejtje egyezik a különálló Python
referenciamodellel. Próba: sikló 4, villogó 2, pulzár 3, siklóágyú 30
generáción át; véletlen tábla továbbfejlődése; futás, szünet, léptetés,
sebességváltás, valamint egérrel szerkesztés, szélső cellák és gombok.

A bevitel az emulátor normál COPS billentyű- és egér-eseménysorát használja.
Nem hívtuk meg közvetlenül a vendég program eljárásait és nem írtuk át
a vendégmemóriát. Az emulátor billentyűkezelése változatlan.
A képernyőképek normál X11 felvételek; a vizsgált állapotokban a látható
tábla mind a 2048 mintavételi pontja egyezik a program állapotával.
A tesztben a Linux LisaEm tartós `forcerefresh=1` beállítása és 4 Hz-es
host-frissítés működött a QEMU virtuális gépen.
A kezdeti, 0 értékű beállításnál a host képe lemaradt a már helyes
Lisa-videómemóriához képest (render-diagnosis.json). A felvételek készítésekor
nem írtunk debuggerrel videófrissítési jelzőket. A DC42 nem módosítja
az emulátor beállításait, és nem tartalmaz kijelzőszéli memóriamódosítást.

További 81 veszteségmentesen rögzített X11 képkocka automatikus
futás közben: a fejléc, a vezérlők és a tábla egy változatlan részlete minden
képen byte-pontosan azonos. Közben 1 generáció
haladt előre, a villogó állapotváltozása látszik. Mintavételes vizsgálat;
nem fizikai kijelzőmérés és nem teljes képkockára atomi frissítés igazolása.
Két valódi X11 billentyűesemény (mintaváltás, léptetés) is eljutott a programhoz.
Egy sűrű véletlen tábla és a következő generáció mind a 2048 látható sejtjét
is összevetettük a referenciával, normál képernyőfelvételen.
A számlálók külön vizuális próbáján 0. generáció / 398 élő sejt, majd
1. generáció / 383 élő sejt volt látható; a csak olvasott natív állapot
ezekkel egyezett (hud-validation.json).

## Együttműködés és másolás

A privát LOS-lemezen megmaradt mind a 20 meglévő
alkalmazásazonosító; 77 régi program-/erőforrásfájl
byte-pontosan változatlan. A program floppyról indult; merevlemezre történő
natív telepítés nem volt a próba része.

A backupra másolt DC42 visszaolvasása megegyezik a tesztelt kiadással.
Mind a 15 korábbi felső szintű fájl hash-e
változatlan; az eredeti .image fájlok és az emulátorcsomag érintetlenek.

## Korlátok

Fizikai Lisa 2-n és Windows LisaEm alatt nem történt futási próba.
Az eredmény natív LOS-program emulátoros ellenőrzése, nem hardveres
sebességmérés. A sebességválasztó számítás utáni várakozást állít;
nem garantált generáció/másodperc. A cellák soronkénti frissítése miatt
a képernyőképek nem igazolnak teljes képkockára atomi rajzolást.


## Public repository

The reports record the existing native release tests; publication does not
claim a new hardware or emulator run. Source and disk image hashes are
preserved. Reports are in validation/, screenshots in screenshots/.
The private VM, SSH keys, OS/Workshop disks and unrelated files are excluded.
