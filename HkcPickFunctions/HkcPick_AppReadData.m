function hkc_result = HkcPick_AppReadData(Hkcdatadir,runs)
% Read Data for Hkc-Pick App
% Input:
% Hkcdatadir: Absolute Path of Hkc Result Data
% runs: Names of Every Perturbated Hkc Result Folder. [string array] 
% Output:
% hkc_result: A Structure Array that Contains all Hkc Results.
%   (Data are imported as table)

cd(Hkcdatadir);
HA_rename_old=["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9","Var10",...
    "Var11","Var12","Var13","Var14","Var15","Var16"];
HA_rename_new=["stnm","tPs","PsA1","PsTheta1","PsA2","PsTheta2","tM1","M1A1","M1Theta1","M1A2",...
    "M1Theta2","tM2","M2A1","M2Theta1","M2A2","M2Theta2"];
hk_rename_old=["Var1","Var2","Var3","Var5"];
hk_rename_new=["stnm","H","kappa","Hqc"];
input_rename_old=["Var1","Var2","Var3","Var7","Var9"];
input_rename_new=["stnm","lat","lon","refH","refkappa"];
hk_remove=["Var4","Var6","Var7","Var8","Var9"];
input_remove=["Var4","Var5","Var6","Var8","Var10","Var11"];
r=length(runs);

datastrc=struct;
hkc_result=struct;
for n=1:r
    suffix1=strcat('run',num2str(n));
    HA_file=strcat(suffix1,'_allHA_results.dat');
    hk_after_file=strcat(suffix1,'_hk_after_results.out');
    hk_before_file=strcat(suffix1,'_hk_before_results.out');
    input_file=strcat(runs(n),'.dat');
    % Read HA results
    opts = detectImportOptions(strcat(runs(n),filesep,HA_file),'ReadVariableNames',false,'Delimiter',{' '},'ConsecutiveDelimitersRule','join','FileType','Text');
    datastrc=setfield(datastrc,suffix1,'harmonics',readtable(strcat(runs(n),filesep,HA_file),opts));
    % Read Hk results
    opts = detectImportOptions(strcat(runs(n),filesep,hk_after_file),'ReadVariableNames',false,'Delimiter',{' '},'ConsecutiveDelimitersRule','join','FileType','Text');
    datastrc=setfield(datastrc,suffix1,'hkafter',readtable(strcat(runs(n),filesep,hk_after_file),opts));
    opts = detectImportOptions(strcat(runs(n),filesep,hk_before_file),'ReadVariableNames',false,'Delimiter',{' '},'ConsecutiveDelimitersRule','join','FileType','Text');
    datastrc=setfield(datastrc,suffix1,'hkbefore',readtable(strcat(runs(n),filesep,hk_before_file),opts));
    opts = detectImportOptions(strcat(runs(n),filesep,input_file),'ReadVariableNames',false,'Delimiter',{' '},'ConsecutiveDelimitersRule','join','FileType','Text');
    datastrc=setfield(datastrc,suffix1,'inputHkc',readtable(strcat(runs(n),filesep,input_file),opts));
    % Generate Structure Array of Desired Variables
    hkc_result=setfield(hkc_result,suffix1,'harmonics',...
                        renamevars(getfield(datastrc,suffix1,'harmonics'),HA_rename_old,HA_rename_new));
    hkc_result=setfield(hkc_result,suffix1,'hkafter',...
                        removevars(renamevars(getfield(datastrc,suffix1,'hkafter'),hk_rename_old,hk_rename_new),hk_remove));
    hkc_result=setfield(hkc_result,suffix1,'hkbefore',...
                        removevars(renamevars(getfield(datastrc,suffix1,'hkbefore'),hk_rename_old,hk_rename_new),hk_remove));
    hkc_result=setfield(hkc_result,suffix1,'inputHkc',...
                        removevars(renamevars(getfield(datastrc,suffix1,'inputHkc'),input_rename_old,input_rename_new),input_remove));
    % Merge According to stnm
    
end


% for n=1:r
%     suffix1=strcat('run',num2str(n));
%     HA_file=strcat(suffix1,'_allHA_results.dat');
%     hk_after_file=strcat(suffix1,'_hk_after_results.out');
%     hk_before_file=strcat(suffix1,'_hk_before_results.out');
%     % Read HA results
%     temp=readtable(srtcat(runs(n),filesep,HA_file),'FileType','Text');
%     readHA_Command=strcat('datastrc.',suffix1,'.harmonics','=temp');
%     eval(readHA_Command);
%     clear temp
%     
%     temp=readtable(strcat(runs(n),filesep,hk_after_file),'FileType','Text');
%     readhkafter_Command=strcat('datastrc.',suffix1,'.hkafter','=temp');
%     eval(readhkafter_Command);
%     clear temp
%     
%     temp=readtable(strcat(runs(n),filesep,hk_before_file),'FileType','Text');
%     readhkbefore_Command=strcat('datastrc.',suffix1,'.hkbefore','=temp');
%     eval(readhkbefore_Command);
%     clear temp
%     
%     % Rename and Remove table
%     renameHA_Command=strcat('hkc_result.',suffix1,'.harmonics','=renamevars(','datastrc.',suffix1,'.harmonics,HA_rename0,HA_rename1);');
%     rename_removehkafter_Command=strcat('hkc_result.',suffix1,'.hkafter','=removevars(renamevars(','datastrc.',suffix1,'.hkafter,hk_rename0,hk_rename1),hk_remove);');
%     rename_removehkbefore_Command=strcat('hkc_result.',suffix1,'.hkbefore','=removevars(renamevars(','datastrc.',suffix1,'.hkbefore,hk_rename0,hk_rename1),hk_remove);');
%     eval(renameHA_Command);
%     eval(rename_removehkafter_Command);
%     eval(rename_removehkbefore_Command);
% end
% 
% end

