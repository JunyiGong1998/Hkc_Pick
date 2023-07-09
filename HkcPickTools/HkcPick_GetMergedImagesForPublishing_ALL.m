%% Read paths for merged Hkc images
% InputPath: Output path of HkcPick_4QuickReview, where subdirectories for 
% merged Hkc images must exist.
InputPath="C:\Users\Administrator\Desktop\test";
PDFname="FigSummary.pdf";
temp=struct2table(dir(InputPath));
temp=convertvars(temp,{'name','folder'},'string');
ImageDir=[];
ImageName=[];
for n=1:size(temp,1)
    if(n==1 || n==2)
        % trim two paths: '.' and '..'
        continue
    end
    if(isfolder(fullfile(temp.folder(n),temp.name(n))))
        ImageDir=[ImageDir;string(fullfile(temp.folder(n),temp.name(n)))];
        ImageName=[ImageName;temp.name(n)];
    end
end
    
%% Set adequate trimming patameters for figures (optimal)
UP=0.01;           % Cutting HA figures
DW=0.72;          % UP,DW,LF,RF >0
LF=0.028;           % UP,DW,LF,RF <=1
RT=0.8;

UPhk=0.07;         % Cutting hk figures
DWhk=0.35;
LFhk=0.035;
RThk=0.38;



for n=1:size(ImageDir,1)
    
    one_dir=ImageDir(n);
    
    ss = get(0,'ScreenSize');
    f=figure(1);
    clf
    pause(0.1)
    f.Position(1:2)=[0 0];
    f.Position(3:4)=[round(800/1080*ss(4)) round(1500/1080*ss(4))];
    t=tiledlayout(4,4);
    t.TileSpacing = 'none';
    t.Padding = 'none';
    %hkbefore
    filename=fullfile(one_dir,ls(fullfile(one_dir,'*_hk_before.png')));
    im_hk_before=imread(filename);
    [a,b,~]=size(im_hk_before);
    nexttile(9,[1 2]);
    imshow(im_hk_before(ceil(UPhk*a):floor(DWhk*a),ceil(LFhk*b):floor(RThk*b),:))
    text(-12,20,'(d)','FontSize',16,'FontWeight','bold','FontName','Times New Roman');
    %hkafter
    filename=fullfile(one_dir,ls(fullfile(one_dir,'*_hk_after.png')));
    im_hk_after=imread(filename);
    [a,b,~]=size(im_hk_after);
    nexttile(13,[1 2]);
    imshow(im_hk_after(ceil(UPhk*a):floor(DWhk*a),ceil(LFhk*b):floor(RThk*b),:))
    text(-12,20,'(e)','FontSize',16,'FontWeight','bold','FontName','Times New Roman');
    %Ps
    filename=fullfile(one_dir,ls(fullfile(one_dir,'*_Ps.png')));
    imPs=imread(filename);
    [a,b,~]=size(imPs);
    nexttile(1,[2 2]);
    imshow(imPs(ceil(UP*a):floor(DW*a),ceil(LF*b):floor(RT*b),:))
    text(-30,60,'(a)','FontSize',16,'FontWeight','bold','FontName','Times New Roman');
    %M1
    filename=fullfile(one_dir,ls(fullfile(one_dir,'*_M1.png')));
    imM1=imread(filename);
    [a,b,~]=size(imM1);
    nexttile(3,[2 2]);
    imshow(imM1(ceil(UP*a):floor(DW*a),ceil(LF*b):floor(RT*b),:))
    text(-30,60,'(b)','FontSize',16,'FontWeight','bold','FontName','Times New Roman');
    %M2
    filename=fullfile(one_dir,ls(fullfile(one_dir,'*_M2.png')));
    imM2=imread(filename);
    [a,b,~]=size(imM2);
    nexttile(11,[2 2]);
    imshow(imM2(ceil(UP*a):floor(DW*a),ceil(LF*b):floor(RT*b),:))
    text(-30,60,'(c)','FontSize',16,'FontWeight','bold','FontName','Times New Roman');
    
    ff=gcf;
    save_path1=fullfile(InputPath,strcat(ImageName(n),'_Summary.pdf'));
    exportgraphics(ff,save_path1,'ContentType','Vector');
    save_path2=fullfile(InputPath,strcat(ImageName(n),'_Summary.png'));
    exportgraphics(ff,save_path2,'Resolution',300);
    
    fprintf('Working on No. %d of %d...\n',n,size(ImageDir,1))
end