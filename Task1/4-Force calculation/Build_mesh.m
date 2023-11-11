function Build_mesh(model,l_s,l_sam,num,h1)

eps=1e-5;

model.component('comp1').mesh.create('mesh1');
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 6);

edg=model.component('comp1').mesh('mesh1').create('edg1', 'Edge');

xmin=-0.5*l_sam-eps; xmax=+0.5*l_sam+eps;
ymin=-0.5*l_sam-eps; ymax=+0.5*l_sam+eps;
range=[xmin,ymin,-0.5*h1-eps;xmax,ymax,-0.5*h1+eps];
coord1=mphselectbox(model,'geom1',range','edge');
range=[xmin,ymin,+0.5*h1-eps;xmax,ymax,+0.5*h1+eps];
coord2=mphselectbox(model,'geom1',range','edge');
edg.selection.set([coord1,coord2]);

edg.create('size1', 'Size');
edg.feature('size1').set('hauto', 1);
edg.feature('size1').set('custom', true);
edg.feature('size1').set('hminactive', true);
edg.feature('size1').set('hmaxactive', true);
edg.feature('size1').set('hgradactive', true);
edg.feature('size1').set('hcurveactive', true);
edg.feature('size1').set('hnarrowactive', true);
edg.feature('size1').set('hmax', l_s/10);

model.component('comp1').mesh('mesh1').create('ftet1', 'FreeTet');