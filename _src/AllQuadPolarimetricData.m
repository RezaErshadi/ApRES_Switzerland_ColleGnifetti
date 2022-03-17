clear
close all
clc
P = ThisIsAn_ApRES_Script(mfilename('fullpath'));
%% Dir
InfoDir = fullfile(P.data,'QuadPolarimetric_PointsInfo.csv');
DataDir = fullfile(P.data,'radar','QuadPolarimetric');
%%
maxRange = 101;
dA = 1;
ao = 0:dA:179; 
C_DepthWin = maxRange * 0.1;
C_ConvWin = maxRange * 0.1;
DenoisingFlag.PA = [  "1", "MovingAverage"  , string(maxRange*0.05) ;
                      "0", "Conv1D"         , string(maxRange*0.1) ;
                      "2", "Conv2D"         , string(maxRange*0.05) ;
                      "0", "DenoisePCA"     , string(1)];
DenoisingFlag.PD = [  "1", "MovingAverage"  , string(maxRange*0.05) ;
                      "0", "Conv1D"         , string(maxRange*0.01) ;
                      "0", "Conv2D"         , string(maxRange*0.01) ;
                      "0", "DenoisePCA"     , string(1)];
%% Read
info = readtable(InfoDir);
[Data,Z,f] = FUNC_ReadDataFolder(DataDir,0,'ice');
[~,iMD] = min(abs(Z-maxRange)); % maximum depth index
Z = Z(1:iMD);
for i = 1:size(Data,2)
    Data{end,i} = Data{end,i}(1:iMD);
end
s = FUNC_SeperateData(Data);
%%
% for i = 1:15
%     sn = string(table2array(info(i,1)));
%     ac = table2array(info(i,4));
%     hh_ll = s.HHll0(:,i);
%     hv_ld = s.HVld0(:,i);
%     vv_dd = s.VVdd0(:,i);
%     [HH,VH,HV,VV] = QuadpoleSynthesizer(hh_ll,hv_ld,hv_ld,vv_dd,ao,ac);
%     ObsDta = CLASS_S2P.Signal2Param(HH,VH,HV,VV,Z,ao,f,C_DepthWin,C_ConvWin,DenoisingFlag,"radar");
%     pltdim = [0.025,0.025,0.5,0.9];  
%     [fg,ax,cb] = CLASS_FixedPlot.StandardFigure([],ObsDta,ao,Z,[],pltdim);
%     fg.InvertHardcopy = 'off';
%     print(fg,"Colle"+sn+".png",'-dpng','-r300');
% end















