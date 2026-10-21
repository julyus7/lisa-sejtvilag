from pathlib import Path
import json,random
from rules import *
checks=[]
def check(name,condition):
 assert condition,name
 checks.append(name)
neighbours=[(dx,dy) for dx in (-1,0,1) for dy in (-1,0,1) if dx or dy]
for alive in (False,True):
 for mask in range(256):
  cells={(32+dx,16+dy) for bit,(dx,dy) in enumerate(neighbours) if mask&(1<<bit)}
  if alive:cells.add((32,16))
  count=mask.bit_count();got=dense_step(encode(cells))
  check(f'B3/S23 center={int(alive)} neighbours={mask}',bool(got[16*66+32])==(count==3 or (alive and count==2)))
check('empty stays empty',not step(set()))
block={(31,16),(32,16),(31,17),(32,17)}
check('block is stable',step(block)==block)
check('isolated cell dies',not step({(1,1)}))
full={(x,y) for y in range(1,33) for x in range(1,65)}
check('finite boundary: full board leaves four corners',step(full)=={(1,1),(64,1),(1,32),(64,32)})
check('boundary does not wrap',not step({(64,1),(1,1),(2,1)}))
for k,period in ((2,2),(3,3)):
 first=cells=pattern(k)
 for _ in range(period):cells=step(cells)
 check(f'pattern {k} period {period}',cells==first)
cells=first=pattern(1)
for _ in range(4):cells=step(cells)
check('glider translates one cell after four generations',cells=={(x+1,y+1) for x,y in first})
official=rle((ROOT/'gosperglidergun.rle').read_text())
check('gun matches published RLE',pattern(4)=={(x+8,y+8) for x,y in official})
cells=pattern(4)
for _ in range(30):cells=step(cells)
check('gun produces first five-cell glider',len(cells)==41)
rng=random.Random(246)
for case in range(80):
 cells={(x,y) for y in range(1,33) for x in range(1,65) if rng.random()<.01+case/100}
 check(f'dense and sparse algorithms agree {case}',decode(dense_step(encode(cells)))==step(cells))
source=(ROOT.parent/'src/game.pas').read_text()
check('native kernel reads only old buffer', 'lfNew[p] := chr(value)' in source and 'for p := 0 to 2243 do lfBoard[p] := lfNew[p]' in source)
check('native rendering copies bounded row bitmap', 'CopyBits(lfBitmap,myWindow^.portBits,src,dst,srcCopy,nil)' in source)
check('generated source has no video invalidation hack', 'BlockPresent' not in (ROOT.parent/'src/M.TEXT').read_text())
report=dict(passed=len(checks),checks=checks,scope='independent rule model, generated patterns and source guards; native execution tested separately')
(ROOT/'rules-validation.json').write_text(json.dumps(report,indent=2)+'\n')
print('PASS',len(checks),'rule/pattern checks')
