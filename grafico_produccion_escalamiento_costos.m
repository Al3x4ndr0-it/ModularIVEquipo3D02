%% grafico_produccion_escalamiento_costos.m
% Genera una sola imagen con dos paneles identificados:
%   (a) Producción mínima, nominal y máxima
%   (b) Escalamiento de OPEX y CAPEX
% No requiere toolboxes adicionales.
clear; clc; close all

%% CONFIGURACION VISUAL EDITABLE
V.figura = [1550 650];          % [ancho alto] en pixeles
V.dpi = 300;
V.fuente = 'Arial';
V.tamanoEjes = 12;
V.tamanoTitulo = 16;
V.tamanoLeyenda = 10;
V.grosor = 2.2;
V.marcador = 6;
V.grosorReferencia = 1.5;
V.leyenda = 'eastoutside';      % recomendable para no cubrir curvas
V.grid = true;
V.box = true;
V.colorFurfural = [0.35 0.48 0.88];
V.colorLA = [0.85 0.00 0.55];
V.colorFA = [0.10 0.60 0.62];
V.colorOPEX = [0.35 0.48 0.88];
V.colorCAPEX = [0.85 0.00 0.55];
V.colorVentana = [0.70 0.86 0.70];
V.transparenciaVentana = 0.25;
V.limX = [220 1030];
V.tituloA = '(a) Producción mínima, nominal y máxima';
V.tituloB = '(b) Escalamiento de costos';
V.archivo = 'produccion_costos_escala.png';

%% DATOS DE ESCENARIOS
F = [250 300 400 500 600 750 1000];  % kg/h
horas = 8000;                         % h/año
hueso = F*horas/1000;                 % t/año

% Factores globales de producto vendible [t producto/t hueso]
yF = 0.033175;
yLA = 0.210325;
yFA = 0.083375;
furfural = hueso*yF;
LA = hueso*yLA;
FA = hueso*yFA;

% Costos recalculados [MUSD]
OPEX = [1.984 2.149 2.479 2.809 3.139 3.634 4.459];
CAPEX = [5.278 5.888 6.998 8.000 8.925 11.640 15.040];

F_minimo = 400;                       % mínimo recomendado
F_nominal = 500;
F_maximo = 600;                       % máximo del tren instalado

%% FIGURA CON DOS PANELES
fig = figure('Color','w','Position',[50 80 V.figura]);
tl = tiledlayout(fig,1,2,'TileSpacing','compact','Padding','compact');

% (a) Producción
ax1 = nexttile(tl,1); hold(ax1,'on');
hVent1 = patch(ax1,[F_minimo F_maximo F_maximo F_minimo], ...
    [0 0 1800 1800],V.colorVentana,'FaceAlpha',V.transparenciaVentana, ...
    'EdgeColor','none','DisplayName','Ventana instalada: 400-600 kg/h');
hF = plot(ax1,F,furfural,'-o','Color',V.colorFurfural, ...
    'LineWidth',V.grosor,'MarkerSize',V.marcador,'DisplayName','Furfural');
hLA = plot(ax1,F,LA,'-o','Color',V.colorLA, ...
    'LineWidth',V.grosor,'MarkerSize',V.marcador,'DisplayName','Ácido levulínico');
hFA = plot(ax1,F,FA,'-o','Color',V.colorFA, ...
    'LineWidth',V.grosor,'MarkerSize',V.marcador,'DisplayName','Ácido fórmico');
hNom1 = xline(ax1,F_nominal,'--k','LineWidth',V.grosorReferencia, ...
    'DisplayName','Nominal: 500 kg/h');
xlabel(ax1,'Alimentación seca de hueso (kg/h)');
ylabel(ax1,'Producción vendible (t/año)');
title(ax1,V.tituloA); xlim(ax1,V.limX); ylim(ax1,[0 1800]);
legend(ax1,[hF hLA hFA hVent1 hNom1], ...
    'Location',V.leyenda,'FontSize',V.tamanoLeyenda,'Box','on');
formatoEjes(ax1,V);

% (b) Costos
ax2 = nexttile(tl,2); hold(ax2,'on');
hVent2 = patch(ax2,[F_minimo F_maximo F_maximo F_minimo], ...
    [0 0 16 16],V.colorVentana,'FaceAlpha',V.transparenciaVentana, ...
    'EdgeColor','none','DisplayName','Ventana instalada: 400-600 kg/h');
hO = plot(ax2,F,OPEX,'-o','Color',V.colorOPEX, ...
    'LineWidth',V.grosor,'MarkerSize',V.marcador,'DisplayName','OPEX anual');
hC = plot(ax2,F,CAPEX,'-s','Color',V.colorCAPEX, ...
    'LineWidth',V.grosor,'MarkerSize',V.marcador,'DisplayName','CAPEX');
hNom2 = xline(ax2,F_nominal,'--k','LineWidth',V.grosorReferencia, ...
    'DisplayName','Nominal: 500 kg/h');
xlabel(ax2,'Alimentación seca de hueso (kg/h)');
ylabel(ax2,'Costo (MUSD)');
title(ax2,V.tituloB); xlim(ax2,V.limX); ylim(ax2,[1.5 16]);
legend(ax2,[hO hC hVent2 hNom2], ...
    'Location',V.leyenda,'FontSize',V.tamanoLeyenda,'Box','on');
formatoEjes(ax2,V);

exportgraphics(fig,V.archivo,'Resolution',V.dpi);
fprintf('Imagen generada: %s\n',V.archivo);

function formatoEjes(ax,V)
set(ax,'FontName',V.fuente,'FontSize',V.tamanoEjes,'LineWidth',1.0);
ax.Title.FontSize = V.tamanoTitulo;
if V.grid, grid(ax,'on'); else, grid(ax,'off'); end
if V.box, box(ax,'on'); else, box(ax,'off'); end
end
