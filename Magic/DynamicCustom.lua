--DynamicCustomCard
local d={nm='Custom Card',ty='Creature',tx='Draw two cards.',pt='0/0',lt='0'}
local I=setmetatable({input_function='input_func',function_owner=self,alignment=1,scale={0.5,0.5,0.5},label='Gold',validation=1,
  position={0,0.25,-1.3},width=1710,height=125,font_size=90},{__call=function(i,p,w,h,l,x)
      i.position[3]=p or i.position[3]
      i.width,i.height,i.label,i.value=w,h,'i_'..l,d[l]
      i.input_function=i.label
      self.setVar(i.label,function(o,c,v,s)onSave(l,v,s)end)
      if x then i.position[1],i.alignment=x,3 end
      self.createInput(i)
      if x then i.position[1],i.alignment=0,1 end
    end})
function onSave(k,v,sE)
  if v and not sE then
    d[k]=v:gsub('"','`')
    if k=='nm'then self.setName(d[k])
    elseif k=='tx'then self.setDescription(d[k])end
  elseif sE then return self.script_state end
  self.script_state=JSON.encode(d)end
function onLoad(D)
  if D~=''then d=JSON.decode(D)end
  self.addContextMenuItem('Finilize Card',setStatic)
  I(-0.85,1710,125,'img')
  I(-1.29,1710,125,'nm')
  I( 0.28,1710,125,'ty')
  I( 0.82,1715,810,'tx')
  if d.ty:find('Planeswalker')then I(1.3,300,125,'lt',-0.75)end
  if d.ty:find('Creature')or d.ty:find('Vehicle')then I(1.3,300,125,'pt',0.75)end end

function setStatic()
  local s=[[--StaticCustomCard
local B=setmetatable({click_function='N',function_owner=self,width=0,height=0,position={0,0.25,-1.3},scale={0.3,1,0.3},font_size=150},{__call=function(b,p,l)b.label,b.position[3]=l,p;self.createButton(b)end})
function onLoad(D)if D~=''then d=JSON.decode(D)B(-1.29,d.nm)B(0.28,d.ty)B(0.82,d.tx)%send end]]
  local m=''
  if d.lt then m=m..'B.position[1]=-0.75;B(1.3,d.lt)'end
  if d.pt then m=m..'B.position[1]=0.75;B(1.3,d.pt)'end
  self.setLuaScript(s:format(m))
  local sT={json=self.getJSON(),position=self.getPosition()}
  for k,v in pairs(sT.position)do sT.position[k]=v+1 end
  if d.img then for _,s in pairs({'.jpg','.png','.webm','.mp4'})do
    if d.img:find(s)then sT.json:gsub('"FrontURL": "[^"]+"','"FrontURL": "'..d.image..'"')
      self.setDescription((d.tx or '')..'\n|'..(d.lt or '| |')..(d.pt or '|\n')..(d.img or ''))
      break end end end
  sT.json:gsub('"Nickname": "[^"]+"',string.format('"Nickname": "%s\n%s"',d.nm,d.ty))
  spawnObjectJSON(sT)
end