%ATENÇÃO: OS PESOS DOS COMPONENTES E SUAS RESPECTIVAS DISTÂNCIAS DEVEM ESTAR NA MESMA POSIÇÃO DO VETOR

clc
clear all
close all 

prompt = {"Corda media (m):","Posicao do bordo de ataque (m):", ...
"Peso dos componentes (lista)(N)", "Distancia dos componentes (lista)(m)"};
rc = [1,40; 1,40; 1,40; 1,40];
default = {'0.45','0.37','[6.3765 4.414 14.715 2.943 1.962 2.943]',...
'[0.1018 0.22448 0.54562 0.5657 1.07893 1.42765]'};
dims = inputdlg (prompt, 'Preencha com os dados do VANT', rc, default);
if (isempty (dims))
  helpdlg ('Preencha corretamente', 'CG');
else
  %Dados fornecidos
  c = str2num (dims{1}); %corda média (metros)
  ba = str2num (dims{2}); %bordo de ataque (metros)
  P = str2num (dims{3}); %Pesos dos componentes (Newtons)
  D = str2num (dims{4}); %Distância dos componentes (metros)

  %Calculo da posição do CG
  Ptot = sum(P); %Peso total (Newtons)
  Xcg = sum(D .*P)/Ptot %Local do CG (metros)

  %Cálculo da porcentagem do CG
  porccg = (Xcg - ba) / c * 100

  helpdlg (sprintf('Posição do centro de gravidade: %.3f m.\nPercentual desta posição em relação a corda media da asa: %.2f (/100) de c', ...
  Xcg, porccg),'CG')
endif  