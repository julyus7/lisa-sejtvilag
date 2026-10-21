"""Generate native Lisa Pascal source using the existing LOS application shell."""
from pathlib import Path
import shutil,json
R=Path(__file__).resolve().parent
patterns={
 1:dict(name='Siklo',origin=[30,14],cells=[(1,0),(2,1),(0,2),(1,2),(2,2)]),
 2:dict(name='Villogo',origin=[31,16],cells=[(0,0),(1,0),(2,0)]),
 3:dict(name='Pulzar',origin=[25,10],cells=sorted(set(
     [(x,y) for y in (0,5,7,12) for x in (2,3,4,8,9,10)]+
     [(x,y) for x in (0,5,7,12) for y in (2,3,4,8,9,10)]))),
 4:dict(name='Sikloagyu',origin=[8,8],cells=[(24,0),(22,1),(24,1),
     (12,2),(13,2),(20,2),(21,2),(34,2),(35,2),
     (11,3),(15,3),(20,3),(21,3),(34,3),(35,3),
     (0,4),(1,4),(10,4),(16,4),(20,4),(21,4),
     (0,5),(1,5),(10,5),(14,5),(16,5),(17,5),(22,5),(24,5),
     (10,6),(16,6),(24,6),(11,7),(15,7),(12,8),(13,8)])}
s=(R/'templates/MalomM.TEXT').read_text().replace('program Malom;','program Sejtvilag;')
s=s.replace('uses (*$U UnitStd.obj *)UnitStd,','uses HWInt, (*$U UnitStd.obj *)UnitStd,')
a=s.index('type BOVideoPtr');b=s.index('   nextClkPoll :')
s=s[:a]+'''type BOVideoPtr = ^integer;
var
   lfState : array[1..24] of integer;
   lfBoard,lfNew : packed array[0..2243] of char;
   lfRow : packed array[0..383] of char;
   lfLeft,lfRight : array[1..32] of integer;
   lfBitmap : BitMap;
   lfHud : array[1..3] of Str255;
   lfGen,lfNextTime : longint;
'''+s[b:]
patterns_pas='procedure LFPatternCells(which : integer);\nbegin\ncase which of\n'
for k,p in patterns.items():
 patterns_pas+=f'{k}: begin\n'
 for x,y in p['cells']:patterns_pas+=f"   LFPlace({x+p['origin'][0]},{y+p['origin'][1]});\n"
 patterns_pas+='end;\n'
patterns_pas+='otherwise\nend\nend;\n'
game=(R.parent/'src/game.pas').read_text().replace('{PATTERN_PROCEDURE}',patterns_pas)
a=s.index('procedure MMInit;');b=s.index('procedure doUpdateEvent')
s=s[:a]+game+s[b:]
s=s.replace('mmFlags[17] := 0;', 'lfState[3] := 0;').replace('MMDraw','LFDraw')
s=s.replace('if mmFlags[16]=0 then MMNew;','if lfState[2]=0 then LFInit;')
s=s.replace('FolderSize(myWindow, 500, 260, false);','FolderSize(myWindow, 704, 316, false);\nMoveFolder(myWindow,0,28);')
s=s.replace('MMKey(theEvent.ascii)','if not theEvent.repeatKey then LFKey(theEvent.ascii)')
s=s.replace('MMClick;', 'LFClick;')
s=s.replace('   mmFlags[6] := 0; MMDirty;', '   lfState[4] := 0;')
s=s.replace('MMInit; mmFlags[16] := 0; mmFlags[2] := 1;','lfState[1] := 24670; lfState[2] := 0;')
s=s.replace('MMTick;', 'LFTick;')
s=s.replace('if myWindow <> nil then BlockPresent;', '')
a=s.index('procedure BlockPresent;');b=s.index('procedure LFNum',a);s=s[:a]+s[b:]
assert 'mmFlags' not in s and 'MMDraw' not in s and 'MMTick' not in s
(R.parent/'src/M.TEXT').write_bytes(s.replace('\n','\r').encode('ascii'))
(R.parent/'tests/patterns.json').write_text(json.dumps(patterns,indent=2)+'\n')
