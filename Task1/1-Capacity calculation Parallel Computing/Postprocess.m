%% Data section:
load("../Configuration.mat");
num=alp1*alp2;   % 样品板一侧上的面元数
h2;              % 板-球距离
dh=h2*0.1;       % 偏差值

load("Data_Capacity.mat");

%% Function section:
for i=1:num
    for j=1:num
        C{i,j}=zeros(num,num);
    end
end

for id=1:num*num*num*num
    [i,j,m,n]=get_coor(num,id);
    C{i,j}(m,n)=(c2(id)-c1(id))/dh;
end

clearvars -except c1 c2 tag1 tag2 C
save('Data_Capacity.mat','c1','c2','tag1','tag2','C');