%% This programme compute parametric medians to be analyzed in analyze_medians.m

%% select which type of masking apply
rois = 'not complete'; %without any kind of masking, otherwise choose 'complete'  
masking = 'GM'; %masking only by GM, otherwise choose 'all'
mse_threshold = 'yes';
mse_threshold_value=85;

%pve_1 = GM,
%pve_0 = CSF,
%pve_2 = WM.
%% select binary masks thresholds
pve_1_threshold=0.5;

fsoma_threshold=0.15;
%%
%change these thresholds values between 0.1 and 1
pve_0_threshold_func=1;%threshold before which the CSF is set to 0
pve_2_threshold_func=1;
pve_0_threshold_dwi=0.3;%
pve_2_threshold_dwi=1;%

%% set rsoma limit for fc and fsup calculation
rsoma_upper_limit=7; %7 micrometer is good for WAND data.%11.1 for Chieti

%% load data
% load subjs idx
%run='run-01';
subjects = importdata(strcat('/home/c25078236/Desktop/WAND_data/subjects.txt'));
subjects(subjects==42565)=[];%subj that does not have mprage
subjects(subjects==19230)=[];%subj that does not have b0
subjects(subjects==20609)=[];%subj that does not have M0
subjects(subjects==69881)=[];%subj that does not have SANDI MAPS
n_subjs=length(subjects);
start_subj=1;
%%
%load pve on subj space
V_pves_0_dwi={};
V_pves_1_dwi={};
V_pves_2_dwi={};
V_pves_0_func={};
V_pves_1_func={};
V_pves_2_func={};

for i = start_subj:n_subjs
    
    subj = subjects(i);
    subj=num2str(subj);
    if numel(subj)==4
        subj=strcat('0',subj);
    else
        subj=subj;
    end

    % img_path_pve_dwi=strcat('/media/nas_rete/Vitality/maps2SUBJSPACE/dwi/pve_on_b0/',subj,'_',run,'_PVE_1_on_b0.nii.gz');
    % img_path_pve_func=strcat('/media/nas_rete/Vitality/maps2SUBJSPACE/func/pve_on_M0/',subj,'_',run,'_PVE_1_on_M0.nii.gz');
    img_path_pve_0_dwi=strcat('/home/c25078236/Desktop/WAND_data/ANAT/pve_coregistered/pve_on_b0/sub-',subj,'_pve0_on_b0.nii.gz');
    img_path_pve_0_func=strcat('/home/c25078236/Desktop/WAND_data/ANAT/pve_coregistered/pve_on_M0/sub-',subj,'_pve0_on_M0.nii.gz');

    img_path_pve_1_dwi=strcat('/home/c25078236/Desktop/WAND_data/ANAT/pve_coregistered/pve_on_b0/sub-',subj,'_pve1_on_b0.nii.gz');
    img_path_pve_1_func=strcat('/home/c25078236/Desktop/WAND_data/ANAT/pve_coregistered/pve_on_M0/sub-',subj,'_pve1_on_M0.nii.gz');
 
    img_path_pve_2_dwi=strcat('/home/c25078236/Desktop/WAND_data/ANAT/pve_coregistered/pve_on_b0/sub-',subj,'_pve2_on_b0.nii.gz');
    img_path_pve_2_func=strcat('/home/c25078236/Desktop/WAND_data/ANAT/pve_coregistered/pve_on_M0/sub-',subj,'_pve2_on_M0.nii.gz');

    V_vol_pve_dwi = spm_vol(img_path_pve_0_dwi);
    V_pve_dwi=spm_read_vols(V_vol_pve_dwi);
    V_pves_0_dwi{end+1}=V_pve_dwi;

    V_vol_pve_dwi = spm_vol(img_path_pve_1_dwi);
    V_pve_dwi=spm_read_vols(V_vol_pve_dwi);
    V_pves_1_dwi{end+1}=V_pve_dwi;

    V_vol_pve_dwi = spm_vol(img_path_pve_2_dwi);
    V_pve_dwi=spm_read_vols(V_vol_pve_dwi);
    V_pves_2_dwi{end+1}=V_pve_dwi;
    
    V_vol_pve_func = spm_vol(img_path_pve_0_func);
    V_pve_func=spm_read_vols(V_vol_pve_func);
    V_pves_0_func{end+1}=V_pve_func;

    V_vol_pve_func = spm_vol(img_path_pve_1_func);
    V_pve_func=spm_read_vols(V_vol_pve_func);
    V_pves_1_func{end+1}=V_pve_func;

    V_vol_pve_func = spm_vol(img_path_pve_2_func);
    V_pve_func=spm_read_vols(V_vol_pve_func);
    V_pves_2_func{end+1}=V_pve_func;

end

%% plot pves to check

% V_pves_0_dwi_first=V_pves_0_dwi{1};
% % figure, imagesc(V_pves_0_dwi_first(:,:,45))
% 
% thr=0.1;
% V_pves_0_dwi_first(V_pves_0_dwi_first<thr)=1;
% V_pves_0_dwi_first(V_pves_0_dwi_first<1)=0;
% figure, imagesc(V_pves_0_dwi_first(:,:,45))
% title(num2str(thr))
% 
% V_pves_1_dwi_first=V_pves_1_dwi{1};
% V_pves_1_dwi_first(V_pves_1_dwi_first>0.5)=1;
% V_pves_1_dwi_first(V_pves_1_dwi_first<1)=0;
% % figure, imagesc(V_pves_1_dwi_first(:,:,45))
% 
% V_refined = V_pves_0_dwi_first.*V_pves_1_dwi_first;
% figure, imagesc(V_refined(:,:,45))
%%
%load atlas on subj space
V_atlases_dwi={};
V_atlases_func={};

for i = start_subj:n_subjs
    
    
    subj = subjects(i);
    subj=num2str(subj);
    if numel(subj)==4
        subj=strcat('0',subj);
    else
        subj=subj;
    end

    
    % img_path_atlas_dwi=strcat('/media/nas_rete/Vitality/maps2SUBJSPACE/dwi/atlas_on_b0/AAL3v1_2mm_on_',subj,'_',run,'_acq-dwi_B0_brain_corr.nii.gz');
    % img_path_atlas_func=strcat('/media/nas_rete/Vitality/maps2SUBJSPACE/func/atlas_on_M0/AAL3v1_2mm_on_',subj,'_task-bh_',run,'_acq-dexi_M0.nii.gz');
    img_path_atlas_dwi=strcat('/home/c25078236/Desktop/WAND_data/ANAT/atlas_coregistered/atlas_on_b0/sub-',subj,'_AAL3v1_1mm_on_b0.nii.gz');
    img_path_atlas_func=strcat('/home/c25078236/Desktop/WAND_data/ANAT/atlas_coregistered/atlas_on_M0/sub-',subj,'_AAL3v1_1mm_on_M0.nii.gz');

    V_vol_atlas_dwi = spm_vol(img_path_atlas_dwi);
    V_atlas_dwi=spm_read_vols(V_vol_atlas_dwi);
    V_atlases_dwi{end+1}=V_atlas_dwi;

    V_vol_atlas_func = spm_vol(img_path_atlas_func);
    V_atlas_func=spm_read_vols(V_vol_atlas_func);
    V_atlases_func{end+1}=V_atlas_func;

end

%% load parametric maps
V_CMRO2_maps={};
%V_CBF_maps={};

V_rsoma_maps={};
V_fsoma_maps={};
V_fneurite_maps={};
V_De_maps={};
V_Din_maps={};
V_fextra_maps={};

V_mse_maps={};

for i = start_subj:n_subjs
    
        
    subj = subjects(i);
    subj=num2str(subj);
    if numel(subj)==4
        subj=strcat('0',subj);
    else
        subj=subj;
    end

    
%     img_path_CMRO2=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/perf/outcome/',subj,'_task-bh_',run,'_acq-dexi_volreg_asl_topup_CMRO2_map.nii.gz');
%     img_path_CBF=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/perf/outcome/',subj,'_task-bh_',run,'_acq-dexi_volreg_asl_topup_CBF_map.nii.gz');

%     img_path_rsoma=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/dwi/SANDI_Output/',subj,'_',run,'_SANDI-fit_Rsoma.nii.gz');
%     img_path_fsoma=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/dwi/SANDI_Output/',subj,'_',run,'_SANDI-fit_fsoma.nii.gz');
%     img_path_fneurite=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/dwi/SANDI_Output/',subj,'_',run,'_SANDI-fit_fneurite.nii.gz');
%     img_path_De=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/dwi/SANDI_Output/',subj,'_',run,'_SANDI-fit_De.nii.gz');
%     img_path_Din=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/dwi/SANDI_Output/',subj,'_',run,'_SANDI-fit_Din.nii.gz');
%     img_path_fextra=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/dwi/SANDI_Output/',subj,'_',run,'_SANDI-fit_fextra.nii.gz');
%     img_path_mse=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/dwi/SANDI_Output/',subj,'_',run,'_SANDI-fit_mse.nii.gz');
    % 
    % img_path_CMRO2=strcat('/media/nas_rete/Vitality/derivatives/',subj,'/perf/outcome/',subj,'_task-bh_',run,'_acq-dexi_volreg_asl_topup_CMRO2_map.nii.gz');
    % 
    % img_path_rsoma=strcat('/media/nas_rete/Work_manuela/Vitality_data_SANDInewrelease/',subj,'/SANDI_output/',subj,'_',run,'_SANDI-fit_Rsoma.nii.gz');
    % img_path_fsoma=strcat('/media/nas_rete/Work_manuela/Vitality_data_SANDInewrelease/',subj,'/SANDI_output/',subj,'_',run,'_SANDI-fit_fsoma.nii.gz');
    % img_path_fneurite=strcat('/media/nas_rete/Work_manuela/Vitality_data_SANDInewrelease/',subj,'/SANDI_output/',subj,'_',run,'_SANDI-fit_fneurite.nii.gz');
    % img_path_De=strcat('/media/nas_rete/Work_manuela/Vitality_data_SANDInewrelease/',subj,'/SANDI_output/',subj,'_',run,'_SANDI-fit_De.nii.gz');
    % img_path_Din=strcat('/media/nas_rete/Work_manuela/Vitality_data_SANDInewrelease/',subj,'/SANDI_output/',subj,'_',run,'_SANDI-fit_Din.nii.gz');
    % img_path_fextra=strcat('/media/nas_rete/Work_manuela/Vitality_data_SANDInewrelease/',subj,'/SANDI_output/',subj,'_',run,'_SANDI-fit_fextra.nii.gz');
    % img_path_mse=strcat('/media/nas_rete/Work_manuela/Vitality_data_SANDInewrelease/',subj,'/SANDI_output/',subj,'_',run,'_SANDI-fit_mse.nii.gz');
    img_path_CMRO2=strcat('/home/c25078236/Desktop/WAND_data/FUNC/CMRO2/sub-',subj,'_cmro2_est.nii.gz');
    % 
    img_path_rsoma=strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-',subj,'/SANDI_Output/SANDI-fit_Rsoma.nii.gz');
    img_path_fsoma=strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-',subj,'/SANDI_Output/SANDI-fit_fsoma.nii.gz');
    img_path_fneurite=strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-',subj,'/SANDI_Output/SANDI-fit_fneurite.nii.gz');
    img_path_De=strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-',subj,'/SANDI_Output/SANDI-fit_De.nii.gz');
    img_path_Din=strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-',subj,'/SANDI_Output/SANDI-fit_Din.nii.gz');
    img_path_fextra=strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-',subj,'/SANDI_Output/SANDI-fit_fextra.nii.gz');
    %img_path_mse=strcat('/media/nas_rete/Work_manuela/Vitality_data_SANDInewrelease/',subj,'/SANDI_output/',subj,'_',run,'_SANDI-fit_mse.nii.gz');
    if strcmp(mse_threshold,'yes')
        img_path_mse=strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-',subj,'/SANDI_Output/sub-',subj,'_SANDI-fit_mse.nii.gz');
    end
    V_vol_CMRO2 = spm_vol(img_path_CMRO2);
    V_CMRO2=spm_read_vols(V_vol_CMRO2);
    V_CMRO2_maps{end+1}=V_CMRO2;
% 
%     V_vol_CBF = spm_vol(img_path_CBF);
%     V_CBF=spm_read_vols(V_vol_CBF);
%     V_CBF_maps{end+1}=V_CBF;

    V_vol_rsoma = spm_vol(img_path_rsoma);
    V_rsoma=spm_read_vols(V_vol_rsoma);
    V_rsoma_maps{end+1}=V_rsoma;

    V_vol_fsoma = spm_vol(img_path_fsoma);
    V_fsoma=spm_read_vols(V_vol_fsoma);
    V_fsoma_maps{end+1}=V_fsoma;

    V_vol_fneurite = spm_vol(img_path_fneurite);
    V_fneurite=spm_read_vols(V_vol_fneurite);
    V_fneurite_maps{end+1}=V_fneurite;

    V_vol_De = spm_vol(img_path_De);
    V_De=spm_read_vols(V_vol_De);
    V_De_maps{end+1}=V_De;

    V_vol_Din = spm_vol(img_path_Din);
    V_Din=spm_read_vols(V_vol_Din);
    V_Din_maps{end+1}=V_Din;

    V_vol_fextra = spm_vol(img_path_fextra);
    V_fextra=spm_read_vols(V_vol_fextra);
    V_fextra_maps{end+1}=V_fextra;

    if strcmp(mse_threshold,'yes')
        V_vol_mse = spm_vol(img_path_mse);
        V_mse=spm_read_vols(V_vol_mse);
        V_mse_first = V_mse(:,:,:,1);
        V_mse_maps{end+1}=V_mse_first;
    end
end




%% number of cells density map (many subjects) 

V_fc_maps={};

for i = 1:n_subjs    

    V_rsoma = V_rsoma_maps{i};
    V_fsoma = V_fsoma_maps{i};

    V_pve_0_dwi = V_pves_0_dwi{i};
    V_pve_1_dwi = V_pves_1_dwi{i};
    V_pve_2_dwi = V_pves_2_dwi{i};

%if wand data, don't remove rsomas (only for plotting)
    for i = 1:length(V_rsoma(:))%V_rsoma_maps(:)
        if V_rsoma(i) < rsoma_upper_limit 
            V_rsoma(i)=0;
        end
    end
    
    V_pve_1_dwi(V_pve_1_dwi>pve_1_threshold)=1;
    V_pve_1_dwi(V_pve_1_dwi<1)=0;

    V_fsoma_to_mask=V_fsoma;
    V_fsoma_to_mask(V_fsoma_to_mask>fsoma_threshold)=1;
    V_fsoma_to_mask(V_fsoma_to_mask<1)=0;

    % %in case you want all the WM
    % V_pve_2_dwi(V_pve_2_dwi==0)=NaN;
    % V_pve_2_dwi(V_pve_2_dwi>0)=0;
    % V_pve_2_dwi(isnan(V_pve_2_dwi))=1;

    %In case you want to mask by considering not all the WM
    V_pve_2_dwi(V_pve_2_dwi<pve_2_threshold_dwi)=NaN;
    V_pve_2_dwi(V_pve_2_dwi>=pve_2_threshold_dwi)=0;
    V_pve_2_dwi(isnan(V_pve_2_dwi))=1;

    % %in case you want all the CSF
    % V_pve_0_dwi(V_pve_0_dwi==0)=NaN;
    % V_pve_0_dwi(V_pve_0_dwi>0)=0;
    % V_pve_0_dwi(isnan(V_pve_0_dwi))=1;

    %In case you want to mask by considering not all the CSF
    V_pve_0_dwi(V_pve_0_dwi<pve_0_threshold_dwi)=NaN;
    V_pve_0_dwi(V_pve_0_dwi>=pve_0_threshold_dwi)=0;
    V_pve_0_dwi(isnan(V_pve_0_dwi))=1;

    %MASKING
    if strcmp(masking,'GM')
         V_GM = V_pve_1_dwi;
    elseif strcmp(masking,'all')
        V_GM = V_pve_1_dwi.*V_pve_0_dwi.*V_pve_2_dwi;
    end

    if strcmp(rois,'complete')
        V_rsoma_masked = V_rsoma.*V_fsoma_to_mask;
    else
        V_rsoma_masked = V_rsoma.*V_fsoma_to_mask.*V_GM; 
    end 

    %convert to m^3
    V_rsoma_masked = V_rsoma_masked.*10^-6;
    
    %voxel wise divide fs map over 4/3pir^3
    fc_map = V_fsoma./((4/3)*pi*V_rsoma_masked.^3);
    %figure, imagesc(fc_map(:,:,45));
    for i = 1:length(fc_map(:))
        if fc_map(i)==Inf
            fc_map(i)=NaN;
        end
    end

    V_fc_maps{end+1} = fc_map;

end

% %find a method to remove too much high values at the borders.
fc_1=V_fc_maps{1};
figure, imagesc(rot90(fc_1(:,:,40)))
title('Numerical soma density')
% clim([10^12,10^14])

%a further method to remove hyperintensities: look at the MSE.
%% save as nifti
img_path='/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-97902/SANDI_Output/SANDI-fit_Rsoma.nii.gz';
hdr=niftiinfo(img_path);
hdr.Datatype = 'double';
one_subj_fc=V_fc_maps{1};
hdr.ImageSize = size(one_subj_fc);
niftiwrite(one_subj_fc,'/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/261104/one_subj_fc.nii.gz',hdr,"Compressed",true);

%% superficial density (many subjects)

V_fsup_maps={};

for i = 1:n_subjs    

    V_rsoma = V_rsoma_maps{i};
    V_fsoma = V_fsoma_maps{i};

    V_pve_0_dwi = V_pves_0_dwi{i};
    V_pve_1_dwi = V_pves_1_dwi{i};
    V_pve_2_dwi = V_pves_2_dwi{i};

%if wand data, don't remove rsomas    
    for i = 1:length(V_rsoma(:))
        if V_rsoma(i) < rsoma_upper_limit
            V_rsoma(i)=0;
        end
    end
    
    V_pve_1_dwi(V_pve_1_dwi>pve_1_threshold)=1;
    V_pve_1_dwi(V_pve_1_dwi<1)=0;

    V_fsoma_to_mask=V_fsoma;
    V_fsoma_to_mask(V_fsoma_to_mask>fsoma_threshold)=1;
    V_fsoma_to_mask(V_fsoma_to_mask<1)=0;

    % %in case you want all the WM
    % V_pve_2_dwi(V_pve_2_dwi==0)=NaN;
    % V_pve_2_dwi(V_pve_2_dwi>0)=0;
    % V_pve_2_dwi(isnan(V_pve_2_dwi))=1;

    %In case you want to mask by considering not all the WM
    V_pve_2_dwi(V_pve_2_dwi<pve_2_threshold_dwi)=NaN;
    V_pve_2_dwi(V_pve_2_dwi>=pve_2_threshold_dwi)=0;
    V_pve_2_dwi(isnan(V_pve_2_dwi))=1;

    % %in case you want all the CSF
    % V_pve_0_dwi(V_pve_0_dwi==0)=NaN;
    % V_pve_0_dwi(V_pve_0_dwi>0)=0;
    % V_pve_0_dwi(isnan(V_pve_0_dwi))=1;

    %In case you want to mask by considering not all the CSF
    V_pve_0_dwi(V_pve_0_dwi<pve_0_threshold_dwi)=NaN;
    V_pve_0_dwi(V_pve_0_dwi>=pve_0_threshold_dwi)=0;
    V_pve_0_dwi(isnan(V_pve_0_dwi))=1;

    %MASKING
    if strcmp(masking,'GM')
        V_GM = V_pve_1_dwi;
    elseif strcmp(masking,'all')
        V_GM = V_pve_1_dwi.*V_pve_0_dwi.*V_pve_2_dwi;
    end

    if strcmp(rois,'complete')
        V_rsoma_masked = V_rsoma.*V_fsoma_to_mask;
    else
        V_rsoma_masked = V_rsoma.*V_fsoma_to_mask.*V_GM; 
    end

    %convert to m^3
    V_rsoma_masked = V_rsoma_masked.*10^-6;    

    %voxel wise divide fs map over 4/3pir^3
    fsup_map = V_fsoma./V_rsoma_masked;
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

% % V_fsup_one_array=V_fsup_one(:);
% % figure, hist(V_fsup_one_array);
% % title('Superficial Soma Density Distribution');
% % grid on

%%  Count total number of regions
% img_path_atlas='/storage/shared/Atlas/AAL3v1_2mm_resampled.nii.gz';
img_path_atlas='/home/c25078236/Desktop/WAND_data/AAL3/AAL3v1_1mm.nii.gz';
Vhdr = spm_vol(img_path_atlas);
V_atlas_tot = spm_read_vols(Vhdr);

regions = unique(V_atlas_tot(:));
%background removal
regions(1)=[];
n_regions=numel(regions);

%%
%atlas for church glass images
img_path_atlas='/home/c25078236/Desktop/saved_workspace/atlas_to_send/AAL3v1_2mm_resampled.nii.gz';
Vhdr = spm_vol(img_path_atlas);
V_atlas_glass = spm_read_vols(Vhdr);

%% in case you don't have the original atlas
n_regions=166;%it is needed to built the empty matrix (you need to know the maximum length. If it's higher, it isn't a problem).

%% compute medians 
%prepare empty matrices with maximum size 
%so to not have problems of different size
%then take the common regions (intersection): 
%1. first keep the common regions across subjects;
%2. then keep the common regions across spaces (func and dwi)

%you can loose some labels (?) when warping in subject space
%so for each space and for each subject I checked which labels we have
labels_func_subjs = zeros(n_subjs,n_regions);
labels_dwi_subjs = zeros(n_subjs,n_regions);

medians_CMRO2_subjs = zeros(n_subjs,n_regions);
% medians_CBF_subjs = zeros(n_subjs,n_regions);

medians_rsoma_subjs = zeros(n_subjs,n_regions);
medians_fsoma_subjs = zeros(n_subjs,n_regions);
medians_fc_subjs = zeros(n_subjs,n_regions);
medians_fsup_subjs = zeros(n_subjs,n_regions);

medians_fneurite_subjs = zeros(n_subjs,n_regions);
medians_fextra_subjs = zeros(n_subjs,n_regions);
medians_Din_subjs = zeros(n_subjs,n_regions);
medians_De_subjs = zeros(n_subjs,n_regions);

percentage_zeros_CMRO2_subjs = zeros(n_subjs,n_regions);
%percentage_unphysical_CBF_subjs = zeros(n_subjs,n_regions); 
percentage_nans_CMRO2_subjs = zeros(n_subjs,n_regions);
%percentage_nans_CBF_subjs = zeros(n_subjs,n_regions); 
percentage_high_MSE_microparameter_subjs = zeros(n_subjs,n_regions); 
percentage_high_MSE_rsoma_subjs = zeros(n_subjs,n_regions);


medians_mse_subjs = zeros(n_subjs,n_regions); %MSE
medians_mse_rsoma_subjs = zeros(n_subjs,n_regions); %MSE

percentage_nans_rsoma_subjs = zeros(n_subjs,n_regions);

V_pve_0_func_mean_subjs = zeros(n_subjs,n_regions);
V_pve_1_func_mean_subjs = zeros(n_subjs,n_regions);
V_pve_2_func_mean_subjs = zeros(n_subjs,n_regions);

V_pve_0_dwi_mean_subjs = zeros(n_subjs,n_regions);
V_pve_1_dwi_mean_subjs = zeros(n_subjs,n_regions);
V_pve_2_dwi_mean_subjs = zeros(n_subjs,n_regions);

V_pve_0_dwi_fs_mean_subjs = zeros(n_subjs,n_regions);
V_pve_1_dwi_fs_mean_subjs = zeros(n_subjs,n_regions);
V_pve_2_dwi_fs_mean_subjs = zeros(n_subjs,n_regions);

%%%%for the analysis across subjs, considering the whole GM
medians_CMRO2_GM_subjs = [];
medians_rsoma_GM_subjs = [];
medians_fsoma_GM_subjs = [];
medians_fc_GM_subjs = [];
medians_fsup_GM_subjs = [];

medians_fneurite_GM_subjs = [];
medians_De_GM_subjs = [];
medians_Din_GM_subjs = [];
medians_fextra_GM_subjs = [];

means_pve_0_func_GM_subjs = [];
means_pve_1_func_GM_subjs = [];
means_pve_2_func_GM_subjs = [];

means_pve_0_dwi_GM_subjs = []; %attention: if you want the same analysis also for Rsoma, you have to consider .V_GM.*V_fs 
means_pve_1_dwi_GM_subjs = [];
means_pve_2_dwi_GM_subjs = [];

start_time=tic;
for subj = 1:n_subjs
    tic
    %load atlases
    V_atlas_func = V_atlases_func{subj}; 
    V_atlas_dwi = V_atlases_dwi{subj};

    %load pve maps
    V_pve_1_func = V_pves_1_func{subj};
    V_pve_1_dwi = V_pves_1_dwi{subj};
    V_pve_0_func = V_pves_0_func{subj};
    V_pve_0_dwi = V_pves_0_dwi{subj};
    V_pve_2_func = V_pves_2_func{subj};
    V_pve_2_dwi = V_pves_2_dwi{subj};

    %load parametric maps
    V_CMRO2 = V_CMRO2_maps{subj};
    % V_CBF = V_CBF_maps{subj};

    V_rsoma = V_rsoma_maps{subj};
    V_fsoma = V_fsoma_maps{subj};
    V_fc = V_fc_maps{subj};
    V_fsup = V_fsup_maps{subj};

    V_fneurite = V_fneurite_maps{subj};
    V_Din = V_Din_maps{subj};
    V_De = V_De_maps{subj};
    V_fextra = V_fextra_maps{subj};


    %where to save parametric medians and PVE means
    medians_CMRO2_subj = [];
    medians_CBF_subj = [];
    medians_rsoma_subj = [];
    medians_fsoma_subj = [];
    medians_fc_subj = [];
    medians_fsup_subj = [];

    medians_fneurite_subj = [];
    medians_Din_subj = [];
    medians_De_subj = [];
    medians_fextra_subj = [];

    labels_func_subj = [];
    labels_dwi_subj = [];

    %percentage_unphysical_CBF_subj = [];
    percentage_zeros_CMRO2_subj = []; 
    %percentage_nans_CBF_subj = [];
    percentage_nans_CMRO2_subj = []; 

    percentage_nans_rsoma_subj=[]; 

    V_pve_0_func_mean_subj = [];
    V_pve_1_func_mean_subj = [];
    V_pve_2_func_mean_subj = [];

    V_pve_0_dwi_mean_subj = [];
    V_pve_1_dwi_mean_subj = [];
    V_pve_2_dwi_mean_subj = [];

    V_pve_0_dwi_fs_mean_subj = []; 
    V_pve_1_dwi_fs_mean_subj = [];
    V_pve_2_dwi_fs_mean_subj = [];

    if strcmp(mse_threshold,'yes')
        V_MSE = V_mse_maps{subj}; %MSE
        medians_mse_subj = []; %MSE
        medians_mse_rsoma_subj = []; %MSE
        percentage_high_MSE_microparameter_subj = []; %MSE
        percentage_high_MSE_rsoma_subj = []; %MSE
    end

    %%%%FUNC SPACE
    V_pve_0_func_original = V_pve_0_func;
    V_pve_1_func_original = V_pve_1_func;
    V_pve_2_func_original = V_pve_2_func;

    %define binary mask which is different for each subject
    V_pve_1_func(V_pve_1_func>pve_1_threshold)=1;
    V_pve_1_func(V_pve_1_func<1)=0;

    %In case you want to mask by considering not all the WM
    V_pve_2_func(V_pve_2_func<pve_2_threshold_func)=NaN;    
    V_pve_2_func(V_pve_2_func>=pve_2_threshold_func)=0;
    V_pve_2_func(isnan(V_pve_2_func))=1;

    % %in case you want all the WM
    % V_pve_2_func(V_pve_2_func==0)=NaN;
    % V_pve_2_func(V_pve_2_func>0)=0;
    % V_pve_2_func(isnan(V_pve_2_func))=1;

    %In case you want to mask by considering not all the CSF
    V_pve_0_func(V_pve_0_func<pve_0_threshold_func)=NaN;
    V_pve_0_func(V_pve_0_func>=pve_0_threshold_func)=0;
    V_pve_0_func(isnan(V_pve_0_func))=1;

    % %in case you want all the CSF
    % V_pve_0_func(V_pve_0_func==0)=NaN;
    % V_pve_0_func(V_pve_0_func>0)=0;
    % V_pve_0_func(isnan(V_pve_0_func))=1;

    %loop over regions
    %list of regions (it can vary among subjs and among spaces)
    regions_func = unique(V_atlas_func(:));
    %background removal
    regions_func(1)=[];
    n_regions_func=numel(regions_func);

    V_atlas_mask_func=V_atlas_func; 
    for region = 1:n_regions_func
        %binarize atlas
        for ii = 1:length(V_atlas_func(:))
            if V_atlas_func(ii) == regions_func(region)
                V_atlas_mask_func(ii) = 1;
            else
                V_atlas_mask_func(ii) = 0;
            end
        end

    if strcmp(masking,'GM')
        V_GM = V_pve_1_func;
    elseif strcmp(masking,'all')
        V_GM = V_pve_1_func.*V_pve_0_func.*V_pve_2_func;
    end

    if strcmp(rois,'complete')
        V_mask_func = V_atlas_mask_func;
    else
        V_mask_func = V_atlas_mask_func.*V_GM;
    end
    

    %mask

    V_CMRO2_masked = V_CMRO2.*V_mask_func;
    % V_CBF_masked = V_CBF.*V_mask_func;

   
    
    %remove background
    mask_func_zeros = find(V_mask_func==0);
    V_CMRO2_masked(mask_func_zeros)=[];
    % V_CBF_masked(mask_func_zeros)=[];


    %%%%%%%%%count how many zeros and NaN inside the regions 
    %count number of zeros in CMRO2 region
    CMRO2_zeros = find(V_CMRO2_masked==0);    
    %count how many voxels we remove
    n_CMRO2_region_voxels_tot = numel(V_CMRO2_masked);
    n_CMRO2_zeros = numel(CMRO2_zeros);
    percentage_zeros_CMRO2 = n_CMRO2_zeros/n_CMRO2_region_voxels_tot;
    percentage_zeros_CMRO2_subj(end+1)=percentage_zeros_CMRO2;

%     %remove CMRO2 zeros
%     V_CMRO2_masked(CMRO2_zeros)=[];

    %count number of nans in CMRO2 region
    CMRO2_nans=find(isnan(V_CMRO2_masked));
    n_CMRO2_nans=length(CMRO2_nans);
    percentage_nans_CMRO2=n_CMRO2_nans/n_CMRO2_region_voxels_tot;
    percentage_nans_CMRO2_subj(end+1)=percentage_nans_CMRO2;

%     %count number of values lower or equal to zero in CBF region
%     CBF_unphysical = find(V_CBF_masked<=0);    
%     %count how many voxels we remove
%     n_CBF_region_voxels_tot = numel(V_CBF_masked);
%     n_CBF_unphysical = numel(CBF_unphysical);
%     percentage_unphysical_CBF = n_CBF_unphysical/n_CBF_region_voxels_tot*100;
%     percentage_unphysical_CBF_subj(end+1)=percentage_unphysical_CBF;   
% 
% %     V_CBF_masked(CBF_unphysical)=[]; you have to keep them
% 
%     %count number of values lower or equal to NaNs in CBF region
%     CBF_nans=find(isnan(V_CBF_masked));
%     n_CBF_nans=length(CBF_nans);
%     percentage_nans_CBF=n_CBF_nans/n_CBF_region_voxels_tot;
%     percentage_nans_CBF_subj(end+1)=percentage_nans_CBF;

    %%%%%%%%%compute medians
    medians_CMRO2_subj(end+1) = nanmedian(V_CMRO2_masked);
    % medians_CBF_subj(end+1) = nanmedian(V_CBF_masked);

    %debugging
    % if isnan(medians_CMRO2_subj)
    %     break
    % end

    labels_func_subj(end+1) = regions_func(region);

    %%%%%%%%%calculate PVE regional means 

    %select the region
    V_pve_0_func_masked = V_pve_0_func_original.*V_mask_func;
    V_pve_1_func_masked = V_pve_1_func_original.*V_mask_func;
    V_pve_2_func_masked = V_pve_2_func_original.*V_mask_func;

    %select zeros from background
    mask_func_zeros = find(V_mask_func==0);

    %remove zeros from background
    V_pve_0_func_masked(mask_func_zeros)=[];
    V_pve_1_func_masked(mask_func_zeros)=[];
    V_pve_2_func_masked(mask_func_zeros)=[];

    %calculate mean and append to the list
    V_pve_0_func_mean = mean(V_pve_0_func_masked(:)); 
    V_pve_0_func_mean_subj(end+1) = V_pve_0_func_mean;

    V_pve_1_func_mean = mean(V_pve_1_func_masked(:));
    V_pve_1_func_mean_subj(end+1) = V_pve_1_func_mean;

    V_pve_2_func_mean = mean(V_pve_2_func_masked(:)); 
    V_pve_2_func_mean_subj(end+1) = V_pve_2_func_mean;

    end
        
    medians_CMRO2_subjs(subj,1:n_regions_func) = medians_CMRO2_subj;

    % medians_CBF_subjs(subj,1:n_regions_func) = medians_CBF_subj;
    labels_func_subjs(subj,1:n_regions_func) = labels_func_subj;
    percentage_zeros_CMRO2_subjs(subj,1:n_regions_func) = percentage_zeros_CMRO2_subj;
    % percentage_unphysical_CBF_subjs(subj,1:n_regions_func) = percentage_unphysical_CBF_subj;
    percentage_nans_CMRO2_subjs(subj,1:n_regions_func) = percentage_nans_CMRO2_subj;
    % percentage_nans_CBF_subjs(subj,1:n_regions_func) = percentage_nans_CBF_subj;

    V_pve_0_func_mean_subjs(subj,1:n_regions_func) = V_pve_0_func_mean_subj;
    V_pve_1_func_mean_subjs(subj,1:n_regions_func) = V_pve_1_func_mean_subj;
    V_pve_2_func_mean_subjs(subj,1:n_regions_func) = V_pve_2_func_mean_subj;

    %%%%for the analysis across subjs, considering the whole GM
    %you don't have to calculate it inside the regional loop
    V_CMRO2_masked_GM = V_CMRO2.*V_GM; 
    GM_func_zeros = find(V_GM==0);
    V_CMRO2_masked_GM(GM_func_zeros)=[];

    medians_CMRO2_GM_subjs(end+1) = nanmedian(V_CMRO2_masked_GM);

    %select the region
    V_pve_0_func_masked_GM = V_pve_0_func_original.*V_GM;
    V_pve_1_func_masked_GM = V_pve_1_func_original.*V_GM;
    V_pve_2_func_masked_GM = V_pve_2_func_original.*V_GM;

    %select zeros from background
    mask_func_GM_zeros = find(V_GM==0);

    %remove zeros from background
    V_pve_0_func_masked_GM(mask_func_GM_zeros)=[];
    V_pve_1_func_masked_GM(mask_func_GM_zeros)=[];
    V_pve_2_func_masked_GM(mask_func_GM_zeros)=[];

    %calculate mean and append to the list

    means_pve_0_func_GM_subjs(end+1) = mean(V_pve_0_func_masked_GM(:));
    means_pve_1_func_GM_subjs(end+1) = mean(V_pve_1_func_masked_GM(:)); 
    means_pve_2_func_GM_subjs(end+1) = mean(V_pve_2_func_masked_GM(:));

    %%%%DWI space
    regions_dwi = unique(V_atlas_dwi(:));
    %background removal
    regions_dwi(1)=[];
    n_regions_dwi=numel(regions_dwi);

    V_pve_0_dwi_original = V_pve_0_dwi;
    V_pve_1_dwi_original = V_pve_1_dwi;
    V_pve_2_dwi_original = V_pve_2_dwi;

    %define mask
    V_fsoma_to_mask = V_fsoma;
    V_fsoma_to_mask(V_fsoma_to_mask>fsoma_threshold)=1;
    V_fsoma_to_mask(V_fsoma_to_mask<1)=0;

    V_pve_1_dwi(V_pve_1_dwi>pve_1_threshold)=1;
    V_pve_1_dwi(V_pve_1_dwi<1)=0;

    %In case you want to mask by considering not all the WM
    V_pve_2_dwi(V_pve_2_dwi<pve_2_threshold_dwi)=NaN;    
    V_pve_2_dwi(V_pve_2_dwi>=pve_2_threshold_dwi)=0;
    V_pve_2_dwi(isnan(V_pve_2_dwi))=1;
     
    % %in case you want all the WM
    % V_pve_2_dwi(V_pve_2_dwi==0)=NaN;
    % V_pve_2_dwi(V_pve_2_dwi>0)=0;
    % V_pve_2_dwi(isnan(V_pve_2_dwi))=1;
    % 
    %In case you want to mask by considering not all the CSF
    V_pve_0_dwi(V_pve_0_dwi<pve_0_threshold_dwi)=NaN;
    V_pve_0_dwi(V_pve_0_dwi>=pve_0_threshold_dwi)=0;
    V_pve_0_dwi(isnan(V_pve_0_dwi))=1;

    % %in case you want all the CSF
    % V_pve_0_dwi(V_pve_0_dwi==0)=NaN;
    % V_pve_0_dwi(V_pve_0_dwi>0)=0;
    % V_pve_0_dwi(isnan(V_pve_0_dwi))=1;


    V_atlas_mask_dwi=V_atlas_dwi;
    %binarize atlas
    for region = 1:n_regions_dwi

    for ii = 1:length(V_atlas_dwi(:))
        if V_atlas_dwi(ii) == region
            V_atlas_mask_dwi(ii) = 1;
        else
            V_atlas_mask_dwi(ii) = 0;
        end
    end


    if strcmp(masking,'GM')
        V_GM = V_pve_1_dwi;
    elseif strcmp(masking,'all')
        V_GM = V_pve_1_dwi.*V_pve_0_dwi.*V_pve_2_dwi;
    end

    if strcmp(rois,'complete')
        V_mask_dwi = V_atlas_mask_dwi;
    else
        V_mask_dwi = V_atlas_mask_dwi.*V_GM;
    end

    V_mask_dwi_fs = V_mask_dwi.*V_fsoma_to_mask;

    %mask

    V_rsoma_masked = V_rsoma.*V_mask_dwi_fs;
    V_fsoma_masked = V_fsoma.*V_mask_dwi;
    V_fc_masked = V_fc.*V_mask_dwi;
    V_fsup_masked = V_fsup.*V_mask_dwi;

    V_fneurite_masked = V_fneurite.*V_mask_dwi;  
    V_De_masked = V_De.*V_mask_dwi;
    V_Din_masked = V_Din.*V_mask_dwi;
    V_fextra_masked = V_fextra.*V_mask_dwi;
    
    %remove background
    mask_dwi_fs_zeros = find(V_mask_dwi_fs==0);
    mask_dwi_zeros = find(V_mask_dwi==0);

    V_rsoma_masked(mask_dwi_fs_zeros)=[];
    V_fsoma_masked(mask_dwi_zeros)=[];
    V_fc_masked(mask_dwi_zeros)=[];
    V_fsup_masked(mask_dwi_zeros)=[];
    
    V_fneurite_masked(mask_dwi_zeros)=[];
    V_De_masked(mask_dwi_zeros)=[];
    V_Din_masked(mask_dwi_zeros)=[];
    V_fextra_masked(mask_dwi_zeros)=[];

  

    if strcmp(mse_threshold,'yes')

        V_MSE_masked_rsoma = V_MSE.*V_mask_dwi_fs; %MSE
        V_MSE_masked = V_MSE.*V_mask_dwi; %MSE

        V_MSE_masked_rsoma(mask_dwi_fs_zeros)=[]; %MSE
        V_MSE_masked(mask_dwi_zeros)=[]; %MSE



        %%%%%%%%find voxels which have MSE higher than Nth percentile
        idx_high_MSE_micropar=find(V_MSE_masked>prctile(V_MSE_masked,mse_threshold_value)); %MSE
        idx_high_MSE_rsoma=find(V_MSE_masked_rsoma>prctile(V_MSE_masked_rsoma,mse_threshold_value)); %MSE

        %COUNT THE PERCENTAGE
        percentage_high_MSE_rsoma = numel(idx_high_MSE_rsoma)/numel(V_rsoma_masked); %MSE

        percentage_high_MSE_micropar = numel(idx_high_MSE_micropar)/numel(V_fsoma_masked); %MSE

        %REMOVE THEM
        V_rsoma_masked(idx_high_MSE_rsoma)=[]; %MSE
        V_fsoma_masked(idx_high_MSE_micropar)=[]; %MSE
        V_fc_masked(idx_high_MSE_micropar)=[]; %MSE
        V_fsup_masked(idx_high_MSE_micropar)=[]; %MSE

        V_fneurite_masked(idx_high_MSE_micropar)=[]; %MSE
        V_De_masked(idx_high_MSE_micropar)=[]; %MSE
        V_Din_masked(idx_high_MSE_micropar)=[]; %MSE
        V_fextra_masked(idx_high_MSE_micropar)=[]; %MSE

 

    end
    % count number of nans in Rsoma regions
    % attention: there should not be. 
    % you can find some median values equal to NaN because 
    % there are no voxels, so median[]=NaN.
    n_rsoma_region_voxels_tot = numel(V_rsoma_masked);
    rsoma_nans=find(isnan(V_rsoma_masked));
    n_rsoma_nans=length(rsoma_nans);
    percentage_nans_rsoma=n_rsoma_nans/n_rsoma_region_voxels_tot;
    percentage_nans_rsoma_subj(end+1)=percentage_nans_rsoma;

    %compute medians and save results
    
    medians_rsoma_subj(end+1) = nanmedian(V_rsoma_masked);
    medians_fsoma_subj(end+1) = nanmedian(V_fsoma_masked);
    medians_fc_subj(end+1) = nanmedian(V_fc_masked);
    medians_fsup_subj(end+1) = nanmedian(V_fsup_masked);

    medians_fneurite_subj(end+1) = nanmedian(V_fneurite_masked);
    medians_De_subj(end+1) = nanmedian(V_De_masked);
    medians_Din_subj(end+1) = nanmedian(V_Din_masked);
    medians_fextra_subj(end+1) = nanmedian(V_fextra_masked);

    labels_dwi_subj(end+1) = regions_dwi(region);  
    
    if strcmp(mse_threshold,'yes')
        medians_mse_subj(end+1) = nanmedian(V_MSE_masked); %MSE
        medians_mse_rsoma_subj(end+1) = nanmedian(V_MSE_masked_rsoma); %MSE

        percentage_high_MSE_microparameter_subj(end+1) = percentage_high_MSE_micropar; %MSE
        percentage_high_MSE_rsoma_subj(end+1) = percentage_high_MSE_rsoma; %MSE
    end

    %calculate PVE regional means

    %valid for Rsoma
    %select the region
    V_pve_0_dwi_masked_fs = V_pve_0_dwi_original.*V_mask_dwi_fs;
    V_pve_1_dwi_masked_fs = V_pve_1_dwi_original.*V_mask_dwi_fs;
    V_pve_2_dwi_masked_fs = V_pve_2_dwi_original.*V_mask_dwi_fs;

    %select zeros from background
    mask_dwi_fs_zeros = find(V_mask_dwi_fs==0);

    %remove zeros from background
    V_pve_0_dwi_masked_fs(mask_dwi_fs_zeros)=[];
    V_pve_1_dwi_masked_fs(mask_dwi_fs_zeros)=[];
    V_pve_2_dwi_masked_fs(mask_dwi_fs_zeros)=[];

    %calculate mean and append to the list
    V_pve_0_dwi_fs_mean = mean(V_pve_0_dwi_masked_fs(:));
    V_pve_0_dwi_fs_mean_subj(end+1) = V_pve_0_dwi_fs_mean;

    V_pve_1_dwi_fs_mean = mean(V_pve_1_dwi_masked_fs(:));
    V_pve_1_dwi_fs_mean_subj(end+1) = V_pve_1_dwi_fs_mean;

    V_pve_2_dwi_fs_mean = mean(V_pve_2_dwi_masked_fs(:));
    V_pve_2_dwi_fs_mean_subj(end+1) = V_pve_2_dwi_fs_mean;

    %valid for all microparameters except Rsoma
    %select the region
    V_pve_0_dwi_masked = V_pve_0_dwi_original.*V_mask_dwi;
    V_pve_1_dwi_masked = V_pve_1_dwi_original.*V_mask_dwi;
    V_pve_2_dwi_masked = V_pve_2_dwi_original.*V_mask_dwi;

    %select zeros from background
    mask_dwi_zeros = find(V_mask_dwi==0);

    %remove zeros from background
    V_pve_0_dwi_masked(mask_dwi_zeros)=[];
    V_pve_1_dwi_masked(mask_dwi_zeros)=[];
    V_pve_2_dwi_masked(mask_dwi_zeros)=[];

    %calculate mean and append to the list
    V_pve_0_dwi_mean = mean(V_pve_0_dwi_masked(:));
    V_pve_0_dwi_mean_subj(end+1) = V_pve_0_dwi_mean;

    V_pve_1_dwi_mean = mean(V_pve_1_dwi_masked(:));
    V_pve_1_dwi_mean_subj(end+1) = V_pve_1_dwi_mean;

    V_pve_2_dwi_mean = mean(V_pve_2_dwi_masked(:));
    V_pve_2_dwi_mean_subj(end+1) = V_pve_2_dwi_mean;

    end
    
    labels_dwi_subjs(subj,1:n_regions_dwi) = labels_dwi_subj;
    medians_rsoma_subjs(subj,1:n_regions_dwi) = medians_rsoma_subj;
    medians_fsoma_subjs(subj,1:n_regions_dwi) = medians_fsoma_subj;
    medians_fc_subjs(subj,1:n_regions_dwi) = medians_fc_subj;
    medians_fsup_subjs(subj,1:n_regions_dwi) = medians_fsup_subj;

    medians_fneurite_subjs(subj,1:n_regions_dwi) = medians_fneurite_subj;
    medians_Din_subjs(subj,1:n_regions_dwi) = medians_Din_subj;
    medians_De_subjs(subj,1:n_regions_dwi) = medians_De_subj;
    medians_fextra_subjs(subj,1:n_regions_dwi) = medians_fextra_subj;

    if strcmp(mse_threshold,'yes')
        medians_mse_rsoma_subjs(subj,1:n_regions_dwi)=medians_mse_rsoma_subj; %MSE
        medians_mse_subjs(subj,1:n_regions_dwi)=medians_rsoma_subj; %MSE
        percentage_high_MSE_microparameter_subjs(subj,1:n_regions_dwi) = percentage_high_MSE_microparameter_subj; %MSE
        percentage_high_MSE_rsoma_subjs(subj,1:n_regions_dwi) = percentage_high_MSE_rsoma_subj; %MSE
        
    end

    percentage_nans_rsoma_subjs(subj,1:n_regions_dwi)=percentage_nans_rsoma_subj;

    V_pve_0_dwi_mean_subjs(subj,1:n_regions_dwi) = V_pve_0_dwi_mean_subj;
    V_pve_1_dwi_mean_subjs(subj,1:n_regions_dwi) = V_pve_1_dwi_mean_subj;
    V_pve_2_dwi_mean_subjs(subj,1:n_regions_dwi) = V_pve_2_dwi_mean_subj;

    V_pve_0_dwi_fs_mean_subjs(subj,1:n_regions_dwi) = V_pve_0_dwi_fs_mean_subj;
    V_pve_1_dwi_fs_mean_subjs(subj,1:n_regions_dwi) = V_pve_1_dwi_fs_mean_subj;
    V_pve_2_dwi_fs_mean_subjs(subj,1:n_regions_dwi) = V_pve_2_dwi_fs_mean_subj;

    %%%%for the analysis across subjs, considering the whole GM
    % here you don't have to be inside the regional for loop
    V_GM_fs = V_GM.*V_fsoma_to_mask;

    %mask

    V_rsoma_GM_masked = V_rsoma.*V_GM_fs;
    V_fsoma_GM_masked = V_fsoma.*V_GM;
    V_fc_GM_masked = V_fc.*V_GM;
    V_fsup_GM_masked = V_fsup.*V_GM;

    V_fneurite_GM_masked = V_fneurite.*V_GM;  
    V_De_GM_masked = V_De.*V_GM;
    V_Din_GM_masked = V_Din.*V_GM;
    V_fextra_GM_masked = V_fextra.*V_GM;

    V_pve_0_dwi_masked_GM = V_pve_0_dwi_original.*V_GM;
    V_pve_1_dwi_masked_GM = V_pve_1_dwi_original.*V_GM;
    V_pve_2_dwi_masked_GM = V_pve_2_dwi_original.*V_GM;
    
    %remove background
    V_GM_fs_zeros = find(V_GM_fs==0);
    V_GM_zeros = find(V_GM==0);

    V_rsoma_GM_masked(V_GM_fs_zeros)=[];
    V_fsoma_GM_masked(V_GM_zeros)=[];
    V_fc_GM_masked(V_GM_zeros)=[];
    V_fsup_GM_masked(V_GM_zeros)=[];
    
    V_fneurite_GM_masked(V_GM_zeros)=[];
    V_De_GM_masked(V_GM_zeros)=[];
    V_Din_GM_masked(V_GM_zeros)=[];
    V_fextra_GM_masked(V_GM_zeros)=[];

    V_pve_0_dwi_masked_GM(V_GM_zeros)=[];
    V_pve_1_dwi_masked_GM(V_GM_zeros)=[];
    V_pve_2_dwi_masked_GM(V_GM_zeros)=[];

    V_MSE_GM_masked_rsoma = V_MSE.*V_GM_fs; %MSE
    V_MSE_GM_masked = V_MSE.*V_GM; %MSE

    V_MSE_GM_masked_rsoma(V_GM_fs_zeros)=[]; %MSE
    V_MSE_GM_masked(V_GM_zeros)=[]; %MSE


    if strcmp(mse_threshold,'yes')
        %%%%%%%%find voxels which have MSE higher than Nth percentile
        idx_high_MSE_GM_micropar=find(V_MSE_GM_masked>prctile(V_MSE_GM_masked,mse_threshold_value)); %MSE
        idx_high_MSE_GM_rsoma=find(V_MSE_GM_masked_rsoma>prctile(V_MSE_GM_masked_rsoma,mse_threshold_value)); %MSE

        %REMOVE THEM
        V_rsoma_GM_masked(idx_high_MSE_GM_rsoma)=[]; %MSE
        V_fsoma_GM_masked(idx_high_MSE_GM_micropar)=[]; %MSE
        V_fc_GM_masked(idx_high_MSE_GM_micropar)=[]; %MSE
        V_fsup_GM_masked(idx_high_MSE_GM_micropar)=[]; %MSE

        V_fneurite_GM_masked(idx_high_MSE_GM_micropar)=[]; %MSE
        V_De_GM_masked(idx_high_MSE_GM_micropar)=[]; %MSE
        V_Din_GM_masked(idx_high_MSE_GM_micropar)=[]; %MSE
        V_fextra_GM_masked(idx_high_MSE_GM_micropar)=[]; %MSE

        V_pve_0_dwi_masked_GM(idx_high_MSE_GM_micropar)=[];
        V_pve_1_dwi_masked_GM(idx_high_MSE_GM_micropar)=[];
        V_pve_2_dwi_masked_GM(idx_high_MSE_GM_micropar)=[];
    end

    medians_rsoma_GM_subjs(end+1) = nanmedian(V_rsoma_GM_masked);
    medians_fsoma_GM_subjs(end+1) = nanmedian(V_fsoma_GM_masked);
    medians_fc_GM_subjs(end+1) = nanmedian(V_fc_GM_masked);
    medians_fsup_GM_subjs(end+1) = nanmedian(V_fsup_GM_masked);

    medians_fneurite_GM_subjs(end+1) = nanmedian(V_fneurite_GM_masked);
    medians_De_GM_subjs(end+1) = nanmedian(V_De_GM_masked);
    medians_Din_GM_subjs(end+1) = nanmedian(V_Din_GM_masked);
    medians_fextra_GM_subjs(end+1) = nanmedian(V_fextra_GM_masked);   

    means_pve_0_dwi_GM_subjs(end+1) = mean(V_pve_0_dwi_masked_GM(:));
    means_pve_1_dwi_GM_subjs(end+1) = mean(V_pve_1_dwi_masked_GM(:));
    means_pve_2_dwi_GM_subjs(end+1) = mean(V_pve_2_dwi_masked_GM(:));
    
    toc
    disp(strcat('Finished subject', num2str(subj),'Starting subject', num2str(subj+1)))

end
timeElapsed = toc(start_time);




