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
clearvars -except lamb alp1 alp2 mu sig2


%% 参数转译：

tot=alp1*alp1;    % Voronoi Nuclei数
num=alp1*alp2;    % 样品板一条边上微分面元个数
l_sam=lamb*alp1;  % 样品板边长
l_s=lamb/alp2;    % 微分面元尺度

%% 代码区: 

% Using polybnd_voronoi
pos=l_sam*rand(tot,2);	% generate random pointss
bnd = [0 0; l_sam 0; l_sam l_sam; 0 l_sam;0 0];    % square boundaries
[vornb,vorvx] = polybnd_voronoi(pos,bnd);

% Random values
V=sqrt(sig2)*randn(1,tot)+mu;

subplot(121);
for i=1:tot
    patch(vorvx{i}(:,1),vorvx{i}(:,2),V(i),'EdgeColor','b','FaceColor','flat');
end
xlim([0,l_sam]); ylim([0,l_sam]);
colormap cool; colorbar;
pbaspect([1 1 1]);

% Calculate the value for samples
V_s=zeros(num,num);
for i=1:num
    for j=1:num
        xmin=(i-1)*l_s; xmax=i*l_s; ymin=(j-1)*l_s; ymax=j*l_s;
        region=polyshape([xmin,xmax,xmax,xmin],[ymin,ymin,ymax,ymax]);
        for k=1:tot
            poly=polyshape(vorvx{k}(:,1),vorvx{k}(:,2));
            inte=intersect(region,poly);
            s=area(inte);
            V_s(i,j)=V_s(i,j)+s*V(k);
        end
        V_s(i,j)=V_s(i,j)/l_s^2;
    end
end

subplot(122);
for i=1:num
    for j=1:num
        xmin=(i-1)*l_s; xmax=i*l_s; ymin=(j-1)*l_s; ymax=j*l_s;
        patch([xmin,xmax,xmax,xmin],[ymin,ymin,ymax,ymax],V_s(i,j));
    end
end
xlim([0,l_sam]); ylim([0,l_sam]);
colormap cool; colorbar;
pbaspect([1 1 1]);

clearvars -except lamb alp1 alp2 mu sig2 tot num V V_s

save('Data_Potential.mat','V_s');
