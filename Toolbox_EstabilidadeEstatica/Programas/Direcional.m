%Estabilidade Direcional EstÃ¡tica

clear
clc

%Contribuiçao do conjunto asa-fuselagem na estabilidade direcional estatica

prompt = {"Fator de interferencia asa-fuselagem:","Fator empirico (funcao direta do numero de Reynolds da fuselagem):", ...
"Area projetada lateral da fuselagem(m^2):", "Comprimento da fuselagemm(m):", ...
"Area da asa (m^2):","Envergadura da asa(m):", ...
"Superficie vertical de empenagem:",...
"Coeficiente angular da superfi­cie vertical da empenagem:", ...
"Volume de cauda vertical:","Enflechamento da asa (25% da asa)(rad):","Distancia do nariz ate a linha de centro da fuselagem(m):",...
"Profundidade maxima da fuselagem(m):", "Razao de aspecto da asa:", ...
"Eficiencia da superfi­cie vertical de empenagem:", "Eficiencia de deflexao do leme:"};
rc = [1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40]; 
default = {'0.003', '1.5', '1', '1.5', '0.92', '2.48', '0.5', '0.1', '0.25', "pi/8", '0.15', '0.3', '6.7', '0.9','0.7'};
dims = inputdlg (prompt, 'Preencha com os dados do VANT', rc, default);

if (isempty (dims))
  helpdlg ('Preencha corretamente', 'Direcional');
else
  %DADOS NECESSARIOS:
  k_n = str2num (dims{1}); %Fator de interferencia asa-fuselagem
  k_rl = str2num (dims{2}); %Fator empirico (funcao direta do numero de Reynolds da fuselagem)
  S_f = str2num (dims{3}); %Area projetada lateral da fuselagem
  l_f = str2num (dims{4}); %Comprimento da fuselagem
  S_w = str2num (dims{5}); %Area da asa
  b = str2num (dims{6}); %Envergadura da asa

  %Contribuicao do conjunto asa-fuselagem 

  C_nbetawf = -k_n * k_rl * (S_f * l_f)/(S_w * b)

  helpdlg (sprintf('Contribuicao do conjunto asa fuselagem da empenagem: O coeficiente angular da curva de momento de guinada em relacao ao angulo de derrapagem e de %.3f\n',C_nbetawf),...
  'Contribuicao da superficie vertical da empenagem na estabilidade direcional');

  %Contribuicao da superfi­cie vertical da empenagem na estabilidade direcional estatica

  S_v = str2num (dims{7}); % superficie vertical de empenagem
  C_Lalphav = str2num (dims{8}); % coeficiente angular da superfi­cie vertical da empenagem
  V_v = str2num (dims{9}); % volume de cauda vertical
  Delta = str2num (dims{10}); %enflechamento da asa (25% da asa)
  Z_w = str2num (dims{11}); % distancia do nariz ate a linha de centro da fuselagem
  d_F = str2num (dims{12}); % profundidade maxima da fuselagem
  AR_w = str2num (dims{13}); %razao de aspecto da asa

  %Calculo contribuicao da superfi­cie vertical da empenagem na estabilidade direcional 

  C_nbetav = V_v * C_Lalphav * (0.724+3.06*((S_v/S_w))/(1+cos(Delta))+ 0.4 * (Z_w/d_F) + 0.009 * AR_w)

  helpdlg (sprintf('Contribuicao da superficie vertical da empenagem: O coeficiente angular da curva de momento de guinada em relacao ao angulo de derrapagem e de %.3f\n',C_nbetav),...
  'Contribuicao da superficie vertical da empenagem na estabilidade direcional');

  %Estabilidade Direcional estatica

  beta_vetor = [-pi:pi];
  eta_v = str2num (dims{14}); %eficiencia da superfi­cie vertical de empenagem

  C_nbeta = C_nbetawf + C_nbetav

  if C_nbeta > 0 
      plot(beta_vetor,C_nbeta.*beta_vetor,'r-','Linewidth',3);
      legend('C_{n\beta}>0')
      helpdlg (sprintf('O aviao esta direcionalmente estavel.\n'),"Estabilidade Direcional");
  else
      plot(beta_vetor,C_nbeta.*beta_vetor,'b-','Linewidth',3);
      legend('C_{n\beta}<0')
      helpdlg (sprintf('O aviao nao esta direcionalmente instavel.\n'),"Estabilidade Direcional");
  end

  grid on
  xlabel('Angulo de derrapagem (\beta) (rad)');
  ylabel('Contribuicao da superfi­cie de empanagem (C_{n})');
  title('Condicao para garantir a estabilidade direcional estatica')

  %Controle Direcional

  tau = str2num (dims{15}); %eficiencia de deflexao do leme

  %Coeficiente de momento de guinadado em relacao ao angulo de deflexao do leme

  C_ndeltar = (-eta_v) * V_v * C_Lalphav * tau;

  helpdlg (sprintf('O coeficiente de momento de guinadado em relacao ao angulo de deflexao do leme e de %.3f.\n',C_ndeltar),...
  'Controle Direcional');
  endif