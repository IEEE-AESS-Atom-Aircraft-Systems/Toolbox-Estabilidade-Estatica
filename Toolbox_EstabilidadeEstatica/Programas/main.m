clear all
close all 
clc

d = dir;
nome_codigo = {d.name};
[indx,tf] = listdlg('PromptString',{'Selecione qual programa relacionado a estabilidade estatica deseja analizar.',...
    'Selecione somente um código.',''},...
    'ListSize',[300 250],'SelectionMode','single','ListString',nome_codigo);

if sum(indx == 3)>0
    CG
elseif sum(indx == 4)>0
    ContAsa
elseif sum(indx == 5)>0
    ContEmpenagem
elseif sum(indx == 6)>0
    ContFuselagem
elseif sum(indx == 7)>0
    Direcional
elseif sum(indx == 8)>0
    Lateral
elseif sum(indx == 9)>0
    Longitudinal
elseif sum(indx == 10)>0 || sum(indx == 13)>0
    opcoes = struct('WindowStyle','modal',... 
              'Interpreter','tex');
    f = warndlg('\color{black} Escolha um código válido',...
             'UAV Stability Toolbox', opcoes);
else
    opcoes = struct('WindowStyle','modal',... 
              'Interpreter','tex');
    f = warndlg('\color{black} Selecione um código',...
             'UAV Stability Toolbox', opcoes);
end