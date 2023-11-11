%% Func_mph.m (mph函鼠）与Func.m的区别在：
%  Func.m中，Build_polygons耗时约占总程序耗时的一半。然而样品表面的polygons在
%  建立后就不会再被改变，我们希望改变的仅是探针的位置。
%  Func_mph.m用mphload打开一个Func.m创建的mph文件，仅调整若干参数，不会调用
%  Build_polygons，因此效率达到了Func.m的三倍以上，单次模拟耗时约1.4~1.5s

%% 参数调整区：
function c=Func_mph(i_t,j_t,i_s,j_s,H2)
load('../Configuration.mat');   %调用参数

% lamb=0.2;
% alp1=int32(10);
% alp2=int32(10);
% bet=1;
% h3=0.1;     % 板高
   
h2=H2;        % 样品与探针距离

% i_t=1;      % 探针位于坐标为(i_t,j_t)方格中心正上方
% j_t=2;
% i_s=1;      % 坐标为(i_s,j_s)方格的电势为100V
% j_s=1;

%% 参数转译：
l_sam=lamb*alp1;         % 样品边长
l_s=lamb/alp2;           % 微分面元边长
num=alp1*alp2;           % 一侧边上面元个数
r_t=lamb*bet/2;         % 探针半径
l_air=1.5*l_sam;         % 空气域边长
h_air=1.5*(h3+h2+r_t);   % 空气域高
z_air=h_air/2-1.5*h3;    % 空气域z坐标(center)

%% 代码区：

import com.comsol.model.*
import com.comsol.model.util.*

model=mphload('Func.mph');

% Build the probe:

model.component('comp1').geom('geom1').feature('sph1').set('pos', [(i_t-0.5)*l_s (j_t-0.5)*l_s h2]);
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').run;

range=[(i_s-1)*l_s-eps,(j_s-1)*l_s-eps,-eps;i_s*l_s+eps,j_s*l_s+eps,+eps];
coord=mphselectcoords(model,'geom1',range','boundary');
model.component('comp1').physics('es').feature('pot1').selection.set([coord]);

range=[
    (i_t-1+0.5)*l_s-r_t-eps,(j_t-1+0.5)*l_s-r_t-eps,h2-r_t-eps;
    (i_t-1+0.5)*l_s+r_t+eps,(j_t-1+0.5)*l_s+r_t+eps,h2+r_t+eps
    ];
inp=mphselectbox(model,'geom1',range','boundary');
model.component('comp1').cpl('intop1').selection.set(inp);

model.sol('sol1').runAll;

result=model.result.numerical('gev1').getReal();
c=-result/100;

fprintf("Probe(%d,%d) Sample(%d,%d) Height=%g Capacity=%g\n",i_t,j_t,i_s,j_s,h2,c);