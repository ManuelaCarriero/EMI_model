%% This programme select common labels medians across subjects and across functional and diffusion space
%(the atlas has been warped from mni space to the subject space so we could
%have lost some labels, so this programme select only common labels).

%% HOW TO USE
%the code must be run 4 times:
%one selecting Rsoma, one selecting fsoma, one selecting fsup
%and one selecting fc.

%% load data already "cooked"
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/maskingGM05_fc_fsup_mse85_withGMmedians_GMpvemeans')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/maskingGM05_fc_fsup_mse85_withGMmedians_GMpvemeans_withoutfsmasking')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/maskingGM05_fc_fsup_mse85_withGMmedians_GMpvemeans_withoutfsmasking_nvoxels_removingzerosfromcmro2regions')
% load('/media/nas_rete/Work_manuela/EMI_model-main/EMI_data/maskingGM05_fc_fsup_mse85_withGMmedians_GMpvemeans_withoutfsmasking_nvoxels_removingzerosfromcmro2regions_andfromGM.mat')
% load('/media/nas_rete/Work_manuela/EMI_model-main/EMI_data/WAND/CORRECTEDRIGHTDWIREGIONS_maskingGM05_fc_fsup_mse85_withGMmedians_GMpvemeans_withoutfsmasking_nvoxels_removingzerosfromcmro2regions_andfromGM_withrsomaGMmaskedvoxels.mat')

% load('/media/nas_rete/Work_manuela/EMI_model-main/EMI_data/WAND/CORRECTEDRIGHTDWIREGIONS_maskingGM05_fc_fsup_mse85_withGMmedians_GMpvemeans_withoutfsmasking_nvoxels_NOTremovingzerosfromcmro2regions_andfromGM_withrsomaGMmaskedvoxels.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/260531/CORRECTEDRIGHTDWIREGIONS_maskingGM05_fc_fsup_mse85_withGMmedians_GMpvemeans_withoutfsmasking_nvoxels_NOTremovingzerosfromcmro2regions_andfromGM_withrsomaGMmaskedvoxels.mat')

% load('/home/c25078236/Desktop/saved_workspace/programmi/data/computed_with_wholeGMcorticalmedians.mat')
%% select variables to examine
energy_parameter = 'CMRO2';
micro_parameter = 'fc';

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

%%
medians_dwi_allpar = {medians_rsoma_subjs,medians_fsoma_subjs,medians_fsup_subjs,medians_fc_subjs};

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

%median parameters values 

for i = 1:numel(medians_dwi_allpar)
    medians_dwi_subjs = [];
    medians_dwi_subjs = medians_dwi_allpar{i};
    medians_dwi_subjs_final=[];
    for row = 1:n_subjs
        medians_dwi_subjs_row=medians_dwi_subjs(row,:);
        lst_idx = lst_idx_matrix_dwi(row,:);
        medians_dwi_subjs_row_final=medians_dwi_subjs_row(lst_idx);
        medians_dwi_subjs_final(row,:)=medians_dwi_subjs_row_final;
    end
    if i==1
        medians_rsoma_subjs_final = medians_dwi_subjs_final;
    elseif i==2
        medians_fsoma_subjs_final = medians_dwi_subjs_final;
    elseif i==3
        medians_fsup_subjs_final = medians_dwi_subjs_final;
    elseif i==4
        medians_fc_subjs_final = medians_dwi_subjs_final;
    end
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

%n voxels
n_voxels_dwi_final=[];
for row = 1:n_subjs
    n_voxels_dwi_row=n_voxels_dwi(row,:);
    lst_idx = lst_idx_matrix_dwi(row,:);
    n_voxels_dwi_row_final=n_voxels_dwi_row(lst_idx);
    n_voxels_dwi_final(row,:)=n_voxels_dwi_row_final;
end

%% if you want to analyze SANDI MSE
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

%n voxels
n_voxels_func_final=[];
for row = 1:n_subjs
    n_voxels_func_row=n_voxels_func(row,:);
    lst_idx = lst_idx_matrix_func(row,:);
    n_voxels_func_row_final=n_voxels_func_row(lst_idx);
    n_voxels_func_final(row,:)=n_voxels_func_row_final;
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

%note: in case of WAND data, the rows of labels_dwi_subjs_final
%and labels_func_subjs_final are equal, so the difference
%lies between spaces.

% %old
% commonElements_lst=[];
% for row = 1:n_subjs
%     commonElements = intersect(labels_dwi_subjs_final(row,:),labels_func_subjs_final(row,:));
%     if length(commonElements)>1
%         commonElements_lst(1,:)=commonElements;%BUG
%     else
%         commonElements_lst(end+1)=commonElements;
%     end
% end

commonElements_lst=[];
for row = 1:n_subjs
    commonElements = intersect(labels_dwi_subjs_final(row,:),labels_func_subjs_final(row,:));
    if length(commonElements)>1
        commonElements_lst(row,:)=commonElements;
    else
        commonElements_lst(end+1)=commonElements;
    end
end

commonElements_lst=unique(commonElements_lst);
% commonElements_lst(commonElements_lst==0)=[];

commonElements_lst = commonElements_lst';

%% dwi space
%First, detect indices of common Elements

lst_idx_matrix_dwi_spaces=[];
for row = 1:n_subjs
    lst_idx_row=[];
    for i = 1:length(commonElements_lst)
        commonElement = commonElements_lst(i);
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

medians_dwi_allpar_final = {medians_rsoma_subjs_final,medians_fsoma_subjs_final,medians_fsup_subjs_final,medians_fc_subjs_final};

for i = 1:numel(medians_dwi_allpar_final)
    medians_dwi_subjs_final=[];
    medians_dwi_subjs_final = medians_dwi_allpar_final{i};
    medians_dwi_subjs_final_spaces=[];
    for row = 1:n_subjs
        medians_dwi_subjs_row=medians_dwi_subjs_final(row,:);
        lst_idx = lst_idx_matrix_dwi_spaces(row,:);
        medians_dwi_subjs_row_final=medians_dwi_subjs_row(lst_idx);
        medians_dwi_subjs_final_spaces(row,:)=medians_dwi_subjs_row_final;
    end
    if i==1
        medians_rsoma_subjs_final_spaces = medians_dwi_subjs_final_spaces;
    elseif i==2
        medians_fsoma_subjs_final_spaces = medians_dwi_subjs_final_spaces;
    elseif i==3
        medians_fsup_subjs_final_spaces = medians_dwi_subjs_final_spaces;
    elseif i==4
        medians_fc_subjs_final_spaces = medians_dwi_subjs_final_spaces;
    end
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

%n voxels 
n_voxels_dwi_row_final_spaces=[];
for row = 1:n_subjs
    n_voxels_dwi_row=n_voxels_dwi_final(row,:);
    lst_idx = lst_idx_matrix_dwi_spaces(row,:);
    n_voxels_dwi_row_final=n_voxels_dwi_row(lst_idx);
    n_voxels_dwi_row_final_spaces(row,:)=n_voxels_dwi_row_final;
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
    for i = 1:length(commonElements_lst)
        commonElement = commonElements_lst(i);
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

% n voxels
n_voxels_func_row_final_spaces=[];
for row = 1:n_subjs
    n_voxels_func_row=n_voxels_func_final(row,:);
    lst_idx = lst_idx_matrix_func_spaces(row,:);
    n_voxels_func_row_final=n_voxels_func_row(lst_idx);
    n_voxels_func_row_final_spaces(row,:)=n_voxels_func_row_final;
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
%isequal(CMRO2 for all microstructural parameters).

%% save the following parameters

medians_func = medians_func_subjs_final_spaces;

means_pve_0_func = V_pve_0_func_mean_subjs_final_spaces;
means_pve_1_func = V_pve_1_func_mean_subjs_final_spaces;
means_pve_2_func = V_pve_2_func_mean_subjs_final_spaces;

means_pve_0_dwi = V_pve_0_dwi_mean_subjs_final_spaces;
means_pve_1_dwi = V_pve_1_dwi_mean_subjs_final_spaces;
means_pve_2_dwi = V_pve_2_dwi_mean_subjs_final_spaces;

labels_final=labels_func_subjs_final_spaces(1,:);

%%

% if strcmp(micro_parameter,'Rsoma')
%     medians_dwi = medians_rsoma_subjs_final_spaces;
% elseif strcmp(micro_parameter,'fsoma')
%     medians_dwi = medians_fsoma_subjs_final_spaces;
% elseif strcmp(micro_parameter,'fsup')
%     medians_dwi = medians_fsup_subjs_final_spaces;
% elseif strcmp(micro_parameter,'fc')
%     medians_dwi = medians_fc_subjs_final_spaces;
% end

%%%%%%%%%%% variables to save

save("/media/nas_rete/Work_manuela/EMI_model-main/EMI_data/WAND/260617/selected_medians.mat","medians_func","means_pve_0_func","means_pve_1_func", ...
    "means_pve_2_func","means_pve_0_dwi","means_pve_1_dwi","means_pve_2_dwi", ...
    "labels_final","medians_rsoma_subjs_final_spaces","medians_fsoma_subjs_final_spaces", ...
    "medians_fsup_subjs_final_spaces","medians_fc_subjs_final_spaces","medians_CMRO2_GM_subjs", ...
    "medians_fsoma_GM_subjs","medians_fsup_GM_subjs","medians_rsoma_GM_subjs","medians_fc_GM_subjs", ...
    "means_pve_0_dwi_GM_subjs","means_pve_1_dwi_GM_subjs","means_pve_1_func_GM_subjs", ...
    "means_pve_2_dwi_GM_subjs","means_pve_2_func_GM_subjs","V_atlas_glass","n_voxels_dwi_row_final_spaces", ...
    "medians_CMRO2_GM_cortical_subjs","means_pve_0_func_GM_cortical_subjs","means_pve_1_func_GM_cortical_subjs", ...
    "means_pve_2_func_GM_cortical_subjs","medians_rsoma_GM_cortical_dwi_subjs","medians_fsoma_GM_cortical_dwi_subjs", ...
    "medians_fc_GM_cortical_dwi_subjs","medians_fsup_GM_cortical_dwi_subjs","medians_fneurite_GM_cortical_dwi_subjs", ...
    "medians_De_GM_cortical_dwi_subjs","medians_Din_GM_cortical_dwi_subjs","medians_fextra_GM_cortical_dwi_subjs", ...
    "means_pve_0_dwi_GM_cortical_subjs","means_pve_1_dwi_GM_cortical_subjs","means_pve_2_dwi_GM_cortical_subjs")





% medians_func
% 
% means_pve_0_func
% means_pve_1_func
% means_pve_2_func
% 
% means_pve_0_dwi
% means_pve_1_dwi
% means_pve_2_dwi
% 
% labels_final

% medians_rsoma_subjs_final_spaces
% medians_fsoma_subjs_final_spaces
% medians_fsup_subjs_final_spaces
% medians_fc_subjs_final_spaces



% medians_CMRO2_GM_subjs
% medians_fsoma_GM_subjs
% medians_fsup_GM_subjs
% medians_rsoma_GM_subjs
% medians_fc_GM_subjs

% means_pve_0_dwi_GM_subjs
% means_pve_0_func_GM_subjs
% means_pve_1_dwi_GM_subjs
% means_pve_1_func_GM_subjs
% means_pve_2_dwi_GM_subjs
% means_pve_2_func_GM_subjs

% V_atlas_glass  
% n_voxels_dwi_final_spaces

% medians_CMRO2_GM_cortical_subjs
% 
% means_pve_0_func_GM_cortical_subjs
% means_pve_1_func_GM_cortical_subjs
% means_pve_2_func_GM_cortical_subjs
% 
% medians_rsoma_GM_cortical_dwi_subjs
% medians_fsoma_GM_cortical_dwi_subjs
% medians_fc_GM_cortical_dwi_subjs
% medians_fsup_GM_cortical_dwi_subjs
% 
% medians_fneurite_GM_cortical_dwi_subjs
% medians_De_GM_cortical_dwi_subjs
% medians_Din_GM_cortical_dwi_subjs
% medians_fextra_GM_cortical_dwi_subjs
% 
% means_pve_0_dwi_GM_cortical_subjs
% means_pve_1_dwi_GM_cortical_subjs
% means_pve_2_dwi_GM_cortical_subjs