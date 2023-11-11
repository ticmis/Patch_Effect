%% Data initialization
load('../Configuration.mat');
num=alp1*alp2;

load('Data_Potential.mat');
load('Data_Capacity.mat');

%% KPFM Simulation

C_tot=zeros(num,num);
for i=1:num
    for j=1:num
        for m=1:num
            for n=1:num
                C_tot(i,j)=C_tot(i,j)+C{i,j}(m,n);
            end
        end
    end
end

V_k=zeros(num,num);
for i=1:num
    for j=1:num
        for m=1:num
            for n=1:num
                V_k(i,j)=V_k(i,j)+C{i,j}(m,n)*V_s(m,n);
            end
        end
        V_k(i,j)=V_k(i,j)/C_tot(i,j);
    end
end

save('Data_KPotential','V_k');