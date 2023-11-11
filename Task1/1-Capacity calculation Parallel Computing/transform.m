function [r1,r2,r3,r4]=transform(num,i,j)
r1=zeros(1,2);
[r1(1,1),r1(1,2)]=rev1(num,i,j);
r2=zeros(1,2);
[r2(1,1),r2(1,2)]=rev2(num,i,j);
r3=zeros(1,2);
[r3(1,1),r3(1,2)]=rev3(num,i,j);
r4=zeros(1,2);
[r4(1,1),r4(1,2)]=rev4(num,i,j);
end