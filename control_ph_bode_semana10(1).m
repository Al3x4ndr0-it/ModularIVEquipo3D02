clear; clc; close all
pHss=2.0; tau=12; K=-0.35; dq=0.20;
f=@(t,pH) -(pH-pHss)/tau + K*(dq*(t>=20 && t<35))/tau;
[t,pH]=ode45(f,[0 100],pHss,odeset('RelTol',1e-9,'AbsTol',1e-11));
G=tf(K,[tau 1]);
figure; tiledlayout(1,2); nexttile; plot(t,pH,'LineWidth',1.5); yline(pHss,'--'); grid on
xlabel('Tiempo (min)'); ylabel('pH'); title('Pulso acido y retorno');
nexttile; bode(G); grid on; title('Bode del proceso de pH');
fprintf('pH minimo = %.5f; pH final = %.5f\n',min(pH),pH(end));
