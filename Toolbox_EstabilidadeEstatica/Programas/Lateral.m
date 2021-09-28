%Estabilidade Lateral

clear
clc

prompt = {"Angulo de diedro da asa (grau):","Coeficiente angular da curva Cl x alpha da Asa:", ...
"Area da asa (m^2):", "Envergadura da asa(m):"};
rc = [1,40; 1,40; 1,40; 1,40];
default = {'5','0.063161','0.92','2.48'};
dims = inputdlg (prompt, 'Preencha com os dados do VANT', rc, default);

if (isempty (dims))
  helpdlg ('Preencha corretamente', 'ContEmpenagem');
else
  Gamma = str2num (dims{1}) ; %Angulo de diedro da asa
  a = str2num (dims{2}); %coeficiente angular da curva CL x alpha da asa
  S_w = str2num (dims{3}); %Area da asa
  b = str2num (dims{4}); %envergadura da asa

  mensagem = {'Selecione o tipo de asa da aeronave'};
  tipo_asa = {'Trapezoidal','Eli­ptica','Retangular'};
  [indx,tf] = listdlg('PromptString',mensagem,'ListSize',[200 50],'ListString',tipo_asa,'SelectionMode','single');

  if sum(indx == 1)>0
    prompt = {"Corda do perfil na estação desejada ao longo da semi-envergadura(lista)(m):",...
    "Posicao dessas cordas ao longo da semi-envergadura(lista)(m):", ...
    "Incremento da posição das contadas (Delta y):"};
    rc = [1,40; 1,40; 1,40];
    default = {'[0.41 0.39 0.38 0.37 0.36 0.35 0.34 0.33 0.32 0.31 0.3 0.29]','[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2]',...
    '[0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1]'};
    dims_asa = inputdlg (prompt, 'Preencha com os dados da asa', rc, default);
    c_y = str2num (dims_asa{1}) ;
    y = str2num (dims_asa{2});
    Deltay = str2num(dims_asa{3});
    somatorio = 0;
    for i = 1:1:length(y)
      somatorio += c_y(i) * y(i) * Deltay(i);
    endfor
    
    Clbeta = (-2 * Gamma * a) / (S_w * b) * somatorio
  elseif sum(indx == 2)>0
    prompt = {"Corda do perfil na estação desejada ao longo da semi-envergadura(lista)(m):",...
    "Posicao dessas cordas ao longo da semi-envergadura(lista)(m):", ...
    "Incremento da posição das contadas (Delta y):"};
    rc = [1,40; 1,40; 1,40];
    default = {'[0.41 0.39 0.38 0.37 0.36 0.35 0.34 0.33 0.32 0.31 0.3 0.29]','[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2]',...
    '[0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1]'};
    dims_asa = inputdlg (prompt, 'Preencha com os dados da asa', rc, default);
    c_y = str2num (dims_asa{1}) ;
    y = str2num (dims_asa{2});
    Deltay = str2num(dims_asa{3});
    somatorio = 0;
    for i = 1:1:length(y)
      somatorio += c_y(i) * y(i) * Deltay(i);
    endfor
    
    Clbeta = (-2 * Gamma * a) / (S_w * b) * somatorio
  else
    Clbeta = (-Gamma * a) / 4
  endif

  helpdlg (sprintf('A contribuicao do angulo de diedro na estabilidade lateral e de %.5f\n',Clbeta),...
  "Contribuicao do angulo de diedro");
  plot([-pi:pi],Clbeta .* [-pi:pi],'r-','Linewidth',3)
  if (Clbeta < 0)
    helpdlg (sprintf('A aeronave esta lateralmente estavel'),"Analise de resultado")    
    legend('C_{l\beta}<0')
  else
    helpdlg (sprintf('A aeronave nao está lateralmente estavel'),"Analise de resultado")
    legend('C_{l\beta}>0')
  endif
  grid on
  xlabel('Angulo de inclinação (\beta) (grau)');
  ylabel('Coeficiente de momento angular lateral (C_{l})');
  title('Contribuicao do angulo de diedro na estabilidade lateral')
  endif