function perturbation_normstd = HkcPick_PerturbationByInitCond(Hkcdatadir,Hkcpickdir,runs)
% Perturbation Analysis of Hkc Results with Perturbated Reference H and kappa
% Input Variables:
% Hkcdatadir: Absolute Path of Hkc Result Data
% Hkcpickdir: Absolute Path of Hkc Pick Job, which will be used to save
% figures
% runs: Names of Every Perturbated Hkc Result Folder. [string array] 
% Output Variables:
% perturbation: Standard Deviation of H kappa and t/A1/A2/theta1/theta2 of Ps
% M1 and M2 perturbation, which will be used to do studentization.
%
% Note: Currently Run1 to Run5 is surported. Other cases requires code
% modification.

vars=5*3+2+1;   % 5 HA vars * 3 wave, 2 Hk result, 1 Hk fail info
r=length(runs);
lim4Hqc=999;    % threshold for H_qc. H_qc>lim4Hqc indicates Hk search fails
lim4Hfail=2;    % threshold for maximum allowable Hk fail numbers.

cd(Hkcdatadir);
% Get station numbers
datainfo=ls('*.txt');
% Read datainfo file
try
    lines=readlines(datainfo,"EmptyLineRule","skip");
catch
    errordlg("Error in reading *_Raw.txt file!",'Error Message','error')
end
[stnum,~]=size(lines);
clear lines
% Read all data
data=zeros(stnum,vars,r);
datastrc=struct;
for n=1:r
    suffix1=strcat('run',num2str(n));
    HA_file=strcat(suffix1,'_allHA_results.dat');
    hk_file=strcat(suffix1,'_hk_after_results.out');

%     temp=importdata(strcat(runs(n),filesep,HA_file));
%     readHA_Command=strcat('datastrc.',suffix1,'.harmonics','=temp;');
%     eval(readHA_Command);
%     clear temp
%     temp=importdata(strcat(runs(n),filesep,hk_file));
%     readhk_Command=strcat('datastrc.',suffix1,'.hk','=temp;');
%     eval(readhk_Command);
%     clear temp
%     getHA_Command=strcat('data(:,1:15,',num2str(n),')=datastrc.',suffix1,'.harmonics.data;');
%     gethk_Command1=strcat('temp0=datastrc.',suffix1,'.hk.data;');
%     gethk_Command2='temp=temp0(:,[1 2 4 5]);';
%     gethk_Command3=strcat('data(:,16:19,',num2str(n),')=temp;');
%     eval(getHA_Command);
%     eval(gethk_Command1);
%     eval(gethk_Command2);
%     eval(gethk_Command3); 

    % Read HA results
    datastrc=setfield(datastrc,suffix1,'harmonics',importdata(strcat(runs(n),filesep,HA_file)));
    datastrc=setfield(datastrc,suffix1,'hk',importdata(strcat(runs(n),filesep,hk_file)));
    % Get Data
    data(:,1:15,n)=getfield(datastrc,suffix1,'harmonics','data');
    temp=getfield(datastrc,suffix1,'hk','data');
    data(:,16:19,n)=temp(:,[1 2 4 5]);

end
% assignment

tPs=squeeze(data(:,1,:)); PsA1=squeeze(data(:,2,:)); PsTheta1=squeeze(data(:,3,:)); 
PsA2=squeeze(data(:,4,:)); PsTheta2=squeeze(data(:,5,:));
tM1=squeeze(data(:,6,:)); M1A1=squeeze(data(:,7,:)); M1Theta1=squeeze(data(:,8,:)); 
M1A2=squeeze(data(:,9,:)); M1Theta2=squeeze(data(:,10,:));
tM2=squeeze(data(:,11,:)); M2A1=squeeze(data(:,12,:)); M2Theta1=squeeze(data(:,13,:)); 
M2A2=squeeze(data(:,14,:)); M2Theta2=squeeze(data(:,15,:));
H=squeeze(data(:,16,:)); kappa=squeeze(data(:,17,:)); H_qc=squeeze(data(:,18,:));

H(H_qc>lim4Hqc)=NaN;
kappa(H_qc>lim4Hqc)=NaN;

% Post treatment for Hk
H_std2=zeros(stnum,1);kappa_std2=zeros(stnum,1);
H_res=zeros(stnum,r);kappa_res=zeros(stnum,r);
for n=1:stnum
    count=sum(isnan(H(n,:)));
    if(count<=lim4Hfail)
        H_std2(n)=std(H(n,:),'omitnan');
        kappa_std2(n)=std(kappa(n,:),'omitnan');
        
        H_res(n,:)=H(n,:)-mean(H(n,:),'omitnan');
        kappa_res(n,:)=kappa(n,:)-mean(kappa(n,:),'omitnan');
    else
        H_std2(n)=NaN;
        kappa_std2(n)=NaN;
        
        H_res(n,:)=NaN;
        kappa_res(n,:)=NaN;
    end
end

H_stdall=sqrt(sum(sum(H_res.^2,'omitnan'),'omitnan')/(sum(sum(~isnan(H_res)))-1));
kappa_stdall=sqrt(sum(sum(kappa_res.^2,'omitnan'),'omitnan')/(sum(sum(~isnan(kappa_res)))-1));

%% Plotting for HA
% for t_Ps
tPs_std2=std(tPs,0,2);
tPs_stdall=sqrt(sum(var(tPs,1,2)*r)/(stnum*r-1));   % std of residuals;

h1=figure('visible','off');
subplot(2,1,1)
histogram(tPs_std2)
xlabel('Standard Deviation of Time Separation for Ps-P (s)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(tPs_std2/tPs_stdall)
xlabel('Normalized Standard Deviation of Time Separation for Ps-P')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'PsTime.png'))
close(h1)

% for A1 of Ps
PsA1_std2=std(PsA1,0,2);
PsA1_stdall=sqrt(sum(var(PsA1,1,2)*r)/(stnum*r-1));   % std of residuals;

h1=figure('visible','off');
subplot(2,1,1)
histogram(PsA1_std2)
xlabel('Standard Deviation of A1 for Ps Harmonic Correction (s)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(PsA1_std2/PsA1_stdall)
xlabel('Normalized Standard Deviation of A1 for Ps Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'PsA1.png'))
close(h1)

% for theta1 of Ps
[PsTheta1_std2,PsTheta1_stdall,PsTheta1_rho]=HkcPick_DegreeSTD(PsTheta1);
h1=figure('visible','off');
subplot(3,2,1)
histogram(PsTheta1_std2)
xlabel(["Standard Deviation of \theta1","for Ps Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,2)
histogram(PsTheta1_std2/PsTheta1_stdall)
xlabel(["Normalized Standard Deviation of \theta1","for Ps Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,3)
histogram(PsTheta1_rho)
xlabel('\rho for Ps \theta1 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,4)
histogram(PsTheta1_rho/mean(PsTheta1_rho))
xlabel('Normalized \rho for Ps \theta1 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,5)
histogram(sqrt(max(-2*log(PsTheta1_rho),0)))
xlabel('\sigma for Ps \theta1 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,6)
histogram(sqrt(max(-2*log(PsTheta1_rho),0))/mean(sqrt(max(-2*log(PsTheta1_rho),0))))
xlabel('Normalized \sigma for Ps \theta1 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'PsTheta1.png'))
close(h1)

% for A2 of Ps
PsA2_std2=std(PsA2,0,2);
PsA2_stdall=sqrt(sum(var(PsA2,1,2)*r)/(stnum*r-1));   % std of residuals;

h1=figure('visible','off');
subplot(2,1,1)
histogram(PsA2_std2)
xlabel('Standard Deviation of A2 for Ps Harmonic Correction (s)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(PsA2_std2/PsA2_stdall)
xlabel('Normalized Standard Deviation of A2 for Ps Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'PsA2.png'))
close(h1)

% for Theta2 of Ps
[PsTheta2_std2,PsTheta2_stdall,PsTheta2_rho]=HkcPick_DegreeSTD(PsTheta2);
h1=figure('visible','off');
subplot(3,2,1)
histogram(PsTheta2_std2)
xlabel(["Standard Deviation of \theta2","for Ps Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,2)
histogram(PsTheta2_std2/PsTheta2_stdall)
xlabel(["Normalized Standard Deviation of \theta2","for Ps Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,3)
histogram(PsTheta2_rho)
xlabel('\rho for Ps \theta2 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,4)
histogram(PsTheta2_rho/mean(PsTheta2_rho))
xlabel('Normalized \rho for Ps \theta2 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,5)
histogram(sqrt(max(-2*log(PsTheta2_rho),0)))
xlabel('\sigma for Ps \theta2 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,6)
histogram(sqrt(max(-2*log(PsTheta2_rho),0))/mean(sqrt(max(-2*log(PsTheta2_rho),0))))
xlabel('\sigma for Ps \theta2 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'PsTheta2.png'))
close(h1)

% for t_M1
tM1_std2=std(tM1,0,2);
tM1_stdall=sqrt(sum(var(tM1,1,2)*r)/(stnum*r-1));   % std of residuals;

h1=figure('visible','off');
subplot(2,1,1)
histogram(tM1_std2)
xlabel('Standard Deviation of Time Separation for M1-P (s)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(tM1_std2/tM1_stdall)
xlabel('Normalized Standard Deviation of Time Separation for M1-P')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M1Time.png'))
close(h1)

% for A1 of M1
M1A1_std2=std(M1A1,0,2);
M1A1_stdall=sqrt(sum(var(M1A1,1,2)*r)/(stnum*r-1));   % std of residuals;

h1=figure('visible','off');
subplot(2,1,1)
histogram(M1A1_std2)
xlabel('Standard Deviation of A1 for M1 Harmonic Correction (s)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(M1A1_std2/M1A1_stdall)
xlabel('Normalized Standard Deviation of A1 for M1 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M1A1.png'))
close(h1)

% for theta1 of M1
[M1Theta1_std2,M1Theta1_stdall,M1Theta1_rho]=HkcPick_DegreeSTD(M1Theta1);
h1=figure('visible','off');
subplot(3,2,1)
histogram(M1Theta1_std2)
xlabel(["Standard Deviation of \theta1","for M1 Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,2)
histogram(M1Theta1_std2/M1Theta1_stdall)
xlabel(["Normalized Standard Deviation of \theta1","for M1 Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,3)
histogram(M1Theta1_rho)
xlabel('\rho for M1 \theta1 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,4)
histogram(M1Theta1_rho/mean(M1Theta1_rho))
xlabel('Normalized \rho for M1 \theta1 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,5)
histogram(sqrt(max(-2*log(M1Theta1_rho),0)))
xlabel('\sigma for M1 \theta1 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,6)
histogram(sqrt(max(-2*log(M1Theta1_rho),0))/mean(sqrt(max(-2*log(M1Theta1_rho),0))))
xlabel('Normalized \sigma for M1 \theta1 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M1Theta1.png'))
close(h1)

% for A2 of M1
M1A2_std2=std(M1A2,0,2);
M1A2_stdall=sqrt(sum(var(M1A2,1,2)*r)/(stnum*r-1));   % std of residuals;

h1=figure('visible','off');
subplot(2,1,1)
histogram(M1A2_std2)
xlabel('Standard Deviation of A2 for M1 Harmonic Correction (s)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(M1A2_std2/M1A2_stdall)
xlabel('Normalized Standard Deviation of A2 for M1 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M1A2.png'))
close(h1)

% for Theta2 of M1
[M1Theta2_std2,M1Theta2_stdall,M1Theta2_rho]=HkcPick_DegreeSTD(M1Theta2);
h1=figure('visible','off');
subplot(3,2,1)
histogram(M1Theta2_std2)
xlabel(["Standard Deviation of \theta2","for M1 Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,2)
histogram(M1Theta2_std2/M1Theta2_stdall)
xlabel(["Normalized Standard Deviation of \theta2","for M1 Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,3)
histogram(M1Theta2_rho)
xlabel('\rho for M1 \theta2 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,4)
histogram(M1Theta2_rho/mean(M1Theta2_rho))
xlabel('Normalized \rho for M1 \theta2 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,5)
histogram(sqrt(max(-2*log(M1Theta2_rho),0)))
xlabel('\sigma for M1 \theta2 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,6)
histogram(sqrt(max(-2*log(M1Theta2_rho),0))/mean(sqrt(max(-2*log(M1Theta2_rho),0))))
xlabel('Normalized \sigma for M1 \theta2 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M1Theta2.png'))
close(h1)

% for t_M2
tM2_std2=std(tM2,0,2);
tM2_stdall=sqrt(sum(var(tM2,1,2)*r)/(stnum*r-1));   % std of residuals;

h1=figure('visible','off');
subplot(2,1,1)
histogram(tM2_std2)
xlabel('Standard Deviation of Time Separation for M2-P (s)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(tM2_std2/tM2_stdall)
xlabel('Normalized Standard Deviation of Time Separation for M2-P')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M2Time.png'))
close(h1)

% for A1 of M2
M2A1_std2=std(M2A1,0,2);
M2A1_stdall=sqrt(sum(var(M2A1,1,2)*r)/(stnum*r-1));   % std of residuals;

h1=figure('visible','off');
subplot(2,1,1)
histogram(M2A1_std2)
xlabel('Standard Deviation of A1 for M2 Harmonic Correction (s)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(M2A1_std2/M2A1_stdall)
xlabel('Normalized Standard Deviation of A1 for M2 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M2A1.png'))
close(h1)

% for theta1 of M2
[M2Theta1_std2,M2Theta1_stdall,M2Theta1_rho]=HkcPick_DegreeSTD(M2Theta1);
h1=figure('visible','off');
subplot(3,2,1)
histogram(M2Theta1_std2)
xlabel(["Standard Deviation of \theta1","for M2 Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,2)
histogram(M2Theta1_std2/M2Theta1_stdall)
xlabel(["Normalized Standard Deviation of \theta1","for M2 Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,3)
histogram(M2Theta1_rho)
xlabel('\rho for M2 \theta1 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,4)
histogram(M2Theta1_rho/mean(M2Theta1_rho))
xlabel('Normalized \rho for M2 \theta1 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,5)
histogram(sqrt(max(-2*log(M2Theta1_rho),0)))
xlabel('\sigma for M2 \theta1 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,6)
histogram(sqrt(max(-2*log(M2Theta1_rho),0))/mean(sqrt(max(-2*log(M2Theta1_rho),0))))
xlabel('Normalized \sigma for M2 \theta1 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M2Theta1.png'))
close(h1)

% for A2 of M2
M2A2_std2=std(M2A2,0,2);
M2A2_stdall=sqrt(sum(var(M2A2,1,2)*r)/(stnum*r-1));   % std of residuals;

h1=figure('visible','off');
subplot(2,1,1)
histogram(M2A2_std2)
xlabel('Standard Deviation of A2 for M2 Harmonic Correction (s)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(M2A2_std2/M2A2_stdall)
xlabel('Normalized Standard Deviation of A2 for M2 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M2A2.png'))
close(h1)

% for Theta2 of M2
[M2Theta2_std2,M2Theta2_stdall,M2Theta2_rho]=HkcPick_DegreeSTD(M2Theta2);
h1=figure('visible','off');
subplot(3,2,1)
histogram(M2Theta2_std2)
xlabel(["Standard Deviation of \theta2","for M2 Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,2)
histogram(M2Theta2_std2/M2Theta2_stdall)
xlabel(["Normalized Standard Deviation of \theta2","for M2 Harmonic Correction (\circ)"])
ylabel('Station Counts')
subplot(3,2,3)
histogram(M2Theta2_rho)
xlabel('\rho for M2 \theta2 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,4)
histogram(M2Theta2_rho/mean(M2Theta2_rho))
xlabel('Normalized \rho for M2 \theta2 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,5)
histogram(sqrt(max(-2*log(M2Theta2_rho),0)))
xlabel('\sigma for M2 \theta2 Harmonic Correction')
ylabel('Station Counts')
subplot(3,2,6)
histogram(sqrt(max(-2*log(M2Theta2_rho),0))/mean(sqrt(max(-2*log(M2Theta2_rho),0))))
xlabel('Normalized \sigma for M2 \theta2 Harmonic Correction')
ylabel('Station Counts')
saveas(gcf,strcat(Hkcpickdir,filesep,'M2Theta2.png'))
close(h1)

%% Plotting for Hk
h1=figure('visible','off');
subplot(2,1,1)
histogram(H_std2)
xlabel('Standard Deviation for Crust Thickness H (km)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(H_std2/H_stdall)
xlabel('Normalized Standard Deviation for Crust Thickness H (km)')
ylabel('Station Counts')
title('all stations')
saveas(gcf,strcat(Hkcpickdir,filesep,'H_all.png'))
close(h1)

h1=figure('visible','off');
subplot(2,1,1)
histogram(kappa_std2)
xlabel('Standard Deviation for Vp/Vs ratio \kappa')
ylabel('Station Counts')
subplot(2,1,2)
histogram(kappa_std2/kappa_stdall)
xlabel('Normalized Standard Deviation for Vp/Vs ratio \kappa')
ylabel('Station Counts')
title('all stations')
saveas(gcf,strcat(Hkcpickdir,filesep,'kappa_all.png'))
close(h1)

h1=figure('visible','off');
subplot(2,1,1)
H_normstd=H_std2/H_stdall;
histogram(H_std2(H_normstd<=4))
xlabel('Standard Deviation for Crust Thickness H (km)')
ylabel('Station Counts')
subplot(2,1,2)
histogram(H_normstd(H_normstd<=4))
xlabel('Normalized Standard Deviation for Crust Thickness H (km)')
ylabel('Station Counts')
title('4 sigma stations')
saveas(gcf,strcat(Hkcpickdir,filesep,'H_4sig.png'))
close(h1)

h1=figure('visible','off');
subplot(2,1,1)
kappa_normstd=kappa_std2/kappa_stdall;
histogram(kappa_std2(kappa_normstd<=4))
xlabel('Standard Deviation for Vp/Vs ratio \kappa')
ylabel('Station Counts')
subplot(2,1,2)
histogram(kappa_normstd(kappa_normstd<=4))
xlabel('Normalized Standard Deviation for Vp/Vs ratio \kappa')
ylabel('Station Counts')
title('4 sigma stations')
saveas(gcf,strcat(Hkcpickdir,filesep,'kappa_4sig.png'))
close(h1)

%% Get Output
perturbation_normstd_names=[...
    "tPs_stdall", ...
    "PsA1_stdall","PsTheta1_stdall","PsTheta1_rhostdall","PsTheta1_sigmastdall", ...
    "PsA2_stdall","PsTheta2_stdall","PsTheta2_rhostdall","PsTheta2_sigmastdall",...
    "tM1_stdall", ...
    "M1A1_stdall","M1Theta1_stdall","M1Theta1_rhostdall","M1Theta1_sigmastdall",...
    "M1A2_stdall","M1Theta2_stdall","M1Theta2_rhostdall","M1Theta2_sigmastdall",...
    "tM2_stdall",...
    "M2A1_stdall","M2Theta1_stdall","M2Theta1_rhostdall","M2Theta1_sigmastdall",...
    "M2A2_stdall","M2Theta2_stdall","M2Theta2_rhostdall","M2Theta2_sigmastdall",...
    "H_stdall","kappa_stdall"];

perturbation_normstd=array2table([...
    tPs_stdall ...
    PsA1_stdall PsTheta1_stdall mean(PsTheta1_rho) mean(sqrt(-2*log(PsTheta1_rho))) ...
    PsA2_stdall PsTheta2_stdall mean(PsTheta2_rho) mean(sqrt(-2*log(PsTheta2_rho))) ...
    tM1_stdall ...
    M1A1_stdall M1Theta1_stdall mean(M1Theta1_rho) mean(sqrt(-2*log(M1Theta1_rho))) ...
    M1A2_stdall M1Theta2_stdall mean(M1Theta2_rho) mean(sqrt(-2*log(M1Theta2_rho))) ...
    tM2_stdall ...
    M2A1_stdall M2Theta1_stdall mean(M2Theta1_rho) mean(sqrt(-2*log(M2Theta1_rho))) ...
    M2A2_stdall M2Theta2_stdall mean(M2Theta2_rho) mean(sqrt(-2*log(M2Theta2_rho))) ...
    H_stdall kappa_stdall],'VariableNames',perturbation_normstd_names);
end

