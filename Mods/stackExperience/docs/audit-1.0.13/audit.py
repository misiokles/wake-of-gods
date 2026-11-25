from pathlib import Path
import csv,json5,collections,json
A=Path('/mnt/data/audit13'); M=A/'wake-of-gods/Mods'; S=Path('/mnt/data/VCMI_1.8_Headless_Test_Environment/restored/source/vcmi-develop')
load=lambda p:json5.loads(p.read_text(encoding='utf-8-sig'))
ids={}; levels={}
for p in (S/'config/creatures').glob('*.json'):
 for k,v in load(p).items():
  if 'index' in v:ids[k]=v['index'];levels[k]=v.get('level',0)
ms=load(M/'mapSupport/mod.json'); ids.update(ms['settings']['mapFormat']['inTheWakeOfGods']['creatures']) if 'settings' in ms and 'mapFormat' in ms['settings'] else None
for folder in ['creatures','level8Units','messengersAndEmissaries']:
 for p in (M/folder/'content/config/creatures').glob('*.json'):
  try:
   for k,v in load(p).items():
    if isinstance(v,dict) and 'level' in v:levels[k]=v['level']
  except Exception:pass
print('ids',len(ids), 'bloodDragon',ids.get('bloodDragon'))
rows=collections.defaultdict(list)
for n,l in enumerate((A/'original/crexpbon.txt').read_text(encoding='cp1252').splitlines()[1:],2):
 c=l.split('\t');
 try:
  idx=int(c[0]); vs=[int(float(x.strip())) for x in c[4:14]]
  if len(vs)==10:rows[idx].append((n,c[1],c[2],vs,c[14] if len(c)>14 else ''))
 except (ValueError,IndexError):pass
files=list((M/'stackExperience/Content/config').glob('*CreaturesStackExp.json'))+[M/'level8Units/content/config/level8CreaturesStackExp.json',*(M/'messengersAndEmissaries/content/config/creatures/stackExperience').glob('*.json')]
statmap={'A':('PRIMARY_SKILL','attack'),'D':('PRIMARY_SKILL','defence'),'M':('CREATURE_DAMAGE','damageMax'),'m':('CREATURE_DAMAGE','damageMin'),'S':('STACKS_SPEED',None),'H':('STACK_HEALTH',None),'O':('SHOTS',None),'P':('CASTS',None),'R':('ADDITIONAL_RETALIATION',None),'e':('DOUBLE_DAMAGE_CHANCE',None)}
rev={v:k for k,v in ids.items()}
flagmap={'F':('FLYING',None),'R':('BLOCKS_RETALIATION',None),'B':('TWO_HEX_ATTACK_BREATH',None),'E':('NO_MELEE_PENALTY',None),'f':('FEARFUL',None)}
# For non-stat codes, matching vectors are candidates, not proof of semantic parity.
report=[]; detail=[]; counts=collections.Counter(); wrong=[]
for p in files:
 for key,v in load(p).items():
  k=key.split(':')[-1]; idx=ids.get(k); lv=levels.get(k); bonuses=v.get('stackExperience',[])
  if isinstance(bonuses,dict):bonuses=list(bonuses.values())
  vv=[]
  for b in bonuses:
   ar=b.get('values',[]);bt=b.get('bonus',{});vv.append((ar,bt))
   if len(ar)!=10:wrong.append((key,bt.get('type'),len(ar)))
  entries=list(rows.get(idx,[])) if idx is not None else []
  explicit_count=len(entries)
  # Tier defaults, VCMI tier as proxy (8 -> 7); global H. Explicit code overrides default by type.
  explicit_types={e[1] for e in entries}
  if lv and lv>0:
   entries += [e for e in rows.get(-min(lv,7),[]) if e[1] not in explicit_types]
   entries += [e for e in rows.get(-8,[]) if e[1] not in explicit_types]
  inherited_count=len(entries)-explicit_count
  # inherited defaults are compared separately from explicit rows (level 8 shares level 7 defaults in WoG).
  status=collections.Counter()
  for line,typ,mod,vals,desc in entries:
   exact=[b for ar,b in vv if ar==vals and not all(x==0 for x in vals)]
   sem=[]
   if mod=='+' and typ in statmap or typ=='e':
    t,sub=statmap[typ];sem=[b for ar,b in vv if ar==vals and b.get('type')==t and (sub is None or b.get('subtype')==sub)]
   # Explicit source conversion of hatred values: x10, signed over 200.
   if typ=='h' and mod.startswith('#'):
    target=rev.get(int(mod[1:]),''); exp=[-10*(x-200) if x>200 else 10*x for x in vals]
    sem=[b for ar,b in vv if ar==exp and b.get('type')=='HATE' and str(b.get('subtype','')).split(':')[-1]==target]
   if typ=='f' and mod in flagmap:
    t,sub=flagmap[mod];exp=[x==1 for x in vals];sem=[b for ar,b in vv if ar==exp and b.get('type')==t and (sub is None or b.get('subtype')==sub) and (mod!='f' or b.get('val')==0)]
   if typ=='w' and mod=='0':sem=[b for ar,b in vv if ar==[x==1 for x in vals] and b.get('type')=='RECEPTIVE']
   if typ=='F' and mod=='=':sem=[b for ar,b in vv if ar==[10 if x==1 else 0 for x in vals] and str(b.get('subtype','')).endswith('stackExperienceFear')]
   if typ=='H' and mod=='%':sem=[b for ar,b in vv if ar==vals and b.get('type')=='STACK_HEALTH' and b.get('valueType') in ('PERCENT_TO_ALL','PERCENT_TO_BASE')]
   if sem:flag='ZGODNA_TABELA_I_TYP' 
   elif not any(vals):flag='ZEROWY_WPIS'
   elif exact:flag='KANDYDAT_WEKTOR'
   else:flag='ROZNICA_LUB_TRANSFORMACJA'
   status[flag]+=1;counts[flag]+=1
   detail.append([key,idx,line,'jawny' if line>30 else 'domyslny_poziom_VCMI',typ,mod,','.join(map(str,vals)),flag,desc,'; '.join(str(b.get('type'))+':'+str(b.get('subtype',b.get('stacking',''))) for b in exact)])
  report.append([key,idx if idx is not None else '',lv if lv else '',p.name,len(bonuses),explicit_count,inherited_count,status['ZGODNA_TABELA_I_TYP'],status['KANDYDAT_WEKTOR'],status['ROZNICA_LUB_TRANSFORMACJA'],status['ZEROWY_WPIS']])
for name,header,data in [('audyt_jednostki.csv',['jednostka','ID_WoG','poziom_VCMI','plik','liczba_bonusow','jawne_wiersze_WoG','domyslne_wiersze_wg_poziomu_VCMI','zgodna_tabela_i_typ','kandydat_wektor','roznica_lub_transformacja','zerowy_wpis'],report),('audyt_wiersze.csv',['jednostka','ID_WoG','linia_TXT','pochodzenie','kod','modyfikator','R1-R10','status','komentarz_WoG','kandydaci_JSON'],detail)]:
 with (A/name).open('w',encoding='utf-8-sig',newline='') as f:w=csv.writer(f,delimiter=';');w.writerow(header);w.writerows(data)
summary={'definitions':len(report),'mapped':sum(x[1]!='' for x in report),'rank_arrays':sum(x[4] for x in report),'explicit_rows':sum(x[5] for x in report),'inherited_rows':sum(x[6] for x in report),'total_rows':len(detail),'statuses':dict(counts),'bad_arrays':wrong,'unmapped':[x[0] for x in report if x[1]=='']}
(A/'audit-summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2));print(summary)
