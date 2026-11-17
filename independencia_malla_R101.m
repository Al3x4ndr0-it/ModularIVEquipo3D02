%% independencia_malla_R101.m
% Genera Malla.png sin toolboxes adicionales.
clear; clc; close all
V.figura=[1100 680]; V.dpi=300; V.fuente='Arial'; V.ejes=13; V.titulo=17;
V.grosor=2.2; V.marcador=7; V.archivo='Malla.png';
Rp=420e-6; D_H=5.83e-10; k1=.07675284/60; k2=.06829077/60; k3=.01263065/60;
tFinal=60*60; Nodos=[26 51 101 201]; conversion=zeros(size(Nodos));
for i=1:numel(Nodos)
 N=Nodos(i); r=linspace(0,Rp,N)'; dr=r(2)-r(1);
 H0=zeros(N,1); H0(end)=1; y0=[H0;ones(N,1);zeros(3*N,1)];
 op=odeset('RelTol',1e-8,'AbsTol',1e-10,'NonNegative',1:numel(y0));
 [~,Y]=ode15s(@(~,y) rhs(y,N,dr,r,D_H,k1,k2,k3),[0 tFinal],y0,op);
 Xn=Y(end,N+(1:N))'; peso=r.^2; Xprom=trapz(r,Xn.*peso)/trapz(r,peso);
 conversion(i)=1-Xprom;
end
errorPct=abs((conversion-conversion(end))/conversion(end))*100;
disp(table(Nodos',conversion',errorPct','VariableNames',{'Nodos','Conversion60min','Error_pct'}));
fig=figure('Color','w','Position',[80 80 V.figura]); ax=axes(fig);
yyaxis(ax,'left'); a=plot(ax,Nodos,conversion,'-o','LineWidth',V.grosor,'MarkerSize',V.marcador); ylabel(ax,'Conversión de xilano a 60 min');
yyaxis(ax,'right'); b=plot(ax,Nodos,errorPct,'-s','LineWidth',V.grosor,'MarkerSize',V.marcador); ylabel(ax,'Error respecto a 201 nodos (%)');
xlabel(ax,'Número de nodos radiales, N_r'); title(ax,'Estudio de independencia de malla');
legend(ax,[a b],{'Conversión','Error relativo'},'Location','eastoutside');
set(ax,'FontName',V.fuente,'FontSize',V.ejes,'LineWidth',1); ax.Title.FontSize=V.titulo;
grid(ax,'on'); box(ax,'on'); exportgraphics(fig,V.archivo,'Resolution',V.dpi);
function dy=rhs(y,N,dr,r,D,k1,k2,k3)
H=y(1:N); Xn=y(N+(1:N)); Xy=y(2*N+(1:N)); F=y(3*N+(1:N));
lap=zeros(N,1); lap(1)=6*(H(2)-H(1))/dr^2;
for j=2:N-1, lap(j)=(H(j+1)-2*H(j)+H(j-1))/dr^2+2/r(j)*(H(j+1)-H(j-1))/(2*dr); end
dH=D*lap; dH(N)=0; H(N)=1; r1=k1.*H.*Xn; r2=k2.*H.*Xy; r3=k3.*H.*F;
dy=[dH;-r1;r1-r2;r2-r3;r3];
end
