function [coord,inv]=Coordinates(model)

coord=zeros(20,20);
inv=cell(400);

for i=0:19
    for j=0:19
        range=[i-1e-3,j-1e-3,-1e-3;i+1+1e-3,j+1+1e-3,1e-3];
        id=mphselectcoords(model,'geom1',range','boundary');
        coord(i+1,j+1)=id;
        inv{id+1}=[i j];
    end
end

end