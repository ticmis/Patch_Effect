%% Parameter section:
load('../Configuration.mat');
num=alp1*alp2;   % 样品板一侧上的面元数
h2;              % 板-球距离
dh=h2*0.1;       % 偏差值

load('Data_Capacity.mat');

%% Data initialization

% c1=cell(num,num); c2=cell(num,num);
% tag1=cell(num,num); tag2=cell(num,num);
% C=cell(num,num);
% for i=1:num
%     for j=1:num
%         c1{i,j}=zeros(num,num); c2{i,j}=zeros(num,num);
%         tag1{i,j}=zeros(num,num); tag2{i,j}=zeros(num,num);
%         C{i,j}=zeros(num,num);
%     end
% end
% clearvars -except c1 c2 tag1 tag2 C;
% save('Data_Capacity.mat','c1','c2','tag1','tag2','C');


%% Calculation!

for i=1:num
    for j=1:num
        for m=1:num
            for n=1:num
                [i1,i2,i3,i4]=make_index(num,i,j);
                [D1,D2,D3,D4]=make_index(num,m,n);
                ans=0;
                if tag1{i,j}(m,n)==0
                    if     tag1{i1(1),i1(2)}(D1(1),D1(2))==1
                        ans=c1{i1(1),i1(2)}(D1(1),D1(2));
                    elseif tag1{i2(1),i2(2)}(D2(1),D2(2))==1
                        ans=c1{i2(1),i2(2)}(D2(1),D2(2));
                    elseif tag1{i3(1),i3(2)}(D3(1),D3(2))==1
                        ans=c1{i3(1),i3(2)}(D3(1),D3(2));
                    elseif tag1{i4(1),i4(2)}(D4(1),D4(2))==1
                        ans=c1{i4(1),i4(2)}(D4(1),D4(2));
                    else
                        ans=Func_mph(i,j,m,n,h2);
                    end
                    c1{i,j}(m,n)=ans;
                    tag1{i,j}(m,n)=1;
                end
                ans=0;
                if tag2{i,j}(m,n)==0
                    if     tag2{i1(1),i1(2)}(D1(1),D1(2))==1
                        ans=c2{i1(1),i1(2)}(D1(1),D1(2));
                    elseif tag2{i2(1),i2(2)}(D2(1),D2(2))==1
                        ans=c2{i2(1),i2(2)}(D2(1),D2(2));
                    elseif tag2{i3(1),i3(2)}(D3(1),D3(2))==1
                        ans=c2{i3(1),i3(2)}(D3(1),D3(2));
                    elseif tag2{i4(1),i4(2)}(D4(1),D4(2))==1
                        ans=c2{i4(1),i4(2)}(D4(1),D4(2));
                    else
                        ans=Func_mph(i,j,m,n,h2+dh);
                    end
                    c2{i,j}(m,n)=ans;
                    tag2{i,j}(m,n)=1;
                end
            end
        end
    end
end

for i=1:num
    for j=1:num
        for m=1:num
            for n=1:num
                C{i,j}(m,n)=(c2{i,j}(m,n)-c1{i,j}(m,n))/dh;
            end
        end
    end
end

clearvars -except c1 c2 tag1 tag2 C
% save('Data_Capacity.mat','c1','c2','tag1','tag2','C');

%% Debug Area:
% num=9;
% pos=randi([1,num],25,2);
% 
% for i=1:25
%     x=pos(i,1); y=pos(i,2);
%     [px,py]=coor(x,y);
%     patch(px,py,i);
%     [x,y]=rev3(num,x,y);
%     [px,py]=coor(x,y);
%     patch(px,py,i);
% end
% xlim([0,num]); ylim([0,num]);
% 
% function [a,b]=coor(i,j) % 返回坐标为(i,j)的多边形坐标
% a=[i-1,i,i,i-1]; b=[j-1,j-1,j,j];
% end