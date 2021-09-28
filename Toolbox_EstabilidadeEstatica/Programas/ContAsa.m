%Este programa calcula individualmente a contribuicao da asa para a estabilidade estática longitudinal
 
%clear all 
%clc

prompt = {"Razão de Aspecto:","Fator de eficiencia da envergadura:", ...
"Coeficiente angular da curva cl por alfa do perfil da asa(1/grau):", "Corda media da asa (m):", ...
"Distancia entre o cg e bordo de ataque (m):","Distancia entre o centro aerodinamico e bordo de ataque (m):", ...
"Angulo de atque para sustentacao nula (grau):","Coeficiente de momento em torno do centro aerodinamico a angulo de ataque nulo:",...
"Valores de possiveis angulos de ataque (lista):"};
default = {'6.7','0.98','0.0766','0.37','0.1587','0.1225','-10','-0.24','[0:10]'};
rc = [1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40]; 
dims = inputdlg (prompt, 'Preencha com os dados do VANT', rc, default);

if (isempty (dims))
  helpdlg ('Preencha corretamente', 'ContAsa');
else
  %DADOS NECESSARIOS:
  AR = str2num (dims{1}); %Razao de aspecto 
  e = str2num (dims{2}); %fator de eficiencia da envergadura 
  a0w = str2num (dims{3}); %coeficiente angular da curva cl por alfa do perfil da asa(/grau)
  c = str2num (dims{4}); %corda media da asa (m)
  hcg = str2num (dims{5}); %dist cg e bordo de ataque (m)
  hac = str2num (dims{6}); %dist centro aerodinamico e bordo de ataque (m)
  alpha0 = str2num (dims{7}); %angulo de ataque para sustentacao nula (grau)
  CMac = str2num (dims{8}); %Coeficiente de momento em torno do centro aerodinamico a angulo de ataque nulo 
  alpha = str2num (dims{9}); %Valores de possiveis angulos de ataque
  
  %CALCULO
  aw = a0w / (1 + (57.3 * a0w) / (pi * e * AR)); %coeficiente angular da curva cl por alfa da asa (/grau)
  Cl0 = aw * (0 - alpha0); %Coeficiente de sustentacao para angulo de ataque nulo 
  CM0w = CMac + (Cl0 * ((hcg/c) - (hac/c))) %Coeficiente de momento em torno do cg para angulo de ataque nulo
  CMalphaw = aw * ((hcg/c)-(hac/c)) %Coeficiente angular da curva de coeficiente de momento em torno do cg
  CMCGw = CM0w .+ CMalphaw .* alpha; %Variacao do coeficiente de momento em torno do cg em funcao do angulo de ataque

  %GERANDO O GRAFICO
  figure(1)
  plot(alpha,CMCGw,'LineWidth',2,"r")
  xlabel('Angulo de ataque (\deg)')
  ylabel('Coeficiente de momento em torno do CG') 
  title('Contribuição da asa na estabilidade longitudinal estatica')
  grid on 
  axis on 
endif
