% Merge Tables
fileloc1="E:\INDEPTH_PICK\INDEPTH_Results_Pick\HkcPickAppData\AllHkcPickData.txt";
fileloc2="E:\shietal1_Pick\shietal1_Results_Pick\HkcPickAppData\AllHkcPickData.txt";
fileloc3="E:\HiChim_Pick\HiChim_Results_Pick\HkcPickAppData\AllHkcPickData.txt";
fileloc4="E:\SANDWICH_Pick\SANDWICH_auto_Results_Pick\HkcPickAppData\AllHkcPickData.txt";
fileloc=[fileloc1;fileloc2;fileloc3;fileloc4];
data=table();
for m=1:length(fileloc)
    opts=detectImportOptions(fileloc(m));
    opts=setvartype(opts,{'stnm','note'},'string');
    temp=readtable(fileloc(m),opts);
    data=[data;temp];
end

% Filter Data
idx_after=(data.demo>-1).*(floor(data.BAZ_coverage)<=150).*(data.lon<=92);
idx_before=~isnan(data.Hbefore).*(data.lon<=92.1);

% Output Data
projectname='TibetSC0';
% set output format
fmtHk='%-6s %-8.4f %-8.4f %-6s  %-8.4f %-8.4f\n';
fmtPsTheta2='%-6s %-8.4f %-8.4f %-6s %-8.4f %-8.4f\n';

fileID=fopen(strcat(projectname,'_before.dat'),'w');
[l,~]=size(data);
for n=1:l
    if(idx_before(n))
        fprintf(fileID,fmtHk,data.stnm(n),data.lon(n),data.lat(n),data.stnm(n),data.Hbefore(n),data.kappabefore(n));
    end
end
fclose(fileID);

fileID=fopen(strcat(projectname,'_after.dat'),'w');
for n=1:l
    if(idx_after(n))
        fprintf(fileID,fmtHk,data.stnm(n),data.lon(n),data.lat(n),data.stnm(n),data.Hafter(n),data.kappaafter(n));
    end
end
fclose(fileID);

fileID=fopen(strcat(projectname,'_PsTheta2.dat'),'w');
for n=1:l
    if(idx_after(n))
        fprintf(fileID,fmtPsTheta2,data.stnm(n),data.lon(n),data.lat(n),data.stnm(n),data.PsTheta2(n),data.PsA2(n));
    end
end
fclose(fileID);
