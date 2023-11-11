function [i,j,m,n]=get_coor(num,id)
    num=int64(num); id=int64(id-1);
    n=mod(id,num)+1; id=idivide(id,num);
    m=mod(id,num)+1; id=idivide(id,num);
    j=mod(id,num)+1; id=idivide(id,num);
    i=mod(id,num)+1; id=idivide(id,num);
end