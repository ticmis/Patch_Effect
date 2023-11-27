function Build_polygons(model)

%% Data Section:
load('../Configuration.mat');
l_s=lamb/double(alp2);     % 微分面元边长
num=alp1*alp2;     % 一维上有num个面元

%% Code Section:
geom=model.component('comp1').geom('geom1');
for i=0:num-1
    for j=0:num-1
        cur=i*num+j;
        poly=geom.create("pol"+cur,'Polygon');
        poly.set('source', 'table');
        poly.set('type', 'closed');
        for k=0:3
            poly.setIndex('table',0,k,2);
        end
        x=double(i)*l_s; xx=x+l_s;
        y=double(j)*l_s; yy=y+l_s;
        poly.setIndex('table',x,0,0);
        poly.setIndex('table',y,0,1);
        poly.setIndex('table',xx,1,0);
        poly.setIndex('table',y,1,1);
        poly.setIndex('table',xx,2,0);
        poly.setIndex('table',yy,2,1);
        poly.setIndex('table',x,3,0);
        poly.setIndex('table',yy,3,1);
    end
end
