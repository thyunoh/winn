/* safeRpt 체크 묶음(DEF/USE 시드) ↔ 원본 dfm 체크박스 캡션 대조 (2026-09-02) */
const fs=require('fs'),path=require('path'),L=require('./dfm_labels.js');
const idx=new Map(fs.readFileSync(path.join(__dirname,'dfm_index.tsv'),'utf8').split(/\r?\n/).filter(Boolean).map(l=>l.split('\t')));
function tuples(body){ const out=[]; let i=0,depth=0,q=false,cur='',row=null;
  for(;i<body.length;i++){ const ch=body[i];
    if(q){ if(ch==="'"){ if(body[i+1]==="'"){cur+="'";i++;} else q=false; } else cur+=ch; continue; }
    if(ch==="'"){ q=true; continue; }
    if(ch==='('){ if(depth===0){row=[];cur='';} depth++; continue; }
    if(ch===')'){ depth--; if(depth===0&&row){ row.push(cur.trim()); out.push(row); row=null; cur=''; } continue; }
    if(ch===','&&depth===1){ row.push(cur.trim()); cur=''; continue; }
    if(depth>=1) cur+=ch; }
  return out; }
const DEF={}, USE={};
['../../sql/qps/ddl','../../sql/qps/seed'].forEach(d=>fs.readdirSync(path.join(__dirname,d)).filter(f=>/\.sql$/i.test(f)).sort().forEach(f=>{
  const s=fs.readFileSync(path.join(__dirname,d,f),'utf8').replace(/--[^\n]*/g,''); let m;
  const re=/INSERT INTO TBL_QPS_SAFERPT_DEF\s*\([^)]*\)\s*VALUES([\s\S]*?)(?:ON DUPLICATE[\s\S]*?)?;/gi;
  while((m=re.exec(s))) tuples(m[1]).forEach(v=>{ if(v.length<8) return; const [gb,grp,gnm,item,multi,etc]=v; ((DEF[gb]=DEF[gb]||{})[grp]=DEF[gb][grp]||{nm:gnm,items:[],multi}).items.push(item); });
  const ru=/INSERT INTO TBL_QPS_SAFERPT_USE\s*\([^)]*\)\s*VALUES([\s\S]*?)(?:ON DUPLICATE[\s\S]*?)?;/gi;
  while((m=ru.exec(s))) tuples(m[1]).forEach(v=>{ (USE[v[0]]=USE[v[0]]||[]).push(v[1]); });
}));
const norm=s=>String(s).toLowerCase().replace(/[\s()（）·.,:/\-]/g,'');
const rows=fs.readFileSync(path.join(__dirname,'compare_rpt.tsv'),'utf8').split(/\r?\n/).slice(1).filter(Boolean).map(l=>l.split('\t'));
const report=[];
const OVERRIDE={SELFDIS:"Employee_Chart_027",MRAGREE:"HEALTH_Chart_013",MRPROXY:"HEALTH_Chart_001",MDDISP:"Employee_Chart_033",MDAS:"Employee_Chart_034"};
function variants(unit){ const base=unit.replace(/(_[A-Z]|_d+(_[A-Zd]+)*)$/,""); return [...idx.keys()].filter(u=>u===base||u.startsWith(base+"_")); }
rows.forEach(r=>{ const id=r[0]; let unit=OVERRIDE[id]||r[3]; if(!USE[id]) return;
  // 변형 폼 중 우리 항목과 가장 겹치는 판을 고른다
  const oursAll=[]; USE[id].forEach(g=>{ const d=(DEF[id]&&DEF[id][g])||(DEF["*"]&&DEF["*"][g]); if(d) d.items.forEach(it=>oursAll.push(norm(it))); }); const oursSet=new Set(oursAll);
  let best=null; variants(unit).forEach(u=>{ try{ const o2=L.extract(idx.get(u)); const caps=o2.filter(x=>/TcxCheckBox/.test(x.cls)&&x.props.Caption).map(x=>norm(x.props.Caption)); const hit=caps.filter(c=>oursSet.has(c)).length; if(!best||hit>best.hit) best={u,hit}; }catch(e){} });
  if(best&&best.hit>0) unit=best.u;
  const p=idx.get(unit); if(!p) return;
  const o=L.extract(p); const cbs=o.filter(x=>/TcxCheckBox/.test(x.cls)&&typeof x.props.Top==='number'&&x.props.Caption&&!/Check ALL|사진사이즈/i.test(x.props.Caption));
  const labs=o.filter(x=>/TLabel|TcxLabel/.test(x.cls)&&x.props.Caption&&typeof x.props.Top==='number');
  const og={}; cbs.forEach(c=>{ const hint=String(c.props.Hint||'').trim(); const near=labs.filter(l=>Math.abs(l.props.Top-c.props.Top)<=28&&l.props.Left<c.props.Left).sort((a,b)=>(c.props.Left-a.props.Left)-(c.props.Left-b.props.Left))[0]; const key=hint||(near?near.props.Caption.trim():'?'); (og[key]=og[key]||[]).push(c.props.Caption.trim()); });
  const ours=[]; USE[id].forEach(g=>{ const d=(DEF[id]&&DEF[id][g])||(DEF['*']&&DEF['*'][g]); if(d) d.items.forEach(it=>ours.push(it)); });
  const oursN=new Set(ours.map(norm)); const origItems=[].concat(...Object.values(og)); const origN=new Set(origItems.map(norm));
  const missing=[...new Set(origItems.filter(it=>!oursN.has(norm(it))&&norm(it).length>1))], extra=[...new Set(ours.filter(it=>!origN.has(norm(it))))];
  report.push({id,nm:r[1],unit,og,origItems:origItems.length,ours:ours.length,missing,extra});
});
module.exports=report;
if(require.main===module){
  console.log('DEF 있는 유형',report.length,'· 원본과 항목 전부 일치',report.filter(x=>!x.missing.length).length);
  report.sort((a,b)=>b.missing.length-a.missing.length).forEach(x=>{ if(!x.missing.length){ console.log('✅ '+x.id+' '+x.nm+' — 원본 '+x.origItems+' · 우리 '+x.ours+(x.extra.length?' · 우리에만 '+x.extra.length:'')); return; }
    console.log('## '+x.id+' '+x.nm+' ['+x.unit+'] 원본 항목 '+x.origItems+' · 우리 '+x.ours); console.log('   원본에만: '+x.missing.slice(0,30).join(' | ')); if(x.extra.length) console.log('   우리에만: '+x.extra.slice(0,20).join(' | ')); });
}
