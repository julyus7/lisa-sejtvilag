procedure LFNum(n : longint; var s : Str255);
var t : Str255;
begin
   s := '';
   repeat
      t := '0'; t[1] := chr(ord('0')+n mod 10);
      s := concat(t,s); n := n div 10
   until n=0
end;
procedure LFDirtyAll;
var r : integer;
begin
   for r := 1 to 32 do begin lfLeft[r] := 1; lfRight[r] := 64 end
end;
function LFDelay : integer;
begin
   case lfState[5] of
      0: LFDelay := 2000;
      1: LFDelay := 800;
      otherwise LFDelay := 250
   end
end;
procedure LFRecount;
var p : integer;
    sig : longint;
begin
   lfState[7] := 0; sig := 0;
   for p := 0 to 2243 do if lfBoard[p]=chr(1) then begin
      lfState[7] := lfState[7]+1; sig := sig+p
   end;
   lfState[16] := sig mod 30011
end;
procedure LFButton(i : integer; title : Str255);
var box : Rect;
    y : integer;
begin
   y := 28+(i-1)*28; SetRect(box,540,y,693,y+22);
   EraseRect(box); FrameRect(box); MoveTo(547,y+15); DrawString(title)
end;
procedure LFHudLine(i,y : integer; text : Str255);
var box : Rect;
begin
   if (lfState[3]=0) or (lfHud[i]<>text) then begin
      SetRect(box,12,y-12,527,y+3); EraseRect(box);
      MoveTo(12,y); DrawString(text); lfHud[i] := text
   end
end;
procedure LFDraw;
var r,c,y,p,v,ink : integer;
    src,dst,box : Rect;
    s,t,u : Str255;
begin
   if myWindow=nil then exit(LFDraw);
   SetPort(myWindow); ClipRect(myWindow^.portRect); PenNormal;
   if lfState[3]=0 then begin
      EraseRect(myWindow^.portRect); TextFont(0); TextSize(12);
      MoveTo(12,17); DrawString('SEJTVILAG - CONWAY ELETJATEKA');
      SetRect(box,11,31,525,225); FrameRect(box);
      LFDirtyAll;
      LFButton(2,'L  Egy lepes'); LFButton(3,'U  Ures tabla');
      LFButton(4,'V  Veletlen');
      LFButton(6,'1  Siklo'); LFButton(7,'2  Villogo');
      LFButton(8,'3  Pulzar'); LFButton(9,'4  Sikloagyu');
      MoveTo(12,289); DrawString('Szokoz: indit/szunet   L: lepes   U: ures   V: veletlen');
      MoveTo(12,307); DrawString('1-4: mintak   +/-: sebesseg   A tabla szele veges.')
   end;
   lfState[21] := 0;
   for r := 1 to 32 do if lfLeft[r]<=lfRight[r] then begin
      for c := lfLeft[r] to lfRight[r] do begin
         p := r*66+c;
         for y := 0 to 5 do begin
            ink := 0;
            if (y mod 2)=0 then ink := 128;
            if y=5 then ink := 170;
            if (lfBoard[p]=chr(1)) and (y<5) then ink := ink+124;
            lfRow[y*64+c-1] := chr(ink)
         end
      end;
      SetRect(src,(lfLeft[r]-1)*8,0,lfRight[r]*8,6);
      SetRect(dst,12+src.left,32+(r-1)*6,12+src.right,32+r*6);
      CopyBits(lfBitmap,myWindow^.portBits,src,dst,srcCopy,nil);
      lfLeft[r] := 65; lfRight[r] := 0; lfState[21] := lfState[21]+1
   end;
   LFNum(lfGen,s); LFNum(lfState[7],t);
   u := concat('Generacio: ',s,'     Elo sejtek: ',t);
   LFHudLine(1,245,u);
   if lfState[4]=1 then s := 'FUT - kattintasra megall es szerkeszt.'
   else s := 'SZUNET - kattints a sejtek be- es kikapcsolasahoz.';
   LFHudLine(2,265,s);
   if lfState[4]=1 then s := 'Szokoz  Szunet' else s := 'Szokoz  Indit';
   { Redraw controls only when their state actually changes. }
   if (lfState[3]=0) or (lfState[4]<>lfState[22]) then LFButton(1,s);
   if (lfState[3]=0) or (lfState[5]<>lfState[23]) then begin
      case lfState[5] of
         0: s := '+/-  Lassu'; 1: s := '+/-  Kozepes';
         otherwise s := '+/-  Gyors'
      end;
      LFButton(5,s)
   end;
   lfState[22] := lfState[4]; lfState[23] := lfState[5];
   lfState[3] := 1
end;
procedure LFClear;
var p : integer;
begin
   lfState[4] := 0; lfGen := 0; lfState[6] := 0;
   lfState[8] := 0; lfState[9] := 0; lfState[10] := 0;
   for p := 0 to 2243 do begin lfBoard[p] := chr(0); lfNew[p] := chr(0) end;
   LFRecount; LFDirtyAll
end;
procedure LFPlace(c,r : integer);
begin
   if (c>=1) and (c<=64) and (r>=1) and (r<=32) then
      lfBoard[r*66+c] := chr(1)
end;
{PATTERN_PROCEDURE}
procedure LFLoad(which : integer);
begin
   LFClear; LFPatternCells(which); lfState[8] := which;
   LFRecount; LFDraw
end;
procedure LFRandom;
var r,c,p : integer;
begin
   LFClear;
   for r := 1 to 32 do for c := 1 to 64 do begin
      lfState[11] := (longint(lfState[11])*25173+13849) mod 32749;
      p := r*66+c;
      if (lfState[11] mod 5)=0 then lfBoard[p] := chr(1)
   end;
   lfState[8] := 5; LFRecount; LFDraw
end;
procedure LFAdvance;
var r,c,p,n,value,pop,changed : integer;
    sig,started,elapsed : longint;
begin
   lfState[12] := 1; started := Timer; pop := 0; changed := 0; sig := 0;
   for r := 1 to 32 do begin
      lfLeft[r] := 65; lfRight[r] := 0;
      for c := 1 to 64 do begin
         p := r*66+c;
         n := ord(lfBoard[p-67])+ord(lfBoard[p-66])+ord(lfBoard[p-65])+
              ord(lfBoard[p-1])+ord(lfBoard[p+1])+
              ord(lfBoard[p+65])+ord(lfBoard[p+66])+ord(lfBoard[p+67]);
         value := 0;
         if (n=3) or ((n=2) and (lfBoard[p]=chr(1))) then value := 1;
         lfNew[p] := chr(value);
         if value=1 then begin pop := pop+1; sig := sig+p end;
         if lfNew[p]<>lfBoard[p] then begin
            changed := changed+1;
            if c<lfLeft[r] then lfLeft[r] := c;
            lfRight[r] := c
         end
      end;
      if (r mod 4)=0 then LetOthersRun
   end;
   for p := 0 to 2243 do lfBoard[p] := lfNew[p];
   lfGen := lfGen+1; lfState[6] := lfGen mod 30000;
   lfState[7] := pop; lfState[9] := changed; lfState[16] := sig mod 30011;
   elapsed := Timer-started; if elapsed>30000 then elapsed := 30000;
   if elapsed<0 then elapsed := 0;
   lfState[10] := elapsed;
   if changed=0 then lfState[4] := 0;
   lfState[12] := 0; LFDraw; lfNextTime := Timer+LFDelay
end;
procedure LFKey(ch : char);
begin
   lfState[15] := ord(ch);
   case ch of
      ' ': begin lfState[4] := 1-lfState[4]; lfNextTime := Timer+LFDelay end;
      'l','L': begin lfState[4] := 0; LFAdvance end;
      'u','U': LFClear;
      'v','V': LFRandom;
      '1','2','3','4': LFLoad(ord(ch)-ord('0'));
      '+','=': begin if lfState[5]<2 then lfState[5] := lfState[5]+1; lfNextTime := Timer+LFDelay end;
      '-': begin if lfState[5]>0 then lfState[5] := lfState[5]-1; lfNextTime := Timer+LFDelay end;
      chr(27): lfState[4] := 0;
      otherwise
   end;
   LFDraw; lfState[24] := (lfState[24]+1) mod 30000
end;
procedure LFClick;
var pt : Point;
    r,c,p,b : integer;
begin
   SetPort(myWindow); GetMouse(pt);
   if (pt.h>=12) and (pt.h<524) and (pt.v>=32) and (pt.v<224) then begin
      lfState[4] := 0; c := (pt.h-12) div 8+1; r := (pt.v-32) div 6+1;
      p := r*66+c; lfBoard[p] := chr(1-ord(lfBoard[p]));
      lfState[13] := (lfState[13]+1) mod 30000; lfState[14] := (r-1)*64+c;
      lfState[8] := 6; lfLeft[r] := c; lfRight[r] := c; LFRecount; LFDraw
   end
   else if (pt.h>=540) and (pt.h<693) and (pt.v>=28) and (pt.v<274) then begin
      b := (pt.v-28) div 28+1;
      if ((pt.v-28) mod 28)<22 then case b of
         1: LFKey(' '); 2: LFKey('l'); 3: LFKey('u'); 4: LFKey('v');
         5: begin lfState[5] := (lfState[5]+1) mod 3; lfNextTime := Timer+LFDelay; LFDraw end;
         6,7,8,9: LFKey(chr(ord('1')+b-6));
         otherwise
      end
   end
end;
procedure LFInit;
var i : integer;
begin
   for i := 1 to 24 do lfState[i] := 0;
   lfState[1] := 24670; lfState[2] := 1; lfState[5] := 1; lfState[11] := 2461;
   lfState[17] := ord(@lfBoard)-ord(@lfState);
   lfState[18] := ord(@lfNew)-ord(@lfState);
   lfState[19] := ord(@lfRow)-ord(@lfState); lfState[20] := 246;
   lfBitmap.baseAddr := QDPtr(@lfRow); lfBitmap.rowBytes := 64;
   SetRect(lfBitmap.bounds,0,0,512,6);
   LFClear; LFPatternCells(1); lfState[8] := 1; LFRecount; lfNextTime := Timer+LFDelay
end;
procedure LFTick;
begin
   if (myWindow=nil) or (activeFolder<>myWindow) then exit(LFTick);
   if (lfState[2]<>0) and (lfState[4]=1) and (Timer>=lfNextTime) then LFAdvance
end;
