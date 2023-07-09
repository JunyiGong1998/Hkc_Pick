%% Get Data
% m_map package is needed
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
idx=(data.demo>-1).*(floor(data.BAZ_coverage)<=150).*(data.lon<=92);

% update data: leave only the data you want, according to idx
data(~idx,:)=[];

%% Define Parameters
median_tolerance=2;
check_range=0.15;
%% Plot Raw Data
figure(1)
clf
m_proj('Mercator','lat',[25 35],'long',[80 95]);
set(gcf,'color','w') 
% BUG: If setting [colormap('white')] becomes ineffective,
%      try to re-run this script without closing figure panel
colormap('white'); 
m_etopo2('shadedrelief','gradient',6);
m_gshhs_i('patch',[.8 .8 .8]);
m_grid('box','fancy');
[x,y]=m_ll2xy(data.lon,data.lat);
% plot the desired information
scatter(x,y,76,data.tPs,'filled','MarkerEdgeColor','k')
colormap(flipud(cbrewer2('seq','RdYlBu')));
c1=colorbar;
c1.Label.String='Ps Time (s)';
c1.Ruler.TickLabelFormat='%.1f';
%% Plot Diagnosis Data
% interpolation check
F=scatteredInterpolant(data.lon,data.lat,data.tPs,'natural','none');
Fpoints=F.Points;
Fvalue=F.Values;
[l,~]=size(data);
interp_check=zeros(l,1);
%check_range=0.15;
for n=1:l
    loncheck=data.lon(n);
    latcheck=data.lat(n);
    idxcheck=(abs(Fpoints(:,1)-loncheck)<check_range).*(abs(Fpoints(:,2)-latcheck)<check_range);
    if(sum(idxcheck)>=1)
        Fpoints_temp=Fpoints;
        Fpoints_temp(logical(idxcheck),:)=[];
        Fvalue_temp=Fvalue;
        Fvalue_temp(logical(idxcheck),:)=[];
        F.Points=Fpoints_temp;
        F.Values=Fvalue_temp;
        interp_check(n)=abs(F(loncheck,latcheck)-data.tPs(n));
    else
        fprintf('Error in finding idx=%d lon=%0.5f lat=%0.5f.\n\n',n,loncheck,latcheck);
        interp_check(n)=NaN;
    end
end
figure(2)
clf
m_proj('Mercator','lat',[25 35],'long',[80 95]);
set(gcf,'color','w') 
% BUG: If setting [colormap('white')] becomes ineffective,
%      try to re-run this script without closing figure panel
colormap('white'); 
m_etopo2('shadedrelief','gradient',6);
m_gshhs_i('patch',[.8 .8 .8]);
m_grid('box','fancy');
[x,y]=m_ll2xy(data.lon,data.lat);
% plot the desired information
interp_check_norm=interp_check/mean(interp_check,'omitnan');
scatter(x,y,76,interp_check_norm,'filled','MarkerEdgeColor','k')
colormap(flipud(cbrewer2('seq','RdYlBu')));
c2=colorbar;
c2.Label.String='Ps Time Outlier Index';
c2.Ruler.TickLabelFormat='%.1f';

figure(3)
m_proj('Mercator','lat',[25 35],'long',[80 95]);
set(gcf,'color','w') 
colormap('white'); 
m_etopo2('shadedrelief','gradient',6);
m_gshhs_i('patch',[.8 .8 .8]);
m_grid('box','fancy');
%median_tolerance=2;
check_flag=interp_check_norm>median(interp_check_norm,'omitnan')*median_tolerance;
scatter(x(check_flag),y(check_flag),76,interp_check_norm(check_flag),'filled','MarkerEdgeColor','k')
colormap(flipud(cbrewer2('seq','RdYlBu')));
c3=colorbar;
c3.Label.String='Ps Time Outliers Detected';
c3.Ruler.TickLabelFormat = '%.1f';
%% Save Data
fmt='%-6s %-8.4f %-8.4f %-6s %-8.4f\n';
[l,~]=size(data);
projectname='TibetSC';
fileID=fopen(strcat(projectname,'_tPs.dat'),'w');
for n=1:l
    fprintf(fileID,fmt,data.stnm(n),data.lon(n),data.lat(n),data.stnm(n),data.tPs(n));
end
fclose(fileID);