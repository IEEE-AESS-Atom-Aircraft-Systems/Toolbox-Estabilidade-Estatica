%LIMPANDO OS DADOS PREVIOS
clear all
close all 
clc

%CHAMANDO OS CODIGOS PARCIAIS
mensagem_asa = {'Deseja calcular a contribuicao da asa?'};
resposta_asa = {'Sim','Inserir valor previamente calculado'};
[indx,tf] = listdlg('PromptString',mensagem_asa,'ListSize',[200 50],'ListString',resposta_asa,'SelectionMode','single');
if sum(indx == 1)>0
  ContAsa;
else
  prompt = {'Coeficiente de momento em torno do cg para angulo de ataque nulo', ...
  'Coeficiente angular da curva de coeficiente de momento em torno do cg'}; 
  rc = [1,40; 1,40];
  dims_asa = inputdlg (prompt, 'Preencha com os dados da asa', rc);
  CM0w = str2num (dims_asa{1});
  CMalphaw = str2num (dims_asa{2});
endif

mensagem_empenagem = {'Deseja calcular a contribuicao da empenagem?'};
resposta_empenagem = {'Sim','Inserir valor previamente calculado'};
[indx,tf] = listdlg('PromptString',mensagem_empenagem,'ListSize',[200 50],'ListString',resposta_empenagem,'SelectionMode','single');
if sum(indx == 1)>0
  ContEmpenagem;
else
  prompt = {'Coeficiente de momento em torno do cg para angulo de ataque nulo', ...
  'Coeficiente angular da curva de coeficiente de momento em torno do cg'}; 
  rc = [1,40; 1,40]
  dims_empenagem = inputdlg (prompt, 'Preencha com os dados da empenagem', rc)
  CM0t = str2num (dims_empenagem{1});
  CMalphat = str2num (dims_empenagem{2});
endif

mensagem_fuselagem = {'Deseja calcular a contribuicao da fuselagem?'};
resposta_fuselagem = {'Sim','Inserir valor previamente calculado'};
[indx,tf] = listdlg('PromptString',mensagem_fuselagem,'ListSize',[200 50],'ListString',resposta_fuselagem,'SelectionMode','single');
if sum(indx == 1)>0
  ContFuselagem;
else
  prompt = {'Coeficiente de momento em torno do cg para angulo de ataque nulo', ...
  'Coeficiente angular da curva de coeficiente de momento em torno do cg'}; 
  rc = [1,40; 1,40];
  dims_fuselagem = inputdlg (prompt, 'Preencha com os dados da fuselagem', rc);
  CM0f = str2num (dims_fuselagem{1});
  CMalphaf = str2num (dims_fuselagem{2});
endif

%CALCULO
alpha = [0:10];
CM0a = CM0w + CM0t + CM0f 
CMalphaa = CMalphaw + CMalphat + CMalphaf
CMCGa = CM0a .+ CMalphaa .* alpha;

%GERANDO O GRAFICO
figure(4)
plot(alpha, CMCGa,'LineWidth',2)
xlabel('Angulo de ataque (graus)')
ylabel('Coeficiente de momento em torno do CG') 
title('Estabilidade longitudinal estatica da aeronave completa')
axis on 
grid on 

%CALCULO DO PONTO NEUTRO DA AERONAVE
mensagem_ME = {'Deseja calcular o ponto neutro e a margem estatica?'};
resposta_ME = {'Sim','Nao'};
[indx,tf] = listdlg('PromptString',mensagem_ME,'ListSize',[200 50],'ListString',resposta_ME,'SelectionMode','single');
if sum(indx == 1)>0
  mensagem_valores = {'Voce inseriu valores previamente calculados para as contribuicoes individuais?'};
  resposta_valores = {'Sim','Nao'};
  [indx,tf] = listdlg('PromptString',mensagem_valores,'ListSize',[200 50],'ListString',resposta_valores,'SelectionMode','single');
  if sum(indx == 1)>0
    prompt = {"Corda media da asa(m):", "Distancia entre o centro aerodinamico e bordo de ataque (m):", ...
    "Distancia entre o centro de gravidade e bordo de ataque (m):","Coeficiente angular da curva Cl x alfa da asa (1/grau):",...
    "Volume de cauda horizontal:","Eficiencia da cauda horizontal:","Coeficiente angular da curva cl por alfa do estabilizador(1/grau)",...
    "Variacao do Vento relativo de acordo com angulo de ataque (1/grau):"};
    rc = [1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40];
    dims_ME = inputdlg (prompt, 'Preencha com os dados da aeronave', rc);
    c = str2num(dims_ME{1});
    hac = str2num(dims_ME{2});
    hcg = str2num(dims_ME{3});
    aw = str2num(dims_ME{4});
    Vh = str2num(dims_ME{5});
    n = str2num(dims_ME{6});
    at = str2num(dims_ME{7});
    EpsilonAlpha = str2num(dims_ME{8});  
  endif
  hpn = c*((hac/c) - (CMalphaf/aw) + ((Vh * n * at / aw) * (1 - EpsilonAlpha))) %ponto neutro (m)
  ME = (hpn/c) - (hcg/c) %Margem estatica (m)
  helpdlg (sprintf ('Margem estatica = %.3f \nPosicao do ponto neutro = %.3f',ME,hpn),"Margem Estatica")
endif
%ANALISE DE DADOS OBTIDOS
if and(CMalphaa < 0, CM0a >0)
  helpdlg (sprintf ('A aeronave esta estaticamente estavel.'),"Estabilidade longitudinal estatica");
else 
  helpdlg (sprintf ('A aeronave nao esta estaticamente estavel'),"Estabilidade longitudinal estatica");
endif