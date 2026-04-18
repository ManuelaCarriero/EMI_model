%% programme that calculates numerical cellular median regional values and shows its map

%% load atlases 

%Load GM 
%img_path_GM = '/home/c25078236/Desktop/WAND_data/gm/atlas_GM.nii.gz'; 
img_path_GM = '/home/c25078236/Desktop/WAND_data/gm/atlas_GM_res_on_MNI152_T1_2mm_brain.nii.gz';%CORREGGI
%atlas_GM resampled on SANDI and CBF dimensions
Vhdr_GM = spm_vol(img_path_GM);
V_GM_tot = spm_read_vols(Vhdr_GM); 

%Loading atlas
%img_path_atlas='/home/c25078236/Desktop/WAND_data/AAL3v1_1mm.nii.gz';
img_path_atlas='/home/c25078236/Desktop/WAND_data/AAL3v1_1mm_res_on_MNI152_T1_2mm_brain.nii.gz';%CORREGGI
Vhdr = spm_vol(img_path_atlas);
V_atlas_tot = spm_read_vols(Vhdr);

%% load data from Cubric

subjects = importdata('/home/c25078236/Desktop/WAND_data/subjects.txt');
subjects(subjects==42565)=[];%subj that does not have mprage
subjects(subjects==19230)=[];%subj that does not have b0
subjects(subjects==20609)=[];%subj that does not have M0
subjects(subjects==69881)=[];%subj that does not have SANDI MAPS

n_subjs=length(subjects);

V_rsoma_tots={};
V_fsoma_tots={};

for i = 1:1:n_subjs%lst

    subj=num2str(subjects(i));
    if length(subj)==4
        subj=strcat('0',subj);
    end

    %Linear Interpolation
    img_path_rsoma = strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS_toMNI/sub-',subj,'/SANDI-fit_RsomatoMNI.nii.gz');
    img_path_fsoma = strcat('/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS_toMNI/sub-',subj,'/SANDI-fit_fsomatoMNI.nii.gz');
 
    Vhdr = spm_vol(img_path_rsoma);
    V_rsoma_tot = spm_read_vols(Vhdr);
    V_rsoma_tots{end+1} = V_rsoma_tot;

    Vhdr = spm_vol(img_path_fsoma);
    V_fsoma_tot = spm_read_vols(Vhdr);
    V_fsoma_tots{end+1} = V_fsoma_tot;

end

size(V_rsoma_tots{1})
%% number of cells density map (many subjects) 

V_fc_tots={};

for i = 1:n_subjs    
    V_rsoma = V_rsoma_tots{i};
    V_fsoma = V_fsoma_tots{i};

    
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

    V_fc_tots{end+1} = fc_map;

end

%%
n_regions = numel(unique(V_atlas_tot(:)));
regions = unique(V_atlas_tot(:));


%% compute medians


medians_fc_subjs= [];

start_time=tic;
for i = 1:1:n_subjs %1:1:length(lst)


    V_fc_tot = V_fc_tots{i};

  
    medians_fc_subj=[];
 

    for k = 1:n_regions
        tic

        V_atlas = V_atlas_tot;

        for ii = 1:length(V_atlas_tot(:))
            if V_atlas_tot(ii)==regions(k)
                V_atlas(ii)=1;
            else
                V_atlas(ii)=0;
            end
        end

        V_fc = V_fc_tot;

        V_mask = V_atlas;%.*V_GM;%.*V_fsoma_to_mask

        V_fc_masked = V_fc.*V_mask;
   
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        disp(strcat('region', num2str(k), 'subject', num2str(i)))
        
        %find zeros of the mask (so outside brain)
        mask_zeros=find(V_mask==0);

        V_fc_masked(mask_zeros)=[];
               
        disp(strcat('region', num2str(k)))

        median_fc = median(V_fc_masked,'omitnan');   
        medians_fc_subj(end+1) = median_fc;
      
    toc
    end

    medians_fc_subjs(i,:) = medians_fc_subj;
 
    disp(strcat('Finished subject', num2str(i),'Starting subject', num2str(i+1)))

end
timeElapsed = toc(start_time);

disp(strcat('Total computing time =',num2str(round(timeElapsed/60,2)),'min'));

%% compute median across subjects

median_fc_tot = nanmedian(medians_fc_subjs,1);
labels = unique(V_atlas_tot(:))';

%% save fc median regional values map

V_atlas = V_atlas_tot;
labels_and_par = [labels;median_fc_tot].';
for ii = 1:length(V_atlas_tot(:))%lo fa per tutti i valori dell'immagine
    if any(0==V_atlas_tot(ii))
        V_atlas(ii)=0;
    else
        idx=find(labels_and_par(:,1)==V_atlas_tot(ii));
        par=labels_and_par(:,2);
        V_atlas(ii)=par(idx);
    end
end

%convert to mm3

V_atlas_mm = V_atlas.*10^-9;
%% save as nifti
% img_path='/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-97902/SANDI_Output/SANDI-fit_Rsoma.nii.gz';
% hdr=niftiinfo(img_path);
% hdr.Datatype = 'double';
% hdr.ImageSize = size(V_atlas);
% hdr.BitsPerPixel = 64;
% hdr.Filesize = 912411;
% hdr.PixelDimensions = [2 2 2];
% niftiwrite(V_atlas,'/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/fc/MNI_2mm/medians_across_subjs_fc_MNIspace.nii.gz',hdr,"Compressed",true);
% 
% niftiwrite(V_atlas_mm,'/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/fc/MNI_2mm/medians_across_subjs_fc_mm_MNIspace.nii.gz',hdr,"Compressed",true);


% img_path='/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS/sub-97902/SANDI_Output/SANDI-fit_Rsoma.nii.gz';
img_path='/home/c25078236/Desktop/WAND_data/DWI/SANDI_MAPS_toMNI/sub-97902/SANDI-fit_RsomatoMNI.nii.gz';
hdr=niftiinfo(img_path);
hdr.Datatype = 'double';
hdr.ImageSize = size(V_rsoma_tots{1});%V_atlas
hdr.PixelDimensions = [2 2 2];
niftiwrite(V_atlas,'/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/fc/MNI_2mm/medians_across_subjs_fc_MNIspace.nii.gz',hdr,"Compressed",true);

niftiwrite(V_atlas_mm,'/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/fc/MNI_2mm/medians_across_subjs_fc_mm_MNIspace.nii.gz',hdr,"Compressed",true);
