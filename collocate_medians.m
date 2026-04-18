
%% This programme analyze median regional values computed through the compute_medians.m code

%the analysis is CMRO2 vs one microstructural parameter at a time between 
%rsoma, fsoma, fsup and fs
%accordingly to which microstructural parameter has been chosen in
%compute_medians

%% load data

% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/V_atlas_glass.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_GMmedians.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_GMPVEmeans.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/medians_CMRO2_GM_subjs.mat')

% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans_withoutfsmasking.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_microparameters_GMmedians_withoutfsmasking.mat')

% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans_withoutfsmasking_withnvoxels.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/labels_final.mat')

load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans_withoutfsmasking_withnvoxels_removingzerosfromcmro2regions.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/n_voxels_dwi_row_final_spaces_removingzerosfromcmro2regions.mat')

%% select parameters to be analyzed
micro_parameter = 'fsup';
energy_parameter = 'CMRO2';

if strcmp(micro_parameter,'Rsoma')
    medians_dwi = medians_rsoma_subjs_final_spaces;
elseif strcmp(micro_parameter,'fsoma')
    medians_dwi = medians_fsoma_subjs_final_spaces;
elseif strcmp(micro_parameter,'fsup')
    medians_dwi = medians_fsup_subjs_final_spaces;
elseif strcmp(micro_parameter,'fc')
    medians_dwi = medians_fc_subjs_final_spaces;
end

n_subjs = 29;

%% across regions (medians across subjs)



medians_energy_vec = nanmedian(medians_func,1);
SE_energy = nanstd(medians_func,0,1)/sqrt(n_subjs);

medians_micro_parameter_vec = nanmedian(medians_dwi,1);
SE_micro_parameter = nanstd(medians_dwi,0,1)/sqrt(n_subjs);


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

n_voxels_dwi_vec = nanmedian(n_voxels_dwi_row_final_spaces,1);
% n_voxels_func_vec = nanmedian(n_voxels_func_row_final_spaces,1);





disp('median across subjects computed')



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

labels_final(idx)=[];

% n_voxels_func_vec(idx)=[];
n_voxels_dwi_vec(idx)=[];

% energetic regions

idx_energy = find(isnan(medians_energy_vec));
medians_energy_vec(idx_energy)=[];
medians_micro_parameter_vec(idx_energy)=[];
SE_energy(idx_energy)=[];
SE_micro_parameter(idx_energy)=[];

%pve 

means_pve_0_dwi_vec(idx_energy)=[];
means_pve_1_dwi_vec(idx_energy)=[];
means_pve_2_dwi_vec(idx_energy)=[];

means_pve_0_func_vec(idx_energy)=[];
means_pve_1_func_vec(idx_energy)=[];
means_pve_2_func_vec(idx_energy)=[];

SE_pve_0_func(idx_energy)=[];
SE_pve_1_func(idx_energy)=[];
SE_pve_2_func(idx_energy)=[];

SE_pve_0_dwi(idx_energy)=[];
SE_pve_1_dwi(idx_energy)=[];
SE_pve_2_dwi(idx_energy)=[];

labels_final(idx_energy)=[];

% n_voxels_func_vec(idx)=[];
n_voxels_dwi_vec(idx_energy)=[];

disp('medians across subjects equal to NaN removed')


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

%%
cortical_regions = load('/home/c25078236/Desktop/WAND_data/AAL_cortical_labels.txt');
subcortical_regions = load('/home/c25078236/Desktop/WAND_data/AAL_subcortical_labels.txt');

logical_cortical = ismember(labels_final,cortical_regions);
labels_final(logical_cortical)

%% matrix

% choose either medians_energy_vec (raw cmro2 regional median values) or
% cmro2_regressed (cmro2 regional median values corrected for PVEs)
data_plot = cat(1,cmro2_regressed,medians_micro_parameter_vec,n_voxels_dwi_vec,logical_cortical,labels_final);%,n_voxels_func_ve
data_plot = data_plot';
data_plot_sorted = sortrows(data_plot,3);

%define marker size based on the number of voxels
marker_size_lst = ceil(data_plot_sorted(:,3)*0.1)+1;
%rounds the element to the nearest integer greater than or equal to that element

data_tot = cat(2,data_plot_sorted,marker_size_lst);

%%  define dimensions of each variable of the table

y_dim = 1;
x_dim = 2;
n_voxels_dim = 3;
logical_cortical_dim = 4;
labels_final_dim = 5;
marker_size_dim = 6;



%% plot adding nvoxels information
% data_tot(data_tot(:,labels_final_dim)==48,:)=[];
% data_tot(data_tot(:,labels_final_dim)==47,:)=[];
% data_tot(data_tot(:,labels_final_dim)==84,:)=[];

n_samples = size(data_tot,1);

figure,
for i = 1:n_samples

    if data_tot(i,logical_cortical_dim)==1
        h1=scatter(data_tot(i,x_dim),data_tot(i,y_dim),data_tot(i,marker_size_dim),'MarkerFaceColor',"r",'MarkerEdgeColor','k');
    elseif data_tot(i,logical_cortical_dim)==0
        h2=scatter(data_tot(i,x_dim),data_tot(i,y_dim),data_tot(i,marker_size_dim),'MarkerFaceColor',"b",'MarkerEdgeColor','k');
    end
    text(data_tot(i,x_dim),data_tot(i,y_dim),num2str(data_tot(i,labels_final_dim)));

    hold on
end
xlabel(strcat(micro_parameter,unit_of_measure_dwi),'FontSize',15,'FontWeight','bold');
ylabel(strcat('CMRO_2',unit_of_measure_energy),'FontSize',12,'FontWeight','bold');
%ylabel(strcat('Adjusted CMRO_2',unit_of_measure_energy),'FontSize',12,'FontWeight','bold');
legend([h1,h2],'cortical','subcortical')
ylim([50,190]);
grid on

%% corr


data_cortical = data_tot(data_tot(:,logical_cortical_dim)==1,:)



[r,p] = corrcoef(data_cortical(:,x_dim),data_cortical(:,y_dim))

data_subcortical = data_tot(data_tot(:,logical_cortical_dim)==0,:)

[r,p] = corrcoef(data_subcortical(:,x_dim),data_subcortical(:,y_dim))

%% plot adding nvoxels information of only a subset and adding labels of regions

% data_tot_subset = data_tot(data_tot(:,n_voxels_dim)>prctile(data_tot(:,n_voxels_dim),75),:);

data_lowrsoma = data_tot(data_tot(:,x_dim)<9,:);
data_tot_subset=data_lowrsoma;
n_samples_subset = size(data_tot_subset,1);

figure,
for i = 1:n_samples_subset

    if data_tot_subset(i,logical_cortical_dim)==1
        h1=scatter(data_tot_subset(i,x_dim),data_tot_subset(i,y_dim),data_tot_subset(i,marker_size_dim),'MarkerFaceColor',"r",'MarkerEdgeColor','k');
    elseif data_tot_subset(i,logical_cortical_dim)==0
        h2=scatter(data_tot_subset(i,x_dim),data_tot_subset(i,y_dim),data_tot_subset(i,marker_size_dim),'MarkerFaceColor',"b",'MarkerEdgeColor','k');
    end
    text(data_tot_subset(i,x_dim),data_tot_subset(i,y_dim),num2str(data_lowrsoma(i,labels_final_dim)));
    hold on
end
xlabel(strcat(micro_parameter,unit_of_measure_dwi),'FontSize',15,'FontWeight','bold');
ylabel(strcat('CMRO_2',unit_of_measure_energy),'FontSize',12,'FontWeight','bold');
%ylabel(strcat('Adjusted CMRO_2',unit_of_measure_energy),'FontSize',12,'FontWeight','bold');
legend([h1,h2],'cortical','subcortical')
ylim([50,190]);
xlim([8,10.5])
grid on

%% check where regions are positioned in the brain

labels_lowrsoma = data_tot_subset(:,labels_final_dim);

diff=setxor(labels_lowrsoma,unique(V_atlas_glass));
%regions which did not survive will be set equal to zero

%
V_atlas = V_atlas_glass;
for ii = 1:length(V_atlas_glass(:))%lo fa per tutti i valori dell'immagine
    if any(0==V_atlas_glass(ii))
        V_atlas(ii)=0;
    elseif any(diff==V_atlas_glass(ii))
        V_atlas(ii)=0;
    else
        idx=find(labels_lowrsoma==V_atlas_glass(ii));
        %substitute the corresponding corr coefficient
        %V_atlas(ii)=labels_lowrsoma(idx);
        V_atlas(ii)=1;
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

V_lowsomaradius = V_atlas;


%%

data_tot_err = cat(2,data_tot,SE_energy', SE_micro_parameter');

SE_y_dim = 7;
SE_x_dim = 8;

figure,
for i = 1:n_samples

    if data_tot(i,logical_cortical_dim)==1
        h1=errorbar(data_tot_err(i,x_dim),data_tot_err(i,y_dim),data_tot_err(i,SE_y_dim),data_tot_err(i,SE_y_dim),data_tot_err(i,SE_x_dim),data_tot_err(i,SE_x_dim),'o','MarkerSize',data_tot(i,marker_size_dim),'MarkerFaceColor',"r",'MarkerEdgeColor','k');
    elseif data_tot(i,logical_cortical_dim)==0
        h2=errorbar(data_tot_err(i,x_dim),data_tot_err(i,y_dim),data_tot_err(i,SE_y_dim),data_tot_err(i,SE_y_dim),data_tot_err(i,SE_x_dim),data_tot_err(i,SE_x_dim),'o','MarkerSize',data_tot(i,marker_size_dim),'MarkerFaceColor',"b",'MarkerEdgeColor','k');
    end
    hold on

end
xlabel(strcat(micro_parameter,unit_of_measure_dwi),'FontSize',15,'FontWeight','bold');
ylabel(strcat('Adjusted CMRO_2',unit_of_measure_energy),'FontSize',12,'FontWeight','bold');
legend([h1,h2],'cortical','subcortical')
ylim([50,190]);
grid on


%% fitlm considering raw data (without correction for PVEs)

% matrix 

data_plot = cat(1,medians_energy_vec,medians_micro_parameter_vec,n_voxels_dwi_vec,logical_cortical,labels_final);%,n_voxels_func_ve
data_plot = data_plot';
data_plot_sorted = sortrows(data_plot,3);

%define marker size based on the number of voxels
marker_size_lst = ceil(data_plot_sorted(:,3)*0.1)+1;
%rounds the element to the nearest integer greater than or equal to that element

data_tot = cat(2,data_plot_sorted,marker_size_lst);

%%  define dimensions of each variable of the table

y_dim = 1;
x_dim = 2;
n_voxels_dim = 3;
logical_cortical_dim = 4;
labels_final_dim = 5;
marker_size_dim = 6;

n_samples = size(data_tot,1);

%%

tbl=table(data_tot_subset(:,x_dim),data_tot_subset(:,y_dim),'VariableNames', ...
        {'Rsoma','CMRO2'});

% fitlm(data_tot_subset(:,2),data_tot_subset(:,1),'RobustOpts','on')
mdl=fitlm(tbl,'CMRO2 ~ Rsoma','RobustOpts','on')

%% plot
% [r,p] = corrcoef(cmro2_regressed, medians_micro_parameter_vec,'rows','complete');

y=cmro2_regressed;
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

[r_cortical,p_cortical] = corrcoef(medians_micro_parameter_vec(logical_cortical==1),cmro2_regressed(logical_cortical==1));
[r_subcortical,p_subcortical] = corrcoef(medians_micro_parameter_vec(logical_cortical==0),cmro2_regressed(logical_cortical==0));


corr_coef_str = num2str(round(r(2),2));
corr_coef_str_cortical = num2str(round(r_cortical(2),2));
corr_coef_str_subcortical = num2str(round(r_subcortical(2),2));

p_value_str = num2str(round(p(2),3));
p_value_str_cortical = num2str(round(p_cortical(2),3));
p_value_str_subcortical = num2str(round(p_subcortical(2),3));


figure, 

%s=plot(medians_micro_parameter_vec,cmro2_regressed,'.',MarkerSize=25);
errorbar(medians_micro_parameter_vec(logical_cortical==1), cmro2_regressed(logical_cortical==1), SE_energy(logical_cortical==1), SE_energy(logical_cortical==1), SE_micro_parameter(logical_cortical==1), SE_micro_parameter(logical_cortical==1),'.','MarkerSize',22,'Color','r');
hold on
errorbar(medians_micro_parameter_vec(logical_cortical==0), cmro2_regressed(logical_cortical==0), SE_energy(logical_cortical==0), SE_energy(logical_cortical==0), SE_micro_parameter(logical_cortical==0), SE_micro_parameter(logical_cortical==0),'.','MarkerSize',22,'Color','b');


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
% s.Color='b';
set(get(gca, 'XAxis'), 'FontWeight', 'bold');
set(get(gca, 'YAxis'), 'FontWeight', 'bold');
set(gca,'box','off')
x0=50;
y0=50;
width=550;
height=450;
%the whole cluster
if p(2)<0.05 && p(2)>0.01    
    txt = {strcat('r= ',corr_coef_str,'*,p-value=',p_value_str)};
elseif p(2)<0.01 && p(2)>0.001   
    txt = {strcat('r= ',corr_coef_str,'**,p-value=',p_value_str)};
elseif p(2)<0.001
    txt = {strcat('r= ',corr_coef_str,'***,p-value=',p_value_str)};
elseif p(2)>0.05
        txt = {strcat('r= ',corr_coef_str,',p-value=',p_value_str)};
end
%the cortical cluster
if p_cortical(2)<0.05 && p_cortical(2)>0.01    
    txt_cortical = {strcat('r\_cortical= ',corr_coef_str_cortical,'*,p-value=',p_value_str_cortical)};
elseif p_cortical(2)<0.01 && p_cortical(2)>0.001   
    txt_cortical = {strcat('r\_cortical= ',corr_coef_str_cortical,'**,p-value=',p_value_str_cortical)};
elseif p_cortical(2)<0.001
    txt_cortical = {strcat('r\_cortical= ',corr_coef_str_cortical,'***,p-value=',p_value_str_cortical)};
elseif p_cortical(2)>0.05
        txt_cortical = {strcat('r\_cortical= ',corr_coef_str_cortical,',p-value=',p_value_str_cortical)};
end
%the subcortical cluster
if p_subcortical(2)<0.05 && p_subcortical(2)>0.01    
    txt_subcortical = {strcat('r\_subcortical= ',corr_coef_str_subcortical,'*,p-value=',p_value_str_subcortical)};
elseif p_subcortical(2)<0.01 && p_subcortical(2)>0.001   
    txt_subcortical = {strcat('r\_subcortical= ',corr_coef_str_subcortical,'**,p-value=',p_value_str_subcortical)};
elseif p_subcortical(2)<0.001
    txt_subcortical = {strcat('r\_subcortical= ',corr_coef_str_subcortical,'***,p-value=',p_value_str_subcortical)};
elseif p_subcortical(2)>0.05
        txt_subcortical = {strcat('r\_subcortical= ',corr_coef_str_subcortical,',p-value=',p_value_str_subcortical)};
end

if strcmp(micro_parameter,'Rsoma')
    text(9,100,txt,'FontWeight', 'Bold','FontSize',9);
    text(9,100,txt_cortical,'FontWeight', 'Bold','FontSize',9);
    text(9,100,txt_subcortical,'FontWeight', 'Bold','FontSize',9);
elseif strcmp(micro_parameter,'fsoma')
    text(0.35,100,txt,'FontWeight', 'Bold','FontSize',9);
    text(0.35,100,txt_cortical,'FontWeight', 'Bold','FontSize',9);
    text(0.35,100,txt_subcortical,'FontWeight', 'Bold','FontSize',9);
elseif strcmp(micro_parameter,'fsup')
    text(10^5,100,txt,'FontWeight', 'Bold','FontSize',9);
    text(10^5,100,txt_cortical,'FontWeight', 'Bold','FontSize',9);
    text(10^5,100,txt_subcortical,'FontWeight', 'Bold','FontSize',9);
elseif strcmp(micro_parameter,'fc')
    text(10^14,100,txt,'FontWeight', 'Bold','FontSize',9);
    text(10^14,100,txt_cortical,'FontWeight', 'Bold','FontSize',9);
    text(10^14,100,txt_subcortical,'FontWeight', 'Bold','FontSize',9);
end
set(gcf,'position',[x0,y0,width,height]);
ylim([50,190]);
legend('cortical','subcortical');
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

%% load data

load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans_withoutfsmasking_withnvoxels_removingzerosfromcmro2regions.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/n_voxels_dwi_row_final_spaces_removingzerosfromcmro2regions.mat')

%% plot fsup vs Rsoma and fsoma vs Rsoma

n_subjs = 29;

%% calculate median across subjects

%energy
medians_energy_vec = nanmedian(medians_func,1);
SE_energy = nanstd(medians_func,0,1)/sqrt(n_subjs);

%microparameters
medians_rsoma_subjs_final_spaces_vec = nanmedian(medians_rsoma_subjs_final_spaces,1);
SE_rsoma = nanstd(medians_rsoma_subjs_final_spaces,0,1)/sqrt(n_subjs);

medians_fsoma_subjs_final_spaces_vec = nanmedian(medians_fsoma_subjs_final_spaces,1);
SE_fsoma = nanstd(medians_fsoma_subjs_final_spaces,0,1)/sqrt(n_subjs);

medians_fsup_subjs_final_spaces_vec = nanmedian(medians_fsup_subjs_final_spaces,1);
SE_fsup = nanstd(medians_fsup_subjs_final_spaces,0,1)/sqrt(n_subjs);

medians_fc_subjs_final_spaces_vec = nanmedian(medians_fc_subjs_final_spaces,1);
SE_fc = nanstd(medians_fc_subjs_final_spaces,0,1)/sqrt(n_subjs);

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

n_voxels_dwi_vec = nanmedian(n_voxels_dwi_row_final_spaces,1);

disp('median across subjects computed')

%% remove regions whose resulting median regional value across subjects is NAN
%in either the functional parameter or microstructural parameter

%energy

idx_energy = find(isnan(medians_energy_vec));

% microstructural regions

idx_rsoma = find(isnan(medians_rsoma_subjs_final_spaces_vec));
idx_fsoma = find(isnan(medians_fsoma_subjs_final_spaces_vec));
idx_fsup = find(isnan(medians_fsup_subjs_final_spaces_vec));
idx_fc = find(isnan(medians_fc_subjs_final_spaces_vec));

idx_tot = cat(2,idx_rsoma,idx_fsoma,idx_energy,idx_fsup,idx_fc);
idx_unique = unique(idx_tot);

medians_rsoma_subjs_final_spaces_vec(idx_unique)=[];
medians_fsoma_subjs_final_spaces_vec(idx_unique)=[];
medians_fsup_subjs_final_spaces_vec(idx_unique)=[];
medians_fc_subjs_final_spaces_vec(idx_unique)=[];
medians_energy_vec(idx_unique)=[];

SE_fsoma(idx_unique)=[];
SE_rsoma(idx_unique)=[];
SE_fsup(idx_unique)=[];
SE_fc(idx_unique)=[];
SE_energy(idx_unique)=[];


%pve 

means_pve_0_dwi_vec(idx_unique)=[];
means_pve_1_dwi_vec(idx_unique)=[];
means_pve_2_dwi_vec(idx_unique)=[];

means_pve_0_func_vec(idx_unique)=[];
means_pve_1_func_vec(idx_unique)=[];
means_pve_2_func_vec(idx_unique)=[];

SE_pve_0_func(idx_unique)=[];
SE_pve_1_func(idx_unique)=[];
SE_pve_2_func(idx_unique)=[];

SE_pve_0_dwi(idx_unique)=[];
SE_pve_1_dwi(idx_unique)=[];
SE_pve_2_dwi(idx_unique)=[];

%labels
labels_final(idx_unique)=[];

%n voxels
n_voxels_dwi_vec(idx_unique)=[];



disp('medians across subjects equal to NaN removed')

%% create a logical array that has values equal to 1 when the region is a cortical region

cortical_regions = load('/home/c25078236/Desktop/WAND_data/AAL_cortical_labels.txt');
subcortical_regions = load('/home/c25078236/Desktop/WAND_data/AAL_subcortical_labels.txt');

logical_cortical = ismember(labels_final,cortical_regions);
%check
labels_final(logical_cortical)

%% matrix

%change considering the microparameters that you prefer to study

micro_parameter_x = 'Rsoma';
micro_parameter_y = 'fsup';

if strcmp(micro_parameter_x,'Rsoma')
    x_dim = medians_rsoma_subjs_final_spaces_vec;
    unit_of_measure_x = '(\mum)';
elseif strcmp(micro_parameter_x,'fsoma')
    x_dim = medians_fsoma_subjs_final_spaces_vec;
    unit_of_measure_x = '';
elseif strcmp(micro_parameter_x,'fsup')
    x_dim = medians_fsup_subjs_final_spaces_vec;
    unit_of_measure_x = '(m^{-1})';
elseif strcmp(micro_parameter_x,'fc')
    x_dim = medians_fc_subjs_final_spaces_vec;
    unit_of_measure_x = '(m^{-3})';
end

if strcmp(micro_parameter_y,'Rsoma')
    y_dim = medians_rsoma_subjs_final_spaces_vec;
    unit_of_measure_y = '(\mum)';
elseif strcmp(micro_parameter_y,'fsoma')
    y_dim = medians_fsoma_subjs_final_spaces_vec;
    unit_of_measure_y = '';
elseif strcmp(micro_parameter_y,'fsup')
    y_dim = medians_fsup_subjs_final_spaces_vec;
    unit_of_measure_y = '(m^{-1})';
elseif strcmp(micro_parameter_y,'fc')
    y_dim = medians_fc_subjs_final_spaces_vec;
    unit_of_measure_y = '(m^{-3})';
end


%create the matrix

data_plot = cat(1,y_dim,x_dim,n_voxels_dwi_vec,logical_cortical,labels_final);%,n_voxels_func_ve
data_plot = data_plot';
data_plot_sorted = sortrows(data_plot,3);

%define marker size based on the number of voxels
marker_size_lst = ceil(data_plot_sorted(:,3)*0.1)+1;
%rounds the element to the nearest integer greater than or equal to that element

data_tot = cat(2,data_plot_sorted,marker_size_lst);

%%  define dimensions of each variable of the table

y_dim_idx = 1;
x_dim_idx = 2;
n_voxels_dim = 3;
logical_cortical_dim = 4;
labels_final_dim = 5;
marker_size_dim = 6;

n_samples = size(data_tot,1);

%% plot adding nvoxels information

figure,
for i = 1:n_samples

    if data_tot(i,logical_cortical_dim)==1
        h1=scatter(data_tot(i,x_dim_idx),data_tot(i,y_dim_idx),data_tot(i,marker_size_dim),'MarkerFaceColor',"r",'MarkerEdgeColor','k');
    elseif data_tot(i,logical_cortical_dim)==0
        h2=scatter(data_tot(i,x_dim_idx),data_tot(i,y_dim_idx),data_tot(i,marker_size_dim),'MarkerFaceColor',"b",'MarkerEdgeColor','k');
    end
    hold on
end
xlabel(strcat(micro_parameter_x,unit_of_measure_x),'FontSize',15,'FontWeight','bold');
ylabel(strcat(micro_parameter_y,unit_of_measure_y),'FontSize',12,'FontWeight','bold');
%ylabel(strcat('Adjusted CMRO_2',unit_of_measure_energy),'FontSize',12,'FontWeight','bold');
legend([h1,h2],'cortical','subcortical')
grid on

%% corr

data_cortical = data_tot(data_tot(:,logical_cortical_dim)==1,:)

[r,p] = corrcoef(data_cortical(:,x_dim_idx),data_cortical(:,y_dim_idx))

data_subcortical = data_tot(data_tot(:,logical_cortical_dim)==0,:)

[r,p] = corrcoef(data_subcortical(:,x_dim_idx),data_subcortical(:,y_dim_idx))