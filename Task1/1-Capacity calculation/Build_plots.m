function Build_plots(model,i_t,j_t,h1)

model.result.dataset.create('surf1', 'Surface');
inp=[];
for i=1:20
    for j=1:20
            range=[i-1-1e-3,j-1-1e-3,-1e-3;i+1e-3,j+1e-3,1e-3];
            coord=mphselectcoords(model,'geom1',range','boundary');
            inp(end+1)=coord;
    end
end
model.result.dataset('surf1').selection.set(inp);
model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').label('Electric Field Norm on sample');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', 'es.normE');
model.result('pg1').feature('surf1').set('descr', 'Electric field norm');
model.result('pg1').set('data', 'surf1');


model.result.dataset.create('surf2', 'Surface');
range=[
    0.5+(i_t-1)*1-0.1-1e-3,0.5+(j_t-1)*1-0.1-1e-3,h1-1e-3;
    0.5+(i_t-1)*1+0.1+1e-3,0.5+(j_t-1)*1+0.1+1e-3,h1+0.1+1e-3
    ];
inp=mphselectbox(model,'geom1',range','boundary');
model.result.dataset('surf2').selection.set(inp);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').label('Electric Field Norm on tip');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', 'es.normE');
model.result('pg2').feature('surf1').set('descr', 'Electric field norm');
model.result('pg2').set('data', 'surf2');

end