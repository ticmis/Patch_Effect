function id=get_id(num,i,j,m,n)
    num=int64(num);
    i=int64(i);
    j=int64(j);
    m=int64(m);
    n=int64(n);
    id=(i-1)*num*num*num+(j-1)*num*num+(m-1)*num+n;
end