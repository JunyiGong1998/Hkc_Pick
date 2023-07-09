function updatedtable = HkcPick_UseDeterminedPlantoUpdate(plan_idx,oldtable,datainfostruct)
% Update HkcPick Record

suffix1=strcat('run',num2str(plan_idx));
lim4Hqc=999;

sta=oldtable.sta_idx(1);
% for inputHkc table
oldtable.run_idx=plan_idx;
temp=getfield(datainfostruct,suffix1,'inputHkc');
oldtable.refH=temp.refH(sta);
oldtable.refkappa=temp.refkappa(sta);
% for harmonics table
temp=getfield(datainfostruct,suffix1,'harmonics');
oldtable.tPs=temp.tPs(sta);
oldtable.PsA1=temp.PsA1(sta);
oldtable.PsTheta1=temp.PsTheta1(sta);
oldtable.PsA2=temp.PsA2(sta);
oldtable.PsTheta2=temp.PsTheta2(sta);
oldtable.tM1=temp.tM1(sta);
oldtable.M1A1=temp.M1A1(sta);
oldtable.M1Theta1=temp.M1Theta1(sta);
oldtable.M1A2=temp.M1A2(sta);
oldtable.M1Theta2=temp.M1Theta2(sta);
oldtable.tM2=temp.tM2(sta);
oldtable.M2A1=temp.M2A1(sta);
oldtable.M2Theta1=temp.M2Theta1(sta);
oldtable.M2A2=temp.M2A2(sta);
oldtable.M2Theta2=temp.M2Theta2(sta);
% for hkbefore table
temp=getfield(datainfostruct,suffix1,'hkbefore');
qc=temp.Hqc(sta);
if(qc>=lim4Hqc)
    oldtable.Hbefore=NaN;
    oldtable.kappabefore=NaN;
else
    oldtable.Hbefore=temp.H(sta);
    oldtable.kappabefore=temp.kappa(sta);
end
temp=getfield(datainfostruct,suffix1,'hkafter');
qc=temp.Hqc(sta);
if(qc>=lim4Hqc)
    oldtable.Hafter=NaN;
    oldtable.kappaafter=NaN;
else
    oldtable.Hafter=temp.H(sta);
    oldtable.kappaafter=temp.kappa(sta);
end

% for a priori
[tPs,tM1,tM2] = HkcPick_TimeSeperation(oldtable.Hafter(1),oldtable.kappaafter(1));
oldtable.tPs_hk=tPs;
oldtable.tM1_hk=tM1;
oldtable.tM2_hk=tM2;
oldtable.dtPs_hkc=tPs-oldtable.tPs(1);
oldtable.dtM1_hkc=tM1-oldtable.tM1(1);
oldtable.dtM2_hkc=tM2-oldtable.tM2(1);

oldtable.M1Psratio_c=oldtable.tM1(1)/oldtable.tPs(1);
oldtable.M1Psratio_hk=tM1/tPs;
oldtable.dM1Psratio_hkc=oldtable.M1Psratio_hk(1)-oldtable.M1Psratio_c(1);

oldtable.PsM1M2_c=oldtable.tPs(1)+oldtable.tM1(1)-oldtable.tM2(1);
oldtable.PsM1M2_hk=tPs+tM1-tM2;
oldtable.dPsM1M2_hkc=oldtable.PsM1M2_hk(1)-oldtable.PsM1M2_c(1);

oldtable.dH_hkc=oldtable.Hafter-oldtable.refH(1);
oldtable.dkappa_hkc=oldtable.kappaafter(1)-oldtable.refkappa(1);

%oldtable.dH_clustering_auto=NaN;
%oldtable.dkappa_clustering_auto=NaN;

updatedtable=oldtable;

end

