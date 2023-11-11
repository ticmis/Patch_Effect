function w=Find_weight(x,y,poly,V)
    lx=size(x,1); ly=size(x,2);
    w=zeros(lx,ly);
    tot=size(poly,2);
    for i=1:lx
        for j=1:ly
            for k=1:tot
                if inpolygon(x(i,j),y(i,j),poly{k}(:,1),poly{k}(:,2))
                    w(i,j)=V(k);
                end
            end
        end
    end
end