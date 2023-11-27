%% Parameter section:
load('../Configuration.mat');
num=alp1*alp2;   % 样品板一侧上的面元数
h2;              % 板-球距离
dh=h2*0.1;       % 偏差值

load('Data_Capacity.mat');

%% Data initialization
% c1=zeros(num,num);
% c2=zeros(num,num);
% tag1=zeros(1,num*num);
% tag2=zeros(1,num*num);
% C=zeros(num,num);
% clearvars -except c1 c2 tag1 tag2 C num h2 dh;
% save('Data_Capacity.mat','c1','c2','tag1','tag2','C');

%% Preparation~
num=int64(num); tot=0;
set_t=zeros((1+num)*num/2,2); set_s=zeros((1+num)*num/2,2);
for i=0:num-1
    for j=0:i
        tot=tot+1;
        x=int64(i); y=int64(j);                   % 样品相对位置:(x,y)
        x_t=(num-(x+1))/2+1; y_t=(num-(y+1))/2+1; % 探针绝对位置
        x_s=x_t+x; y_s=y_t+y;                     % 样品绝对位置
        id_t=(x_t-1)*num+y_t;                     % 探针绝对位置编号
        id_s=(x_s-1)*num+y_s;                     % 样品绝对位置编号
        set_t(tot,1)=x_t; set_t(tot,2)=y_t;
        set_s(tot,1)=x_s; set_s(tot,2)=y_s;
    end
end

%% Calculation!
for id=1:tot
    i=set_t(id,1); j=set_t(id,2); m=set_s(id,1); n=set_s(id,2);
    if tag1(id)==0
        c1(m-i+1,n-j+1)=Func_mph(double(i),double(j),double(m),double(n),double(h2));
        tag1(id)=1;
    end
    if tag2(id)==0
        c2(m-i+1,n-j+1)=Func_mph2(double(i),double(j),double(m),double(n),double(h2+dh));
        tag2(id)=1;
    end
end

for j=1:num
    for i=1:j-1
        c1(i,j)=c1(j,i); c2(i,j)=c2(j,i);
    end
end

for i=1:num
    for j=1:num
        C(i,j)=(c2(i,j)-c1(i,j))/dh;
    end
end

clearvars -except c1 c2 tag1 tag2 C pre T
save('Data_Capacity.mat','c1','c2','tag1','tag2','C');
