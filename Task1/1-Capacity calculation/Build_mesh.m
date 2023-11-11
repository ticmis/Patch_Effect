function Build_mesh(model,l_s,num,r_t,i_t,j_t,i_s,j_s,h2)

eps=1e-4;

model.component('comp1').mesh.create('mesh1');
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 6);

%% Free triangulars on the tip
ftri=model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
range=[
    (i_t-1+0.5)*l_s-r_t-eps,(j_t-1+0.5)*l_s-r_t-eps,h2-r_t-eps;
    (i_t-1+0.5)*l_s+r_t+eps,(j_t-1+0.5)*l_s+r_t+eps,h2+r_t+eps
    ];
inp=mphselectbox(model,'geom1',range','boundary');
ftri.selection.set(inp);
ftri.create('size1', 'Size');
ftri.feature('size1').set('hauto', 1);
ftri.feature('size1').set('custom', true);
ftri.feature('size1').set('hminactive', true);
ftri.feature('size1').set('hmaxactive', true);
ftri.feature('size1').set('hgradactive', true);
ftri.feature('size1').set('hcurveactive', true);
ftri.feature('size1').set('hnarrowactive', true);
ftri.feature('size1').set('hmax', r_t*r_t/1);

%% Free triangulars

flag=zeros(num,num);

%Extremely fine
ftri=model.component('comp1').mesh('mesh1').create('ftri2', 'FreeTri');
inp=[];
ext=2;
for i=-ext:ext
    for j=-ext:ext
        x=i_s+i; y=j_s+j;
        if x>=1&&x<=num&&y>=1&&y<=num&&flag(x,y)==0
            flag(x,y)=1;
            range=[(x-1)*l_s-eps,(y-1)*l_s-eps,-eps;x*l_s+eps,y*l_s+eps,+eps];
            coord=mphselectbox(model,'geom1',range','boundary');
            inp(end+1)=coord;
        end
        x=i_t+i; y=j_t+j;
        if x>=1&&x<=num&&y>=1&&y<=num&&flag(x,y)==0
            flag(x,y)=1;
            range=[(x-1)*l_s-eps,(y-1)*l_s-eps,-eps;x*l_s+eps,y*l_s+eps,+eps];
            coord=mphselectbox(model,'geom1',range','boundary');
            inp(end+1)=coord;
        end
    end
end
ftri.selection.set(inp);
ftri.create('size1', 'Size');
ftri.feature('size1').set('hauto', 1);
ftri.feature('size1').set('custom', true);
ftri.feature('size1').set('hminactive', true);
ftri.feature('size1').set('hmaxactive', true);
ftri.feature('size1').set('hgradactive', true);
ftri.feature('size1').set('hcurveactive', true);
ftri.feature('size1').set('hnarrowactive', true);
ftri.feature('size1').set('hmax', l_s/10);

%Finer
ftri=model.component('comp1').mesh('mesh1').create('ftri3', 'FreeTri');
inp=[];
ext=3;
for i=-ext:ext
    for j=-ext:ext
        x=i_s+i; y=j_s+j;
        if x>=1&&x<=num&&y>=1&&y<=num&&flag(x,y)==0
            flag(x,y)=1;
            range=[(x-1)*l_s-eps,(y-1)*l_s-eps,-eps;x*l_s+eps,y*l_s+eps,+eps];
            coord=mphselectbox(model,'geom1',range','boundary');
            inp(end+1)=coord;
        end
        x=i_t+i; y=j_t+j;
        if x>=1&&x<=num&&y>=1&&y<=num&&flag(x,y)==0
            flag(x,y)=1;
            range=[(x-1)*l_s-eps,(y-1)*l_s-eps,-eps;x*l_s+eps,y*l_s+eps,+eps];
            coord=mphselectbox(model,'geom1',range','boundary');
            inp(end+1)=coord;
        end
    end
end
ftri.selection.set(inp);
ftri.create('size1', 'Size');
ftri.feature('size1').set('hauto', 1);
ftri.feature('size1').set('custom', true);
ftri.feature('size1').set('hminactive', true);
ftri.feature('size1').set('hmaxactive', true);
ftri.feature('size1').set('hgradactive', true);
ftri.feature('size1').set('hcurveactive', true);
ftri.feature('size1').set('hnarrowactive', true);
ftri.feature('size1').set('hmax', l_s/4);

model.component('comp1').mesh('mesh1').create('ftet1', 'FreeTet');

end