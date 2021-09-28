%Este programa calcula individualmente a contribuicao da empenagem para a estabilidade estática longitudinal
 
%clear all 
%close all 
%clc

prompt = {"Razão de Aspecto:","Razao de aspecto do estabilizador:", ...
"Fator de eficiencia da envergadura da asa:", "Fator de eficiencia da envergadura do estabilizador:", ...
"Coeficiente angular da curva cl por alfa do perfil do estabilizador(1/grau):","Area da asa (m^2):", ...
"Area do estabilizador (m^2):","Angulo de incidencia da asa (graus):","Angulo de incidencia do estabilizador (graus):",...
"Eficiencia da cauda:", "Volume de cauda horizontal:","Coeficiente de sustentacao para angulo de ataque nulo:",...
"Variacao do coeficiente de sustentacao com angulo de ataque:", ...
"Valores possiveis para o angulo de ataque (lista):"};

default = {'6.7','3.15','0.98','1','0.133','0.92','0.169','5','0','0.95','0.45','0.62','0.0631','[0:10]'};
rc = [1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40]; 
dims = inputdlg (prompt, 'Preencha com os dados do VANT', rc, default);

if (isempty (dims))
  helpdlg ('Preencha corretamente', 'ContEmpenagem');
else
  %DADOS NECESSARIOS:
  AR = str2num (dims{1}); %Razao de aspecto da asa 
  ARt = str2num (dims{2}); %Razao de aspecto do estabilizador
  e = str2num (dims{3}); %Fator de eficiencia da envergadura da asa
  et = str2num (dims{4}); %Fator de eficiencia da envergadura do estabilizador
  a0t = str2num (dims{5}); %Coeficiente angular da curva cl por alfa do perfil do estabilizador(/grau)
  Sw = str2num (dims{6}); %Area da asa (m^2)
  St = str2num (dims{7}); %Area do estabilizador (m^2)
  iw = str2num (dims{8}); %Angulo de incidencia da asa (graus)
  it = str2num (dims{9}); %Angulo de incidencia do estabilizador (graus)
  n = str2num (dims{10}); %Eficiencia da cauda
  Vh = str2num (dims{11}); %Volume de cauda horizontal 
  Cl0 = str2num (dims{12}); %Coeficiente de sustentacao para angulo de ataque nulo
  aw = str2num (dims{13}); %Variacao do coeficiente de sustentacao de acordo com angulo de ataque
  alpha = str2num (dims{14}); %Valores possiveis para o angulo de ataque

  %CALCULO
  at = a0t / (1 + (57.3 * a0t) / (pi * et * ARt)); %coeficiente angular da curva cl por alfa do estabilizador (/grau)
  Epsilon0  = (57.3 * 2 * Cl0)/(pi * AR); %Vento relativo para o estabilizador 
  EpsilonAlpha = (57.3 * 2 * aw)/(pi * AR); %Coeficiente angular da variacao do vento relativo pelo angulo de ataque 
  CM0t = Vh * n * at * (iw - it + Epsilon0) %Coeficiente de momento ao redor do CG para angulo de ataque nulo
  CMalphat = -Vh * n * at * (1 - EpsilonAlpha) %Coeficiente angular da curva do coeficiente de momento em funcao do angulo de ataque 
  CMCGt = CM0t .+ CMalphat .* alpha; %Coeficiente de momento ao redor do CG em funcao do angulo de ataque 

  %GERANDO O GRAFICO
  figure(2)
  plot(alpha,CMCGt,'LineWidth',2,"b")
  xlabel('Angulo de ataque (graus)')
  ylabel('Coeficiente de momento em torno do CG') 
  title('Contribuição do estabilizador horizontal na estabilidade longitudinal estatica')
  grid on 
  axis on 
  
endif