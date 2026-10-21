"""Independent sparse reference implementation and native-layout test helpers."""
from collections import Counter
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parent
WIDTH,HEIGHT=64,32
def step(cells):
 counts=Counter((x+dx,y+dy) for x,y in cells
                for dx in (-1,0,1) for dy in (-1,0,1) if dx or dy)
 return {p for p,n in counts.items() if 1<=p[0]<=64 and 1<=p[1]<=32
         and (n==3 or (n==2 and p in cells))}
def pattern(k):
 p=json.loads((ROOT/'patterns.json').read_text())[str(k)]
 return {(x+p['origin'][0],y+p['origin'][1]) for x,y in p['cells']}
def encode(cells):
 data=bytearray(2244)
 for x,y in cells:data[y*66+x]=1
 return bytes(data)
def decode(data):
 assert len(data)==2244 and set(data)<={0,1}
 assert all(data[r*66]==data[r*66+65]==0 for r in range(34))
 assert data[:66]==data[-66:]==bytes(66)
 return {(c,r) for r in range(1,33) for c in range(1,65) if data[r*66+c]}
def dense_step(data):
 """Model the Pascal's padded two-buffer calculation for cross-checking."""
 out=bytearray(2244)
 for r in range(1,33):
  for c in range(1,65):
   p=r*66+c;n=sum(data[p+d] for d in (-67,-66,-65,-1,1,65,66,67))
   out[p]=int(n==3 or (n==2 and data[p]==1))
 return bytes(out)
def rle(text):
 body=''.join(s for s in text.splitlines() if not s.startswith(('#','x')))
 x=y=n=0;cells=set()
 for ch in body:
  if ch.isdigit():n=n*10+int(ch);continue
  count=n or 1;n=0
  if ch=='o':cells.update((x+i,y) for i in range(count));x+=count
  elif ch=='b':x+=count
  elif ch=='$':y+=count;x=0
  elif ch=='!':break
 return cells
