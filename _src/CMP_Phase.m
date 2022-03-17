clear
close all
clc
[PP,SavedPath,Prjcts,ps] = FUNC_ApRES_PathFix;
%%
ProjectName = "ColleGnifetti_Switzerland";
SiteName = "CMP";
%%
DtaDir = strcat(PP,ps,ProjectName,ps,SiteName);
DataList = dir(string(DtaDir)+ps+"*.dat");
dta = funcReadCMP(DataList,DtaDir,ps);
maxZ = 100;
%% Plot
% HH
HHll = dta.HHll;
z = HHll(1).Z;
X = 0:0.5:30;
for i = 1:length(HHll)
    x(i) = HHll(i).DistCnt;
    c(:,i) = HHll(i).Signal;
end
Phs = angle(c);
[~,ii] = min(abs(z-maxZ));
z = z(1:ii);
Phs = Phs(1:ii,:);
C = nan(size(Phs,1),length(X));
for i = 1:length(x)
    ixx = find(x(i) == X);
    C(:,ixx) = Phs(:,i);
end
figure,
subplot(3,1,1)
imagesc(X,z,C)
title("HH")

aa = -4:0.0001:4;
cb = ones(length(aa),3);
[~,ipi] = min(abs(pi-aa));
[~,impi] = min(abs(-pi-aa));
for i = 1:impi
cb(i,:) = [0 0 0];
end
for i = ipi:length(cb)
cb(i,:) = [0 0 0];
end
colorbar
colormap(cb)
caxis([-4 4])
ylabel("Depth")

% HV
HVld = dta.HVld;
z = HVld(1).Z;
for i = 1:length(HVld)
    x(i) = HVld(i).DistCnt;
    c(:,i) = HVld(i).Signal;
end
Phs = angle(c);
[~,ii] = min(abs(z-maxZ));
z = z(1:ii);
Phs = angle(c);
[~,ii] = min(abs(z-maxZ));
z = z(1:ii);
Phs = Phs(1:ii,:);
C = nan(size(Phs,1),length(X));
for i = 1:length(x)
    ixx = find(x(i) == X);
    C(:,ixx) = Phs(:,i);
end
subplot(3,1,2)
imagesc(X,z,C)
title("HV")
colorbar
colormap(cb)
caxis([-4 4])
ylabel("Depth")

% VV
VVdd = dta.VVdd;
z = VVdd(1).Z;
for i = 1:length(VVdd)
    x(i) = VVdd(i).DistCnt;
    c(:,i) = VVdd(i).Signal;
end
Phs = angle(c);
[~,ii] = min(abs(z-maxZ));
z = z(1:ii);
Phs = Phs(1:ii,:);
C = nan(size(Phs,1),length(X));
for i = 1:length(x)
    ixx = find(x(i) == X);
    C(:,ixx) = Phs(:,i);
end
subplot(3,1,3)
imagesc(X,z,C)
title("VV")
colorbar
colormap(cb)
caxis([-4 4])
xlabel("Distance to the center [m]")
ylabel("Depth [m]")













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






