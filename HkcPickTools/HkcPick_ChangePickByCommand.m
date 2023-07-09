HkcPickRaw=readtable('AllHkcPickData.txt');
HkcPickRaw=convertvars(HkcPickRaw,'stnm','string');

stnm=HkcPickRaw.stnm;
chosen_stations=["YS96";"YS93";"YS92";"YS91";"YS90";"YS88";"YS87";"YS86";"YS85"];

idx=contains(stnm,chosen_stations);

HkcPickRaw.demo(idx)=-1;

writetable(HkcPickRaw,'AllHkcPickData.txt')
filebak=strcat('AllHkcPickData',datestr(now,'yymmdd_HHMMss'),'.txt');
copyfile('AllHkcPickData.txt',filebak)
movefile(filebak,'DataBackUp')