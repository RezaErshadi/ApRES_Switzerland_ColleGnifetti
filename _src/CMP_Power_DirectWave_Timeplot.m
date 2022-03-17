clear
close all
clc
ps = filesep;
[PP,Prjcts] = FUNC_ApRES_PathFix;
% [PP,SavedPath,Prjcts,ps] = FUNC_ApRES_PathFix;
%%
ProjectName = "ColleGnifetti_Switzerland";
SiteName = "CMP";
%%
DtaDir = strcat(PP,ps,ProjectName,ps,SiteName);
DataList = dir(string(DtaDir)+ps+"*.dat");
dta = funcReadCMP(DataList,DtaDir,ps);
maxZ = 101;
%% Plot
for i = 1:size(dta.HHll,2)
    DistCnt(i) = dta.HHll(i).DistCnt;
end
% HH
HHll = dta.HHll;
z = HHll(1).Z;
t = HHll(1).t;
X = 0:0.5:30;
for i = 1:length(HHll)
    x(i) = HHll(i).DistCnt;
    c(:,i) = HHll(i).Signal;
end
PowerReturnHH = 20.*log10(abs(c));
[~,ii] = min(abs(z-maxZ));
z = z(1:ii);
PowerReturnHH = PowerReturnHH(1:ii,:);
%%
% figure,
% k = 1;
% ii = [1:5];
% for i = ii
% subplot(1,length(ii),k)
% plot(PowerReturnHH(:,i),t)
% set(gca,'YDIR','reverse')
% xlim([-160 0])
% title("half distance "+string(DistCnt(ii(k))))
% k = k+1;
% end
%%
% ii = 1:15;
% cm = prism(length(ii));
% figure,
% for i = ii
% plot(PowerReturnHH(:,i),t,'*-')
% hold on
% set(gca,'YDIR','reverse')
% ylim([0.75e-3 1.5e-3])
% set(gca,'color','k');
% ylabel('time [ns]')
% end
%%
% prall = [PowerReturnHH];
% nshots = size(prall,2);
% figure,
% for i = 1:nshots
%     bn(1,i) = fmcw_findbed(z,prall(:,i),[15 25],'maxAmp',[]);
%     Bed(1,i) = z(bn(1,i));
%     sp = subplot(1,nshots,i);
%     plot(prall(:,i),z)
%     hold on
%     plot([-142 -22],[Bed(i) Bed(i)],'-r')
%     set(gca,'YDIR','reverse')
%     xlim([-160 0])
%     ylim([10 30])
% end
%%
% prall = [PowerReturnHH PowerReturnHV PowerReturnVV];
% nshots = size(prall,2);
% figure,
% for i = 1:nshots
%     bn(1,i) = fmcw_findbed(z,prall(:,i),[15 25],'maxAmp',[]);
%     Bed(1,i) = z(bn(1,i));
%     sp = subplot(3,nshots/3,i);
%     plot(prall(:,i),z)
%     hold on
%     plot([-142 -22],[Bed(i) Bed(i)],'-r')
%     set(gca,'YDIR','reverse')
%     xlim([-160 0])
%     ylim([0 maxZ])
% end
%%
function dta = funcReadCMP(DataList,DtaDir,ps)
    for i = 1:length(DataList)
        FileName_temp = DataList(i).name;
        [~,~,ext] = fileparts(FileName_temp);
        FileName = string(erase(FileName_temp,ext));
        splt = split(FileName,"_");
        Tpos = str2double(splt{4});
        Rpos = str2double(splt{3});
        AntDist = abs(Rpos - Tpos);
        DistCntr = AntDist/2;
        AntOr_temp = splt{2};
        AntOr(1) = string(AntOr_temp(1:2));
        AntOr(2) = string(AntOr_temp(3:4));
        Data(i,:) = [AntOr string(DistCntr) string(AntDist) string(Tpos) string(Rpos) FileName_temp];
    end
    DistCntr = str2double(Data(:,3));
    [~,ii] = sort(DistCntr);
    Data = Data(ii,:);

    iHHll = Data(:,1) == "HH" & Data(:,2) == "ll";
    iHVld = Data(:,1) == "HV" & Data(:,2) == "ld";
    iVVdd = Data(:,1) == "VV" & Data(:,2) == "dd";

    DtaHHll = Data(iHHll,:);
    for i = 1:size(DtaHHll,1)
        filePath = strcat(DtaDir,ps,DtaHHll(i,end));
        DtaMean = FUNC_SimpleRead(filePath,'ice');
        DtaMean.DistCnt = str2double(DtaHHll(i,3));
        dta.HHll(i) = DtaMean;
    end
    DtaHVld = Data(iHVld,:);
    for i = 1:size(DtaHVld,1)
        filePath = strcat(DtaDir,ps,DtaHVld(i,end));
        DtaMean = FUNC_SimpleRead(filePath,'ice');
        DtaMean.DistCnt = str2double(DtaHVld(i,3));
        dta.HVld(i) = DtaMean;
    end
    DtaVVdd = Data(iVVdd,:);
    for i = 1:size(DtaVVdd,1)
        filePath = strcat(DtaDir,ps,DtaVVdd(i,end));
        DtaMean = FUNC_SimpleRead(filePath,'ice');
        DtaMean.DistCnt = str2double(DtaVVdd(i,3));
        dta.VVdd(i) = DtaMean;
    end
end