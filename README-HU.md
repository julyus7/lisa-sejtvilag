# Sejtvilág – Conway Game of Life Apple Lisa 2-re

Magyar nyelvű, natív LOS 3/3.1 alkalmazás, 64×32 sejtes, egérrel
szerkeszthető táblával. A Lisa betűkészlete miatt a program feliratai
ékezet nélküliek. Saját alkalmazásazonosítója **246**, lemezazonosítójának
vége **D607**; saját siklóikonja van.

## Indítás és kezelés

LOS alatt nyisd meg a `Sejtvilag.dc42` floppy lemezablakát, majd a
Sejtvilag ikont a File/Print → Open művelettel. Az alkalmazás nem indítólemez.
LisaEm-ben nem igényli a Prince-demóhoz készült billentyűjavítást;
minden fontos művelet egérrel is elérhető.
Billentyűs gyorsgombokhoz a használt LisaEm-buildben a **Key → ASCII Keyboard** mód ajánlott.
Linux LisaEm-ben a teszt a globális `~/.lisaem` fájl `forcerefresh=1`
beállításával, Display → Refresh Rate → 4 Hz értékkel futott a helyi
QEMU virtuális gépben. A fájlt csak bezárt emulátornál állítsd át. A 0 értéknél
a tesztpéldány képernyőgyorsítótára egy generációval lemaradt, miközben a
Lisa videómemóriájában már a helyes kép volt. A floppy nem állítja át
az emulátort. Fizikai Lisán nincs ilyen host-gyorsítótár.
Valódi Lisa 2 esetén Lisa-formátumú floppy vagy megfelelő floppyhelyettesítő
szükséges, a natív szektorcímkékkel.

- **Kattintás a táblán:** egy sejt be-/kikapcsolása. A futás szerkesztéskor megáll.
- **Szóköz / Indít:** futás vagy szünet.
- **L / Egy lépés:** megállítás és pontosan egy generáció kiszámítása.
- **U / Üres tábla:** törlés, generációszámláló nullázása.
- **V / Véletlen:** körülbelül 20%-os kezdeti sűrűség.
- **+ és - / Sebesség:** lassú, közepes és gyors futás.
- **1–4:** sikló, villogó, pulzár, Gosper-féle siklóágyú.
- **Escape:** megállítás.

A rács **véges**, a széleken kívül minden sejt halott; nincs átfordulás
az ellenkező oldalra. Születés három szomszédnál, túlélés két vagy három
szomszédnál: **B3/S23**. A generációváltás egyidejű: mindig a teljes régi
táblából készül a teljes új tábla. A változatlan állapot automatikusan megáll.
Az oszcillátorok tovább futnak. Másik ablak aktiválásakor a futás szünetel.

A sebesség a számítás és rajzolás után tartott várakozás: 2000, 800 vagy
250 Lisa-milliszekundum. Nem garantált képkockaszám; az emulátor és a
gép sebességétől is függ. Csak a megváltozott sorok érintett területei
kerülnek újrarajzolásra, kis sorpufferből, a teljes ablak törlése nélkül.


## Letöltés és forrás

[Letölthető Sejtvilag.dc42](https://github.com/julyus7/lisa-sejtvilag/releases/latest/download/Sejtvilag.dc42).

Valódi Apple Lisa 2 hardverre készült natív LOS-alkalmazás. A dokumentált
futási teszt Linux LisaEm / LOS 3.1 / 1 MB környezetben történt; fizikai
Lisa 2-n és Windows LisaEmben még nem teszteltük. A Lisa-floppy natív
szektorcímkéit megőrző író vagy megfelelő floppyhelyettesítő szükséges.

Forrás: [src/M.TEXT](src/M.TEXT), [src/game.pas](src/game.pas).
Újrafordítás: [BUILD.md](BUILD.md). Ellenőrzés: [VALIDATION.md](VALIDATION.md).
