%% programme that shows parametric maps

%% load subjects file

subjects = importdata('/home/c25078236/Desktop/WAND_data/subjects.txt');
subjects(subjects==42565)=[];%subj that does not have mprage
subjects(subjects==19230)=[];%subj that does not have b0
subjects(subjects==20609)=[];%subj that does not have M0
subjects(subjects==69881)=[];%subj that does not have SANDI MAPS
n_subjs=length(subjects);
start_subj=1;

%% parameters to tune
subj=10;%subj 10 scelto per l'articolo.
cmro2_upper_limit=100;

%%
V_CMRO2_subj=V_CMRO2_maps{subj};
V_fc_subj=V_fc_maps{subj};
V_fsup_subj=V_fsup_maps{subj};

figure,
ax1=subplot(1,3,1);
imagesc(rot90(V_CMRO2_subj(:,:,8)))
title("CMRO_2",'FontSize',12)
colormap(ax1,parula)
cb=colorbar();
ylabel(cb,'\mumol/100g/min','FontSize',12,'Rotation',270,'FontWeight','bold')
caxis([0,cmro2_upper_limit]);
set(ax1,'xTickLabel',{},'yTickLabel',{})

ax2=subplot(1,3,2);
imagesc(rot90(V_fc_subj(:,:,33)))
title("f_{c}",'FontSize',12)
colormap(ax2,jet)
cb=colorbar();
ylabel(cb,'m^{-3}','FontSize',12,'Rotation',270,'FontWeight','bold')
%caxis([0,300]);
set(ax2,'xTickLabel',{},'yTickLabel',{})

ax3=subplot(1,3,3);
imagesc(rot90(V_fsup_subj(:,:,33)))
title("f_{sup}",'FontSize',12)
colormap(ax3,turbo)
cb=colorbar();
ylabel(cb,'m^{-1}','FontSize',12,'Rotation',270,'FontWeight','bold')
%caxis([0,300]);
set(ax3,'xTickLabel',{},'yTickLabel',{})

%% Plot maps in MNI space



%% load parametric images

V_cmro2_maps={};

for i = 1:n_subjs         
    subj = subjects(i);
    % subj=subj{1};
    subj = num2str(subj);

    if numel(subj)==4
        subj=strcat('0',subj);
    else
        subj=subj;
    end

    img_path_cmro2=strcat('/home/c25078236/Desktop/WAND_data/FUNC/CMRO2_toMNI/sub-',subj,'_cmro2_est_toMNI.nii.gz');

    V_vol_cmro2 = spm_vol(img_path_cmro2);
    V_cmro2=spm_read_vols(V_vol_cmro2);
    V_cmro2_maps{end+1}=V_cmro2;
end

%% plot maps for all subjects

% idx_to_remove = [1,4,9,21];
% for i = 1:numel(idx_to_remove)
%     V_cmro2_maps{idx_to_remove(i)}=[];
% end
% c = V_cmro2_maps(~cellfun('isempty',V_cmro2_maps));
% V_cmro2_maps=c;

figure,
for i = 1:numel(V_cmro2_maps)
    subplot(6,5,i);
    V_cmro2 = V_cmro2_maps{i};
    imagesc(rot90(V_cmro2(:,:,7)))
    clim([0,200])
    title(strcat('sub-',num2str(i)))
    cb=colorbar();
end
sgtitle('CMRO_{2} in subject space','FontWeight','bold') %change title accordingly
% all_cmro2_maps_subjs = cat(4,V_cmro2_maps{:});
% median_cmro2_maps_subjs = nanmedian(all_cmro2_maps_subjs,4);
% 
% figure, 
% imagesc(rot90(median_cmro2_maps_subjs(:,:,45)))
% clim([0,180])

% figure,
% V_one_subj = V_cmro2_maps{25};
% imagesc(rot90(V_one_subj(:,:,45)))

%%
img_path_T1MNI='/cubric/software/fsl.versions/6.0.5/data/standard/MNI152_T1_2mm_brain.nii.gz';

V_vol_T1MNI = spm_vol(img_path_T1MNI);
V_T1MNI=spm_read_vols(V_vol_T1MNI);

%% load fsoma and rsoma
V_fsoma_maps={};
V_rsoma_maps={};

for i=1:n_subjs

    img_path_fsoma=strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS_toMNI/sub-',subj,'/SANDI-fit_fsomatoMNI.nii.gz');
    img_path_rsoma=strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS_toMNI/sub-',subj,'/SANDI-fit_RsomatoMNI.nii.gz');

    V_vol_fsoma = spm_vol(img_path_fsoma);
    V_fsoma=spm_read_vols(V_vol_fsoma);
    V_fsoma_maps{end+1}=V_fsoma;


    V_vol_rsoma = spm_vol(img_path_rsoma);
    V_rsoma=spm_read_vols(V_vol_rsoma);
    V_rsoma_maps{end+1}=V_rsoma;

end

%% calculate fsup
V_fsup_maps={};

for i = 1:n_subjs    

    V_rsoma = V_rsoma_maps{i};
    V_fsoma = V_fsoma_maps{i};

    for i = 1:length(V_rsoma(:))
        if V_rsoma(i) < 5
            V_rsoma(i)=0;
        end
    end
    
    %convert to m^3
    V_rsoma = V_rsoma.*10^-6;    

    %voxel wise divide fs map over 4/3pir^3
    fsup_map = V_fsoma./V_rsoma;
    fsup_map = 3*fsup_map;
    for i = 1:length(fsup_map(:))
        if fsup_map(i)==Inf
            fsup_map(i)=NaN;
        end
    end

    V_fsup_maps{end+1} = fsup_map;

end

V_fsup_one=V_fsup_maps{1};%.*10^(-6);
figure, imagesc(rot90(V_fsup_one(:,:,40)));
title('Superficial Soma Density map')

%% calculate fc

V_fc_maps={};

for i = 1:n_subjs    
    V_rsoma = V_rsoma_maps{i};
    V_fsoma = V_fsoma_maps{i};

    
    for i = 1:length(V_rsoma(:))
        if V_rsoma(i) < 5
            V_rsoma(i)=0;
        end
    end
    
    
    %convert to m^3
    V_rsoma = V_rsoma.*10^-6;
    
    %voxel wise divide fs map over 4/3pir^3
    fc_map = V_fsoma./((4/3)*pi*V_rsoma.^3);
    %figure, imagesc(fc_map(:,:,45));
    for i = 1:length(fc_map(:))
        if fc_map(i)==Inf
            fc_map(i)=NaN;%VALUTA SE METTERE A 0.
    %     elseif isnan(fc_map(i))
    %         fc_map(i)=0;
        end
    end

    V_fc_maps{end+1} = fc_map;

end

V_fc_one=V_fc_maps{1};%.*10^(-6);
figure, imagesc(rot90(V_fc_one(:,:,40)));
title('Numerical Soma Density map')


%%
all_cmro2_maps_subjs = cat(4,V_cmro2_maps{:});
median_cmro2_maps_subjs = nanmedian(all_cmro2_maps_subjs,4);

% all_cmro2_maps_subjs = cat(4,V_cmro2_maps{:});
% mean_cmro2_maps_subjs = nanmean(all_cmro2_maps_subjs,4);

all_fsup_maps_subjs = cat(4,V_fsup_maps{:});
median_fsup_maps_subjs = nanmedian(all_fsup_maps_subjs,4);

all_fc_maps_subjs = cat(4,V_fc_maps{:});
median_fc_maps_subjs = nanmedian(all_fc_maps_subjs,4);

all_fsoma_maps_subjs = cat(4,V_fsoma_maps{:});
median_fsoma_maps_subjs = nanmedian(all_fsoma_maps_subjs,4);




figure, 
imagesc(rot90(median_cmro2_maps_subjs(:,:,45)))
clim([0,180])

figure, 
imagesc(rot90(mean_cmro2_maps_subjs(:,:,45)))
clim([0,180])
% hold on
% imagesc(rot90(V_T1MNI(:,:,45)))

% figure,
% imagesc(rot90(V_T1MNI(:,:,45)))
% hold on
% imagesc(rot90(median_cmro2_maps_subjs(:,:,45)))
% clim([0,200])

%% save nifti images
img_path_T1MNI='/cubric/software/fsl.versions/6.0.5/data/standard/MNI152_T1_2mm_brain.nii.gz';
hdr=niftiinfo(img_path_T1MNI);
hdr.Datatype = 'double';
hdr.ImageSize = size(median_cmro2_maps_subjs);

niftiwrite(median_cmro2_maps_subjs,'/home/c25078236/Desktop/WAND_data/median_maps_MNI/median_cmro2.nii.gz',hdr,"Compressed",true);
niftiwrite(median_fsoma_maps_subjs,'/home/c25078236/Desktop/WAND_data/median_maps_MNI/median_fsoma.nii.gz',hdr,"Compressed",true);
niftiwrite(median_fsup_maps_subjs,'/home/c25078236/Desktop/WAND_data/median_maps_MNI/median_fsup.nii.gz',hdr,"Compressed",true);
niftiwrite(median_fc_maps_subjs,'/home/c25078236/Desktop/WAND_data/median_maps_MNI/median_fc.nii.gz',hdr,"Compressed",true);
