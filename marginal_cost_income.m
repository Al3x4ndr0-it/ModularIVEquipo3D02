%% grafico_ingreso_costo_marginal.m
% Genera una imagen individual sin toolboxes adicionales:
%   marginal_cost_income.png
% Solo usa funciones base de MATLAB.
clear; clc; close all

%% CONFIGURACION VISUAL EDITABLE
V.figura = [1150 720];          % [ancho alto] en pixeles
V.dpi = 300;
V.fuente = 'Arial';
V.tamanoEjes = 13;
V.tamanoTitulo = 18;
V.tamanoLeyenda = 11;
V.grosor = 2.3;
V.grosorReferencia = 1.5;
V.leyenda = 'eastoutside';      % eastoutside, best, northeast...
V.grid = true;
V.box = true;
V.colorIngresoBase = [0.35 0.48 0.88];
V.colorIngresoEspecialidad = [0.85 0.00 0.55];
V.colorCosto = [0.00 0.00 0.00];
V.colorNominal = [0.45 0.45 0.45];
V.colorLimite = [0.85 0.10 0.10];
V.colorMargen = [0.70 0.86 0.70];
V.transparenciaMargen = 0.28;
V.limX = [250 1000];
V.limY = [390 960];            % [] para escala automatica
V.titulo = 'Ingreso y costo marginal de producción';
V.archivo = 'marginal_cost_income.png';

%% DATOS Y SUPUESTOS DEL ESCENARIO
F = linspace(250,1000,301);     % alimentación seca [kg/h]
F_nominal = 500;                % kg/h
F_limite = 600;                 % kg/h, límite del tren instalado

% Ingresos marginales antes de saturación del mercado [USD/t hueso]
IM_base_0 = 600.68;
IM_esp_0  = 931.14;

% Costo variable marginal [USD/t hueso]
CM_0 = 412.50;
CM_expansion = 652.50;          % incluye segundo tren/logística incremental

% Penalización comercial después de 600 kg/h
factorMercado = ones(size(F));
idx = F > F_limite;
factorMercado(idx) = max(0.72,1-0.0007*(F(idx)-F_limite));

IM_base = IM_base_0 .* factorMercado;
IM_especialidad = IM_esp_0 .* factorMercado;
CM = CM_0*ones(size(F));
CM(idx) = CM_expansion;

%% GRAFICA
fig = figure('Color','w','Position',[80 80 V.figura]);
ax = axes(fig); hold(ax,'on');

% Área de contribución marginal positiva para escenario base
hArea = fill(ax,[F fliplr(F)],[CM fliplr(IM_base)],V.colorMargen, ...
    'FaceAlpha',V.transparenciaMargen,'EdgeColor','none', ...
    'DisplayName','Contribución marginal positiva');

hBase = plot(ax,F,IM_base,'Color',V.colorIngresoBase, ...
    'LineWidth',V.grosor,'DisplayName','Ingreso marginal: precios base');
hEsp = plot(ax,F,IM_especialidad,'Color',V.colorIngresoEspecialidad, ...
    'LineWidth',V.grosor,'DisplayName','Ingreso marginal: especialidad');
hCosto = plot(ax,F,CM,'Color',V.colorCosto, ...
    'LineWidth',V.grosor,'DisplayName','Costo marginal variable');
hNom = xline(ax,F_nominal,'--','Color',V.colorNominal, ...
    'LineWidth',V.grosorReferencia,'DisplayName','Nominal: 500 kg/h');
hLim = xline(ax,F_limite,':','Color',V.colorLimite, ...
    'LineWidth',V.grosorReferencia+0.5,'DisplayName','Límite del tren: 600 kg/h');

xlabel(ax,'Alimentación seca de hueso (kg/h)');
ylabel(ax,'USD por tonelada adicional de hueso');
title(ax,V.titulo);
xlim(ax,V.limX); if ~isempty(V.limY), ylim(ax,V.limY); end
legend(ax,[hBase hEsp hCosto hNom hLim hArea], ...
    'Location',V.leyenda,'FontSize',V.tamanoLeyenda,'Box','on');
formatoEjes(ax,V);
exportgraphics(fig,V.archivo,'Resolution',V.dpi);

fprintf('Contribución marginal base a 500 kg/h = %.2f USD/t hueso\n',IM_base_0-CM_0);
fprintf('Contribución marginal especialidad a 500 kg/h = %.2f USD/t hueso\n',IM_esp_0-CM_0);
fprintf('Imagen generada: %s\n',V.archivo);

function formatoEjes(ax,V)
set(ax,'FontName',V.fuente,'FontSize',V.tamanoEjes,'LineWidth',1.0);
ax.Title.FontSize = V.tamanoTitulo;
if V.grid, grid(ax,'on'); else, grid(ax,'off'); end
if V.box, box(ax,'on'); else, box(ax,'off'); end
end
