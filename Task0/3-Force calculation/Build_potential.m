function Build_potential(model)

%% Data Section:
load('../Configuration.mat');
l_s=lamb/double(alp2);        % 微分面元边长
l_sam=lamb*alp1;              % 样品边长
num=alp1*alp2;                % 一维上有num个面元
load('Data_KPotential.mat');  % 获取电势值
eps=1e-5;

%% Code Section:
es=model.component('comp1').physics('es');
for i=0:num-1
    for j=0:num-1
        cur=i*num+j;
        x=double(i)*l_s-0.5*l_sam; xx=x+l_s;
        y=double(j)*l_s-0.5*l_sam; yy=y+l_s;

        pot=es.create("pot"+cur, 'ElectricPotential', 2);
        range=[x-eps,y-eps,-0.5*h1-eps;xx+eps,yy+eps,-0.5*h1+eps];
        coord=mphselectcoords(model,'geom1',range','boundary');
        pot.selection.set([coord]);
        pot.set('V0', V_k(i+1,j+1));

        pot=es.create("pot"+(num*num+cur), 'ElectricPotential', 2);
        range=[x-eps,y-eps,+0.5*h1-eps;xx+eps,yy+eps,+0.5*h1+eps];
        coord=mphselectcoords(model,'geom1',range','boundary');
        pot.selection.set([coord]);
        pot.set('V0', V_k(i+1,j+1));
    end
end