function Build_polygons(model)

%% Data Section:
load('../Configuration.mat');
l_s=lamb/double(alp2);     % 微分面元边长
l_sam=lamb*alp1;           % 样品边长
num=alp1*alp2;             % 一维上有num个面元


%% Code Section:
geom=model.component('comp1').geom('geom1');
for i=0:num-1
    for j=0:num-1
        x=double(i)*l_s-0.5*l_sam; xx=x+l_s;
        y=double(j)*l_s-0.5*l_sam; yy=y+l_s;
        cur=i*num+j;
        poly=geom.create("pol"+cur,'Polygon');
        poly.set('source', 'table');
        poly.set('type', 'closed');
        for k=0:3
            poly.setIndex('table',-0.5*h1,k,2);
        end
        poly.setIndex('table',round(x,5),0,0);
        poly.setIndex('table',round(y,5),0,1);
        poly.setIndex('table',round(xx,5),1,0);
        poly.setIndex('table',round(y,5),1,1);
        poly.setIndex('table',round(xx,5),2,0);
        poly.setIndex('table',round(yy,5),2,1);
        poly.setIndex('table',round(x,5),3,0);
        poly.setIndex('table',round(yy,5),3,1);
    end
end

for i=0:num-1
    for j=0:num-1
        x=double(i)*l_s-0.5*l_sam; xx=x+l_s;
        y=double(j)*l_s-0.5*l_sam; yy=y+l_s;
        cur=num*num+i*num+j;
        poly=geom.create("pol"+cur,'Polygon');
        poly.set('source', 'table');
        poly.set('type', 'closed');
        for k=0:3
            poly.setIndex('table',+0.5*h1,k,2);
        end
        poly.setIndex('table',round(x,5),0,0);
        poly.setIndex('table',round(y,5),0,1);
        poly.setIndex('table',round(xx,5),1,0);
        poly.setIndex('table',round(y,5),1,1);
        poly.setIndex('table',round(xx,5),2,0);
        poly.setIndex('table',round(yy,5),2,1);
        poly.setIndex('table',round(x,5),3,0);
        poly.setIndex('table',round(yy,5),3,1);
    end
end
