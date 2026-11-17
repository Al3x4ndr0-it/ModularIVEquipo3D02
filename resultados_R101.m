%% resultados_R101.m
% Genera una sola imagen: resultados_R101.png
% Modelo de líneas esférico simplificado para R-101.
clear; clc; close all
figPos = [80 60 1450 800];
Rp=420e-6; Nr=51; D=5.83e-10; k1=0.07675284/60; k2=0.06829077/60; k3=0.01263065/60;
r=linspace(0,Rp,Nr)'; dr=r(2)-r(1); tspan=linspace(0,120*60,361);
H0=zeros(Nr,1); H0(end)=1;
y0=[H0; ones(Nr,1); zeros(Nr,1); zeros(Nr,1); zeros(Nr,1)];
opt=odeset('RelTol',1e-7,'AbsTol',1e-9,'NonNegative',1:numel(y0));
[t,Y]=ode15s(@rhs,tspan,y0,opt,Nr,dr,r,D,k1,k2,k3);
i60=find(t>=3600,1); H=Y(:,1:Nr); Xn=Y(:,Nr+(1:Nr)); F=Y(:,3*Nr+(1:Nr));
w=r.^2; Xavg=trapz(r,Xn.*w',2)/trapz(r,w); conv=1-Xavg;
rateAvg=3/Rp^3*trapz(r,(k1.*H.*Xn).*w',2);
rateIdeal=k1.*max(Xavg,eps); eta=min(rateAvg./rateIdeal,1);

fig=figure('Color','w','Position',figPos); tl=tiledlayout(fig,2,2,'TileSpacing','compact','Padding','compact');
ax=nexttile; plot(r*1e6,H(i60,:),'LineWidth',1.7); grid on; title('(a) Penetración de ácido a 60 min'); xlabel('Radio (\mum)'); ylabel('c_H/c_{H,b}');
ax=nexttile; plot(r*1e6,Xn(i60,:),'LineWidth',1.7); hold on; plot(r*1e6,F(i60,:),'LineWidth',1.7); grid on; title('(b) Perfiles de especies a 60 min'); xlabel('Radio (\mum)'); ylabel('Concentración normalizada'); legend({'Xilano','Furfural'},'Location','eastoutside');
ax=nexttile; plot(t/60,conv,'LineWidth',1.7); xline(60,'--k'); grid on; title('(c) Conversión promedio de xilano'); xlabel('Tiempo (min)'); ylabel('Conversión');
ax=nexttile; plot(t/60,eta,'LineWidth',1.7); yline(0.95,'--k'); ylim([0.9 1.01]); grid on; title('(d) Factor de efectividad'); xlabel('Tiempo (min)'); ylabel('\eta'); legend({'\eta','Criterio \eta=0.95'},'Location','eastoutside');
exportgraphics(fig,'resultados_R101.png','Resolution',300);

function dy=rhs(~,y,N,dr,r,D,k1,k2,k3)
H=y(1:N); Xn=y(N+(1:N)); Xy=y(2*N+(1:N)); F=y(3*N+(1:N)); Deg=y(4*N+(1:N));
L=zeros(N,1); L(1)=6*(H(2)-H(1))/dr^2;
for j=2:N-1, L(j)=(H(j+1)-2*H(j)+H(j-1))/dr^2+2/r(j)*(H(j+1)-H(j-1))/(2*dr); end
L(N)=0; dH=D*L; dH(N)=0; H(N)=1;
r1=k1.*H.*Xn; r2=k2.*H.*Xy; r3=k3.*H.*F;
dy=[dH;-r1;r1-r2;r2-r3;r3];
end
