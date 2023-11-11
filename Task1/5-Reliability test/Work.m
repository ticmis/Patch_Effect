%% Work.m(工作鼠)将会执行n次下列操作，并评估KPFM测量Patch效应静电力方法的可靠性
%  1.利用Voronoi Diagram得到电势理论值TPotential
%  2.计算理论值的力TForce
%  3.计算KPFM电势测量值KPotential
%  4.计算测量值的力KForce.

%  注1：使用前把Data_Capacity.mat存在3-KPFM simulation，
%            把Configuration.mat存在根目录。

%% 参数区：
load('../Configuration.mat');   %调用参数
alp1;
alp2;
num=alp1*alp2;        % 一边上微分面元个数
qwq=10;                % 测试总次数
clearvars -except num qwq

%% 变量区：
TForce=zeros(qwq,3);  % 理论值对应的力
KForce=zeros(qwq,3);  % 测量值对应的力
Error=zeros(qwq,3);   % 测量值与理论值的误差

%% 代码区：

for TaT=1:qwq
    fprintf("Current loop:%d\n",TaT);
    
    % 运行Voronoi diagram，获得电势理论值TPotential
    run('2-Voronoi diagram/Work.m');
    V=load("2-Voronoi diagram/Data_TPotential.mat").V;
    V_t=V;

    % 计算理论值TPotential对应的力
    save("4-Force calculation/Data_Potential.mat","V");
    run("4-Force calculation/Calc.m");
    tmp=load("4-Force calculation/Data_Force.mat",'F_z','F_x','F_y');
    TForce(TaT,1)=tmp.F_z; TForce(TaT,2)=tmp.F_x; TForce(TaT,3)=tmp.F_y;

    % 计算KPFM测量电势KPotential
    save("3-KPFM simulation/Data_TPotential.mat","V");
    run("3-KPFM simulation/Test.m");
    V=load("3-KPFM simulation/Data_KPotential.mat").V;
    V_k=V;

    % 计算测量值KPotential对应的力
    save("4-Force calculation/Data_Potential.mat","V");
    run("4-Force calculation/Calc.m");
    tmp=load("4-Force calculation/Data_Force.mat",'F_z','F_x','F_y');
    KForce(TaT,1)=tmp.F_z; KForce(TaT,2)=tmp.F_x; KForce(TaT,3)=tmp.F_y;

    clearvars -except TaT qwq num TForce KForce
end

% 计算各次计算的加权误差
for i=1:qwq
    Error(i)=abs(KForce(i)-TForce(i))/abs(TForce(i));
end
for i=2:qwq
    Error(i)=Error(i-1)+Error(i);
end
for i=1:qwq
    Error(i)=Error(i)/i;
end
clearvars -except qwq num TForce KForce Error
save("Data_Test.mat","TForce","KForce","Error");

%% 可靠性分析
Rel=abs(Error(qwq,1));
plot(abs(Error(:,1)),'linewidth',2)
line([1,qwq],[Rel,Rel],'linewidth',1,'color','red','linestyle','-');
title('Reliability test on z direction');
