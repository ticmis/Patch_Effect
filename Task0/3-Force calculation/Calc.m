%% 参数调整区：
load('../Configuration.mat');
h1;                      % 板-板距离
l_sam=lamb*alp1;         % 样品边长

%% 计算：

W1=Func(h1,0,0,0);


dis=h1*0.1;

% Force on z-axis
W2=Func(h1,0,0,dis);
F_z=(W2-W1)/dis;

dis=l_sam*0.1;

% Force on x-axis
W2=Func(h1,dis,0,0);
F_x=(W2-W1)/dis;

% Force on y-axis
W2=Func(h1,0,dis,0);
F_y=(W2-W1)/dis;

fprintf("F_z=%gN\nF_x=%gN\nF_y=%gN\n",F_z,F_x,F_y);