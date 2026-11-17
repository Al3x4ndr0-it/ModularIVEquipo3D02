%% verificacion_termica.m
% Genera verificacion_termica.png sin toolboxes adicionales.
clear; clc; close all
V.figura=[1000 650]; V.dpi=300; V.fuente='Arial'; V.ejes=13; V.titulo=17;
V.grosor=2.2; V.color=[0.20 0.40 0.85]; V.archivo='verificacion_termica.png';
Rp=420e-6; rho_s=1100; Cp_s=1800; k_s=0.20; h=300; T0=25; Tinf=170;
Lc=Rp/3; Bi=h*Lc/k_s; tauT=rho_s*Cp_s*Rp/(3*h);
t=linspace(0,10,500); T=Tinf-(Tinf-T0).*exp(-t/tauT);
fig=figure('Color','w','Position',[80 80 V.figura]); ax=axes(fig); hold(ax,'on');
a=plot(ax,t,T,'Color',V.color,'LineWidth',V.grosor);
b=yline(ax,Tinf,'--k','Temperatura del medio','LineWidth',1.4);
xlabel(ax,'Tiempo (s)'); ylabel(ax,'Temperatura media de la partícula (°C)');
title(ax,sprintf('Verificación térmica: Bi = %.3f, \\tau_T = %.2f s',Bi,tauT));
legend(ax,[a b],{'Temperatura media','Temperatura del medio'},'Location','eastoutside');
set(ax,'FontName',V.fuente,'FontSize',V.ejes,'LineWidth',1); ax.Title.FontSize=V.titulo;
grid(ax,'on'); box(ax,'on'); exportgraphics(fig,V.archivo,'Resolution',V.dpi);
fprintf('Bi = %.4f\ntau_T = %.4f s\n',Bi,tauT);
if Bi>=0.1, fprintf('Bi >= 0.1: el modelo concentrado es una aproximación preliminar.\n'); end
