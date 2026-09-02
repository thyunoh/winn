/* 서식별 시드 항목(items.tsv) ↔ dfm 글자 대조 (2026-09-02, v3)
   ★이름 후보(최대 10)를 전부 항목 대조해 보고 **일치 수가 가장 많은 dfm** 을 고른다 — 같은 제목의 변형 폼이 많아 이름만으로는 엇갈린다. */
const fs = require('fs'), L = require('./dfm_labels.js');
const DIR = __dirname;
const norm = s => String(s || '').replace(/[\s　·ㆍ.,:;/\-_~()（）\[\]【】「」'"`!?※★☆■□▶▷○●]/g, '').toLowerCase();
function bigrams(s){const a=[];for(let i=0;i<s.length-1;i++)a.push(s.slice(i,i+2));return a;}
function dice(a,b){const A=bigrams(a),B=bigrams(b);if(!A.length||!B.length)return a===b?1:0;const m=new Map();A.forEach(x=>m.set(x,(m.get(x)||0)+1));let h=0;B.forEach(x=>{const c=m.get(x);if(c){h++;m.set(x,c-1);}});return 2*h/(A.length+B.length);}
const GENERIC = /^(년도?|연도|월|일|시간?|날짜|구분|항목|점검항목|점검내용|내용|비고|확인|점검자|담당자?|서명|결재|승인|검토|작성자?|작성|병동|부서|성명|이름|합계|계|번호|no|순번|o|x|v|○|×|△|\d{1,2}|\d{1,2}일|\d{1,2}월|[1-9]월~\d{1,2}월|월일|년월일|년\s*월\s*일|일자|기타|상태|결과|조치사항?|조치|특이사항|의견|저장|인쇄|닫기|출력|삭제|추가|조회|이전|다음|전월|복사|전체|선택)$/i;
const TIME=/^\d{1,2}\s*:\s*\d{2}(\s*[~\-–]\s*\d{1,2}\s*:\s*\d{2})?$|^\d{1,2}시(\s*[~\-–]\s*\d{1,2}\s*시)?$/;
const dfmIdx = new Map(fs.readFileSync(DIR+'/dfm_index.tsv','utf8').split(/\r?\n/).filter(Boolean).map(l=>l.split('\t')));
const matches = new Map(fs.readFileSync(DIR+'/matches.tsv','utf8').split(/\r?\n/).slice(1).filter(Boolean).map(l=>{const c=l.split('\t');return [c[0],{id:c[0],nm:c[1],axis:c[2],score:c[4],unit:c[5],unitNm:c[6],dfm:c[7],others:c[8]||''}];}));
const unitNames = new Map(fs.readFileSync(DIR+'/t_unit.tsv','utf8').split(/\r?\n/).filter(Boolean).map(l=>{const c=l.split('\t');return [c[0],c[2]];}));
const items = {}; fs.readFileSync(DIR+'/items.tsv','utf8').split(/\r?\n/).filter(Boolean).forEach(l=>{const [id,sort,nm,grp,gb,unit]=l.split('\t');(items[id]=items[id]||[]).push({sort,nm,grp,gb,unit});});
const forms = fs.readFileSync(DIR+'/forms.tsv','utf8').split(/\r?\n/).filter(Boolean).map(l=>l.split('\t'));
const cache = new Map();
function texts(dfm){ if(!cache.has(dfm)){ try{ const objs=L.extract(dfm); const labs=L.labels(objs).concat(L.inputTexts(objs), L.pasStrings(dfm)).map(x=>x.text).filter(t=>t.length>=2 && !GENERIC.test(t.trim())); const inp=L.inputs(objs); cache.set(dfm,{labN:[...new Set(labs.map(norm).filter(Boolean))], cb:inp.filter(x=>/CheckBox|RadioButton/.test(x.cls)).length, te:inp.filter(x=>/TextEdit|Memo|MaskEdit|Edit$/.test(x.cls)).length, im:inp.filter(x=>/Image/.test(x.cls)).length}); }catch(e){ cache.set(dfm,null); } } return cache.get(dfm); }
function evalUnit(seedNames, dfm){
  const T=texts(dfm); if(!T) return null;
  let miss=[], hit=0; const labN=T.labN;
  seedNames.forEach(sn=>{ const n=norm(sn); if(!n) return; let best=0, bl=''; labN.forEach(l=>{ let s=dice(n,l); if(l===n) s=1; else if(l.indexOf(n)>=0||n.indexOf(l)>=0) s=Math.max(s,0.9); if(s>best){best=s;bl=l;} }); if(best>=0.75) hit++; else miss.push(sn+(bl?' ≈'+bl+'('+best.toFixed(2)+')':'')); });
  const seedN=seedNames.map(norm); let extra=[];
  labN.forEach(l=>{ if(l.length<3) return; let best=0; seedN.forEach(n=>{ let s=dice(n,l); if(l===n) s=1; else if(l.indexOf(n)>=0||n.indexOf(l)>=0) s=Math.max(s,0.9); if(s>best) best=s; }); if(best<0.75) extra.push(l); });
  return {hit, miss, extra, dfmLabels:labN.length, cb:T.cb, te:T.te, im:T.im};
}
const rows=[], detail=[];
forms.forEach(c=>{
  const id=c[0], m=matches.get(id); if(!m||!m.unit){ rows.push({id,nm:c[1],note:'dfm 없음'}); return; }
  const its=items[id]||[];
  const rawNames=[...new Set(its.map(x=>x.nm).concat(its.map(x=>x.grp)).filter(t=>t && t.length>=2 && !/^null$/i.test(t.trim()) && !GENERIC.test(t.trim())))];
  const timeItems=rawNames.filter(t=>TIME.test(t.trim())).length, seedNames=rawNames.filter(t=>!TIME.test(t.trim()));
  const gb={}; its.forEach(x=>gb[x.gb||'?']=(gb[x.gb||'?']||0)+1);
  // 후보 = 1순위 + OTHERS
  const cands=[{unit:m.unit,score:Number(m.score)||0}].concat((m.others||'').split(/\s+/).filter(Boolean).map(s=>{const mm=s.match(/^(.+)\((\d+\.\d+)\)$/);return mm?{unit:mm[1],score:Number(mm[2])}:null;}).filter(Boolean));
  let best=null;
  cands.forEach(cd=>{ const dfm=dfmIdx.get(cd.unit); if(!dfm) return; const r=evalUnit(seedNames,dfm); if(!r) return; const key=[r.hit, cd.score]; if(!best || key[0]>best.key[0] || (key[0]===best.key[0] && key[1]>best.key[1])) best={key,cd,r,dfm}; });
  if(!best){ rows.push({id,nm:c[1],note:'dfm 읽기 실패'}); return; }
  const r={id,nm:c[1],axis:m.axis,unit:best.cd.unit,unitNm:unitNames.get(best.cd.unit)||'',others:cands.filter(x=>x.unit!==best.cd.unit).slice(0,5).map(x=>x.unit+'('+x.score.toFixed(2)+')').join(' '),score:best.cd.score.toFixed(2),nameFirst:m.unit,seed:seedNames.length,timeItems,hit:best.r.hit,miss:best.r.miss.length,extra:best.r.extra.length,dfmLabels:best.r.dfmLabels,cb:best.r.cb,te:best.r.te,im:best.r.im,gb:JSON.stringify(gb)};
  rows.push(r); detail.push(Object.assign({}, r, {missList:best.r.miss, extraList:best.r.extra.slice(0,40)}));   // 객체 전개는 Eclipse JS 검사기가 오탐한다
});
fs.writeFileSync(DIR+'/compare.tsv','FORM_ID\tFORM_NM\tAXIS\tUNIT\tSCORE\t이름1순위\t시드항목\t시간칸\t일치\t시드에만\tdfm에만\tdfm글자\tdfm체크\tdfm글자칸\tdfm이미지\t시드INPUT_GB\n'+rows.map(r=>[r.id,r.nm,r.axis||'',r.unit||'',r.score||'',r.nameFirst||'',r.seed??'',r.timeItems??'',r.hit??'',r.miss??'',r.extra??'',r.dfmLabels??'',r.cb??'',r.te??'',r.im??'',r.gb||r.note||''].join('\t')).join('\n'));
fs.writeFileSync(DIR+'/compare_detail.json',JSON.stringify(detail,null,1));
const ok=rows.filter(r=>r.seed!=null);
console.log('대조 서식', ok.length, '· 전부 확인', ok.filter(r=>r.miss===0).length, '· 일부 불일치', ok.filter(r=>r.miss>0).length, '· 이름1순위와 다른 dfm 을 고른 서식', ok.filter(r=>r.unit!==r.nameFirst).length);
console.log('시드 항목', ok.reduce((a,r)=>a+r.seed,0), '· 일치', ok.reduce((a,r)=>a+r.hit,0), '· 시드에만', ok.reduce((a,r)=>a+r.miss,0), '· 시간칸(대조 밖)', ok.reduce((a,r)=>a+r.timeItems,0));
