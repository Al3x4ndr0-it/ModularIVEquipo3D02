%% resultados_R102.m
% Genera una sola imagen: resultados_R102.png
clear; clc; close all
figPos=[80 60 1450 800];
Rp=420e-6; Nr=51; D=5.83e-10; r=linspace(0,Rp,Nr)'; dr=r(2)-r(1); tspan=linspace(0,180*60,541);
k=[0.04346692 0.05172644 0.00878792 0.13307176 0.00782117 0.00055429]/60;
H0=zeros(Nr,1); H0(end)=1;
% 7 bloques: H, S, G, HM, LA, U, DL  ->  H0 + S(1) + 5 bloques en cero
y0=[H0; ones(Nr,1); zeros(5*Nr,1)];
opt=odeset('RelTol',1e-7,'AbsTol',1e-9,'NonNegative',1:numel(y0));
[t,Y]=ode15s(@rhs,tspan,y0,opt,Nr,dr,r,D,k);
i90=find(t>=5400,1); H=Y(:,1:Nr); S=Y(:,Nr+(1:Nr)); LA=Y(:,4*Nr+(1:Nr));
w=r.^2; Savg=trapz(r,S.*w',2)/trapz(r,w); conv=1-Savg; rateAvg=3/Rp^3*trapz(r,(k(1).*H.*S).*w',2); rateIdeal=k(1).*max(Savg,eps); eta=min(rateAvg./rateIdeal,1);
fig=figure('Color','w','Position',figPos); tl=tiledlayout(fig,2,2,'TileSpacing','compact','Padding','compact');
nexttile; plot(r*1e6,H(i90,:),'LineWidth',1.7); grid on; title('(a) Penetración de ácido a 90 min'); xlabel('Radio (\mum)'); ylabel('c_H/c_{H,b}');
nexttile; plot(r*1e6,S(i90,:),'LineWidth',1.7); hold on; plot(r*1e6,LA(i90,:),'LineWidth',1.7); grid on; title('(b) Perfiles de especies a 90 min'); xlabel('Radio (\mum)'); ylabel('Concentración normalizada'); legend({'Almidón','Ácido levulínico'},'Location','eastoutside');
nexttile; plot(t/60,conv,'LineWidth',1.7); xline(90,'--k'); grid on; title('(c) Conversión promedio de almidón'); xlabel('Tiempo (min)'); ylabel('Conversión');
nexttile; plot(t/60,eta,'LineWidth',1.7); yline(0.95,'--k'); ylim([0.9 1.01]); grid on; title('(d) Factor de efectividad'); xlabel('Tiempo (min)'); ylabel('\eta'); legend({'\eta','Criterio \eta=0.95'},'Location','eastoutside');
exportgraphics(fig,'resultados_R102.png','Resolution',300);
function dy=rhs(~,y,N,dr,r,D,k)
H=y(1:N); S=y(N+(1:N)); G=y(2*N+(1:N)); HM=y(3*N+(1:N)); LA=y(4*N+(1:N)); U=y(5*N+(1:N)); DL=y(6*N+(1:N));
L=zeros(N,1); L(1)=6*(H(2)-H(1))/dr^2;
for j=2:N-1, L(j)=(H(j+1)-2*H(j)+H(j-1))/dr^2+2/r(j)*(H(j+1)-H(j-1))/(2*dr); end
L(N)=0; dH=D*L; dH(N)=0; H(N)=1;
r4=k(1)*H.*S; r5=k(2)*H.*G; r7=k(3)*H.*G; r6=k(4)*H.*HM; r8=k(5)*H.*HM; r9=k(6)*H.*LA;
dy=[dH;-r4;r4-r5-r7;r5-r6-r8;r6-r9;r7+r8;r9];
end