% m_map package is needed
% Merge Tables
fileloc1="E:\SANDWICH_Pick\SANDWICH_auto_Results_Pick\HkcPickAppData\AllHkcPickData.txt";
fileloc=[fileloc1];
data=table();
for m=1:length(fileloc)
    opts=detectImportOptions(fileloc(m));
    opts=setvartype(opts,{'stnm','note'},'string');
    temp=readtable(fileloc(m),opts);
    data=[data;temp];
end

% Filter Data
idx=(data.lon<=88.2).*(data.lon>=85.5).*(data.lat>=30).*(data.lat<=31.8);

% update data: leave only the data you want, according to idx
data(~idx,:)=[];

figure(1)
clf
m_proj('Mercator','lat',[30 32],'long',[85 88]);
set(gcf,'color','w') 
% BUG: If setting [colormap('white')] becomes ineffective,
%      try to re-run this script without closing figure panel
colormap('white'); 
m_etopo2('shadedrelief','gradient',6);
m_gshhs_i('patch',[.8 .8 .8]);
m_grid('box','fancy');
[x,y]=m_ll2xy(data.lon,data.lat);
% plot the desired information
scatter(x,y,76,data.BAZ_coverage,'filled','MarkerEdgeColor','k')
colormap('hsv');
colorbar
