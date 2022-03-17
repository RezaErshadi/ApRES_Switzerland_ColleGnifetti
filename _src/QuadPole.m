clear
close all
clc
ps = filesep;
[PP,Prjcts] = FUNC_ApRES_PathFix;
%%
ProjectName = "ColleGnifetti_Switzerland";
SiteName = "KCC";
%%
maxRange = 101;
dA = 1;
ao = 0:dA:179; 
ac = 0;
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
%%
[Data,Z,f] = FUNC_ReadDataFolder(PP,ProjectName,SiteName,ps,0,'ice');
[~,iMD] = min(abs(Z-maxRange)); % maximum depth index
Z = Z(1:iMD);
for i = 1:size(Data,2)
    Data{end,i} = Data{end,i}(1:iMD);
end
%%
s = FUNC_SeperateData(Data);
%% Signal to Parameters
% hh_ll = -s.HHll0;
% hv_ld = s.HVld0;
% vv_dd = s.VVdd0;
hh_rr = s.HHrr0;
hv_ru = s.HVru0;
vv_uu = s.VVuu0;
%%
% [HH,VH,HV,VV] = QuadpoleSynthesizer(hh_ll,hv_ld,hv_ld,vv_dd,ao,ac);
[HH,VH,HV,VV] = QuadpoleSynthesizer(hh_rr,hv_ru,hv_ru,vv_uu,ao,ac);
ObsDta = CLASS_S2P.Signal2Param(HH,VH,HV,VV,Z,ao,f,C_DepthWin,C_ConvWin,DenoisingFlag,"radar");
PAHH = ObsDta{5};
PAVH = ObsDta{6};
PAHV = ObsDta{7};
PAVV = ObsDta{8};
CM = ObsDta{13};
CP = ObsDta{14};
Psi = ObsDta{18};
pltdim = [0.025,0.025,0.5,0.9];  
[fg,ax,cb] = CLASS_FixedPlot.StandardFigure([],ObsDta,ao,Z,[],pltdim);
fg.InvertHardcopy = 'off';
