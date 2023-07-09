function NewLine = HkcPick_GetOneTableLine(idx,datasource0,datainfostruct,normconstable)
% Get One Table Line

lim4Hqc=999;    % threshold for H_qc. H_qc>lim4Hqc indicates Hk search fails
lim4Hfail=2;    % threshold for maximum allowable Hk fail numbers.

s=struct;
% Hkc_info
s.sta_idx=idx;
s.stnm=string(datainfostruct.run3.inputHkc.stnm{idx});
s.lon=datainfostruct.run3.inputHkc.lon(idx);
s.lat=datainfostruct.run3.inputHkc.lat(idx);
s.run_idx=NaN;
s.datasource=datasource0;
s.refH=NaN;
s.refkappa=NaN;

%Hkc_result
s.tPs=NaN;
s.PsA1=NaN;
s.PsTheta1=NaN;
s.PsA2=NaN;
s.PsTheta2=NaN;
s.tM1=NaN;
s.M1A1=NaN;
s.M1Theta1=NaN;
s.M1A2=NaN;
s.M1Theta2=NaN;
s.tM2=NaN;
s.M2A1=NaN;
s.M2Theta1=NaN;
s.M2A2=NaN;
s.M2Theta2=NaN;
s.Hbefore=NaN;
s.kappabefore=NaN;
s.Hafter=NaN;
s.kappaafter=NaN;

%Hkc_stability_raw
%tPs
temp=[datainfostruct.run1.harmonics.tPs(idx),datainfostruct.run2.harmonics.tPs(idx),datainfostruct.run3.harmonics.tPs(idx),...
    datainfostruct.run4.harmonics.tPs(idx),datainfostruct.run5.harmonics.tPs(idx)];
s.tPs_stdraw=std(temp,0);
%PsA1
temp=[datainfostruct.run1.harmonics.PsA1(idx),datainfostruct.run2.harmonics.PsA1(idx),datainfostruct.run3.harmonics.PsA1(idx),...
    datainfostruct.run4.harmonics.PsA1(idx),datainfostruct.run5.harmonics.PsA1(idx)];
s.PsA1_stdraw=std(temp,0);
%PsTheta1
temp=[datainfostruct.run1.harmonics.PsTheta1(idx),datainfostruct.run2.harmonics.PsTheta1(idx),datainfostruct.run3.harmonics.PsTheta1(idx),...
    datainfostruct.run4.harmonics.PsTheta1(idx),datainfostruct.run5.harmonics.PsTheta1(idx)];
[degrees_std2,~,rho] = HkcPick_DegreeSTD(temp);
s.PsTheta1_stdraw=degrees_std2;
s.PsTheta1_rhostdraw=rho;
s.PsTheta1_sigmastdraw=sqrt(-2*log(rho));
%PsA2
temp=[datainfostruct.run1.harmonics.PsA2(idx),datainfostruct.run2.harmonics.PsA2(idx),datainfostruct.run3.harmonics.PsA2(idx),...
    datainfostruct.run4.harmonics.PsA2(idx),datainfostruct.run5.harmonics.PsA2(idx)];
s.PsA2_stdraw=std(temp,0);
%PsTheta2
temp=[datainfostruct.run1.harmonics.PsTheta2(idx),datainfostruct.run2.harmonics.PsTheta2(idx),datainfostruct.run3.harmonics.PsTheta2(idx),...
    datainfostruct.run4.harmonics.PsTheta2(idx),datainfostruct.run5.harmonics.PsTheta2(idx)];
[degrees_std2,~,rho] = HkcPick_DegreeSTD(temp);
s.PsTheta2_stdraw=degrees_std2;
s.PsTheta2_rhostdraw=rho;
s.PsTheta2_sigmastdraw=sqrt(-2*log(rho));
%tM1
temp=[datainfostruct.run1.harmonics.tM1(idx),datainfostruct.run2.harmonics.tM1(idx),datainfostruct.run3.harmonics.tM1(idx),...
    datainfostruct.run4.harmonics.tM1(idx),datainfostruct.run5.harmonics.tM1(idx)];
s.tM1_stdraw=std(temp,0);
%M1A1
temp=[datainfostruct.run1.harmonics.M1A1(idx),datainfostruct.run2.harmonics.M1A1(idx),datainfostruct.run3.harmonics.M1A1(idx),...
    datainfostruct.run4.harmonics.M1A1(idx),datainfostruct.run5.harmonics.M1A1(idx)];
s.M1A1_stdraw=std(temp,0);
%M1Theta1
temp=[datainfostruct.run1.harmonics.M1Theta1(idx),datainfostruct.run2.harmonics.M1Theta1(idx),datainfostruct.run3.harmonics.M1Theta1(idx),...
    datainfostruct.run4.harmonics.M1Theta1(idx),datainfostruct.run5.harmonics.M1Theta1(idx)];
[degrees_std2,~,rho] = HkcPick_DegreeSTD(temp);
s.M1Theta1_stdraw=degrees_std2;
s.M1Theta1_rhostdraw=rho;
s.M1Theta1_sigmastdraw=sqrt(-2*log(rho));
%M1A2
temp=[datainfostruct.run1.harmonics.M1A2(idx),datainfostruct.run2.harmonics.M1A2(idx),datainfostruct.run3.harmonics.M1A2(idx),...
    datainfostruct.run4.harmonics.M1A2(idx),datainfostruct.run5.harmonics.M1A2(idx)];
s.M1A2_stdraw=std(temp,0);
%M1Theta2
temp=[datainfostruct.run1.harmonics.M1Theta2(idx),datainfostruct.run2.harmonics.M1Theta2(idx),datainfostruct.run3.harmonics.M1Theta2(idx),...
    datainfostruct.run4.harmonics.M1Theta2(idx),datainfostruct.run5.harmonics.M1Theta2(idx)];
[degrees_std2,~,rho] = HkcPick_DegreeSTD(temp);
s.M1Theta2_stdraw=degrees_std2;
s.M1Theta2_rhostdraw=rho;
s.M1Theta2_sigmastdraw=sqrt(-2*log(rho));
%tM2
temp=[datainfostruct.run1.harmonics.tM2(idx),datainfostruct.run2.harmonics.tM2(idx),datainfostruct.run3.harmonics.tM2(idx),...
    datainfostruct.run4.harmonics.tM2(idx),datainfostruct.run5.harmonics.tM2(idx)];
s.tM2_stdraw=std(temp,0);
%M2A1
temp=[datainfostruct.run1.harmonics.M2A1(idx),datainfostruct.run2.harmonics.M2A1(idx),datainfostruct.run3.harmonics.M2A1(idx),...
    datainfostruct.run4.harmonics.M2A1(idx),datainfostruct.run5.harmonics.M2A1(idx)];
s.M2A1_stdraw=std(temp,0);
%M2Theta1
temp=[datainfostruct.run1.harmonics.M2Theta1(idx),datainfostruct.run2.harmonics.M2Theta1(idx),datainfostruct.run3.harmonics.M2Theta1(idx),...
    datainfostruct.run4.harmonics.M2Theta1(idx),datainfostruct.run5.harmonics.M2Theta1(idx)];
[degrees_std2,~,rho] = HkcPick_DegreeSTD(temp);
s.M2Theta1_stdraw=degrees_std2;
s.M2Theta1_rhostdraw=rho;
s.M2Theta1_sigmastdraw=sqrt(-2*log(rho));
%M2A2
temp=[datainfostruct.run1.harmonics.M2A2(idx),datainfostruct.run2.harmonics.M2A2(idx),datainfostruct.run3.harmonics.M2A2(idx),...
    datainfostruct.run4.harmonics.M2A2(idx),datainfostruct.run5.harmonics.M2A2(idx)];
s.M2A2_stdraw=std(temp,0);
%M2Theta2
temp=[datainfostruct.run1.harmonics.M2Theta2(idx),datainfostruct.run2.harmonics.M2Theta2(idx),datainfostruct.run3.harmonics.M2Theta2(idx),...
    datainfostruct.run4.harmonics.M2Theta2(idx),datainfostruct.run5.harmonics.M2Theta2(idx)];
[degrees_std2,~,rho] = HkcPick_DegreeSTD(temp);
s.M2Theta2_stdraw=degrees_std2;
s.M2Theta2_rhostdraw=rho;
s.M2Theta2_sigmastdraw=sqrt(-2*log(rho));
%H and kappa
temp=[datainfostruct.run1.hkafter.Hqc(idx),datainfostruct.run2.hkafter.Hqc(idx),datainfostruct.run3.hkafter.Hqc(idx),...
    datainfostruct.run4.hkafter.Hqc(idx),datainfostruct.run5.hkafter.Hqc(idx)];
tempH=[datainfostruct.run1.hkafter.H(idx),datainfostruct.run2.hkafter.H(idx),datainfostruct.run3.hkafter.H(idx),...
    datainfostruct.run4.hkafter.H(idx),datainfostruct.run5.hkafter.H(idx)];
tempk=[datainfostruct.run1.hkafter.kappa(idx),datainfostruct.run2.hkafter.kappa(idx),datainfostruct.run3.hkafter.kappa(idx),...
    datainfostruct.run4.hkafter.kappa(idx),datainfostruct.run5.hkafter.kappa(idx)];
tempH(temp>lim4Hqc)=NaN;tempk(temp>lim4Hqc)=NaN;
if(sum(isnan(tempH))<=lim4Hfail)
    s.H_stdraw=std(tempH,'omitnan');
    s.kappa_stdraw=std(tempk,'omitnan');
else
    s.H_stdraw=NaN;
    s.kappa_stdraw=NaN;
end
temp=[datainfostruct.run1.hkbefore.Hqc(idx),datainfostruct.run2.hkbefore.Hqc(idx),datainfostruct.run3.hkbefore.Hqc(idx),...
    datainfostruct.run4.hkbefore.Hqc(idx),datainfostruct.run5.hkbefore.Hqc(idx)];
tempH=[datainfostruct.run1.hkbefore.H(idx),datainfostruct.run2.hkbefore.H(idx),datainfostruct.run3.hkbefore.H(idx),...
    datainfostruct.run4.hkbefore.H(idx),datainfostruct.run5.hkbefore.H(idx)];
tempk=[datainfostruct.run1.hkbefore.kappa(idx),datainfostruct.run2.hkbefore.kappa(idx),datainfostruct.run3.hkbefore.kappa(idx),...
    datainfostruct.run4.hkbefore.kappa(idx),datainfostruct.run5.hkbefore.kappa(idx)];
tempH(temp>lim4Hqc)=NaN;tempk(temp>lim4Hqc)=NaN;
if(sum(isnan(tempH))==5)
    %All plan failed
    s.Hbefore_check=NaN;
    s.kappabefore_check=NaN;
else
    s.Hbefore_check=std(tempH,'omitnan');
    s.kappabefore_check=std(tempk,'omitnan');
end


%stability_norm
s.tPs_stdnorm=s.tPs_stdraw/normconstable.tPs_stdall(1);
s.PsA1_stdnorm=s.PsA1_stdraw/normconstable.PsA1_stdall(1);
s.PsTheta1_stdnorm=s.PsTheta1_stdraw/normconstable.PsTheta1_stdall(1);
s.PsTheta1_rhostdnorm=s.PsTheta1_rhostdraw/normconstable.PsTheta1_rhostdall(1);
s.PsTheta1_sigmastdnorm=s.PsTheta1_sigmastdraw/normconstable.PsTheta1_sigmastdall(1);
s.PsA2_stdnorm=s.PsA2_stdraw/normconstable.PsA2_stdall(1);
s.PsTheta2_stdnorm=s.PsTheta2_stdraw/normconstable.PsTheta2_stdall(1);
s.PsTheta2_rhostdnorm=s.PsTheta2_rhostdraw/normconstable.PsTheta2_rhostdall(1);
s.PsTheta2_sigmastdnorm=s.PsTheta2_sigmastdraw/normconstable.PsTheta2_sigmastdall(1);
s.tM1_stdnorm=s.tM1_stdraw/normconstable.tM1_stdall(1);
s.M1A1_stdnorm=s.M1A1_stdraw/normconstable.M1A1_stdall(1);
s.M1Theta1_stdnorm=s.M1Theta1_stdraw/normconstable.M1Theta1_stdall(1);
s.M1Theta1_rhostdnorm=s.M1Theta1_rhostdraw/normconstable.M1Theta1_rhostdall(1);
s.M1Theta1_sigmastdnorm=s.M1Theta1_sigmastdraw/normconstable.M1Theta1_sigmastdall(1);
s.M1A2_stdnorm=s.M1A2_stdraw/normconstable.M1A2_stdall(1);
s.M1Theta2_stdnorm=s.M1Theta2_stdraw/normconstable.M1Theta2_stdall(1);
s.M1Theta2_rhostdnorm=s.M1Theta2_rhostdraw/normconstable.M1Theta2_rhostdall(1);
s.M1Theta2_sigmastdnorm=s.M1Theta2_sigmastdraw/normconstable.M1Theta2_sigmastdall(1);
s.tM2_stdnorm=s.tM2_stdraw/normconstable.tM2_stdall(1);
s.M2A1_stdnorm=s.M2A1_stdraw/normconstable.M2A1_stdall(1);
s.M2Theta1_stdnorm=s.M2Theta1_stdraw/normconstable.M2Theta1_stdall(1);
s.M2Theta1_rhostdnorm=s.M2Theta1_rhostdraw/normconstable.M2Theta1_rhostdall(1);
s.M2Theta1_sigmastdnorm=s.M2Theta1_sigmastdraw/normconstable.M2Theta1_sigmastdall(1);
s.M2A2_stdnorm=s.M2A2_stdraw/normconstable.M2A2_stdall(1);
s.M2Theta2_stdnorm=s.M2Theta2_stdraw/normconstable.M2Theta2_stdall(1);
s.M2Theta2_rhostdnorm=s.M2Theta2_rhostdraw/normconstable.M2Theta2_rhostdall(1);
s.M2Theta2_sigmastdnorm=s.M2Theta2_sigmastdraw/normconstable.M2Theta2_sigmastdall(1);
s.H_stdnorm=s.H_stdraw/normconstable.H_stdall(1);
s.kappa_stdnorm=s.kappa_stdraw/normconstable.kappa_stdall(1);

%quality_manual
s.BAZ_coverage=NaN;
s.Ps_clarity=NaN;
s.M1_clarity=NaN;
s.M2_clarity=NaN;
s.Ps_Arange=NaN;
s.M1_Arange=NaN;
s.M2_Arange=NaN;
s.H_clustering=NaN;
s.kappa_clustering=NaN;

%apriori
s.tPs_hk=NaN;
s.tM1_hk=NaN;
s.tM2_hk=NaN;
s.dtPs_hkc=NaN;
s.dtM1_hkc=NaN;
s.dtM2_hkc=NaN;
s.M1Psratio_c=NaN;
s.M1Psratio_hk=NaN;
s.dM1Psratio_hkc=NaN;
s.PsM1M2_c=NaN;
s.PsM1M2_hk=NaN;
s.dPsM1M2_hkc=NaN;
s.dH_hkc=NaN;
s.dkappa_hkc=NaN;
s.dH_clustering_auto=NaN;
s.dkappa_clustering_auto=NaN;

%notes
s.Hkcquality=0;
s.rerun=0;
s.demo=0;
s.isnote=0;
s.note="";

NewLine=struct2table(s);

end

