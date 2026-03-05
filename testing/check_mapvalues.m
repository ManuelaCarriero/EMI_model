%% This programme checks the distribution of CMRO2 throughout the brain regions

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


%% SUBJECT SPACE

V_atlases_func={};

for i = start_subj:n_subjs
    
    
    subj = subjects(i);
    subj=num2str(subj);
    if numel(subj)==4
        subj=strcat('0',subj);
    else
        subj=subj;
    end

    
    img_path_atlas_func=strcat('/home/c25078236/Desktop/WAND_data/ANAT/atlas_coregistered/atlas_on_M0/sub-',subj,'_AAL3v1_1mm_on_M0.nii.gz');


    V_vol_atlas_func = spm_vol(img_path_atlas_func);
    V_atlas_func=spm_read_vols(V_vol_atlas_func);
    V_atlases_func{end+1}=V_atlas_func;

end

%% load parametric maps
V_cmro2_maps={};
%V_CBF_maps={};



for i = start_subj:n_subjs
    
        
    subj = subjects(i);
    subj=num2str(subj);
    if numel(subj)==4
        subj=strcat('0',subj);
    else
        subj=subj;
    end

    
    img_path_CMRO2=strcat('/home/c25078236/Desktop/WAND_data/FUNC/CMRO2/sub-',subj,'_cmro2_est.nii.gz');
    % 
 
    V_vol_CMRO2 = spm_vol(img_path_CMRO2);
    V_CMRO2=spm_read_vols(V_vol_CMRO2);
    V_cmro2_maps{end+1}=V_CMRO2;

end



%%

n_regions = 166; %maximum number to create the empty matrix

%% compute medians 
%prepare empty matrices with maximum size 
%so to not have problems of different size
%then take the common regions (intersection): 
%1. first keep the common regions across subjects;
%2. then keep the common regions across spaces (func and dwi)

%you can loose some labels (?) when warping in subject space
%so for each space and for each subject I checked which labels we have
labels_func_subjs = zeros(n_subjs,n_regions);

medians_CMRO2_subjs = zeros(n_subjs,n_regions);
% medians_CBF_subjs = zeros(n_subjs,n_regions);



start_time=tic;
for subj = 1:n_subjs
    tic
    %load atlases
    V_atlas_func = V_atlases_func{subj}; 

    %load parametric maps
    V_CMRO2 = V_CMRO2_maps{subj};
    % V_CBF = V_CBF_maps{subj};




    %where to save parametric medians and PVE means
    medians_CMRO2_subj = [];

    labels_func_subj = [];

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



    V_mask_func = V_atlas_mask_func;


    %mask

    V_CMRO2_masked = V_CMRO2.*V_mask_func;

   
    %remove background
    mask_func_zeros = find(V_mask_func==0);
    V_CMRO2_masked(mask_func_zeros)=[];

 
    medians_CMRO2_subj(end+1) = nanmedian(V_CMRO2_masked);



    labels_func_subj(end+1) = regions_func(region);


    end
        
    medians_CMRO2_subjs(subj,1:n_regions_func) = medians_CMRO2_subj;

    % medians_CBF_subjs(subj,1:n_regions_func) = medians_CBF_subj;
    labels_func_subjs(subj,1:n_regions_func) = labels_func_subj;

    toc
    disp(strcat('Finished subject', num2str(subj),'Starting subject', num2str(subj+1)))

end
timeElapsed = toc(start_time);

%%


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
%%
medians_func_subjs = medians_CMRO2_subjs;
%%
%Secondly, select elements corresponding to common indices
%apply this both to the median values and labels
medians_func_subjs_final=[];
for row = 1:n_subjs
    medians_func_subjs_row=medians_func_subjs(row,:);
    lst_idx = lst_idx_matrix_func(row,:);
    medians_func_subjs_row_final=medians_func_subjs_row(lst_idx);
    medians_func_subjs_final(row,:)=medians_func_subjs_row_final;
end

labels_func_subjs_final=[];
for row = 1:n_subjs
    labels_func_subjs_row=labels_func_subjs(row,:);
    lst_idx = lst_idx_matrix_func(row,:);
    labels_func_subjs_row_final=labels_func_subjs_row(lst_idx);
    labels_func_subjs_final(row,:)=labels_func_subjs_row_final;
end

%%

labels_final = labels_func_subjs_final(1,:);

occipital_labels = [53,54,55,56,57,58];
frontal_labels = [3,4,5,6,7,8,9,10,11,12,19,20,21,22];

medians_CMRO2_occ_subjs = [];

for subj=1:29

    for i = 1:numel(occipital_labels)

        medians_CMRO2_occ_subj = [];
        idx = find(labels_final == occipital_labels(i));
        medians_CMRO2_occ_subj(end+1)=medians_func_subjs_final(subj,idx);

    end
    medians_CMRO2_occ_subjs(end+1)=median(medians_CMRO2_occ_subj);
end

medians_CMRO2_front_subjs = [];

for subj=1:29

    for i = 1:numel(frontal_labels)

        medians_CMRO2_front_subj = [];
        idx = find(labels_final == frontal_labels(i));
        medians_CMRO2_front_subj(end+1)=medians_func_subjs_final(subj,idx);

    end
    medians_CMRO2_front_subjs(end+1)=median(medians_CMRO2_front_subj);
end

figure,
subplot(1,2,1)
ax1=histogram(medians_CMRO2_front_subjs);
title('Frontal CMRO2 medians')
median_front = round(median(medians_CMRO2_front_subjs),2);
% std_front = round(std(medians_CMRO2_front_subjs),2);
txt = strcat(num2str(median_front),'\mumol/100g/min');%'\pm',num2str(std_front),
text(100,10,txt,'FontWeight','bold')
ylabel('Counts (# of subjects)')
xlabel('CMRO_2 median values (\mumol/100g/min)')
ylim([0,14]);
grid on

subplot(1,2,2)
ax2=histogram(medians_CMRO2_occ_subjs);
title('Occipital CMRO2 medians')
median_occ = round(median(medians_CMRO2_occ_subjs),2);
% std_occ = round(std(medians_CMRO2_occ_subjs),2);
txt = strcat(num2str(median_occ),'\mumol/100g/min');%'\pm',num2str(std_occ),
text(100,10,txt,'FontWeight','bold')
ylabel('Counts (# of subjects)')
xlabel('CMRO_2 median values (\mumol/100g/min)')
ylim([0,14]);
grid on

%% MNI space

%% load atlas

img_path='/home/c25078236/Desktop/WAND_data/AAL3v1_1mm_res_on_MNI152_T1_2mm_brain_multilabel.nii.gz';

V_vol = spm_vol(img_path);
V_atlas_tot = spm_read_vols(V_vol);

V_atlas = V_atlas_tot;

%% plot regions of interest

labels_of_interest = frontal_labels; %change it according to what you want to visualize %occipital_labels

for ii = 1:length(V_atlas_tot(:))%lo fa per tutti i valori dell'immagine
    if any(labels_of_interest==V_atlas_tot(ii))
        V_atlas(ii)=1;
    elseif (0==V_atlas_tot(ii))
        V_atlas(ii)=0;
    else
        V_atlas(ii)=0.1;
    end
end

figure, 
imagesc(rot90(V_atlas(:,:,45)))
colormap gray
clim([0,1])

%% load parametric maps in MNI space

V_CMRO2_maps={};

for i = 1:n_subjs         
    subj = subjects(i);
    % subj=subj{1};
    subj = num2str(subj);

    if numel(subj)==4
        subj=strcat('0',subj);
    else
        subj=subj;
    end

    img_path_cmro2=strcat('/home/c25078236/Desktop/WAND_data/FUNC/CMRO2_toMNI/sub-',subj,'_cmro2_est_toMNI_linear.nii.gz');

    V_vol_cmro2 = spm_vol(img_path_cmro2);
    V_cmro2=spm_read_vols(V_vol_cmro2);
    V_CMRO2_maps{end+1}=V_cmro2;
end



%% compute medians

medians_CMRO2_subjs = [];

regions = unique(V_atlas_tot(:));
%background removal
regions(1)=[];
n_regions=numel(regions);


start_time=tic;
for subj = 1:n_subjs
    tic


    %load parametric maps
    V_CMRO2 = V_CMRO2_maps{subj};
    % V_CBF = V_CBF_maps{subj};



    %where to save parametric medians 
    medians_CMRO2_subj = [];


    for region = 1:n_regions

        V_atlas = V_atlas_tot; %initialize atlas matrix

        %binarize atlas
        for ii = 1:length(V_atlas_tot(:))
            if V_atlas(ii) == regions(region)
                V_atlas(ii) = 1;
            else
                V_atlas(ii) = 0;
            end
        end



        V_mask = V_atlas;
    
    
        %mask
    
        V_CMRO2_masked = V_CMRO2.*V_mask;
    
       
        %remove background
        mask_func_zeros = find(V_mask==0);
        V_CMRO2_masked(mask_func_zeros)=[];
    
     
        medians_CMRO2_subj(end+1) = nanmedian(V_CMRO2_masked);

    end
        
    medians_CMRO2_subjs(end+1,:) = medians_CMRO2_subj;


    toc
    disp(strcat('Finished subject', num2str(subj),'Starting subject', num2str(subj+1)))

end
timeElapsed = toc(start_time);

%%

labels_final = regions;

occipital_labels = [53,54,55,56,57,58];
frontal_labels = [3,4,5,6,7,8,9,10,11,12,19,20,21,22];

medians_CMRO2_occ_subjs = [];

for subj=1:29

    for i = 1:numel(occipital_labels)

        medians_CMRO2_occ_subj = [];
        idx = find(labels_final == occipital_labels(i));
        medians_CMRO2_occ_subj(end+1)=medians_CMRO2_subjs(subj,idx);

    end
    medians_CMRO2_occ_subjs(end+1)=median(medians_CMRO2_occ_subj);
end

medians_CMRO2_front_subjs = [];

for subj=1:29

    for i = 1:numel(frontal_labels)

        medians_CMRO2_front_subj = [];
        idx = find(labels_final == frontal_labels(i));
        medians_CMRO2_front_subj(end+1)=medians_CMRO2_subjs(subj,idx);

    end
    medians_CMRO2_front_subjs(end+1)=median(medians_CMRO2_front_subj);
end

figure,
subplot(1,2,1)
ax1=histogram(medians_CMRO2_front_subjs);
title('Frontal CMRO2 medians')
median_front = round(median(medians_CMRO2_front_subjs),2);
% std_front = round(std(medians_CMRO2_front_subjs),2);
txt = strcat(num2str(median_front),'\mumol/100g/min');%'\pm',num2str(std_front),
text(100,10,txt,'FontWeight','bold')
ylabel('Counts (# of subjects)')
xlabel('CMRO_2 median values (\mumol/100g/min)')
ylim([0,16]);
grid on

subplot(1,2,2)
ax2=histogram(medians_CMRO2_occ_subjs);
title('Occipital CMRO2 medians')
median_occ = round(median(medians_CMRO2_occ_subjs),2);
% std_occ = round(std(medians_CMRO2_occ_subjs),2);
txt = strcat(num2str(median_occ),'\mumol/100g/min');%'\pm',num2str(std_occ),
text(100,10,txt,'FontWeight','bold')
ylabel('Counts (# of subjects)')
xlabel('CMRO_2 median values (\mumol/100g/min)')
ylim([0,16]);
grid on