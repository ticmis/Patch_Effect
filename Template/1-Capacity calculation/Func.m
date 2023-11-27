%% 1-Capacity calculation
%  Func.m（函鼠）会执行以下操作：
%  1. 创建一个l_sam长，l_sam宽，h3高的样品板
%  2. 创建一个半径为r_t的球形探针
%  3. 在样品板上有num*num个微分面元
%  4. 会优化Mesh分布，在探针处和高电势处增加大量Mesh，在其余空间缩减Mesh
%  5. 计算探针位于(i_t,j_t)，高电势位于(i_s,j_s)情况下的样品-探针电容

%% 参数调整区：
% function c=Func(i_t,j_t,i_s,j_s,H2)
load('../Configuration.mat');   %调用参数

% lamb=0.2;
% alp1=int32(10);
% alp2=int32(10);
% bet=1;
% h3=0.1;     % 板高
   
% h2=H2;        % 样品与探针距离

i_t=1;      % 探针位于坐标为(i_t,j_t)方格中心正上方
j_t=1;
i_s=1;      % 坐标为(i_s,j_s)方格的电势为100V
j_s=1;

%% 参数转译：
l_sam=lamb*alp1;         % 样品边长
l_s=lamb/alp2;           % 微分面元边长
num=alp1*alp2;           % 一侧边上面元个数
r_t=lamb*bet/2;          % 探针半径
l_air=1.5*l_sam;         % 空气域边长
h_air=1.5*(h3+h2+r_t);   % 空气域高
z_air=h_air/2-1.5*h3;    % 空气域z坐标(center)

%% 代码区：

import com.comsol.model.*
import com.comsol.model.util.*

model=ModelUtil.create('Model');

model.component.create('comp1', true);
model.component('comp1').geom.create('geom1', 3);
model.component('comp1').geom('geom1').lengthUnit([native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']);

% Build the probe:
sph1=model.component('comp1').geom('geom1').create('sph1', 'Sphere');
sph1.set('r', r_t);
sph1.set('pos', [(i_t-0.5)*l_s (j_t-0.5)*l_s h2]);

%Build the sample
blk1=model.component('comp1').geom('geom1').create('blk1', 'Block');
blk1.set('size', [l_sam l_sam h3]);
blk1.set('pos', [0 0 -h3]);

%Create material
mat=model.component('comp1').material.create('mat1', 'Common');
mat.label('mat1');
mat.propertyGroup('def').set('resistivity', {'0'});
mat.propertyGroup('def').set('relpermittivity', {'1'});

%Build polygons
Build_polygons(model);
%Time-consuming!!!!!!!

%Build air domain
blk2=model.component('comp1').geom('geom1').create('blk2', 'Block');
blk2.set('size', [l_air l_air h_air]);
blk2.set('pos', [l_sam/2 l_sam/2 z_air]);
blk2.set('base', 'center');
model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').set('keepsubtract', true);
model.component('comp1').geom('geom1').feature('dif1').set('intbnd', false);
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'blk2'});

inp={'blk1' 'sph1'};
for i=1:alp1*alp1*alp2*alp2
    inp{end+1}=char("pol"+(i-1));
end
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set(inp);

model.component('comp1').geom('geom1').run;


%Build mesh
Build_mesh(model,l_s,num,r_t,i_t,j_t,i_s,j_s,h2);
% model.component('comp1').mesh.create('mesh1');
% model.component('comp1').mesh('mesh1').autoMeshSize(5);  %5-Normal
model.component('comp1').mesh('mesh1').run;


model.component('comp1').physics.create('es', 'Electrostatics', 'geom1');
model.component('comp1').physics('es').create('gnd1', 'Ground', 2);
model.component('comp1').physics('es').feature('gnd1').selection.all;
model.component('comp1').physics('es').create('pot1', 'ElectricPotential', 2);
range=[(i_s-1)*l_s-eps,(j_s-1)*l_s-eps,-eps;i_s*l_s+eps,j_s*l_s+eps,+eps];
coord=mphselectcoords(model,'geom1',range','boundary');
model.component('comp1').physics('es').feature('pot1').selection.set([coord]);
model.component('comp1').physics('es').feature('pot1').set('V0', 100);
    
model.component('comp1').cpl.create('intop1', 'Integration');
model.component('comp1').cpl('intop1').set('axisym', true);
model.component('comp1').cpl('intop1').selection.geom('geom1', 2);
range=[
    (i_t-1+0.5)*l_s-r_t-eps,(j_t-1+0.5)*l_s-r_t-eps,h2-r_t-eps;
    (i_t-1+0.5)*l_s+r_t+eps,(j_t-1+0.5)*l_s+r_t+eps,h2+r_t+eps
    ];
inp=mphselectbox(model,'geom1',range','boundary');
model.component('comp1').cpl('intop1').selection.set(inp);

model.component('comp1').variable.create('var1');
model.component('comp1').variable('var1').set('Q_t', 'intop1(es.nD)');

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').setSolveFor('/physics/es', true);

model.sol.create('sol1');
model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', 'auto');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', 'auto');

model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'cg');
model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('prefun', 'amg');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('coarseningmethod', 'classic');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

% Build_plots(model,i_t,j_t,h1);
model.sol('sol1').runAll;
% model.result('pg1').run;
% model.result('pg2').run;

model.result.numerical.create('gev1', 'EvalGlobal');
model.result.numerical('gev1').setIndex('expr', 'Q_t', 0);
result=model.result.numerical('gev1').getReal();
c=-result/100;

fprintf("Probe(%d,%d) Sample(%d,%d) Height=%g Capacity=%g\n",i_t,j_t,i_s,j_s,h2,c);
mphsave('Model','Func');