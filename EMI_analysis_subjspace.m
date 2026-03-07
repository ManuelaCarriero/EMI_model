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


%% load data already "cooked"
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/maskingGM05_fc_fsup_mse85_withGMmedians_GMpvemeans')

%% select variables to examine
energy_parameter = 'CMRO2';
micro_parameter = 'fsup';

%% remove uncommon labels between subjects and between spaces
%% select matrices

if strcmp(micro_parameter,'Rsoma')
    medians_dwi_subjs = medians_rsoma_subjs;
elseif strcmp(micro_parameter,'fsoma')
    medians_dwi_subjs = medians_fsoma_subjs;
elseif strcmp(micro_parameter,'fsup')
    medians_dwi_subjs = medians_fsup_subjs;
elseif strcmp(micro_parameter,'fc')
    medians_dwi_subjs = medians_fc_subjs;
end

if strcmp(energy_parameter,'CMRO2')
    medians_func_subjs = medians_CMRO2_subjs;
    percentage_removal_func_subjs = percentage_zeros_CMRO2_subjs;
    percentage_nans_func_subjs = percentage_nans_CMRO2_subjs;
elseif strcmp(energy_parameter,'CBF')
    medians_func_subjs = medians_CBF_subjs;
    percentage_removal_func_subjs = percentage_removal_CBF_subjs;
    percentage_nans_func_subjs = percentage_removal_CBF_subjs;
end


%% The following blocks are to select common regions

%% select common elements across subjects

%% dwi space 

% detect common labels in dwi space across subjs
initial_common = labels_dwi_subjs(1,:);
common = initial_common;
for i = 1:n_subjs
    commonElements = intersect(common, labels_dwi_subjs(i,:));
    common = commonElements;
end

%First, detect indices of common Elements
commonElements(commonElements==0)=[];
lst_idx_matrix_dwi=[];
for row = 1:n_subjs
    lst_idx_row=[];
    for i = 1:length(commonElements)
        commonElement = commonElements(i);            
        idx = find(labels_dwi_subjs(row,:) == commonElement);
        % if length(idx)>1
        %     lst_idx_row(1,:)=idx;
        % else
            lst_idx_row(end+1)=idx;
        % end
    end
    lst_idx_matrix_dwi(row,:)=lst_idx_row;
end

%Secondly,select elements corresponding to common indices
%apply this both to the median values and labels

%parametric median values
medians_dwi_subjs_final=[];
for row = 1:n_subjs
    medians_dwi_subjs_row=medians_dwi_subjs(row,:);
    lst_idx = lst_idx_matrix_dwi(row,:);
    medians_dwi_subjs_row_final=medians_dwi_subjs_row(lst_idx);
    medians_dwi_subjs_final(row,:)=medians_dwi_subjs_row_final;
end

%labels
labels_dwi_subjs_final=[];
for row = 1:n_subjs
    labels_dwi_subjs_row=labels_dwi_subjs(row,:);
    lst_idx = lst_idx_matrix_dwi(row,:);
    labels_dwi_subjs_row_final=labels_dwi_subjs_row(lst_idx);
    labels_dwi_subjs_final(row,:)=labels_dwi_subjs_row_final;
end

%PVEs

V_pve_0_dwi_mean_subjs_final=[];
for row = 1:n_subjs
    V_pve_0_dwi_mean_subjs_row=V_pve_0_dwi_mean_subjs(row,:);
    lst_idx = lst_idx_matrix_dwi(row,:);
    V_pve_0_dwi_mean_subjs_row_final=V_pve_0_dwi_mean_subjs_row(lst_idx);
    V_pve_0_dwi_mean_subjs_final(row,:)=V_pve_0_dwi_mean_subjs_row_final;
end

V_pve_1_dwi_mean_subjs_final=[];
for row = 1:n_subjs
    V_pve_1_dwi_mean_subjs_row=V_pve_1_dwi_mean_subjs(row,:);
    lst_idx = lst_idx_matrix_dwi(row,:);
    V_pve_1_dwi_mean_subjs_row_final=V_pve_1_dwi_mean_subjs_row(lst_idx);
    V_pve_1_dwi_mean_subjs_final(row,:)=V_pve_1_dwi_mean_subjs_row_final;
end

V_pve_2_dwi_mean_subjs_final=[];
for row = 1:n_subjs
    V_pve_2_dwi_mean_subjs_row=V_pve_2_dwi_mean_subjs(row,:);
    lst_idx = lst_idx_matrix_dwi(row,:);
    V_pve_2_dwi_mean_subjs_row_final=V_pve_2_dwi_mean_subjs_row(lst_idx);
    V_pve_2_dwi_mean_subjs_final(row,:)=V_pve_2_dwi_mean_subjs_row_final;
end

%% if you have MSE
% %these matrices are needed to check if at higher variability correspond
% %high mse median regional values.
% 
% if strcmp(micro_parameter,'Rsoma')    
%     medians_mse_rsoma_subjs_final=[];
%     for row = 1:n_subjs
%         medians_mse_rsoma_subjs_row=medians_mse_rsoma_subjs(row,:);
%         lst_idx = lst_idx_matrix_dwi(row,:);
%         medians_mse_rsoma_subjs_row_final=medians_mse_rsoma_subjs_row(lst_idx);
%         medians_mse_rsoma_subjs_final(row,:)=medians_mse_rsoma_subjs_row_final;
%     end
% else
%     medians_mse_subjs_final=[];
%     for row = 1:n_subjs
%         medians_mse_subjs_row=medians_mse_subjs(row,:);
%         lst_idx = lst_idx_matrix_dwi(row,:);
%         medians_mse_subjs_row_final=medians_mse_subjs_row(lst_idx);
%         medians_mse_subjs_final(row,:)=medians_mse_subjs_row_final;
%     end
% end
% 
% %in case you remove regions with high MSE values
% 
% if strcmp(micro_parameter,'rsoma')    
%     percentage_high_MSE_rsoma_subjs_final=[];
%     for row = 1:n_subjs
%         percentage_high_MSE_rsoma_subjs_row=percentage_high_MSE_rsoma_subjs(row,:);
%         lst_idx = lst_idx_matrix_dwi(row,:);
%         percentage_high_MSE_rsoma_subjs_row_final=percentage_high_MSE_rsoma_subjs_row(lst_idx);
%         percentage_high_MSE_rsoma_subjs_final(row,:)=percentage_high_MSE_rsoma_subjs_row_final;
%     end
% else
%     percentage_high_MSE_microparameter_subjs_final=[];
%     for row = 1:n_subjs
%         percentage_high_MSE_microparameter_subjs_row=percentage_high_MSE_microparameter_subjs(row,:);
%         lst_idx = lst_idx_matrix_dwi(row,:);
%         percentage_high_MSE_microparameter_subjs_row_final=percentage_high_MSE_microparameter_subjs_row(lst_idx);
%         percentage_high_MSE_microparameter_subjs_final(row,:)=percentage_high_MSE_microparameter_subjs_row_final;
%     end
% end

%repeat everything for func space
%% func space
% detect common labels in func space across subjs
initial_common = labels_func_subjs(1,:);
common = initial_common;
for i = 1:n_subjs
    commonElements = intersect(common, labels_func_subjs(i,:));
    common = commonElements;
end

%First, detect indices of common Elements
commonElements(commonElements==0)=[];
lst_idx_matrix_func=[];
for row = 1:n_subjs
    lst_idx_row=[];
    for i = 1:length(commonElements)
        commonElement = commonElements(i);
        idx = find(labels_func_subjs(row,:) == commonElement);
        % if length(idx)>1
        %     lst_idx_row(1,:)=idx;
        % else
        lst_idx_row(end+1)=idx;
        % end
    end
    lst_idx_matrix_func(row,:)=lst_idx_row;
end

%Secondly, select elements corresponding to common indices
%apply this both to the median values and labels

%median values
medians_func_subjs_final=[];
for row = 1:n_subjs
    medians_func_subjs_row=medians_func_subjs(row,:);
    lst_idx = lst_idx_matrix_func(row,:);
    medians_func_subjs_row_final=medians_func_subjs_row(lst_idx);
    medians_func_subjs_final(row,:)=medians_func_subjs_row_final;
end

%labels 

labels_func_subjs_final=[];
for row = 1:n_subjs
    labels_func_subjs_row=labels_func_subjs(row,:);
    lst_idx = lst_idx_matrix_func(row,:);
    labels_func_subjs_row_final=labels_func_subjs_row(lst_idx);
    labels_func_subjs_final(row,:)=labels_func_subjs_row_final;
end

%PVEs

V_pve_0_func_mean_subjs_final=[];
for row = 1:n_subjs
    V_pve_0_func_mean_subjs_row=V_pve_0_func_mean_subjs(row,:);
    lst_idx = lst_idx_matrix_func(row,:);
    V_pve_0_func_mean_subjs_row_final=V_pve_0_func_mean_subjs_row(lst_idx);
    V_pve_0_func_mean_subjs_final(row,:)=V_pve_0_func_mean_subjs_row_final;
end

V_pve_1_func_mean_subjs_final=[];
for row = 1:n_subjs
    V_pve_1_func_mean_subjs_row=V_pve_1_func_mean_subjs(row,:);
    lst_idx = lst_idx_matrix_func(row,:);
    V_pve_1_func_mean_subjs_row_final=V_pve_1_func_mean_subjs_row(lst_idx);
    V_pve_1_func_mean_subjs_final(row,:)=V_pve_1_func_mean_subjs_row_final;
end

V_pve_2_func_mean_subjs_final=[];
for row = 1:n_subjs
    V_pve_2_func_mean_subjs_row=V_pve_2_func_mean_subjs(row,:);
    lst_idx = lst_idx_matrix_func(row,:);
    V_pve_2_func_mean_subjs_row_final=V_pve_2_func_mean_subjs_row(lst_idx);
    V_pve_2_func_mean_subjs_final(row,:)=V_pve_2_func_mean_subjs_row_final;
end

% %percentage of zeros in the different regions of different subjects
% percentage_zeros_CMRO2_subjs_final=[];
% for row = 1:n_subjs
%     percentage_zeros_CMRO2_subjs_row=percentage_zeros_CMRO2_subjs(row,:);
%     lst_idx = lst_idx_matrix_func(row,:);
%     percentage_zeros_CMRO2_subjs_row_final=percentage_zeros_CMRO2_subjs_row(lst_idx);
%     percentage_zeros_CMRO2_subjs_final(row,:)=percentage_zeros_CMRO2_subjs_row_final;
% end
% 
% %percentage of nans in the different regions of different subjects
% percentage_nans_CMRO2_subjs_final=[];
% for row = 1:n_subjs
%     percentage_nans_CMRO2_subjs_row=percentage_nans_CMRO2_subjs(row,:);
%     lst_idx = lst_idx_matrix_func(row,:);
%     percentage_nans_CMRO2_subjs_row_final=percentage_nans_CMRO2_subjs_row(lst_idx);
%     percentage_nans_CMRO2_subjs_final(row,:)=percentage_nans_CMRO2_subjs_row_final;
% end

%%
%then for each subj (row of the two matrices),
%find common elements (regions) between a (dwi) and b (func) space,
%find the idx 
%keep only those common both in DWI and func space
%create a new dwi and func matrix which will have same size.

%% select common elements between the two spaces

commonElements_lst=[];
for row = 1:n_subjs
    commonElements = intersect(labels_dwi_subjs_final(row,:),labels_func_subjs_final(row,:));
    if length(commonElements)>1
        commonElements_lst(1,:)=commonElements;
    else
        commonElements_lst(end+1)=commonElements;
    end
end

commonElements_lst=unique(commonElements_lst);
commonElements(commonElements==0)=[];

%% dwi space
%First, detect indices of common Elements

lst_idx_matrix_dwi_spaces=[];
for row = 1:n_subjs
    lst_idx_row=[];
    for i = 1:length(commonElements)
        commonElement = commonElements(i);
        idx = find(labels_dwi_subjs_final(row,:) == commonElement);
        % if length(idx)>1
        %     lst_idx_row(1,:)=idx;
        % else
        lst_idx_row(end+1)=idx;
        % end
    end
    lst_idx_matrix_dwi_spaces(row,:)=lst_idx_row;
end

%Secondly, select common indices
%apply this both to the median values and labels
medians_dwi_subjs_final_spaces=[];
for row = 1:n_subjs
    medians_dwi_subjs_row=medians_dwi_subjs_final(row,:);
    lst_idx = lst_idx_matrix_dwi_spaces(row,:);
    medians_dwi_subjs_row_final=medians_dwi_subjs_row(lst_idx);
    medians_dwi_subjs_final_spaces(row,:)=medians_dwi_subjs_row_final;
end

labels_dwi_subjs_final_spaces=[];
for row = 1:n_subjs
    labels_dwi_subjs_row=labels_dwi_subjs_final(row,:);
    lst_idx = lst_idx_matrix_dwi_spaces(row,:);
    labels_dwi_subjs_row_final=labels_dwi_subjs_row(lst_idx);
    labels_dwi_subjs_final_spaces(row,:)=labels_dwi_subjs_row_final;
end

V_pve_0_dwi_mean_subjs_final_spaces=[];
for row = 1:n_subjs
    V_pve_0_dwi_mean_subjs_row=V_pve_0_dwi_mean_subjs_final(row,:);
    lst_idx = lst_idx_matrix_dwi_spaces(row,:);
    V_pve_0_dwi_mean_subjs_row_final=V_pve_0_dwi_mean_subjs_row(lst_idx);
    V_pve_0_dwi_mean_subjs_final_spaces(row,:)=V_pve_0_dwi_mean_subjs_row_final;
end

V_pve_1_dwi_mean_subjs_final_spaces=[];
for row = 1:n_subjs
    V_pve_1_dwi_mean_subjs_row=V_pve_1_dwi_mean_subjs_final(row,:);
    lst_idx = lst_idx_matrix_dwi_spaces(row,:);
    V_pve_1_dwi_mean_subjs_row_final=V_pve_1_dwi_mean_subjs_row(lst_idx);
    V_pve_1_dwi_mean_subjs_final_spaces(row,:)=V_pve_1_dwi_mean_subjs_row_final;
end

V_pve_2_dwi_mean_subjs_final_spaces=[];
for row = 1:n_subjs
    V_pve_2_dwi_mean_subjs_row=V_pve_2_dwi_mean_subjs_final(row,:);
    lst_idx = lst_idx_matrix_dwi_spaces(row,:);
    V_pve_2_dwi_mean_subjs_row_final=V_pve_2_dwi_mean_subjs_row(lst_idx);
    V_pve_2_dwi_mean_subjs_final_spaces(row,:)=V_pve_2_dwi_mean_subjs_row_final;
end
%% if you have MSE
% if strcmp(micro_parameter,'Rsoma')    
%     medians_mse_rsoma_subjs_final_spaces=[];
%     for row = 1:n_subjs
%         medians_mse_rsoma_subjs_row=medians_mse_rsoma_subjs_final(row,:);
%         lst_idx = lst_idx_matrix_dwi_spaces(row,:);
%         medians_mse_rsoma_subjs_row_final=medians_mse_rsoma_subjs_row(lst_idx);
%         medians_mse_rsoma_subjs_final_spaces(row,:)=medians_mse_rsoma_subjs_row_final;
%     end
% else
%     medians_mse_subjs_final_spaces=[];
%     for row = 1:n_subjs
%         medians_mse_subjs_row=medians_mse_subjs_final(row,:);
%         lst_idx = lst_idx_matrix_dwi_spaces(row,:);
%         medians_mse_subjs_row_final=medians_mse_subjs_row(lst_idx);
%         medians_mse_subjs_final_spaces(row,:)=medians_mse_subjs_row_final;
%     end
% end
% %In case you remove high MSE regions
% if strcmp(micro_parameter,'rsoma')
%     percentage_high_MSE_rsoma_subjs_final_spaces=[];
%     for row = 1:n_subjs
%         percentage_high_MSE_rsoma_subjs_row=percentage_high_MSE_rsoma_subjs_final(row,:);
%         lst_idx = lst_idx_matrix_dwi_spaces(row,:);
%         percentage_high_MSE_rsoma_subjs_row_final=percentage_high_MSE_rsoma_subjs_row(lst_idx);
%         percentage_high_MSE_rsoma_subjs_final_spaces(row,:)=percentage_high_MSE_rsoma_subjs_row_final;
%     end
% else
%     percentage_high_MSE_microparameter_subjs_final_spaces=[];
%     for row = 1:n_subjs
%         percentage_high_MSE_microparameter_subjs_row=percentage_high_MSE_microparameter_subjs_final(row,:);
%         lst_idx = lst_idx_matrix_dwi_spaces(row,:);
%         percentage_high_MSE_microparameter_subjs_row_final=percentage_high_MSE_microparameter_subjs_row(lst_idx);
%         percentage_high_MSE_microparameter_subjs_final_spaces(row,:)=percentage_high_MSE_microparameter_subjs_row_final;
%     end
% end
%% func space

%First, detect indices of common Elements

lst_idx_matrix_func_spaces=[];
for row = 1:length(labels_func_subjs_final(:,1))
    lst_idx_row=[];
    for i = 1:length(commonElements)
        commonElement = commonElements(i);
        idx = find(labels_func_subjs_final(row,:) == commonElement);
        % if length(idx)>1
        %     lst_idx_row(1,:)=idx;
        % else
        lst_idx_row(end+1)=idx;
        % end
    end
    lst_idx_matrix_func_spaces(row,:)=lst_idx_row;
end

%Secondly, select common indices
%apply this both to the median values and labels
medians_func_subjs_final_spaces=[];
for row = 1:length(medians_func_subjs_final(:,1))
    medians_func_subjs_row=medians_func_subjs_final(row,:);
    lst_idx = lst_idx_matrix_func_spaces(row,:);
    medians_func_subjs_row_final=medians_func_subjs_row(lst_idx);
    medians_func_subjs_final_spaces(row,:)=medians_func_subjs_row_final;
end

labels_func_subjs_final_spaces=[];
for row = 1:length(labels_func_subjs_final(:,1))
    labels_func_subjs_row=labels_func_subjs_final(row,:);
    lst_idx = lst_idx_matrix_func_spaces(row,:);
    labels_func_subjs_row_final=labels_func_subjs_row(lst_idx);
    labels_func_subjs_final_spaces(row,:)=labels_func_subjs_row_final;
end

V_pve_0_func_mean_subjs_final_spaces=[];
for row = 1:length(V_pve_0_func_mean_subjs_final(:,1))
    V_pve_0_func_mean_subjs_row=V_pve_0_func_mean_subjs_final(row,:);
    lst_idx = lst_idx_matrix_func_spaces(row,:);
    V_pve_0_func_mean_subjs_row_final=V_pve_0_func_mean_subjs_row(lst_idx);
    V_pve_0_func_mean_subjs_final_spaces(row,:)=V_pve_0_func_mean_subjs_row_final;
end

V_pve_1_func_mean_subjs_final_spaces=[];
for row = 1:length(V_pve_1_func_mean_subjs_final(:,1))
    V_pve_1_func_mean_subjs_row=V_pve_1_func_mean_subjs_final(row,:);
    lst_idx = lst_idx_matrix_func_spaces(row,:);
    V_pve_1_func_mean_subjs_row_final=V_pve_1_func_mean_subjs_row(lst_idx);
    V_pve_1_func_mean_subjs_final_spaces(row,:)=V_pve_1_func_mean_subjs_row_final;
end

V_pve_2_func_mean_subjs_final_spaces=[];
for row = 1:length(V_pve_2_func_mean_subjs_final(:,1))
    V_pve_2_func_mean_subjs_row=V_pve_2_func_mean_subjs_final(row,:);
    lst_idx = lst_idx_matrix_func_spaces(row,:);
    V_pve_2_func_mean_subjs_row_final=V_pve_2_func_mean_subjs_row(lst_idx);
    V_pve_2_func_mean_subjs_final_spaces(row,:)=V_pve_2_func_mean_subjs_row_final;
end

% %percentage of zeros in the different regions of different subjects
% percentage_zeros_CMRO2_subjs_final_spaces=[];
% for row = 1:length(percentage_zeros_CMRO2_subjs_final(:,1))
%     percentage_zeros_CMRO2_subjs_row=percentage_zeros_CMRO2_subjs_final(row,:);
%     lst_idx = lst_idx_matrix_func_spaces(row,:);
%     percentage_zeros_CMRO2_subjs_row_final=percentage_zeros_CMRO2_subjs_row(lst_idx);
%     percentage_zeros_CMRO2_subjs_final_spaces(row,:)=percentage_zeros_CMRO2_subjs_row_final;
% end
% 
% %percentage of nans in the different regions of different subjects
% percentage_nans_CMRO2_subjs_final_spaces=[];
% for row = 1:length(percentage_nans_CMRO2_subjs_final(:,1))
%     percentage_nans_CMRO2_subjs_row=percentage_nans_CMRO2_subjs_final(row,:);
%     lst_idx = lst_idx_matrix_func_spaces(row,:);
%     percentage_nans_CMRO2_subjs_row_final=percentage_nans_CMRO2_subjs_row(lst_idx);
%     percentage_nans_CMRO2_subjs_final_spaces(row,:)=percentage_nans_CMRO2_subjs_row_final;
% end

%% informal testing
%isequal(labels_func_subjs_final_spaces,labels_dwi_subjs_final_spaces)

%% Remove regions based on the number of NaNs

% %Check number of nan values vs subjects for each region
% for region = 1:length(labels_func_subjs_final_spaces(1,:))
%     figure, bar(percentage_nans_func_subjs(:,region))
%     title(strcat('Region',num2str(region)))
%     ylabel(strcat('percentage CMRO_{2} nan values  removed'));
%     xlabel('subjects')
% end

% count how many subjects have number of nans > 50% of total number of
% voxels for each region
percentage=0.5;
n_subjects_tot=[];
for region = 1:length(labels_func_subjs_final_spaces(1,:))
    n_subjects = numel(find(percentage_nans_CMRO2_subjs_final_spaces(:,region)>percentage))/n_subjs;
    n_subjects_tot(end+1)=n_subjects;
end

%%barplot
% figure, bar(n_subjects_tot);
% xlabel('Region');
% ylabel('Number of subjects ratio')
% title(strcat('Number of NaNs >',num2str(percentage*100),'%'));
% grid on

nans_threshold=0.5;
regions_idx=find(n_subjects_tot>nans_threshold);

%% You can run only this if don't want to remove anything
medians_func = medians_func_subjs_final_spaces;
medians_dwi = medians_dwi_subjs_final_spaces;

if strcmp(micro_parameter,'Rsoma')
    if strcmp(mse_threshold,'yes')
        medians_mse = medians_mse_rsoma_subjs_final_spaces;
    end
    labels_final_rsoma=labels_func_subjs_final_spaces(1,:);
elseif strcmp(micro_parameter,'fsoma')
    if strcmp(mse_threshold,'yes')
        medians_mse = medians_mse_subjs_final_spaces;
    end
    labels_final_fsoma=labels_func_subjs_final_spaces(1,:);
elseif strcmp(micro_parameter,'fsup')
    if strcmp(mse_threshold,'yes')
        medians_mse = medians_mse_subjs_final_spaces;
    end
    labels_final_fsup=labels_func_subjs_final_spaces(1,:);
elseif strcmp(micro_parameter,'fc')
    if strcmp(mse_threshold,'yes')
        medians_mse = medians_mse_subjs_final_spaces;
    end
    labels_final_fc=labels_func_subjs_final_spaces(1,:);
end

means_pve_0_func = V_pve_0_func_mean_subjs_final_spaces;
means_pve_1_func = V_pve_1_func_mean_subjs_final_spaces;
means_pve_2_func = V_pve_2_func_mean_subjs_final_spaces;

means_pve_0_dwi = V_pve_0_dwi_mean_subjs_final_spaces;
means_pve_1_dwi = V_pve_1_dwi_mean_subjs_final_spaces;
means_pve_2_dwi = V_pve_2_dwi_mean_subjs_final_spaces;

labels_final=labels_func_subjs_final_spaces(1,:);
%%

medians_func(:,regions_idx)=[];
medians_dwi(:,regions_idx)=[];
if strcmp(mse_threshold,'yes')
    medians_mse(:,regions_idx)=[];
end

means_pve_0_func(:,regions_idx)=[];
means_pve_1_func(:,regions_idx)=[];
means_pve_2_func(:,regions_idx)=[];

means_pve_0_dwi(:,regions_idx)=[];
means_pve_1_dwi(:,regions_idx)=[];
means_pve_2_dwi(:,regions_idx)=[];




labels_final(regions_idx)=[];
disp('Regions with high number of NaNs successfully removed');

%%
% if strcmp(micro_parameter,'fsup')
%     medians_fsup=medians_dwi;
% elseif strcmp(micro_parameter,'fc')
%     medians_fc=medians_dwi;
% elseif strcmp(micro_parameter,'Rsoma')
%     medians_rsoma=medians_dwi;
% end

 %% Remove regions based on the number of high idx MSE
% 
% 
% percentage=0.5;
% n_subjects_tot=[];
% if strcmp(micro_parameter,'rsoma')
%     for region = 1:length(labels_func_subjs_final_spaces(1,:))
%         n_subjects = numel(find(percentage_removal_rsoma_subjs(:,region)>percentage))/n_subjs;
%         n_subjects_tot(end+1)=n_subjects;
%     end
% else
%     for region = 1:length(labels_func_subjs_final_spaces(1,:))
%         n_subjects = numel(find(percentage_removal_microparameter_subjs(:,region)>percentage))/n_subjs;
%         n_subjects_tot(end+1)=n_subjects;
%     end
% end
% % figure, bar(n_subjects_tot);
% % xlabel('Region');
% % ylabel('Number of subjects ratio')
% % title(strcat('Number of NaNs >',num2str(percentage*100),'%'));
% % grid on
% 
% high_mse_threshold=0.5;
% regions_idx=find(n_subjects_tot>high_mse_threshold);
% 
% medians_func = medians_func_subjs_final_spaces;
% medians_dwi = medians_dwi_subjs_final_spaces;
% if strcmp(micro_parameter,'Rsoma')
%     medians_mse = medians_mse_rsoma_subjs_final_spaces;
% else
%     medians_mse = medians_mse_subjs_final_spaces;
% end
% medians_func(:,regions_idx)=[];
% medians_dwi(:,regions_idx)=[];
% medians_mse(:,regions_idx)=[];
% disp('Regions with high number of high MSE values successfully removed');

%% across regions (medians across subjs)

%for median analysis
% medians_func = medians_func_subjs_final_spaces;
% medians_dwi = medians_dwi_subjs_final_spaces;

if strcmp(energy_parameter,'CBF')   
    dependent_parameter='CBF (ml/100g/min)';
elseif strcmp(energy_parameter,'CMRO2')
    dependent_parameter='CMRO_2 (\mu mol/100g/min)';
end

medians_energy_vec = nanmedian(medians_func,1);
SE_energy = nanstd(medians_func,0,1)/sqrt(n_subjs);
if strcmp(micro_parameter,'Rsoma')
    medians_micro_parameter_vec_rsoma = nanmedian(medians_dwi,1);
elseif strcmp(micro_parameter,'fsoma')
    medians_micro_parameter_vec_fsoma = nanmedian(medians_dwi,1);
elseif strcmp(micro_parameter,'fsup')
    medians_micro_parameter_vec_fsup = nanmedian(medians_dwi,1);
elseif strcmp(micro_parameter,'fc')
    medians_micro_parameter_vec_fc = nanmedian(medians_dwi,1);
end

medians_micro_parameter_vec = nanmedian(medians_dwi,1);
SE_micro_parameter = nanstd(medians_dwi,0,1)/sqrt(n_subjs);
if strcmp(mse_threshold,'yes')
    medians_mse = nanmedian(medians_mse,1);
end

cv_micro_parameter = SE_micro_parameter./medians_micro_parameter_vec;

means_pve_0_dwi_vec = nanmedian(means_pve_0_dwi,1);
SE_pve_0_dwi = nanstd(means_pve_0_dwi_vec,0,1)/sqrt(n_subjs);
means_pve_1_dwi_vec = nanmedian(means_pve_1_dwi,1);
SE_pve_1_dwi = nanstd(means_pve_1_dwi_vec,0,1)/sqrt(n_subjs);
means_pve_2_dwi_vec = nanmedian(means_pve_2_dwi,1);
SE_pve_2_dwi = nanstd(means_pve_2_dwi_vec,0,1)/sqrt(n_subjs);

means_pve_0_func_vec = nanmedian(means_pve_0_func,1);
SE_pve_0_func = nanstd(means_pve_0_func_vec,0,1)/sqrt(n_subjs);
means_pve_1_func_vec = nanmedian(means_pve_1_func,1);
SE_pve_1_func = nanstd(means_pve_1_func_vec,0,1)/sqrt(n_subjs);
means_pve_2_func_vec = nanmedian(means_pve_2_func,1);
SE_pve_2_func = nanstd(means_pve_2_func_vec,0,1)/sqrt(n_subjs);

disp('median across subjects computed')

%% save matrices for threshold value analysis
% if pve_0_threshold_dwi==0
%     medians_energy_vec_thr00=medians_energy_vec;
%     medians_micro_parameter_vec_thr00=medians_micro_parameter_vec;
%     labels_final_thr00=labels_final;
% elseif pve_0_threshold_dwi==0.1
%     medians_energy_vec_thr01=medians_energy_vec;
%     medians_micro_parameter_vec_thr01=medians_micro_parameter_vec;
%     labels_final_thr01=labels_final;
% elseif pve_0_threshold_dwi==0.2
%     medians_energy_vec_thr02=medians_energy_vec;
%     medians_micro_parameter_vec_thr02=medians_micro_parameter_vec;
%     labels_final_thr02=labels_final;
% elseif pve_0_threshold_dwi==0.3
%     medians_energy_vec_thr03=medians_energy_vec;
%     medians_micro_parameter_vec_thr03=medians_micro_parameter_vec;
%     labels_final_thr03=labels_final;
% elseif pve_0_threshold_dwi==0.4
%     medians_energy_vec_thr04=medians_energy_vec;
%     medians_micro_parameter_vec_thr04=medians_micro_parameter_vec;
%     labels_final_thr04=labels_final;
% elseif pve_0_threshold_dwi==0.5
%     medians_energy_vec_thr05=medians_energy_vec;
%     medians_micro_parameter_vec_thr05=medians_micro_parameter_vec;
%     labels_final_thr05=labels_final;
% elseif pve_0_threshold_dwi==0.6
%     medians_energy_vec_thr06=medians_energy_vec;
%     medians_micro_parameter_vec_thr06=medians_micro_parameter_vec;
%     labels_final_thr06=labels_final;
% elseif pve_0_threshold_dwi==0.7
%     medians_energy_vec_thr07=medians_energy_vec;
%     medians_micro_parameter_vec_thr07=medians_micro_parameter_vec;
%     labels_final_thr07=labels_final;
% elseif pve_0_threshold_dwi==0.8
%     medians_energy_vec_thr08=medians_energy_vec;
%     medians_micro_parameter_vec_thr08=medians_micro_parameter_vec;
%     labels_final_thr08=labels_final;
% elseif pve_0_threshold_dwi==0.9
%     medians_energy_vec_thr09=medians_energy_vec;
%     medians_micro_parameter_vec_thr09=medians_micro_parameter_vec;
%     labels_final_thr09=labels_final;
% elseif pve_0_threshold_dwi==1
%     medians_energy_vec_onlyGM=medians_energy_vec;
%     medians_micro_parameter_vec_onlyGM=medians_micro_parameter_vec;
%     labels_final_onlyGM=labels_final;
% end

 %% compare std vs mse and cv vs mse
% 
% figure, 
% bar(SE_micro_parameter);
% legend('Standard Error')
% 
% figure,
% bar(medians_mse);
% ylim([0,1.5*10^(-3)])
% legend('MSE')
% 
% figure,
% bar(cv_micro_parameter);
% legend('CV')
% 
% 
% 
% idx_mse = find(medians_mse>prctile(medians_mse,75));
% % isequal(labels_func_subjs_final_spaces,labels_dwi_subjs_final_spaces)
% labels_high_mse=labels_final(idx_mse);
% 
% %CV
% idx_cv = find(cv_micro_parameter>prctile(cv_micro_parameter,75));
% labels_high_cv = labels_final(idx_cv);
% %size(labels_high_mse)==size(labels_high_cv)
% 
% %find labels that have both high cv and high MSE
% equal_labels=intersect(labels_high_cv,labels_high_mse);
% percentage_equal_labels=numel(equal_labels)/numel(labels_high_mse);% 58%
% percentage_equal_labels
% 
% %SE
% idx_SE = find(SE_micro_parameter>prctile(SE_micro_parameter,75));
% labels_high_SE = labels_final(idx_SE);
% %size(labels_high_mse)==size(labels_high_SE)
% 
% %find labels that have both high SE and MSE
% equal_labels=intersect(labels_high_SE,labels_high_mse);
% percentage_equal_labels=numel(equal_labels)/numel(labels_high_mse);% 55%
% percentage_equal_labels
% 
% equal_labels_idx_SE_MSE=[];
% for i = 1:numel(equal_labels)
%     idx=find(labels_final==equal_labels(i));
%     equal_labels_idx_SE_MSE(end+1)=idx;
% end
% 
% % V_mse_maps_1=V_mse_maps{1};
% % median(V_mse_maps_1(:))
% % figure, imagesc(V_mse_maps_1(:,:,40))
% 
 %% remove regions which have high SE and MSE values
% medians_energy_vec(equal_labels_idx_SE_MSE)=[];
% medians_micro_parameter_vec(equal_labels_idx_SE_MSE)=[];
% SE_energy(equal_labels_idx_SE_MSE)=[];
% SE_micro_parameter(equal_labels_idx_SE_MSE)=[];
% 
% %% remove regions which have high SE values
% medians_energy_vec(idx_SE)=[];
% medians_micro_parameter_vec(idx_SE)=[];
% SE_energy(idx_SE)=[];
% SE_micro_parameter(idx_SE)=[];
% 
% %% remove regions which have high CV values
% medians_energy_vec(idx_cv)=[];
% medians_micro_parameter_vec(idx_cv)=[];
% SE_energy(idx_cv)=[];
% SE_micro_parameter(idx_cv)=[];

%% run this section to save names of labels in the variables

if strcmp(micro_parameter,'Rsoma')
    unit_of_measure_dwi='(\mum)';
elseif strcmp(micro_parameter,'fsoma')
    unit_of_measure_dwi='';
elseif strcmp(micro_parameter,'fsup')
    unit_of_measure_dwi='(m^{-1})';
elseif strcmp(micro_parameter,'fc')
    unit_of_measure_dwi='(m^{-3})';
elseif strcmp(micro_parameter,'fneurite')
    unit_of_measure_dwi='';
end

if strcmp(energy_parameter,'CMRO2')
    energy_parameter_label='CMRO_2';
    unit_of_measure_energy='(\mumol/100g/min)';
else
    energy_parameter_label='CBF';
    unit_of_measure_energy='(ml/100g/min)';
end

 %% Run if you want to remove outliers identified by eyes
% rsoma_limit=11.1;%11.1
% idx_outlier=find(medians_micro_parameter_vec<rsoma_limit);
% % energy_limit=160;
% % idx_outlier=find(medians_energy_vec>energy_limit);
% 
% labels_low_rsoma = labels_final(idx_outlier);
% 
% medians_energy_vec(idx_outlier)=[];
% medians_micro_parameter_vec(idx_outlier)=[];
% SE_energy(idx_outlier)=[];
% SE_micro_parameter(idx_outlier)=[];
% 
% means_pve_0_dwi_vec(idx_outlier)=[];
% means_pve_1_dwi_vec(idx_outlier)=[];
% means_pve_2_dwi_vec(idx_outlier)=[];
% 
% means_pve_0_func_vec(idx_outlier)=[];
% means_pve_1_func_vec(idx_outlier)=[];
% means_pve_2_func_vec(idx_outlier)=[];
% 
% SE_pve_0_func(idx_outlier)=[];
% SE_pve_1_func(idx_outlier)=[];
% SE_pve_2_func(idx_outlier)=[];
% 
% SE_pve_0_dwi(idx_outlier)=[];
% SE_pve_1_dwi(idx_outlier)=[];
% SE_pve_2_dwi(idx_outlier)=[];
% 
% labels_final(idx_outlier)=[];
% 
% 
% % %find which are low rsoma regions
% % disp(strcat('Lower rsoma labels are:',num2str(labels_final(idx_outlier))))
% % numel(idx_outlier)
% % find(labels_final==46)

 %% remove regional micro_parameter regions corresponding to low rsoma labels 
% 
% idx_outlier = [];
% for i=1:length(labels_low_rsoma)
%     idx = find(labels_final==labels_low_rsoma(i));
%     idx_outlier(end+1)=idx;
% end
% 
% medians_energy_vec(idx_outlier)=[];
% medians_micro_parameter_vec(idx_outlier)=[];
% SE_energy(idx_outlier)=[];
% SE_micro_parameter(idx_outlier)=[];


% %% compute correlation coefficient without removing NaN medians and without removing PVE effects
% [r,p]=corrcoef(medians_energy_vec,medians_micro_parameter_vec,'rows','complete');%0.37%p0.0029
% %try other kind of correlation
% corr_coef_str=num2str(round(r(2),2));

%% remove regions whose resulting median regional value across subjects is NAN
%in either the functional parameter or microstructural parameter

% microstructural regions

idx = find(isnan(medians_micro_parameter_vec))
medians_energy_vec(idx)=[];
medians_micro_parameter_vec(idx)=[];
SE_energy(idx)=[];
SE_micro_parameter(idx)=[];

means_pve_0_dwi_vec(idx)=[];
means_pve_1_dwi_vec(idx)=[];
means_pve_2_dwi_vec(idx)=[];

means_pve_0_func_vec(idx)=[];
means_pve_1_func_vec(idx)=[];
means_pve_2_func_vec(idx)=[];

SE_pve_0_func(idx)=[];
SE_pve_1_func(idx)=[];
SE_pve_2_func(idx)=[];

SE_pve_0_dwi(idx)=[];
SE_pve_1_dwi(idx)=[];
SE_pve_2_dwi(idx)=[];

% energetic regions

idx = find(isnan(medians_energy_vec))
medians_energy_vec(idx)=[];
medians_micro_parameter_vec(idx)=[];
SE_energy(idx)=[];
SE_micro_parameter(idx)=[];

%pve 

means_pve_0_dwi_vec(idx)=[];
means_pve_1_dwi_vec(idx)=[];
means_pve_2_dwi_vec(idx)=[];

means_pve_0_func_vec(idx)=[];
means_pve_1_func_vec(idx)=[];
means_pve_2_func_vec(idx)=[];

SE_pve_0_func(idx)=[];
SE_pve_1_func(idx)=[];
SE_pve_2_func(idx)=[];

SE_pve_0_dwi(idx)=[];
SE_pve_1_dwi(idx)=[];
SE_pve_2_dwi(idx)=[];

disp('medians across subjects equal to NaN removed')

%% fit and plot (without taking into account PVE influences)
% 
% y=medians_energy_vec;
% x=medians_micro_parameter_vec;
% % Fit a quadratic equation
% pol = polyfit(x, y, 1);
% % Evaluate the fitted polynomial
% y_fit = polyval(pol, x);
% % Calculate the R-squared value
% Rsquared = 1 - sum((y - y_fit).^2) / sum((y - nanmean(y)).^2);
% Rsquared
% 
% [x_sorted,index] = sortrows(x');
% y_fit=y_fit';
% y_fit_sorted = y_fit(index);
% 
% 
 %%
% figure, 
% s = errorbar(medians_micro_parameter_vec, medians_energy_vec, SE_energy, SE_energy, SE_micro_parameter, SE_micro_parameter,'o');
% % hold on
% % plot(x_sorted,y_fit_sorted,'--','LineWidth',3,'Color',"#000000");
% % diff=setdiff(medians_micro_parameter_vec_ALLpves,medians_micro_parameter_vec_GMpves);
% % idx_diff=find(medians_micro_parameter_vec==diff(1));
% % hold on
% % h = errorbar(medians_micro_parameter_vec(idx_diff), medians_energy_vec(idx_diff), SE_energy(idx_diff), SE_energy(idx_diff), SE_micro_parameter(idx_diff), SE_micro_parameter(idx_diff),'o');
% xlabel(strcat(micro_parameter,unit_of_measure_dwi),'FontSize',15,'FontWeight','bold');
% ylabel(strcat(energy_parameter_label,unit_of_measure_energy),'FontSize',15,'FontWeight','bold');
% s.LineWidth = 0.6;
% % h.LineWidth = 0.6;
% s.MarkerEdgeColor = 'b';
% % h.MarkerEdgeColor = 'r';
% s.MarkerFaceColor = [0 0.5 0.5];
% %h.MarkerFaceColor = [0 0.5 0.5];
% % if p(2)<0.05 && p(2)>0.01    
% %     txt = {strcat('r = ',corr_coef_str,'*')};
% % elseif p(2)<0.01 && p(2)>0.001   
% %     txt = {strcat('r = ',corr_coef_str,'**')};
% % elseif p(2)<0.001
% %     txt = {strcat('r = ',corr_coef_str,'***')};
% % elseif p(2)>0.05
% %         txt = {strcat('r = ',corr_coef_str,'')};
% % end
% % text(5*10^4,100,txt,'FontWeight', 'Bold');
% % annotation('textbox',[.6,.2,.30,.13], 'String', txt, 'FontWeight', 'Bold','FontSize',15);
% % if strcmp(energy_parameter,'CBF') && strcmp(micro_parameter,'Rsoma')
% %     text(13.8,60,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CBF') && strcmp(micro_parameter,'fsoma')
% %     text(0.39,60,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'Rsoma')
% %     text(13.8,140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'fsoma')
% %     text(0.39,140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'fc')
% %     text(3*10^(13),140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'fsup')
% %     text(8*10^4,140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'fneurite')
% %     text(0.3,140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CBF') && strcmp(micro_parameter,'fsup')
% %     text(8*10^4,60,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CBF') && strcmp(micro_parameter,'fc')
% %     text(3*10^13,60,txt, 'FontWeight', 'bold','FontSize',12);
% % 
% % end
% set(get(gca, 'XAxis'), 'FontWeight', 'bold');
% set(get(gca, 'YAxis'), 'FontWeight', 'bold');
% set(gca,'box','off')
% x0=50;
% y0=50;
% width=550;
% height=450;
% set(gcf,'position',[x0,y0,width,height]);
% grid on

 %% to save content variables
% if strcmp(micro_parameter,'Rsoma')
%     medians_rsoma = medians_micro_parameter_vec;
% elseif strcmp(micro_parameter,'fsup')
%     medians_fsup = medians_micro_parameter_vec;
% elseif strcmp(micro_parameter,'fc')
%     medians_fc = medians_micro_parameter_vec;
% elseif strcmp(micro_parameter,'fsoma')
%     medians_fsoma = medians_micro_parameter_vec;
% end
% 
 %% check relationship between parameters and PVE medians
% 
% %select parameters
% pve_tissue = 'GM';
% parameter = 'func';
% 
% %select data
% if strcmp(parameter,'dwi')
%     medians_parameter = medians_micro_parameter_vec;
%     SE_parameter = SE_micro_parameter;
%     if strcmp(pve_tissue,'CSF')
%         means_pve = means_pve_0_dwi_vec;
%         SE_pve = SE_pve_0_dwi;
%     elseif strcmp(pve_tissue,'WM')
%         means_pve = means_pve_2_dwi_vec;
%         SE_pve = SE_pve_2_dwi;
%     elseif strcmp(pve_tissue,'GM')
%         means_pve = means_pve_1_dwi_vec;
%         SE_pve = SE_pve_1_dwi;
%     end
% elseif strcmp(parameter,'func')
%     medians_parameter = medians_energy_vec;
%     SE_parameter = SE_energy;
%     if strcmp(pve_tissue,'CSF')
%         means_pve = means_pve_0_func_vec;
%         SE_pve = SE_pve_0_func;
%     elseif strcmp(pve_tissue,'WM')
%         means_pve = means_pve_2_func_vec;
%         SE_pve = SE_pve_2_func;
%     elseif strcmp(pve_tissue,'GM')
%         means_pve = means_pve_1_func_vec;
%         SE_pve = SE_pve_1_func;
% 
%     end
% end
% 
% 
% % 
% [r,p]=corrcoef(medians_parameter,means_pve,'rows','complete');
% corr_coef_str=num2str(round(r(2),2));
% 
% tbl = table(medians_parameter', means_pve','VariableNames',{'parameter','pve'});
% fitlm(tbl,'parameter~pve','RobustOpts','on')
% 
% %plot (manually select y label)
% figure, 
% s = errorbar(means_pve, medians_parameter, SE_parameter, SE_parameter, SE_pve, SE_pve,'o');
% % hold on
% % plot(x_sorted,y_fit_sorted,'--','LineWidth',3,'Color',"#000000");
% xlabel(strcat(pve_tissue,'pve'),'FontSize',15,'FontWeight','bold');
% if strcmp(parameter,'dwi')
%     ylabel(strcat(micro_parameter,unit_of_measure_dwi),'FontSize',15,'FontWeight','bold');
% else
%     ylabel(strcat(energy_parameter_label,unit_of_measure_energy),'FontSize',15,'FontWeight','bold');
% end
% s.LineWidth = 0.6;
% % h.LineWidth = 0.6;
% s.MarkerEdgeColor = 'b';
% % h.MarkerEdgeColor = 'r';
% s.MarkerFaceColor = [0 0.5 0.5];
% if p(2)<0.05 && p(2)>0.01    
%     txt = {strcat('r = ',corr_coef_str,'*')};
% elseif p(2)<0.01 && p(2)>0.001   
%     txt = {strcat('r = ',corr_coef_str,'**')};
% elseif p(2)<0.001
%     txt = {strcat('r = ',corr_coef_str,'***')};
% elseif p(2)>0.05
%         txt = {strcat('r = ',corr_coef_str,'')};
% end
% title('Regional medians')
% text(60,12,txt,'FontWeight', 'Bold');
% annotation('textbox',[.6,.2,.30,.13], 'String', txt, 'FontWeight', 'Bold','FontSize',15);
% % if strcmp(energy_parameter,'CBF') && strcmp(micro_parameter,'Rsoma')
% %     text(13.8,60,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CBF') && strcmp(micro_parameter,'fsoma')
% %     text(0.39,60,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'Rsoma')
% %     text(13.8,140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'fsoma')
% %     text(0.39,140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'fc')
% %     text(3*10^(13),140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'fsup')
% %     text(8*10^4,140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CMRO2') && strcmp(micro_parameter,'fneurite')
% %     text(0.3,140,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CBF') && strcmp(micro_parameter,'fsup')
% %     text(8*10^4,60,txt, 'FontWeight', 'bold','FontSize',12);
% % elseif strcmp(energy_parameter,'CBF') && strcmp(micro_parameter,'fc')
% %     text(3*10^13,60,txt, 'FontWeight', 'bold','FontSize',12);
% % 
% % end
% set(get(gca, 'XAxis'), 'FontWeight', 'bold');
% set(get(gca, 'YAxis'), 'FontWeight', 'bold');
% set(gca,'box','off')
% %where the plot will be displayed
% x0=400;
% y0=400;
% width=550;
% height=450;
% set(gcf,'position',[x0,y0,width,height]);
% grid on

%% GLM considering PVE_WM and PVE_CSF as covariates

%to use this, you should remove NaNs to everyone
% medians_dwi_scored = zscore(medians_micro_parameter_vec);
% medians_pve_0_dwi_scored = zscore(medians_pve_0_dwi_vec);
% medians_pve_2_dwi_scored = zscore(medians_pve_2_dwi_vec);
% medians_energy_dwi_scored = zscore(medians_energy_vec);
%medians_micro_parameter_vec = medians_fc;
cd('/home/c25078236/Desktop/programmes/250902')

disp('Computing Generalized Linear Model')

medians_dwi_scored = nanzscore(medians_micro_parameter_vec);
means_pve_0_dwi_scored = nanzscore(means_pve_0_dwi_vec);
means_pve_1_dwi_scored = nanzscore(means_pve_1_dwi_vec);
means_pve_2_dwi_scored = nanzscore(means_pve_2_dwi_vec);
medians_energy_scored = nanzscore(medians_energy_vec);
means_pve_0_func_scored = nanzscore(means_pve_0_func_vec);
means_pve_1_func_scored = nanzscore(means_pve_1_func_vec);
means_pve_2_func_scored = nanzscore(means_pve_2_func_vec);
%medians_mse_scored = nanzscore(medians_mse);

medians_dwi_scored_tr = medians_dwi_scored';
means_pve_0_dwi_scored_tr = means_pve_0_dwi_scored';
means_pve_1_dwi_scored_tr = means_pve_1_dwi_scored';
means_pve_2_dwi_scored_tr = means_pve_2_dwi_scored';
medians_energy_scored_tr = medians_energy_scored';
means_pve_0_func_scored_tr = means_pve_0_func_scored';
means_pve_1_func_scored_tr = means_pve_1_func_scored';
means_pve_2_func_scored_tr = means_pve_2_func_scored';
%medians_mse_scored_tr = medians_mse_scored';

% %consider both dwi and func PVE medians as covariates
% %CMRO2 can be influenced by: pve in its space (as we saw)
% %Rsoma and, since in turn Rsoma can be influenced by pve in dwi space,
% %CMRO2 can be influenced by the pve values in dwi space as well.


%% using table

if strcmp(micro_parameter,'fc')
    tbl=table(medians_energy_scored_tr,medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_1_dwi_scored_tr,means_pve_2_dwi_scored_tr,means_pve_0_func_scored_tr,means_pve_1_func_scored_tr,means_pve_2_func_scored_tr, 'VariableNames', ...
        {'CMRO2','fc','pve_0_dwi','pve_1_dwi','pve_2_dwi','pve_0_func','pve_1_func','pve_2_func'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ fc + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    % mdl=fitlm(tbl,'CMRO2 ~ fc','RobustOpts','on')
elseif strcmp(micro_parameter,'fsup')
    tbl=table(medians_energy_scored_tr,medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_1_dwi_scored_tr,means_pve_2_dwi_scored_tr,means_pve_0_func_scored_tr,means_pve_1_func_scored_tr,means_pve_2_func_scored_tr, 'VariableNames', ...
        {'CMRO2','fsup','pve_0_dwi','pve_1_dwi','pve_2_dwi','pve_0_func','pve_1_func','pve_2_func'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ fsup + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','off')
elseif strcmp(micro_parameter,'fsoma')
    tbl=table(medians_energy_scored_tr,medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_1_dwi_scored_tr,means_pve_2_dwi_scored_tr,means_pve_0_func_scored_tr,means_pve_1_func_scored_tr,means_pve_2_func_scored_tr, 'VariableNames', ...
        {'CMRO2','fsoma','pve_0_dwi','pve_1_dwi','pve_2_dwi','pve_0_func','pve_1_func','pve_2_func'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ fsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
elseif strcmp(micro_parameter,'Rsoma')
    tbl=table(medians_energy_scored_tr,medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_1_dwi_scored_tr,means_pve_2_dwi_scored_tr,means_pve_0_func_scored_tr,means_pve_1_func_scored_tr,means_pve_2_func_scored_tr, 'VariableNames', ...
        {'CMRO2','Rsoma','pve_0_dwi','pve_1_dwi','pve_2_dwi','pve_0_func','pve_1_func','pve_2_func'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ Rsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
end


 %% using matrix 
% y = medians_energy_scored_tr;
% X = cat(2, medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr);
% 
% %build your model
% mdl=fitlm(X,y,'RobustOpts','on');

 %% covaried out covariates (method I)
% % convert zscored GLM results in original units
% coeffs_mat=table2array(mdl.Coefficients);
% estimate_pve_0_rescaled = coeffs_mat(3,1).*std(means_pve_0_dwi_vec)+mean(means_pve_0_dwi_vec);
% estimate_pve_2_rescaled = coeffs_mat(4,1).*std(means_pve_2_dwi_vec)+mean(means_pve_2_dwi_vec);
% %values calculated in this way do not correspond to the original values
% %that I obtain calculating the GLM rescaling by 10^9
% %so I don't know if it is right
% 
% tstat_pve_0_rescaled = coeffs_mat(3,2).*std(means_pve_0_dwi_vec)+mean(means_pve_0_dwi_vec);
% tstat_pve_2_rescaled = coeffs_mat(4,2).*std(means_pve_2_dwi_vec)+mean(means_pve_2_dwi_vec);
% 
% %regress out
% y_pve_0_dwi = means_pve_0_dwi_vec.*estimate_pve_0_rescaled;
% y_pve_2_dwi = means_pve_2_dwi_vec.*estimate_pve_2_rescaled;
% cmro2_regressed = medians_energy_vec-y_pve_0_dwi-y_pve_2_dwi;
% 
 %% covaried out covariates (method II)
% %GLM in original units (consider units of 10^9 cells)
% 
% if strcmp(micro_parameter,'fc')
%     scaling_factor=10^9;
% elseif strcmp(micro_parameter,'fsup')
%     scaling_factor=1;
% end
% 
% %GLM in original units
% if strcmp(micro_parameter,'fc')
%     medians_microparameter_rescaled = medians_micro_parameter_vec'./scaling_factor;
%     tbl=table(medians_energy_vec',medians_microparameter_rescaled,means_pve_0_dwi_vec',means_pve_1_dwi_vec',means_pve_2_dwi_vec',means_pve_0_func_vec',means_pve_1_func_vec',means_pve_2_func_vec', 'VariableNames', ...
%         {'CMRO2','fc','pve_0_dwi','pve_1_dwi','pve_2_dwi','pve_0_func','pve_1_func','pve_2_func'});
%     %build your model
%     mdl=fitlm(tbl,'CMRO2 ~ fc + pve_0_dwi + pve_2_dwi','RobustOpts','on')
%     % mdl=fitlm(tbl,'CMRO2 ~ fc','RobustOpts','on')
% elseif strcmp(micro_parameter,'fsup')
%     tbl=table( medians_energy_vec',medians_micro_parameter_vec',means_pve_0_dwi_vec',means_pve_1_dwi_vec',means_pve_2_dwi_vec',means_pve_0_func_vec',means_pve_1_func_vec',means_pve_2_func_vec','VariableNames', ...
%         {'CMRO2','fsup','pve_0_dwi','pve_1_dwi','pve_2_dwi','pve_0_func','pve_1_func','pve_2_func'});
%     %build your model
%     mdl=fitlm(tbl,'CMRO2 ~ fsup + pve_0_dwi + pve_2_dwi','RobustOpts','on')
%     % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','off')
% end
% 
% %betas
% coeffs_mat=table2array(mdl.Coefficients);
% estimate_pve_0=coeffs_mat(3,1).*scaling_factor;
% estimate_pve_2=coeffs_mat(4,1).*scaling_factor;
% 
% %regress out
% y_pve_0_dwi = means_pve_0_dwi_vec.*estimate_pve_0;
% y_pve_2_dwi = means_pve_2_dwi_vec.*estimate_pve_2;
% cmro2_regressed = medians_energy_vec-y_pve_0_dwi-y_pve_2_dwi;

%% calculate the scale out cmro2 (III method)
% and then rescale back to the original
% it's the method used for the article analysis

coeffs_mat=table2array(mdl.Coefficients);
estimate_pve_0=coeffs_mat(3,1);
estimate_pve_2=coeffs_mat(4,1);

%regress out
y_pve_0_dwi = means_pve_0_dwi_scored.*estimate_pve_0;
y_pve_2_dwi = means_pve_2_dwi_scored.*estimate_pve_2;
cmro2_regressed_zscored = medians_energy_scored-y_pve_0_dwi-y_pve_2_dwi;

cmro2_regressed = cmro2_regressed_zscored.*std(medians_energy_vec)+mean(medians_energy_vec);

%% plot
% [r,p] = corrcoef(cmro2_regressed, medians_micro_parameter_vec,'rows','complete');

y=cmro2_regressed';
x=medians_micro_parameter_vec;
% Fit a quadratic equation
[pol,S] = polyfit(x, y, 1); %to plot the linear model I use this function
% Evaluate the fitted polynomial
y_fit = polyval(pol, x);
% Calculate the R-squared value
Rsquared = 1 - sum((y - y_fit).^2) / sum((y - nanmean(y)).^2);
% Rsquared

alpha = 0.05; % Significance level
[y_fit,delta] = polyconf(pol,x,S,'alpha',alpha);

[x_sorted,index] = sortrows(x');
y_fit=y_fit';
delta = delta';
y_fit_sorted = y_fit(index);
delta_sorted = delta(index);

[r,p] = corrcoef(medians_micro_parameter_vec,cmro2_regressed);

corr_coef_str = num2str(round(r(2),2));

figure, 
s=plot(medians_micro_parameter_vec,cmro2_regressed,'.',MarkerSize=25);

%plot confidence interval shadow
x_patch = x_sorted;
y_patch_lower = y_fit_sorted-delta_sorted;
y_patch_higher = y_fit_sorted+delta_sorted;

x_all = [x_patch; flipud(x_patch)];
y_all = [y_patch_higher; flipud(y_patch_lower)];

patch(x_all,y_all,'cyan','FaceAlpha',0.1,'EdgeColor','none')

hold on
plot(x_sorted,y_fit_sorted,'--','LineWidth',3,'Color',"#000000");
hold on
plot(x_sorted,y_fit_sorted-delta_sorted,'--',x_sorted,y_fit_sorted+delta_sorted,'--','LineWidth',1.5,'Color',[0.5 0.5 0.5])

xlabel(strcat(micro_parameter,unit_of_measure_dwi),'FontSize',15,'FontWeight','bold');
ylabel(strcat('Adjusted CMRO_2',unit_of_measure_energy),'FontSize',12,'FontWeight','bold');
s.Color='b';
set(get(gca, 'XAxis'), 'FontWeight', 'bold');
set(get(gca, 'YAxis'), 'FontWeight', 'bold');
set(gca,'box','off')
x0=50;
y0=50;
width=550;
height=450;
if p(2)<0.05 && p(2)>0.01    
    txt = {strcat('Pearson r = ',corr_coef_str,'*')};
elseif p(2)<0.01 && p(2)>0.001   
    txt = {strcat('Pearson r = ',corr_coef_str,'**')};
elseif p(2)<0.001
    txt = {strcat('Pearson r = ',corr_coef_str,'***')};
elseif p(2)>0.05
        txt = {strcat('Pearson r = ',corr_coef_str,'')};
end
%text(9,100,txt,'FontWeight', 'Bold','FontSize',12);
%text(0.35,100,txt,'FontWeight', 'Bold','FontSize',12);
text(10^5,100,txt,'FontWeight', 'Bold','FontSize',12);
%text(10^14,100,txt,'FontWeight', 'Bold','FontSize',12);
set(gcf,'position',[x0,y0,width,height]);
ylim([50,180]);
grid on


% % x = [1 0 1 0];
% % y = [0 0 1 1];
% x = [0 1 1 0];
% y = [0 0 1 1];
% figure,
% patch(x,y,'red')
% %l'ordine cambia la figura


%you can't have error bars because you can't regress out for
%each subject.

 %% TEST YOUR MODEL
% 
% %% analysis using all regions for all subjects
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/RandomForest/data/data_ML.mat')
% y = medians_cmro2(:);
% 
% micro_parameter='fsup';
% 
% if strcmp(micro_parameter,'fsup')
%     X = cat(2,medians_fsup(:),means_pve_0_dwi(:),means_pve_2_dwi(:));
% elseif strcmp(micro_parameter,'fc')
%     X = cat(2,medians_fc(:),means_pve_0_dwi(:),means_pve_2_dwi(:));
% end
% 
% %build your model
% mdl=fitlm(X,y,'RobustOpts','on');
% 
 %% plot predicted vs true value
% 
% y_pred = predict(mdl,X);
% 
% figure, 
% scatter(y_pred,y);
% hold on
% plot(1:250,1:250);%bisector
% xlabel('Predicted')
% ylabel('target')
% 
% 
% 
% 
% % train on n samples and predict on n samples
% n_samples = length(medians_dwi_scored_tr)/2;


 %% to study the dependence on radius^2
% 
% X = cat(2,medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr);
% rsoma_squared = medians_dwi_scored_tr.^2;
% X_r2 = cat(2,rsoma_squared,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr);
% mdl=fitlm(X_r2,medians_energy_scored_tr,'RobustOpts','off')
% 
% 
% 
% 
% %% GLM without considering PVEs as covariates
% 
% medians_dwi_scored = nanzscore(medians_micro_parameter_vec);
% medians_energy_scored = nanzscore(medians_energy_vec);
% medians_dwi_scored_tr = medians_dwi_scored';
% medians_energy_scored_tr = medians_energy_scored';
% 
% tbl = table(medians_energy_scored_tr,medians_dwi_scored_tr,'VariableNames',{'CMRO2','fsup'});
% mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','on')
% 
% 
% % 
% % %consider both dwi PVE medians as covariates
% % X=cat(1,medians_dwi_scored, medians_pve_0_dwi_scored, medians_pve_2_dwi_scored);
% % y = medians_energy_scored;
% % X=X';
% % y=y';
% % fitlm(X,y)
% % 
% % %consider both func PVE medians as covariates
% % X=cat(1,medians_dwi_scored, medians_pve_0_func_scored, medians_pve_2_func_scored);
% % y = medians_energy_scored;
% % X=X';
% % y=y';
% % fitlm(X,y)



 %% How are pve medians in dwi and func spaces related ?
% 
% figure, 
% s=scatter(medians_pve_2_dwi_vec,medians_pve_2_func_vec,40);
% s.MarkerFaceColor = 'b';
% s.MarkerEdgeColor = 'b';
% title('Median WM PVE values');
% xlabel('PVE dwi space','FontWeight','bold');
% ylabel('PVE func space','FontWeight','bold');
% grid on
% 
% idx_nans = find(isnan(medians_pve_0_dwi_vec));
% 
% medians_pve_0_dwi_vec_nonans = medians_pve_0_dwi_vec;
% medians_pve_0_func_vec_nonans = medians_pve_0_func_vec;
% 
% medians_pve_0_dwi_vec_nonans(idx_nans)=[];
% medians_pve_0_func_vec_nonans(idx_nans)=[];
% 
% idx_nans = find(isnan(medians_pve_0_func_vec_nonans));
% 
% medians_pve_0_dwi_vec_nonans(idx_nans)=[];
% medians_pve_0_func_vec_nonans(idx_nans)=[];
% 
% [r,p]=corrcoef(medians_pve_0_dwi_vec_nonans,medians_pve_0_func_vec_nonans);

%% A METHOD TO FIND THE RIGHT PVE THRESHOLD 

% %% check parameter diff trend between the masked image and the row image (for different pve threshold)
% %you have to launch the code for different values of threshold
% %save results: labels, CMRO2 and rsoma medians.
% 
% %check if labels have equal order
% comparisons=[];
% for i = 1:length(labels_final_thr01)
%     elements=[labels_final_thr0(i),labels_final_thr01(i),labels_final_thr02(i),labels_final_thr03(i),labels_final_thr05(i),labels_final_onlyGM(i),labels_final_thr06(i),labels_final_thr07(i),labels_final_thr08(i),labels_final_thr09(i),labels_final_thr04(i)];
%     m = repmat(labels_final_thr01(i),1,length(elements));
%     comparison = isequal(m, elements);
%     comparisons(end+1)=comparison;
% end
% %check
% sum(comparisons)==length(comparisons)
% 
% % %detect uncommon label which is present in threshold=0.4
% % %and delete it
% % uncommon_label=setdiff(labels_final_thr04,labels_final_thr05);
% % 
% % idx_uncommon_label=find(labels_final_thr04==uncommon_label);
% % 
% % labels_final_thr04_withoutuncommon=labels_final_thr04;
% % medians_energy_vec_thr04_withoutuncommon=medians_energy_vec_thr04;
% % medians_micro_parameter_vec_thr04_withoutuncommon = medians_micro_parameter_vec_thr04;
% % 
% % labels_final_thr04_withoutuncommon(idx_uncommon_label)=[];
% % medians_energy_vec_thr04_withoutuncommon(idx_uncommon_label)=[];
% % medians_micro_parameter_vec_thr04_withoutuncommon(idx_uncommon_label)=[];
% 
 %%
% %now you can calculate the mean of differences
% % diff05 = medians_micro_parameter_vec_thr05-medians_micro_parameter_vec_onlyGM;
% % mean_diff05 = abs(nanmean(diff05));
% medians_micros={medians_micro_parameter_vec_thr0,medians_micro_parameter_vec_thr01,medians_micro_parameter_vec_thr02,medians_micro_parameter_vec_thr03,medians_micro_parameter_vec_thr04,medians_micro_parameter_vec_thr05,medians_micro_parameter_vec_thr06,medians_micro_parameter_vec_thr07,medians_micro_parameter_vec_thr08,medians_micro_parameter_vec_thr09};
% mean_diffs_micros=[];
% for i=1:length(medians_micros)
% diff=medians_micros{i}-medians_micro_parameter_vec_onlyGM;
% mean_diff = nanmean(abs(diff));
% mean_diffs_micros(end+1)=mean_diff;
% end
% 
% figure, plot(0:0.1:0.9,mean_diffs_micros,'-o')
% ylabel('mean(abs(diff))');
% xlabel('threshold value');
% title('Mean of absolute values of differences (Rsoma)');
% 
% medians_energy={medians_energy_vec_thr0,medians_energy_vec_thr01,medians_energy_vec_thr02,medians_energy_vec_thr03,medians_energy_vec_thr04,medians_energy_vec_thr05,medians_energy_vec_thr06,medians_energy_vec_thr07,medians_energy_vec_thr08,medians_energy_vec_thr09};
% mean_diffs_energy=[];
% for i=1:length(medians_energy)
% diff=medians_energy{i}-medians_energy_vec_onlyGM;
% mean_diff = nanmean(abs(diff));
% mean_diffs_energy(end+1)=mean_diff;
% end
% 
% figure, plot(0:0.1:0.9,mean_diffs_energy,'-o')
% ylabel('mean(abs(diff))');
% xlabel('threshold value');
% title('Mean of absolute values of differences (CMRO_2)');

 %% check significance of test using bootstrapping
% original_samples = cat(1,medians_micro_parameter_vec,medians_energy_vec);
% original_samples = original_samples';
% 
% counter_coeffs_linear=[];
% counter_coeffs_squared=[];
% 
% tot_iterations = 100000;
% 
% rng(10)
% for j = 1:tot_iterations
%     extracted_samples=[];
% 
%     for i = 1:length(medians_energy_vec)
%         %generate N randm numbers with repetition
%         indices=randi(length(medians_energy_vec),1,length(medians_energy_vec));
%         extracted_sample=original_samples(indices(i),:);
%         extracted_samples(i,:)=extracted_sample;
%     end
% 
%     tbl = table(nanzscore(extracted_samples(:,1)),nanzscore(extracted_samples(:,2)),'VariableNames',{'Rsoma','CMRO2'});
%     mdl=fitlm(tbl,'CMRO2 ~ Rsoma^2','RobustOpts','off');
%     matrix_mdl = table2array(mdl.Coefficients);
% 
%     linear_coeff = matrix_mdl(2,1);
%     squared_coeff = matrix_mdl(3,1);
% 
%     if linear_coeff<0
%         counter_coeffs_linear(end+1)=-1;
%     elseif linear_coeff==0
%         counter_coeffs_linear(end+1)=0;
%     elseif linear_coeff>0
%         counter_coeffs_linear(end+1)=1;
%     end
% 
%     if squared_coeff<0
%         counter_coeffs_squared(end+1)=-1;
%     elseif squared_coeff==0
%         counter_coeffs_squared(end+1)=0;
%     elseif squared_coeff>0
%         counter_coeffs_squared(end+1)=1;
%     end
% 
% end
% 
% pvalue_squaredcoeff=numel(find(counter_coeffs_squared<0))/tot_iterations;
% pvalue_linearcoeff=numel(find(counter_coeffs_linear<0))/tot_iterations;
% 
% tbl=table(nanzscore(medians_energy_vec'),nanzscore(medians_micro_parameter_vec'),'VariableNames',{'CMRO2','Rsoma'});
% total_mdl = fitlm(tbl,'CMRO2~Rsoma^2','RobustOpts','off');

 %% Check relationship between Rsoma and fsoma,fc
% 
% [r,p]=corrcoef(medians_micro_parameter_vec_rsoma,medians_micro_parameter_vec_fc,'rows','complete')
% corr_coef_str=num2str(round(r(2),2));
% 
% figure,
% s=plot(medians_micro_parameter_vec_rsoma,medians_micro_parameter_vec_fc,'o','MarkerSize',7);
% xlabel('Rsoma','FontSize',15,'FontWeight','bold');
% ylabel('fc','FontSize',15,'FontWeight','bold');
% %s.MarkerEdgeColor = [1,0.5,1];
% if p(2)<0.05 && p(2)>0.01    
%     txt = {strcat('r = ',corr_coef_str,'*')};
% elseif p(2)<0.01 && p(2)>0.001   
%     txt = {strcat('r = ',corr_coef_str,'**')};
% elseif p(2)<0.001
%     txt = {strcat('r = ',corr_coef_str,'***')};
% elseif p(2)>0.05
%         txt = {strcat('r = ',corr_coef_str,'')};
% end
% s.MarkerFaceColor = 'b';
% text(7,0.4,txt,'FontWeight', 'Bold');
% grid on
% %annotation('textbox',[.6,.2,.30,.13], 'String', txt, 'FontWeight', 'Bold','FontSize',15);

 %% across regions (for each subject) without removing PVEs effect
% 
% %correlation
% 
% corr_for_each_subj = [];
% for i = 1:n_subjs
%     [r,p] = corrcoef(medians_dwi(i,:),medians_func(i,:),'rows','complete');
%     %'rows','complete', Omit any rows of the input containing NaN values
%     corr_for_each_subj(end+1)=r(2);
% end
% 
% mean_with_subjs_corr=nanmean(corr_for_each_subj);%with fsup we could have NaNs
% [h,p,ci,stats]=ttest(atanh(corr_for_each_subj));
% 
% 
% mean_corr=round(mean_with_subjs_corr,2);
% mean_corr=num2str(mean_corr);
% 
% pvalue=num2str(round(p,2));
% 
% 
% figure, 
% s=histogram(corr_for_each_subj,'FaceAlpha',1,'BinWidth',0.07);
% s.FaceColor="b";
% xlabel('correlation coefficient, r','FontWeight','bold','FontSize',15);
% ylabel('Counts (# subjects)','FontWeight','bold','FontSize',15);
% ylim([0,12]);
% xline(0,'--','LineWidth',3);
% if p<0.05 && p>0.01    
%     txt = {strcat('\mu_r = ',mean_corr,'*')};
% elseif p<0.01 && p>0.001   
%     txt = {strcat('\mu_r = ',mean_corr,'**')};
% elseif p<0.001
%     txt = {strcat('\mu_r = ',mean_corr,'***')};
% elseif p>0.05
%         txt = {strcat('\mu_r = ',mean_corr,'')};
% end
% 
% title(strcat(energy_parameter, 'vs',micro_parameter));
% text(-0.5,7,txt, 'FontWeight', 'bold','FontSize',15);
% grid on

%% GLM for each subject and correlation regressing out PVE effects

disp('Computing GLM for each subject')

pvalue_microparameter_subjs=[];
estimate_microparameter_subjs=[];
corr_for_each_subjs_regout_pves=[];

for i = 1:n_subjs
    medians_dwi_subj=medians_dwi(i,:);
    medians_func_subj=medians_func(i,:);
    means_pve_0_subj=means_pve_0_dwi(i,:);
    means_pve_2_subj=means_pve_2_dwi(i,:);

    samples_mat=cat(1,medians_dwi_subj,medians_func_subj,means_pve_0_subj,means_pve_2_subj);
    % samples_mat=rmmissing(samples_mat,2);

    medians_dwi_subj_scored=nanzscore(samples_mat(1,:));
    medians_func_subj_scored=nanzscore(samples_mat(2,:));
    means_pve_0_subj_scored=nanzscore(samples_mat(3,:));
    means_pve_2_subj_scored=nanzscore(samples_mat(4,:));

    medians_dwi_subj_scored_tr=medians_dwi_subj_scored';
    medians_func_subj_scored_tr=medians_func_subj_scored';
    means_pve_0_subj_scored_tr=means_pve_0_subj_scored';
    means_pve_2_subj_scored_tr=means_pve_2_subj_scored';

    tbl=table(medians_func_subj_scored_tr,medians_dwi_subj_scored_tr,means_pve_0_subj_scored_tr,means_pve_2_subj_scored_tr, 'VariableNames', ...
        {'CMRO2','microparameter','pve_0_dwi','pve_2_dwi'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ microparameter + pve_0_dwi + pve_2_dwi','RobustOpts','on');

    coeffs_mat=table2array(mdl.Coefficients);
    pvalue_microparameter=coeffs_mat(2,4);
    estimate_microparameter=coeffs_mat(2,1);
    pvalue_microparameter_subjs(end+1)=pvalue_microparameter;
    estimate_microparameter_subjs(end+1)=estimate_microparameter;

    %calculate CMRO2 values without pve contributions

    pve_0_estimate = coeffs_mat(3,1);
    pve_2_estimate = coeffs_mat(4,1);
    cmro2_without_pves = medians_func_subj_scored_tr - means_pve_0_subj_scored_tr.*pve_0_estimate - means_pve_2_subj_scored_tr.*pve_2_estimate;

    %calculate corr coef for each subject
    [r,p] = corrcoef(medians_dwi_subj_scored_tr, cmro2_without_pves, 'rows','complete');

    corr_for_each_subjs_regout_pves(end+1) = r(2);  
end
% Error using statrobustfit (line 21)
% Not enough points to perform robust estimation.
%so you must put robustots off

figure, 
s=histogram(pvalue_microparameter_subjs,'FaceAlpha',1,'BinWidth',0.07);
s.FaceColor="b";
xlabel('p-values','FontWeight','bold','FontSize',15);
ylabel('Counts (# subjects)','FontWeight','bold','FontSize',15);
title('pvalues')
ylim([0,14]);
xline(0,'--','LineWidth',3);
grid on

%regression coefficient distribution

figure, 
s=histogram(estimate_microparameter_subjs,'FaceAlpha',1,'BinWidth',0.07);
s.FaceColor="b";
xlabel('Estimates','FontWeight','bold','FontSize',15);
ylabel('Counts (# subjects)','FontWeight','bold','FontSize',15);
title('Region coefficients estimates')
ylim([0,9]);
%xlim([-0.5,0.5])
xline(0,'--','LineWidth',3);
% if p<0.05 && p>0.01    
%     txt = {strcat('\mu_r = ',mean_corr,'*')};
% elseif p<0.01 && p>0.001   
%     txt = {strcat('\mu_r = ',mean_corr,'**')};
% elseif p<0.001
%     txt = {strcat('\mu_r = ',mean_corr,'***')};
% elseif p>0.05
%         txt = {strcat('\mu_r = ',mean_corr,'')};
% end

% title(strcat(energy_parameter, 'vs',micro_parameter));
% text(-0.5,7,txt, 'FontWeight', 'bold','FontSize',15);
grid on

[h,p]=ttest(estimate_microparameter_subjs);%1 rejects the null hypothesis that the mean is equal to 0.

median_estimate = median(estimate_microparameter_subjs);
median_pvalue = median(pvalue_microparameter_subjs);
std_estimate = std(estimate_microparameter_subjs);
std_pvalue = std(pvalue_microparameter_subjs);

mean_with_subjs_corr=nanmean(corr_for_each_subjs_regout_pves);%with fsup we could have NaNs
[h,p,ci,stats]=ttest(atanh(corr_for_each_subjs_regout_pves));

mean_corr = num2str(round(mean_with_subjs_corr,2));

% correlation distribution

figure, 
s=histogram(corr_for_each_subjs_regout_pves,'FaceAlpha',1,'BinWidth',0.07);
s.FaceColor="b";
xlabel('correlation coefficient, r','FontWeight','bold','FontSize',15);
ylabel('Counts (# subjects)','FontWeight','bold','FontSize',15);
ylim([0,8]);
xline(0,'--','LineWidth',3);
if p<0.05 && p>0.01    
    txt = {strcat('\mu_r = ',mean_corr,'*')};
elseif p<0.01 && p>0.001   
    txt = {strcat('\mu_r = ',mean_corr,'**')};
elseif p<0.001
    txt = {strcat('\mu_r = ',mean_corr,'***')};
elseif p>0.05
        txt = {strcat('\mu_r = ',mean_corr,'')};
end
title(strcat(energy_parameter, 'vs',micro_parameter));
text(0.1,7,txt, 'FontWeight', 'bold','FontSize',15);
grid on

%% across subjs for each region
% check correlation distribution 

disp('correlation across subjects for each region')

n_regions_final = numel(labels_final);

z=[];
pvalue=[];
z_regout_pves=[];
pvalue_regout_pves=[];
std_dev_func=[];
std_dev_dwi=[];
labels_final_mdlaccepted = [];


for i = 1:n_regions_final
    [r,p] = corrcoef(medians_func(:,i), medians_dwi(:,i),'rows','complete');
    z(end+1)=r(2);
    pvalue(end+1)=p(2);
    std_dev_func(end+1)=std(medians_func(:,i));
    std_dev_dwi(end+1)=std(medians_dwi(:,i));

    % calculate corr regressing out variables
    %zscore
    medians_dwi_scored = nanzscore(medians_dwi(:,i));
    means_pve_0_dwi_scored = nanzscore(means_pve_0_dwi(:,i));
    means_pve_2_dwi_scored = nanzscore(means_pve_2_dwi(:,i));
    medians_energy_scored = nanzscore(medians_func(:,i));
    
    medians_dwi_scored_tr = medians_dwi_scored';
    means_pve_0_dwi_scored_tr = means_pve_0_dwi_scored';
    means_pve_2_dwi_scored_tr = means_pve_2_dwi_scored';
    medians_energy_scored_tr = medians_energy_scored';

    %GLM

    tbl=table(medians_energy_scored_tr',medians_dwi_scored_tr',means_pve_0_dwi_scored_tr',means_pve_2_dwi_scored_tr', 'VariableNames', ...
        {'CMRO2','microparameter','pve_0_dwi','pve_2_dwi'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ microparameter + pve_0_dwi + pve_2_dwi','RobustOpts','off');

    coeffs_mat=table2array(mdl.Coefficients);

    if anynan(coeffs_mat)
        disp('do nothing')
    else
        disp('append correlation coefficient')
        %reg out
        pve_0_estimate = coeffs_mat(3,1);
        pve_2_estimate = coeffs_mat(4,1);
        cmro2_without_pves = medians_energy_scored_tr - means_pve_0_dwi_scored_tr.*pve_0_estimate - means_pve_2_dwi_scored_tr.*pve_2_estimate;

        %calculate corr

        [r_regout,p_regout] = corrcoef(cmro2_without_pves, medians_dwi_scored_tr,'rows','complete');
        z_regout_pves(end+1)=r_regout(2);
        pvalue_regout_pves(end+1)=p_regout(2);
        labels_final_mdlaccepted(end+1)=labels_final(i);

        % if isnan(r_regout(2))
        %     break
        % end
        % if r_regout(2) < -0.9
        %      break
        % end
        % if anynan(coeffs_mat)
        %      break
        % end
    end

end

%% fdr correction 
%in case you remove pve effect
pvalue = pvalue_regout_pves;
z = z_regout_pves;

%%
BHFDR_correction = 'yes';

%%
[pFDR] = mafdr(pvalue,'BHFDR','True');

significant_pFDR=[];
idx_significant_pFDR=[];
%select regions based on qvalues
for i = 1:length(pvalue)
    if pFDR(i) < 0.05
        significant_pFDR(end+1)=pFDR(i);
        idx_significant_pFDR(end+1)=i;
    end
end

ratio_survived=length(significant_pFDR)/length(pvalue);
disp(strcat(num2str(round(ratio_survived*100,1)),'%'))

figure, scatter(pvalue,pFDR,'o')
xlabel('p values','FontWeight','Bold')
ylabel('q values','FontWeight','Bold')
grid on

%%
if strcmp(BHFDR_correction,'yes')
    z_accepted = z(idx_significant_pFDR);
    labels_final_accepted = labels_final_mdlaccepted(idx_significant_pFDR);
else
    z_accepted=z_regout_pves;
    labels_final_accepted=labels_final_mdlaccepted;
end

 %% check if the correlation is due to high variability
% %(high std cmro2 distributions may correspond to high
% %std microstructural parameter distribution)
% 
% std_dev_func_labels = std_dev_func(idx_significant_pFDR);
% std_dev_dwi_labels = std_dev_dwi(idx_significant_pFDR);
% 
% figure, 
% hist(std_dev_func)
% xlabel('standard deviation across subjects')
% ylabel('counts (# of regions)')
% title('CMRO_2')
% hold on
% s=scatter(std_dev_func_labels,zeros(1,length(idx_significant_pFDR)));
% s.MarkerEdgeColor = 'r';
% s.MarkerFaceColor = 'r';
% ylim([0,40]);
% grid on
% 
% figure, 
% hist(std_dev_dwi)
% xlabel('standard deviation across subjects')
% ylabel('counts (# of regions)')
% title('fsup')
% hold on
% s=scatter(std_dev_dwi_labels,zeros(1,length(idx_significant_pFDR)));
% s.MarkerEdgeColor = 'r';
% s.MarkerFaceColor = 'r';
% grid on





%% distribution of z accepted

mean_regions_corr=nanmean(z_accepted);
[h,p,ci,stats]=ttest(atanh(z_accepted));

mean_corr=round(mean_regions_corr,2);
mean_corr=num2str(mean_corr);

figure, hist(z_accepted);
xlabel('correlation coefficient, r','FontWeight','bold','FontSize',15);
ylabel('# regions','FontWeight','bold','FontSize',15);
ylim([0,8]);
if p<0.05 && p>0.01    
    txt = {strcat('\mu_r = ',mean_corr,'*')};
elseif p<0.01 && p>0.001   
    txt = {strcat('\mu_r = ',mean_corr,'**')};
elseif p<0.001
    txt = {strcat('\mu_r = ',mean_corr,'***')};
elseif p>0.05
        txt = {strcat('\mu_r = ',mean_corr,'')};
end
text(0.57,3,txt, 'FontWeight', 'bold','FontSize',15);
grid on 


%% create matrix to create map
corr_and_regions = [z_accepted;labels_final_accepted].';

% %% check which are regions with negative correlation coefficients
% z_accepted_neg=[];
% 
% for i = 1:length(z_accepted)
%     if z_accepted(i)<0
%         z_accepted_neg(end+1)=labels_final_accepted(i);
%     end
% end
% 
% %% run this section if you want to check where pos and neg corr regions are
% binary_z=[];
% for i=1:length(z_accepted)
%     if z_accepted(i)>0
%         binary_z(i)=1;
%     else
%         binary_z(i)=-1;
%     end
% end
% corr_and_regions = [binary_z;labels_accepted].';

%%
diff=setxor(labels_final_accepted,unique(V_atlas_glass));
%regions which did not survive will be set equal to zero

%
V_atlas = V_atlas_glass;
for ii = 1:length(V_atlas_glass(:))%lo fa per tutti i valori dell'immagine
    if any(0==V_atlas_glass(ii))
        V_atlas(ii)=0;
    elseif any(diff==V_atlas_glass(ii))
        V_atlas(ii)=0;
    else
        idx=find(corr_and_regions(:,2)==V_atlas_glass(ii));
        %substitute the corresponding corr coefficient
        corr=corr_and_regions(:,1);
        V_atlas(ii)=corr(idx);
    end
end

rgb = [ ...
    94    79   162
    50   136   189
   102   194   165
   171   221   164
   230   245   152
    %255    255   255   
   255   255   191
   254   224   139
   253   174    97
   244   109    67
   213    62    79
   158     1    0  ] / 255;%66

b = repmat(linspace(0,1,200),20,1);


%plot only regions with significant p-values
fig=figure;
a=28:4:68;%12:4:72;
for i = 1:length(a)
    subplot(4,4,i)
    imagesc(rot90(V_atlas(:,:,a(i))))%[0,8]
    axis equal
    axis off
    caxis([-1,+1])
end
h=axes(fig,'visible','off');
imshow(b,[],'InitialMagnification','fit')
colormap(rgb)
%colormap seismic
colorbar(h,'orientation','horizontal','Location','SouthOutside','FontSize',12);
sgtitle('Regional correlation map thresholded for p<0.05')
caxis([-1,+1])

%% check for symmetry between positive and negative correlation.
% colormap(rgb)
% 
% hf = figure('Units','normalized');
% colormap(rgb)
% %hCB = colorbar('east');
% caxis([0, 10^14]);
% % colormap jet
%  hCB = colorbar('north');
% % caxis([0, 1]);
% set(gca,'Visible',false)
% hCB.Position = [0.15 0.3 0.74 0.4];
% hf.Position(4) = 0.1000;
% hCB.Label.FontSize = 18;
% hCB.Label.FontWeight = 'bold';

% Save maps
V_corr_map=V_atlas;

if strcmp(micro_parameter,'fsoma')
    V_corr_CMRO2vsfsoma_map=V_corr_map;
    labels_accepted_CMRO2vsfsoma_map=labels_final_accepted;
    z_accepted_CMRO2vsfsoma_map=z_accepted;
elseif strcmp(micro_parameter,'Rsoma')
    V_corr_CMRO2vsrsoma_map=V_corr_map;
    labels_accepted_CMRO2vsrsoma_map=labels_final_accepted;
    z_accepted_CMRO2vsrsoma_map=z_accepted;
elseif strcmp(micro_parameter,'fsup')
    V_corr_CMRO2vsfsup_map=V_corr_map;
    labels_accepted_CMRO2vsfsup_map=labels_final_accepted;
    z_accepted_CMRO2vsfsup_map=z_accepted;
elseif strcmp(micro_parameter,'fc')
    V_corr_CMRO2vsfc_map=V_corr_map;
    labels_accepted_CMRO2vsfc_map=labels_final_accepted;
    z_accepted_CMRO2vsfc_map=z_accepted;
end


%% across subjs (GM median)

disp('GLM across subjects, considering Grey Matter median values')

if strcmp(micro_parameter,'fsup')
    medians_microparameter = medians_fsup_GM_subjs;
elseif strcmp(micro_parameter,'fc')
    medians_microparameter = medians_fc_GM_subjs;
elseif strcmp(micro_parameter,'fsoma')
    medians_microparameter = medians_fsoma_GM_subjs;
elseif strcmp(micro_parameter,'Rsoma')
    medians_microparameter = medians_rsoma_GM_subjs;
end
 %% corr and GLM analysis without taking into account PVEs effect
% 
% [r,p]=corrcoef(medians_CMRO2_GM_subjs,medians_microparameter,'rows','complete');
% corr_coef_str = num2str(round(r(2),2));
% 
% x=medians_microparameter;
% y=medians_CMRO2_GM_subjs;
% pol = polyfit(x, y, 1);
% % Evaluate the fitted polynomial
% y_fit = polyval(pol, x);
% % Calculate the R-squared value
% Rsquared = 1 - sum((y - y_fit).^2) / sum((y - nanmean(y)).^2);
% Rsquared
% 
% [x_sorted,index] = sortrows(x');
% y_fit=y_fit';
% y_fit_sorted = y_fit(index);
% 
% %regression line
% 
% figure, 
% h=plot(medians_microparameter,medians_CMRO2_GM_subjs,'.',MarkerSize=25);
% hold on
% plot(x_sorted,y_fit_sorted,'--','LineWidth',3,'Color',"#000000");
% xlabel(strcat(micro_parameter,unit_of_measure_dwi),'FontSize',15,'FontWeight','bold');
% ylabel('CMRO_2(\mu mol/100g/min)','FontSize',12,'FontWeight','bold');
% h.Color='b';
% set(get(gca, 'XAxis'), 'FontWeight', 'bold');
% set(get(gca, 'YAxis'), 'FontWeight', 'bold');
% set(gca,'box','off')
% x0=50;
% y0=50;
% width=550;
% height=450;
% set(gcf,'position',[x0,y0,width,height]);
% if p(2)<0.05 && p(2)>0.01    
%     txt = {strcat('r = ',corr_coef_str,'*')};
% elseif p(2)<0.01 && p(2)>0.001   
%     txt = {strcat('r = ',corr_coef_str,'**')};
% elseif p(2)<0.001
%     txt = {strcat('r = ',corr_coef_str,'***')};
% elseif p(2)>0.05
%     txt = {strcat('r = ',corr_coef_str,'')};
% end
% s.MarkerFaceColor = 'b';
% % text(1.45*10^14,100,txt,'FontWeight', 'Bold','FontSize',12);
% text(1.55*10^5,100,txt,'FontWeight', 'Bold','FontSize',12);
% grid on

%%
%check pve influence
medians_dwi_scored = nanzscore(medians_microparameter);
means_pve_0_dwi_scored = nanzscore(means_pve_0_dwi_GM_subjs);
means_pve_2_dwi_scored = nanzscore(means_pve_2_dwi_GM_subjs);
medians_energy_scored = nanzscore(medians_CMRO2_GM_subjs);

medians_dwi_scored_tr = medians_dwi_scored';
means_pve_0_dwi_scored_tr = means_pve_0_dwi_scored';
means_pve_2_dwi_scored_tr = means_pve_2_dwi_scored';
medians_energy_scored_tr = medians_energy_scored';

if strcmp(micro_parameter,'fc')
    tbl=table(medians_energy_scored_tr,medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr, 'VariableNames', ...
        {'CMRO2','fc','pve_0_dwi','pve_2_dwi'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ fc + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    % mdl=fitlm(tbl,'CMRO2 ~ fc','RobustOpts','on')
    % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','off')
elseif strcmp(micro_parameter,'fsup')
    tbl=table(medians_energy_scored_tr,medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr, 'VariableNames', ...
        {'CMRO2','fsup','pve_0_dwi','pve_2_dwi'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ fsup + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','on')
    % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','off')
elseif strcmp(micro_parameter,'fsoma')
    tbl=table(medians_energy_scored_tr,medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr, 'VariableNames', ...
        {'CMRO2','fsoma','pve_0_dwi','pve_2_dwi'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ fsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','on')
    % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','off')
elseif strcmp(micro_parameter,'Rsoma')
    tbl=table(medians_energy_scored_tr,medians_dwi_scored_tr,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr, 'VariableNames', ...
        {'CMRO2','Rsoma','pve_0_dwi','pve_2_dwi'});
    %build your model
    mdl=fitlm(tbl,'CMRO2 ~ Rsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    
end

%% method I
%calculate cmro2 regressed using zscored results and 
%then transform back to the original units

%this is the method used for the paper analysis

coeffs_mat=table2array(mdl.Coefficients);
estimate_pve_0=coeffs_mat(3,1);
estimate_pve_2=coeffs_mat(4,1);

%regress out
y_pve_0_dwi = means_pve_0_dwi_scored.*estimate_pve_0;
y_pve_2_dwi = means_pve_2_dwi_scored.*estimate_pve_2;
cmro2_regressed_scored = medians_energy_scored-y_pve_0_dwi-y_pve_2_dwi;

cmro2_regressed = cmro2_regressed_scored.*std(medians_CMRO2_GM_subjs)+mean(medians_CMRO2_GM_subjs);

 %% method II
% %GLM original units
% 
% if strcmp(micro_parameter,'fc')
%     tbl=table(medians_CMRO2_GM_subjs',medians_microparameter', means_pve_0_dwi_GM_subjs',means_pve_2_dwi_GM_subjs','VariableNames', ...
%         {'CMRO2','fc','pve_0_dwi','pve_2_dwi'});
%     %build your model
%     mdl_regout=fitlm(tbl,'CMRO2 ~ fc + pve_0_dwi + pve_2_dwi','RobustOpts','on')
%     mdl=fitlm(tbl,'CMRO2 ~ fc','RobustOpts','on')
%     % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','off')
% elseif strcmp(micro_parameter,'fsup')
%     tbl=table(medians_CMRO2_GM_subjs',medians_microparameter', means_pve_0_dwi_GM_subjs',means_pve_2_dwi_GM_subjs','VariableNames', ...
%         {'CMRO2','fsup','pve_0_dwi','pve_2_dwi'});
%     %build your model
%     mdl_regout=fitlm(tbl,'CMRO2 ~ fsup + pve_0_dwi + pve_2_dwi','RobustOpts','on')
%     mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','on')
%     % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','off')
% elseif strcmp(micro_parameter,'fsoma')
%     tbl=table(medians_CMRO2_GM_subjs',medians_microparameter', means_pve_0_dwi_GM_subjs',means_pve_2_dwi_GM_subjs','VariableNames', ...
%         {'CMRO2','fsoma','pve_0_dwi','pve_2_dwi'});
%     %build your model
%     mdl_regout=fitlm(tbl,'CMRO2 ~ fsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
%     mdl=fitlm(tbl,'CMRO2 ~ fsoma','RobustOpts','on')
%     % mdl=fitlm(tbl,'CMRO2 ~ fsup','RobustOpts','off')
% end
% 
% coeffs_mat=table2array(mdl_regout.Coefficients);
% estimate_pve_0=coeffs_mat(3,1);
% estimate_pve_2=coeffs_mat(4,1);
% 
% %regress out
% y_pve_0_dwi = means_pve_0_dwi_GM_subjs.*estimate_pve_0;
% y_pve_2_dwi = means_pve_2_dwi_GM_subjs.*estimate_pve_2;
% cmro2_regressed = medians_CMRO2_GM_subjs-y_pve_0_dwi-y_pve_2_dwi;

%%
% [r,p] = corrcoef(cmro2_regressed, medians_micro_parameter_vec,'rows','complete');

y=cmro2_regressed;
x=medians_microparameter;
% Fit a quadratic equation
[pol,S] = polyfit(x, y, 1); %to plot the linear model I use this function
% Evaluate the fitted polynomial
y_fit = polyval(pol, x);
% Calculate the R-squared value
Rsquared = 1 - sum((y - y_fit).^2) / sum((y - nanmean(y)).^2);
Rsquared

alpha = 0.05; % Significance level
[y_fit,delta] = polyconf(pol,x,S,'alpha',alpha);

[x_sorted,index] = sortrows(x');
y_fit=y_fit';
delta = delta';
y_fit_sorted = y_fit(index);
delta_sorted = delta(index);

[r,p] = corrcoef(medians_microparameter,cmro2_regressed,'rows','complete');

corr_coef_str = num2str(round(r(2),2));

figure, 
s=plot(medians_microparameter,cmro2_regressed,'.',MarkerSize=25);
%plot confidence interval shadow
x_patch = x_sorted;
y_patch_lower = y_fit_sorted-delta_sorted;
y_patch_higher = y_fit_sorted+delta_sorted;

x_all = [x_patch; flipud(x_patch)];
y_all = [y_patch_higher; flipud(y_patch_lower)];

patch(x_all,y_all,'cyan','FaceAlpha',0.1,'EdgeColor','none')

hold on
plot(x_sorted,y_fit_sorted,'--','LineWidth',3,'Color',"#000000");
hold on
plot(x_sorted,y_fit_sorted-delta_sorted,'--',x_sorted,y_fit_sorted+delta_sorted,'--','LineWidth',1.5,'Color',[0.5 0.5 0.5])


xlabel(strcat(micro_parameter,unit_of_measure_dwi),'FontSize',15,'FontWeight','bold');
ylabel(strcat('Adjusted CMRO_2',unit_of_measure_energy),'FontSize',12,'FontWeight','bold');
s.Color='b';
set(get(gca, 'XAxis'), 'FontWeight', 'bold');
set(get(gca, 'YAxis'), 'FontWeight', 'bold');
set(gca,'box','off')
x0=50;
y0=50;
width=550;
height=450;
if p(2)<0.05 && p(2)>0.01    
    txt = {strcat('Pearson r = ',corr_coef_str,'*')};
elseif p(2)<0.01 && p(2)>0.001   
    txt = {strcat('Pearson r = ',corr_coef_str,'**')};
elseif p(2)<0.001
    txt = {strcat('Pearson r = ',corr_coef_str,'***')};
elseif p(2)>0.05
        txt = {strcat('Pearson r = ',corr_coef_str,'')};
end
%text(9.5,100,txt,'FontWeight', 'Bold','FontSize',12);
%text(0.45,100,txt,'FontWeight', 'Bold','FontSize',12);
text(1.5*10^5,100,txt,'FontWeight', 'Bold','FontSize',12);
%text(1.5*10^14,100,txt,'FontWeight', 'Bold','FontSize',12);
set(gcf,'position',[x0,y0,width,height]);
%ylim([50,160]);
grid on

 %% plot spatially regional medians parametric maps
% %for one subject
% % subj=1;
% % V_atlas_tot = V_atlases_dwi{subj};
% labels = labels_final;
% medians_rsoma_tot = medians_micro_parameter_vec;
% 
% %%
% diff=setxor(labels,unique(V_atlas_tot));
% 
% 
% V_atlas = V_atlas_tot;
% labels_and_par = [labels;medians_rsoma_tot].';
% for ii = 1:length(V_atlas_tot(:))%lo fa per tutti i valori dell'immagine
%     if any(0==V_atlas_tot(ii))
%         V_atlas(ii)=0;
%     elseif any(diff==V_atlas_tot(ii))
%         V_atlas(ii)=0;
%     else
%         idx=find(labels_and_par(:,1)==V_atlas_tot(ii));
%         par=labels_and_par(:,2);
%         V_atlas(ii)=par(idx);
%     end
% end
% 
% %convert to mm3
% 
% V_atlas_mm = V_atlas.*10^-9;
% %% save as nifti
% img_path='/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-97902/SANDI_Output/SANDI-fit_Rsoma.nii.gz';
% hdr=niftiinfo(img_path);
% hdr.Datatype = 'double';
% hdr.ImageSize = size(V_atlas);
% niftiwrite(V_atlas,'/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/261104/medians_one_subj_fc.nii.gz',hdr,"Compressed",true);
% 
% niftiwrite(V_atlas_mm,'/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/261104/medians_mm_one_subj_fc.nii.gz',hdr,"Compressed",true);
