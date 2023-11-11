load('Configuration.mat');
num=alp1*alp2;

load('Data_Potential.mat');
load('Data_KPotential.mat');

x=linspace(0,num,num); y=x';

subplot(121);
surf(x,y,V_s);

subplot(122);
surf(x,y,V_k);