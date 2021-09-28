%Este programa calcula individualmente a contribuicao da empenagem para a estabilidade estática longitudinal
 
%clear all 
%close all 
%clc

%INSTRUÇAO: PARA ESTE CÓDIGO, E IMPORTANTE QUE EXISTA UMA CLARA DIVISAO DAS SECOES DA AERONAVE.
%ESTE CODIGO APENAS FOI FEITO COM DADOS ESTIPULADOS SENDO A MARCACAO "%%" AO LADO DE VARIAVEIS AS MEDIDAS ESTIPULADAS

prompt = {"Fator de correcao k2-k1:","corda media da asa:", ...
"Area da asa (m^2):", ...
"Angulo de incidencia da fuselagem (graus):","Largura media das secoes analisadas (m):", ... 
"Angulo de sustentacao nula da asa em relacao a linha da fuselagem (graus):", ...
"Valores possiveis para o angulo de ataque (lista)(graus)", ...
"Variacao do Vento relativo de acordo com angulo de ataque (1/grau)", ...
"Numero total de secoes Analisadas:","Secao da aeronave onde ha o fim do nariz:", ...
"Secao da aeronave onde está localizada a asa:", "Incremento de comprimento(lista)(m)",...
"Comprimento da fuselagem (m):","Maxima largura da fuselagem (m)"};

default = {'0.025','0.37','0.92','1.2','0.1','1.5','[0:10]','0.34355','10','3','[5, 6]',...
'[ 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15 ]','1.5','0.4'};
rc = [1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40]; 
dims = inputdlg (prompt, 'Preencha com os dados do VANT', rc, default);

if (isempty (dims))
  helpdlg ('Preencha corretamente', 'ContFuselagem');
else
  %DADOS NECESSARIOS:

  k2k1 = str2num (dims{1}); %fator de correcao %%
  c = str2num (dims{2}); %corda media da asa (m)
  Sw = str2num (dims{3}); %Area da asa (m^2)
  ifu = str2num (dims{4}); %Angulo de incidencia da fuselagem (graus) %%
  wf = str2num (dims{5}); %Largura media das secoes analisadas (m) %%
  alpha0w = str2num (dims{6}); %Angulo de sustentacao nula da asa em relacao a linha da fuselagem (graus) %%
  alpha = str2num (dims{7}); %Valores possiveis para o angulo de ataque (graus)
  EpsilonAlpha = str2num (dims{8}); %Variacao do Vento relativo de acordo com angulo de ataque (1/grau)

  %DIVISÃO DAS SEÇÕES DA FUSELAGEM
  sec = str2num (dims{9}); %Numero total de secoes Analisadas %%
  secnariz = str2num (dims{10}); %Secao da aeronave onde ha o fim do nariz %%
  secasa = str2num (dims{11}); %Secao(oes) da aeronave onde estaas localizada a asa %%
  x = str2num (dims{12}); %incremento de comprimento (m) %%
  lf = str2num (dims{13}); %comprimento da fuselagem (m) %%
  dmax = str2num (dims{14}); %maxima largura da fuselagem (m) %%

  %CALCULO
  som1 = 0;
  lh = 0;
  for i = (secasa(1)+ length(secasa)):1:sec
    lh = lh + x(i);
  endfor 
  for i = 1:1:sec 
    som1 = som1 + (wf^2 *(alpha0w + ifu) * x(i));
  endfor 
    CM0f = (k2k1 / (36.5 * Sw * c)) * som1 

  EpsilonAlphau = [];
  for i = 1:1:sec
    if (i <= secnariz)
      EpsilonAlphau(i) = 1.5; %%
    elseif and(i > secnariz, i < secasa)
      EpsilonAlphau(i) = 2.4; %%
    elseif (i == secasa(1)|| i == secasa(2))
      EpsilonAlphau(i) = 0;  
    else
      EpsilonAlphau(i) = (x(i) / lh * (1 - EpsilonAlpha));
    endif
  endfor
  som2 = 0;
  for i = 1:1:sec
    som2 = som2 + wf^2 * EpsilonAlphau(i) * x(i);
  endfor
  CMalphaf = 1 / ( 36.5 * Sw * c) * som2 
  CMCGf = CM0f .+ CMalphaf .* alpha;

  %GERANDO O GRAFICO
  figure(3)
  plot(alpha,CMCGf,'LineWidth',2,"c")
  xlabel('Angulo de ataque (graus)')
  ylabel('Coeficiente de momento em torno do CG') 
  title('Contribuição da fuselagem na estabilidade longitudinal estatica')
  grid on 
  axis on 
endif