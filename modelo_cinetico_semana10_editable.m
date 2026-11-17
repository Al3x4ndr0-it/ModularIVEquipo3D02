%% modelo_cinetico_semana10.m
% Salidas individuales: cinetica_R101.png y cinetica_R102.png
clear; clc; close all
%% CONFIGURACION VISUAL EDITABLE
V.figura=[1100 700]; V.dpi=300; V.fuente='Arial'; V.ejes=13; V.titulo=17;
V.linea=2.2; V.ref=1.5; V.estiloRef='--'; V.grid=true; V.box=true;
V.leyenda='eastoutside'; V.limY=[0 1.05]; V.t1=[0 120]; V.t2=[0 180];
V.titulo1='R-101: solución cinética'; V.titulo2='R-102: solución cinética';
V.archivo1='cinetica_R101.png'; V.archivo2='cinetica_R102.png';
V.c1=[.20 .40 .85;.85 0 .55;.10 .60 .62;.55 .40 .72];
V.c2=[.20 .40 .85;.85 0 .55;.10 .60 .62;.55 .40 .72;.10 .60 .10;.20 .55 .80];
%% R-101
k1=[.07675284 .06829077 .01263065];
f1=@(~,y)[-k1(1)*y(1);k1(1)*y(1)-k1(2)*y(2);k1(2)*y(2)-k1(3)*y(3);k1(3)*y(3)];
[t1,y1]=ode15s(f1,V.t1,[1 0 0 0],odeset('RelTol',1e-8,'AbsTol',1e-10,'NonNegative',1:4));
F1=figure('Color','w','Position',[80 80 V.figura]); ax=axes(F1); hold(ax,'on');
n1={'Xilano','Xilosa','Furfural','Degradados'}; h1=gobjects(1,4);
for j=1:4, h1(j)=plot(ax,t1,y1(:,j),'Color',V.c1(j,:),'LineWidth',V.linea); end
hr=xline(ax,60,V.estiloRef,'60 min','Color','k','LineWidth',V.ref,'LabelVerticalAlignment','bottom');
xlim(ax,V.t1); ylim(ax,V.limY); xlabel(ax,'Tiempo (min)'); ylabel(ax,'Fracción molar normalizada'); title(ax,V.titulo1);
legend(ax,[h1 hr],[n1 {'Residencia nominal'}],'Location',V.leyenda); formato(ax,V);
exportgraphics(F1,V.archivo1,'Resolution',V.dpi);
%% R-102
k2=[.04346692 .05172644 .00878792 .13307176 .00782117 .00055429];
f2=@(~,y)[-k2(1)*y(1);k2(1)*y(1)-(k2(2)+k2(3))*y(2);k2(2)*y(2)-(k2(4)+k2(5))*y(3);k2(4)*y(3)-k2(6)*y(4);k2(3)*y(2)+k2(5)*y(3);k2(6)*y(4)];
[t2,y2]=ode15s(f2,V.t2,[1 0 0 0 0 0],odeset('RelTol',1e-8,'AbsTol',1e-10,'NonNegative',1:6));
F2=figure('Color','w','Position',[100 100 V.figura]); ax=axes(F2); hold(ax,'on');
n2={'Almidón','Glucosa','5-HMF','Ácido levulínico','Huminas','Degradación de LA'}; h2=gobjects(1,6);
for j=1:6, h2(j)=plot(ax,t2,y2(:,j),'Color',V.c2(j,:),'LineWidth',V.linea); end
hr=xline(ax,90,V.estiloRef,'90 min','Color','k','LineWidth',V.ref,'LabelVerticalAlignment','bottom');
xlim(ax,V.t2); ylim(ax,V.limY); xlabel(ax,'Tiempo (min)'); ylabel(ax,'Fracción molar normalizada'); title(ax,V.titulo2);
legend(ax,[h2 hr],[n2 {'Residencia nominal'}],'Location',V.leyenda); formato(ax,V);
exportgraphics(F2,V.archivo2,'Resolution',V.dpi);
function formato(ax,V)
set(ax,'FontName',V.fuente,'FontSize',V.ejes,'LineWidth',1); ax.Title.FontSize=V.titulo;
if V.grid, grid(ax,'on'); else, grid(ax,'off'); end
if V.box, box(ax,'on'); else, box(ax,'off'); end
end
