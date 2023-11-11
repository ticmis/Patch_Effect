function [t1,t2,t3,t4]=transform_id(num,i1,i2,i3,i4,D1,D2,D3,D4)
    t1=get_id(num,i1(1,1),i1(1,2),D1(1,1),D1(1,2));
    t2=get_id(num,i2(1,1),i2(1,2),D2(1,1),D2(1,2));
    t3=get_id(num,i3(1,1),i3(1,2),D3(1,1),D3(1,2));
    t4=get_id(num,i4(1,1),i4(1,2),D4(1,1),D4(1,2));
end