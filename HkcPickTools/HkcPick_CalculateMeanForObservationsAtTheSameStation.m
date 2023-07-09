HkcResultsRaw=readtable('TibetSC0_before.dat');
HkcResultsRaw=convertvars(HkcResultsRaw,{'Var1','Var4'},'string');

% set output format and output filename
filename_out='TibetSC_before.dat';
fmtHk='%-6s %-8.4f %-8.4f %-6s  %-8.4f %-8.4f\n';
fmtPsTheta2='%-6s %-8.4f %-8.4f %-6s %-8.4f %-8.4f\n';

%Processing
HkcResultsNew=table();
unique_stations=unique(HkcResultsRaw.Var1);

for n=1:length(unique_stations)
    strpat=unique_stations(n);
    hits=matches(HkcResultsRaw.Var1,strpat);
    if(sum(hits)==1)
        HkcResultsNew=[HkcResultsNew;HkcResultsRaw(hits,:)];
    elseif(sum(hits)>1)
        onecheck=HkcResultsRaw(hits,:);
        loncheck=uniquetol(onecheck.Var2,1e-3/max(abs(onecheck.Var2)));
        latcheck=uniquetol(onecheck.Var3,1e-3/max(abs(onecheck.Var3)));
        if(length(loncheck)==1 && length(latcheck)==1)
            %Unique Location
            newtableline=onecheck(1,:);
            newtableline.Var2=mean(onecheck.Var2);
            newtableline.Var3=mean(onecheck.Var3);
            newtableline.Var5=mean(onecheck.Var5);
            newtableline.Var6=mean(onecheck.Var6);
            %Merge Table
            HkcResultsNew=[HkcResultsNew;newtableline];
            fprintf('%d for %s.\n',sum(hits),strpat);
        else
            fprintf('More than 1 location for %s! Please check!\n',strpat);
        end
        clear onecheck latcheck loncheck newtableline
    else
        fprintf('Error in calculating hits!');
    end
end

%Output
fileID=fopen(filename_out,'w');
[l,~]=size(HkcResultsNew);
for n=1:l
    fprintf(fileID,fmtHk,HkcResultsNew.Var1(n),HkcResultsNew.Var2(n),...
                         HkcResultsNew.Var3(n),HkcResultsNew.Var4(n),...
                         HkcResultsNew.Var5(n),HkcResultsNew.Var6(n));
end
fclose(fileID);