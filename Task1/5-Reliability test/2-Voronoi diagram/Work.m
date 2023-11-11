%% Work.m （工作鼠） 将会执行以下操作：
%  1. 在l_sam*l_sam上生成tot个Voronoi nuclei，
%     并在各个Voronoi polygons内随机赋值
%  2. 在l_sam*l_sam上生成num*num个微分面元
%  3. 多边形运算，每个微分面元的值为对应Voronoi digram中的加权平均值

%% 参数调整区:
load('../Configuration.mat');
% lamb=0.2;
% alp1=2;
% alp2=10;
% mu=0;
% sig2=1;
% clearvars -except lamb alp1 alp2 mu sig2


%% 参数转译：

tot=alp1*alp1;    % Voronoi Nuclei数
num=alp1*alp2;    % 样品板一条边上微分面元个数
l_sam=lamb*alp1;  % 样品板边长
l_s=lamb/alp2;    % 微分面元尺度

%% 代码区: 

% 调用polybnd_voronoi
pos=l_sam*rand(tot,2);	% generate random pointss
bnd = [0 0; l_sam 0; l_sam l_sam; 0 l_sam;0 0];    % square boundaries
[vornb,vorvx] = polybnd_voronoi(pos,bnd);

% Val数组随机变量服从方差为sig2，平均值为mu的正态分布
Val=sqrt(sig2)*randn(1,tot)+mu;

% 绘制Voronoi Diagram
% subplot(121);
% for i=1:tot
%     patch(vorvx{i}(:,1),vorvx{i}(:,2),Val(i),'EdgeColor','b','FaceColor','flat');
% end
% xlim([0,l_sam]); ylim([0,l_sam]);
% colormap cool; colorbar;
% pbaspect([1 1 1]);

% 根据Voronoi，计算样品表面微分面元的理论值
V=zeros(num,num);
for i=1:num
    for j=1:num
        xmin=(i-1)*l_s; xmax=i*l_s; ymin=(j-1)*l_s; ymax=j*l_s;
        region=polyshape([xmin,xmax,xmax,xmin],[ymin,ymin,ymax,ymax]);
        for k=1:tot
            poly=polyshape(vorvx{k}(:,1),vorvx{k}(:,2));
            inte=intersect(region,poly);
            s=area(inte);
            V(i,j)=V(i,j)+s*Val(k);
        end
        V(i,j)=V(i,j)/l_s^2;
    end
end

% 绘制面元的理论值
% subplot(122);
% for i=1:num
%     for j=1:num
%         xmin=(i-1)*l_s; xmax=i*l_s; ymin=(j-1)*l_s; ymax=j*l_s;
%         patch([xmin,xmax,xmax,xmin],[ymin,ymin,ymax,ymax],V(i,j));
%     end
% end
% xlim([0,l_sam]); ylim([0,l_sam]);
% colormap cool; colorbar;
% pbaspect([1 1 1]);

% clearvars -except lamb alp1 alp2 mu sig2 tot num V V_s
save('Data_TPotential.mat','V');
