%% 3-Force Calculation
%  Func.m（函鼠）会执行以下操作：
%  1. 创建两个l_sam长，l_sam宽，h3高的样品板，两板表面间距为h1
%  2. 在两板表面各创建微分面元，并在面元内赋电势值
%  3. 计算空气域的静电能

%% 参数调整区：
function W_e=Func(h1,dx,dy,dz)
load('../Configuration.mat');   % 调用参数


% lamb=0.2;
% alp1=int32(10);
% alp2=int32(10);
% h3=0.1;         % 板高
   
% h1=0.4;           % 板-板距离
% dx=0;             % x轴方向偏移
% dy=0;             % y轴方向偏移
% dz=0;             % z轴方向偏移

%% 参数转译：
l_sam=lamb*alp1;         % 样品边长
l_s=lamb/alp2;           % 微分面元边长
num=alp1*alp2;           % 一侧边上面元个数
l_air=1.5*l_sam;         % 空气域边长
h_air=1.5*(h3+2*h1);     % 空气域高
z_air=h_air/2-1.5*h3;    % 空气域z坐标(center)

%% 代码区：

import com.comsol.model.*
import com.comsol.model.util.*

% if model_name=='Model0' model_name='Model1';
% else model_name='Model0'; end
% model = ModelUtil.create(model_name);
model=ModelUtil.create('Model');

model.component.create('comp1', true);
model.component('comp1').geom.create('geom1', 3);
model.component('comp1').geom('geom1').lengthUnit([native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']);

%Build the sample
blk1=model.component('comp1').geom('geom1').create('blk1', 'Block');
blk1.set('size', [l_sam l_sam h3]);
blk1.set('pos', [0 0 -0.5*(h3+h1)]);
blk1.set('base', 'center');

blk2=model.component('comp1').geom('geom1').create('blk2', 'Block');
blk2.set('size', [l_sam l_sam h3]);
blk2.set('pos', [0+dx 0+dy +0.5*(h3+h1)+dz]);
blk2.set('base', 'center');

%Create material
mat=model.component('comp1').material.create('mat1', 'Common');
mat.label('mat1');
mat.propertyGroup('def').set('resistivity', {'0'});
mat.propertyGroup('def').set('relpermittivity', {'1'});

%Build polygons
Build_polygons(model);
%Time-consuming!!!!!!!

%Build air domain
blk3=model.component('comp1').geom('geom1').create('blk3', 'Block');
blk3.set('size', [l_air l_air h_air]);
blk3.set('pos', [0 0 0]);
blk3.set('base', 'center');
model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').set('keepsubtract', true);
model.component('comp1').geom('geom1').feature('dif1').set('intbnd', false);
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'blk3'});

inp={'blk1' 'blk2'};
for i=1:2*alp1*alp1*alp2*alp2
    inp{end+1}=char("pol"+(i-1));
end
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set(inp);

model.component('comp1').geom('geom1').create('uni1', 'Union');
inp={'blk1' 'blk2' 'dif1'};
for i=1:2*alp1*alp1*alp2*alp2
    inp{end+1}=char("pol"+(i-1));
end
model.component('comp1').geom('geom1').feature('uni1').selection('input').set(inp);

model.component('comp1').geom('geom1').run;

%Build integration and variable
model.component('comp1').cpl.create('intop1', 'Integration');
model.component('comp1').cpl('intop1').set('axisym', true);
model.component('comp1').cpl('intop1').selection.set([1]);
var1=model.component('comp1').variable.create('var1');
var1.set('W_e', 'epsilon0_const/2*intop1(es.Ex^2+es.Ey^2+es.Ez^2)');


%Build mesh
Build_mesh(model,l_s,l_sam,num,h1);
% model.component('comp1').mesh.create('mesh1');
% model.component('comp1').mesh('mesh1').autoMeshSize(5);  %5-Normal
model.component('comp1').mesh('mesh1').run;

%Build Electrostatics
model.component('comp1').physics.create('es', 'Electrostatics', 'geom1');
model.component('comp1').physics('es').create('gnd1', 'Ground', 2);
model.component('comp1').physics('es').feature('gnd1').selection.all;
Build_potential(model);
    
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

model.sol('sol1').runAll;

model.result.numerical.create('gev1', 'EvalGlobal');
model.result.numerical('gev1').setIndex('expr', 'W_e', 0);
W_e=model.result.numerical('gev1').getReal();

fprintf("Displacement(%g,%g,%g) Electrostatic energe=%g\n",dx,dy,dz,W_e);

% fprintf("Name of the current model: %s\n",model_name);