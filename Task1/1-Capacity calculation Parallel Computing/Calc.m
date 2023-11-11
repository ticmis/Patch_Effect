%% Calc.m 在原本的基础上进行了并行运算改进！
% parpool; parpool(4);
% matlab启动Parallel pool; 启动4个Workers
% delete(gcp('nocreate'));
% matlab结束Parellel pool
% system( ['D:\Comsol\COMSOL61\Multiphysics\bin\win64\comsolmphserver.exe -multi on -np 1 -port ' num2str(comsolPort) '&'] );
% 作用：在Port上启动comsolmphserver，并且在disconnect后保持服务器开启
% gcp('nocreate').NumWorkers;
% 在主程序中，获取WorkerID
% labit=getCurrentTask().ID;
% 在函数中，获取WorkerID
% mphstart(labit);
% 作用：连接端口为labit的服务器
% ModelUtil.disconnect;
% 作用：与服务器断开连接

%% Parallel computing:
parpool(32);
Pnum=gcp('nocreate').NumWorkers;  % Pnum为当前Parallel pool中的Worker数
% for i=1:Pnum
%     comsolPort=i+27;
%     system( ['D:\Comsol\COMSOL61\Multiphysics\bin\win64\comsolmphserver.exe -multi on -np 1 -port ' num2str(comsolPort) '&'] );
%     pause(6)
% end

%% Parameter section:
load('../Configuration.mat');
num=alp1*alp2;   % 样品板一侧上的面元数
h2;              % 板-球距离
dh=h2*0.1;       % 偏差值

load('Data_Capacity.mat');

%% Data initialization

% c1=zeros(1,num*num*num*num);
% c2=zeros(1,num*num*num*num);
% tag1=zeros(1,num*num*num*num);
% tag2=zeros(1,num*num*num*num);
% C=cell(num,num);
% clearvars -except c1 c2 tag1 tag2 C num;
% save('Data_Capacity.mat','c1','c2','tag1','tag2','C');

%% Preparation~
% T=zeros(4,num*num*num*num);
% for id=1:num*num*num*num
%     [i,j,m,n]=get_coor(num,id);                 % 当前探针(i,j)，高电势(m,n)
%     [i1,i2,i3,i4]=transform(num,i,j);           % 探针坐标的四种变形
%     [D1,D2,D3,D4]=transform(num,m,n);           % 高电势坐标的四种变形
%     [t1,t2,t3,t4]=transform_id(num,i1,i2,i3,i4,D1,D2,D3,D4);
%                                                 % 获取四种变形对应的id
%     T(1,id)=t1; T(2,id)=t2; T(3,id)=t3; T(4,id)=t4;
% end

%% Calculation!

parfor id=1:num*num*num*num
    [i,j,m,n]=get_coor(num,id);                 % 当前探针(i,j)，高电势(m,n)
    if tag1(id)==0
        c1(id)=Func_mph(double(i),double(j),double(m),double(n),double(h2));
        tag1(id)=1;
    end
    if tag2(id)==0
        c2(id)=Func_mph(double(i),double(j),double(m),double(n),double(h2+dh));
        tag2(id)=1;
    end
end

delete(gcp('nocreate'));

clearvars -except c1 c2 tag1 tag2 C
save('Data_Capacity.mat','c1','c2','tag1','tag2','C');

%% Debug Area:

% function [px,py]=poly(x,y)
% px=[x-1,x,x,x-1];
% py=[y-1,y-1,y,y];
% end