%% This programme analyzes medians calculated from compute_medians.m

% Differently from analyze_medians.m, this programme considers more than
% one microparameter at a time

%%

% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/V_atlas_glass.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_GMmedians.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_GMPVEmeans.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/medians_CMRO2_GM_subjs.mat')

% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans_withoutfsmasking.mat')
% load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_microparameters_GMmedians_withoutfsmasking.mat')

load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans_withoutfsmasking_withnvoxels.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/labels_final.mat')

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

disp('medians across subjects equal to NaN removed')

%% zscore regional medians

cd('/home/c25078236/Desktop/programmes/250902')

disp('Computing Generalized Linear Model')

medians_rsoma_scored = nanzscore(medians_rsoma_subjs_final_spaces_vec);
medians_fsoma_scored = nanzscore(medians_fsoma_subjs_final_spaces_vec);
medians_fsup_scored = nanzscore(medians_fsup_subjs_final_spaces_vec);
medians_fc_scored = nanzscore(medians_fsup_subjs_final_spaces_vec);
medians_energy_scored = nanzscore(medians_energy_vec);

means_pve_0_dwi_scored = nanzscore(means_pve_0_dwi_vec);
means_pve_2_dwi_scored = nanzscore(means_pve_2_dwi_vec);
means_pve_1_dwi_scored = nanzscore(means_pve_1_dwi_vec);

medians_rsoma_scored_tr = medians_rsoma_scored';
medians_fsoma_scored_tr = medians_fsoma_scored';
medians_fsup_scored_tr = medians_fsup_scored';
medians_fc_scored_tr = medians_fc_scored';
medians_energy_scored_tr = medians_energy_scored';

means_pve_0_dwi_scored_tr = means_pve_0_dwi_scored';
means_pve_2_dwi_scored_tr = means_pve_2_dwi_scored';
means_pve_1_dwi_scored_tr = means_pve_1_dwi_scored';

%% I PART: CMRO2 vs Rsoma, removing soma densities effects and PVEs

%% define table for GLM

medians_invertedrsoma_scored_tr = 1./medians_rsoma_scored_tr;
tbl=table(medians_energy_scored_tr,medians_invertedrsoma_scored_tr,medians_rsoma_scored_tr,medians_fsoma_scored_tr,medians_fsup_scored_tr,medians_fc_scored_tr,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr, 'VariableNames', ...
    {'CMRO2','invertedRsoma','Rsoma','fsoma','fsup','fc','pve_0_dwi','pve_2_dwi'});

%% build your model



covariate_microparameter='no'; %fsup %fsoma

pve_micro_parameter='no';

%%
if strcmp(pve_micro_parameter,'no') && strcmp(covariate_microparameter,'no')
    mdl=fitlm(tbl,'CMRO2 ~ Rsoma ','RobustOpts','on')
    y_pve_0_dwi=0;
    y_pve_2_dwi=0;
    y_f=0;
elseif strcmp(covariate_microparameter,'no') && strcmp(pve_micro_parameter,'yes')
    mdl=fitlm(tbl,'CMRO2 ~ Rsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    covariate_f=0;
    estimate_f=0;
    coeffs_mat=table2array(mdl.Coefficients);
    estimate_pve_0=coeffs_mat(3,1);
    estimate_pve_2=coeffs_mat(4,1);
 
    %regress out
    y_pve_0_dwi = means_pve_0_dwi_scored.*estimate_pve_0;
    y_pve_2_dwi = means_pve_2_dwi_scored.*estimate_pve_2;
    y_f = covariate_f.*estimate_f;
    % y_fsup = medians_fsup_scored.*estimate_fsup;
    %y_fc = medians_fc_scored.*estimate_fc;
elseif strcmp(covariate_microparameter,'fsup')
    mdl=fitlm(tbl,'CMRO2 ~ Rsoma + fsup  + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    covariate_f = medians_fsup_scored;
    coeffs_mat=table2array(mdl.Coefficients);
    estimate_pve_0=coeffs_mat(4,1);
    estimate_pve_2=coeffs_mat(5,1);
    estimate_f = coeffs_mat(3,1);

    %regress out
    y_pve_0_dwi = means_pve_0_dwi_scored.*estimate_pve_0;
    y_pve_2_dwi = means_pve_2_dwi_scored.*estimate_pve_2;
    y_f = covariate_f.*estimate_f;
    % y_fsup = medians_fsup_scored.*estimate_fsup;
    %y_fc = medians_fc_scored.*estimate_fc;

elseif strcmp(covariate_microparameter,'fsoma')
    mdl=fitlm(tbl,'CMRO2 ~ Rsoma + fsoma  + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    covariate_f = medians_fsoma_scored;
    coeffs_mat=table2array(mdl.Coefficients);
    estimate_pve_0=coeffs_mat(4,1);
    estimate_pve_2=coeffs_mat(5,1);
    estimate_f = coeffs_mat(3,1);

    %regress out
    y_pve_0_dwi = means_pve_0_dwi_scored.*estimate_pve_0;
    y_pve_2_dwi = means_pve_2_dwi_scored.*estimate_pve_2;
    y_f = covariate_f.*estimate_f;
    % y_fsup = medians_fsup_scored.*estimate_fsup;
    %y_fc = medians_fc_scored.*estimate_fc;
end

%% calculate the scale out cmro2 (III method)
% and then rescale back to the original
% it's the method used for the article analysis



cmro2_regressed_zscored = medians_energy_scored-y_pve_0_dwi-y_pve_2_dwi-y_f;%-y_fsup;%-y_fc;

cmro2_regressed = cmro2_regressed_zscored.*std(medians_energy_vec)+mean(medians_energy_vec);

%% run this section to save names of labels in the variables

micro_parameter = 'Rsoma';
energy_parameter = 'CMRO2';

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

%% plot
% [r,p] = corrcoef(cmro2_regressed, medians_micro_parameter_vec,'rows','complete');

y=cmro2_regressed;
x=medians_rsoma_subjs_final_spaces_vec;
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

[r,p] = corrcoef(x,cmro2_regressed);

corr_coef_str = num2str(round(r(2),2));

figure, 
%s=plot(medians_micro_parameter_vec,cmro2_regressed,'.',MarkerSize=25);
s = errorbar(x, cmro2_regressed, SE_energy, SE_energy, SE_rsoma, SE_rsoma,'.','MarkerSize',22);


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
text(9,100,txt,'FontWeight', 'Bold','FontSize',12);
%text(0.35,100,txt,'FontWeight', 'Bold','FontSize',12);
% text(10^5,100,txt,'FontWeight', 'Bold','FontSize',12);
%text(10^14,100,txt,'FontWeight', 'Bold','FontSize',12);
set(gcf,'position',[x0,y0,width,height]);
ylim([50,190]);
grid on

%% II PART: study of the cellular packaging (see christallography)

%% define table for GLM

medians_invertedrsoma_scored_tr = 1./medians_rsoma_scored_tr;
tbl=table(medians_energy_scored_tr,medians_invertedrsoma_scored_tr,medians_rsoma_scored_tr,medians_fsoma_scored_tr,medians_fsup_scored_tr,medians_fc_scored_tr,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr, 'VariableNames', ...
    {'CMRO2','invertedRsoma','Rsoma','fsoma','fsup','fc','pve_0_dwi','pve_2_dwi'});

%% select parameters
parameter_y = 'fsup';%fsup
parameter_x = 'Rsoma';

%%
% %build your model

if strcmp(parameter_y,'fsoma') && strcmp(parameter_x,'Rsoma')
 mdl=fitlm(tbl,'fsoma ~ Rsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
elseif strcmp(parameter_y,'fsup') && strcmp(parameter_x,'Rsoma')
 mdl=fitlm(tbl,'fsup ~ Rsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
elseif strcmp(parameter_y,'fsoma') && strcmp(parameter_x,'fsup')
 mdl=fitlm(tbl,'fsoma ~ fsup + pve_0_dwi + pve_2_dwi','RobustOpts','on')
end

 %% calculate the scale out dependent variable (III method)
% and then rescale back to the original
% it's the method used for the article analysis


if strcmp(parameter_y,'fsoma')
    medians_parameter_scored = medians_fsoma_scored;
    medians_parameter_vec = medians_fsoma_subjs_final_spaces_vec;
    SE_y = SE_fsoma;
    micro_parameter_y = 'fsoma';
    unit_of_measure_y='';
elseif strcmp(parameter_y,'fsup')
    medians_parameter_scored = medians_fsup_scored;
    medians_parameter_vec = medians_fsup_subjs_final_spaces_vec;
    SE_y = SE_fsup;
    micro_parameter_y = 'fsup';
    unit_of_measure_y='(m^{-1})';
elseif strcmp(parameter_y,'Rsoma')
    medians_parameter_scored = medians_rsoma_scored;
    medians_parameter_vec = medians_rsoma_subjs_final_spaces_vec;
    SE_y = SE_rsoma;
    micro_parameter_y = 'Rsoma';
    unit_of_measure_y='(\mum)';
end

if strcmp(parameter_x,'fsoma')
    x = medians_fsoma_subjs_final_spaces_vec;
    SE_x = SE_fsoma;
    micro_parameter_x = 'fsoma';
    unit_of_measure_x='';
elseif strcmp(parameter_x,'fsup')
    x = medians_fsup_subjs_final_spaces_vec;
    SE_x = SE_fsup;
    micro_parameter_x = 'fsup';
    unit_of_measure_x='(m^{-1})';
elseif strcmp(parameter_x,'Rsoma')
    x = medians_rsoma_subjs_final_spaces_vec;
    SE_x = SE_rsoma;
    micro_parameter_x = 'Rsoma';
    unit_of_measure_x='(\mum)';
end

%%
coeffs_mat=table2array(mdl.Coefficients);
estimate_pve_0=coeffs_mat(3,1);
estimate_pve_2=coeffs_mat(4,1);

%regress out
y_pve_0_dwi = means_pve_0_dwi_scored.*estimate_pve_0;
y_pve_2_dwi = means_pve_2_dwi_scored.*estimate_pve_2;


parameter_regressed_zscored = medians_parameter_scored-y_pve_0_dwi-y_pve_2_dwi;

parameter_regressed = parameter_regressed_zscored.*std(medians_parameter_vec)+mean(medians_parameter_vec);

%% plot
% [r,p] = corrcoef(cmro2_regressed, medians_micro_parameter_vec,'rows','complete');

y=parameter_regressed;

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

[r,p] = corrcoef(x,y);

corr_coef_str = num2str(round(r(2),2));

figure, 
%s=plot(medians_micro_parameter_vec,cmro2_regressed,'.',MarkerSize=25);
s = errorbar(x, y, SE_y, SE_y, SE_x, SE_x,'.','MarkerSize',22);


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

xlabel(strcat(micro_parameter_x,unit_of_measure_x),'FontSize',15,'FontWeight','bold');
ylabel(strcat(micro_parameter_y,unit_of_measure_y),'FontSize',12,'FontWeight','bold');
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
if strcmp(parameter_x,'Rsoma') && strcmp(parameter_y,'fsoma')
    text(9,0.5,txt,'FontWeight', 'Bold','FontSize',12);
elseif strcmp(parameter_x,'fsup') && strcmp(parameter_y,'fsoma')
    text(10^5,0.5,txt,'FontWeight', 'Bold','FontSize',12);
elseif strcmp(parameter_x,'Rsoma') && strcmp(parameter_y,'fsup')
    text(9,10^5,txt,'FontWeight', 'Bold','FontSize',12);
end
set(gcf,'position',[x0,y0,width,height]);
% ylim([50,180]);
grid on

%% clustering
%This approach uses a clustering algorithm applied to the fsup vs rsoma
%space and a clustering algorithm applied to fsoma vs rsoma space
%then it considers as main cluster the labels classified as main 
% both in the fsup vs rsoma space and in the fsoma vs rsoma space
% (analogous reasoning for the sparsed cluster).

data_label = cat(1,x,y,labels_final);
data_label = data_label';
data = data_label(:,1:2);

% [idx,C] = kmeans(data,2);

data_zscored = zscore(data);
idx = dbscan(data_zscored,0.5,5);


figure;
plot(data_zscored(idx==1,1),data_zscored(idx==1,2),'r.','MarkerSize',12)
hold on
plot(data_zscored(idx==2,1),data_zscored(idx==2,2),'b.','MarkerSize',12)
plot(data_zscored(idx==-1,1),data_zscored(idx==-1,2),'k.','MarkerSize',12)
% plot(C(:,1),C(:,2),'kx',...
%      'MarkerSize',15,'LineWidth',3) 
legend('Cluster 1','Cluster 2','Noise','Location','NW') %'Centroids',...
title 'Cluster Assignments'% and Centroids'
hold off

%a=[3,4,5];
%a(a==3)

%% identify labels of each cluster
% you must run the II part twice: one for fsup vs rsoma and the other one 
% for fsoma vs rsoma

%% fsup vs rsoma

if strcmp(parameter_y,'fsup') && strcmp(parameter_x,'Rsoma')
    noise_cluster_fsupvsrsoma=labels_final(idx==-1);
    small_cluster_fsupvsrsoma=labels_final(idx==2);

    important_cluster_fsupvsrsoma=labels_final(idx==1);
    sparsed_cluster_fsupvsrsoma=cat(2,noise_cluster_fsupvsrsoma,small_cluster_fsupvsrsoma);
end

%% test

% figure,scatter(data_zscored(find(ismember(labels_final,important_cluster_fsupvsrsoma)),1),data_zscored(find(ismember(labels_final,important_cluster_fsupvsrsoma)),2),'Marker','s')
% ylim([-3.5,1.5])
% xlim([-3,2])

%% fsoma vs rsoma

if strcmp(parameter_y,'fsoma') && strcmp(parameter_x,'Rsoma')
    noise_cluster_fsomavsrsoma=labels_final(idx==-1);
    small_cluster_fsomavsrsoma=labels_final(idx==2);

    important_cluster_fsomavsrsoma=labels_final(idx==1);
    sparsed_cluster_fsomavsrsoma=cat(2,noise_cluster_fsomavsrsoma,small_cluster_fsomavsrsoma);
end

%% test

% figure,scatter(data_zscored(find(ismember(labels_final,important_cluster_fsomavsrsoma)),1),data_zscored(find(ismember(labels_final,important_cluster_fsomavsrsoma)),2),'Marker','s')
% ylim([-4,2])
% xlim([-3,2])

%%
common_important_cluster = intersect(important_cluster_fsupvsrsoma,important_cluster_fsomavsrsoma);
common_sparsed_cluster = intersect(sparsed_cluster_fsupvsrsoma,sparsed_cluster_fsomavsrsoma);

size(common_sparsed_cluster)
size(common_important_cluster)
% common_noise = intersect(noise_cluster_fsupvsrsoma,noise_cluster_fsomavsrsoma);
% common_small_cluster = intersect(small_cluster_fsupvsrsoma,small_cluster_fsomavsrsoma);
% tot_labels = cat(2, common_noise,common_important_cluster,common_small_cluster);
% setdiff(labels_final,tot_labels)
% there is a difference of one label that probably is in the noise cluster
% for fsupvsrsoma and in the small cluster for fsomavsrsoma or viseversa

%% check CMRO2 vs microparameter behavior for the selected subgroups
%for those group of labels, check CMRO2 vs fSAD, CMRO2 vs fc, CMRO2 vs
%Rsoma, CMRO2 vs fsoma

%% run this in case you want only cortical regions
cortical_regions = load('/home/c25078236/Desktop/WAND_data/AAL_cortical_labels.txt');
numel(cortical_regions)
common_important_cluster=cortical_regions';
subcortical_regions = load('/home/c25078236/Desktop/WAND_data/AAL_subcortical_labels.txt');
numel(subcortical_regions)
common_sparsed_cluster=subcortical_regions';
%%
%run this in case you want regions classified by the clustering algorithm
%selecting the main cluster 
logical_important_cluster = ismember(labels_final,common_important_cluster);
% idx_important_cluster = find(logical_important_cluster);



medians_rsoma_scored_important_cluster=medians_rsoma_scored_tr(logical_important_cluster);
medians_fsoma_scored_important_cluster=medians_fsoma_scored_tr(logical_important_cluster);
medians_fsup_scored_important_cluster=medians_fsup_scored_tr(logical_important_cluster);
medians_fc_scored_important_cluster=medians_fc_scored_tr(logical_important_cluster);
medians_energy_scored_important_cluster=medians_energy_scored_tr(logical_important_cluster);
means_pve_0_dwi_scored_important_cluster=means_pve_0_dwi_scored_tr(logical_important_cluster);
means_pve_2_dwi_scored_important_cluster=means_pve_2_dwi_scored_tr(logical_important_cluster);
means_pve_1_dwi_scored_important_cluster=means_pve_1_dwi_scored_tr(logical_important_cluster);

medians_rsoma_important_cluster = medians_rsoma_subjs_final_spaces_vec(logical_important_cluster);
medians_fsoma_important_cluster = medians_fsoma_subjs_final_spaces_vec(logical_important_cluster);
medians_fsup_important_cluster = medians_fsup_subjs_final_spaces_vec(logical_important_cluster);
medians_fc_important_cluster = medians_fc_subjs_final_spaces_vec(logical_important_cluster);
medians_energy_important_cluster = medians_energy_vec(logical_important_cluster);
means_pve_0_important_cluster = means_pve_0_dwi_vec(logical_important_cluster);
means_pve_2_important_cluster = means_pve_2_dwi_vec(logical_important_cluster);
means_pve_1_important_cluster = means_pve_1_dwi_vec(logical_important_cluster);

% %test
% figure,
% scatter(medians_rsoma_scored_important_cluster,medians_fsup_scored_important_cluster,'Marker','s')
% ylim([-3.5,1.5])
% xlim([-3,2])
% %it can't be the same plot as it isn't corrected for PVEs.





%selecting the sparsed cluster

logical_sparsed_cluster = ismember(labels_final,common_sparsed_cluster);
% idx_sparsed_cluster = find(logical_sparsed_cluster);

medians_rsoma_scored_sparsed_cluster=medians_rsoma_scored_tr(logical_sparsed_cluster);
medians_fsoma_scored_sparsed_cluster=medians_fsoma_scored_tr(logical_sparsed_cluster);
medians_fsup_scored_sparsed_cluster=medians_fsup_scored_tr(logical_sparsed_cluster);
medians_fc_scored_sparsed_cluster=medians_fc_scored_tr(logical_sparsed_cluster);
medians_energy_scored_sparsed_cluster=medians_energy_scored_tr(logical_sparsed_cluster);
means_pve_0_dwi_scored_sparsed_cluster=means_pve_0_dwi_scored_tr(logical_sparsed_cluster);
means_pve_2_dwi_scored_sparsed_cluster=means_pve_2_dwi_scored_tr(logical_sparsed_cluster);
means_pve_1_dwi_scored_sparsed_cluster=means_pve_1_dwi_scored_tr(logical_sparsed_cluster);

medians_rsoma_sparsed_cluster = medians_rsoma_subjs_final_spaces_vec(logical_sparsed_cluster);
medians_fsoma_sparsed_cluster = medians_fsoma_subjs_final_spaces_vec(logical_sparsed_cluster);
medians_fsup_sparsed_cluster = medians_fsup_subjs_final_spaces_vec(logical_sparsed_cluster);
medians_fc_sparsed_cluster = medians_fc_subjs_final_spaces_vec(logical_sparsed_cluster);
medians_energy_sparsed_cluster = medians_energy_vec(logical_sparsed_cluster);
means_pve_0_sparsed_cluster = means_pve_0_dwi_vec(logical_sparsed_cluster);
means_pve_2_sparsed_cluster = means_pve_2_dwi_vec(logical_sparsed_cluster);
means_pve_1_sparsed_cluster = means_pve_1_dwi_vec(logical_sparsed_cluster);



%% choose microparameter to study its relationship with CMRO2 and which cluster
cluster='important'; %sparsed
parameter_x = 'Rsoma';

pve_adjustment = 'no';

%% GLM

if strcmp(cluster,'sparsed')
    tbl_sparsed=table(medians_energy_scored_sparsed_cluster,medians_rsoma_scored_sparsed_cluster,medians_fsoma_scored_sparsed_cluster,medians_fsup_scored_sparsed_cluster,medians_fc_scored_sparsed_cluster,means_pve_0_dwi_scored_sparsed_cluster,means_pve_1_dwi_scored_sparsed_cluster, 'VariableNames', ...
        {'CMRO2','Rsoma','fsoma','fsup','fc','pve_0_dwi','pve_2_dwi','pve_1_dwi'});
    tbl = tbl_sparsed;
else
    tbl_important=table(medians_energy_scored_important_cluster,medians_rsoma_scored_important_cluster,medians_fsoma_scored_important_cluster,medians_fsup_scored_important_cluster,medians_fc_scored_important_cluster,means_pve_0_dwi_scored_important_cluster,means_pve_2_dwi_scored_important_cluster,means_pve_1_dwi_scored_important_cluster, 'VariableNames', ...
        {'CMRO2','Rsoma','fsoma','fsup','fc','pve_0_dwi','pve_2_dwi','pve_1_dwi'});
    tbl = tbl_important;
end

%%
% %build your model
if strcmp(pve_adjustment,'no')
   mdl=fitlm(tbl,'CMRO2 ~ Rsoma','RobustOpts','on')

   if strcmp(cluster,'sparsed')
        x = medians_rsoma_sparsed_cluster;
    else
        x=medians_rsoma_important_cluster;
    end
    % SE_x = SE_rsoma;
    micro_parameter_x = 'Rsoma';
    unit_of_measure_x='(\mum)';  
elseif strcmp(parameter_x,'Rsoma')
    mdl=fitlm(tbl,'CMRO2 ~ Rsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    if strcmp(cluster,'sparsed')
        x = medians_rsoma_sparsed_cluster;
    else
        x=medians_rsoma_important_cluster;
    end
    % SE_x = SE_rsoma;
    micro_parameter_x = 'Rsoma';
    unit_of_measure_x='(\mum)';
elseif strcmp(parameter_x,'fsoma')
    mdl=fitlm(tbl,'CMRO2 ~ fsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    if strcmp(cluster,'sparsed')
        x = medians_fsoma_sparsed_cluster;
    else
        x = medians_fsoma_important_cluster;
    end
    % SE_x = SE_fsoma;
    micro_parameter_x = 'fsoma';
    unit_of_measure_x='';
elseif strcmp(parameter_x,'fsup')
    mdl=fitlm(tbl,'CMRO2 ~ fsup + pve_0_dwi + pve_2_dwi','RobustOpts','on')%+ pve_0_dwi
    if strcmp(cluster,'sparsed')
        x = medians_fsup_sparsed_cluster;
    else
        x=medians_fsup_important_cluster;
    end
    % SE_x = SE_fsup;
    micro_parameter_x = 'fsup';
    unit_of_measure_x='(m^{-1})';
elseif strcmp(parameter_x,'fc')
    mdl=fitlm(tbl,'CMRO2 ~ fc + pve_0_dwi + pve_2_dwi','RobustOpts','on')
    if strcmp(cluster,'sparsed')
        x = medians_fc_sparsed_cluster;
    else
        x=medians_fc_important_cluster;
    end
    % SE_x = SE_fc;
    micro_parameter_x = 'fc';
    unit_of_measure_x='(m^{-3})';
end


%% regress out
coeffs_mat=table2array(mdl.Coefficients);
estimate_pve_0=coeffs_mat(3,1);
estimate_pve_2=coeffs_mat(4,1);

if strcmp(cluster,'sparsed')
    medians_cmro2_scored = medians_energy_scored_sparsed_cluster;
    medians_cmro2 = medians_energy_sparsed_cluster;
    means_pve_0 = means_pve_0_dwi_scored_sparsed_cluster;
    means_pve_2 = means_pve_2_dwi_scored_sparsed_cluster;

else
    medians_cmro2_scored = medians_energy_scored_important_cluster;
    medians_cmro2 = medians_energy_important_cluster;
    means_pve_0 = means_pve_0_dwi_scored_important_cluster;
    means_pve_2 = means_pve_2_dwi_scored_important_cluster;
end

y_pve_0_dwi = means_pve_0.*estimate_pve_0;
y_pve_2_dwi = means_pve_2.*estimate_pve_2;

cmro2_regressed_zscored = medians_cmro2_scored-y_pve_0_dwi-y_pve_2_dwi;

cmro2_regressed = cmro2_regressed_zscored.*std(medians_cmro2)+mean(medians_cmro2);

%% plot
% [r,p] = corrcoef(cmro2_regressed, medians_micro_parameter_vec,'rows','complete');
if strcmp(pve_adjustment,'no')
    if strcmp(cluster,'important')
    y=medians_energy_important_cluster;
    elseif strcmp(cluster,'sparsed')
        y=medians_energy_important_cluster;
    end
elseif strcmp(pve_adjustment,'yes')
    y=cmro2_regressed;
end

SE_y=SE_energy;

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

[r,p] = corrcoef(x,y);

corr_coef_str = num2str(round(r(2),2));
pvalue_str = num2str(round(p(2),3));

figure, 
s=plot(x,y,'.',MarkerSize=25);
% s = errorbar(x, y, SE_y, SE_y, SE_x, SE_x,'.','MarkerSize',22);


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

xlabel(strcat(micro_parameter_x,unit_of_measure_x),'FontSize',15,'FontWeight','bold');
ylabel('CMRO_2(\mumol/100g/min','FontSize',12,'FontWeight','bold');
s.Color='b';
set(get(gca, 'XAxis'), 'FontWeight', 'bold');
set(get(gca, 'YAxis'), 'FontWeight', 'bold');
set(gca,'box','off')
x0=50;
y0=50;
width=550;
height=450;
if p(2)<0.05 && p(2)>0.01    
    txt = {strcat('Pearson r = ',corr_coef_str,'*,p-value=',pvalue_str)};
elseif p(2)<0.01 && p(2)>0.001   
    txt = {strcat('Pearson r = ',corr_coef_str,'**,p-value=',pvalue_str)};
elseif p(2)<0.001
    txt = {strcat('Pearson r = ',corr_coef_str,'***,p-value=',pvalue_str)};
elseif p(2)>0.05
        txt = {strcat('Pearson r = ',corr_coef_str,',p-value=',pvalue_str)};
end
if strcmp(parameter_x,'Rsoma')
    text(9,100,txt,'FontWeight', 'Bold','FontSize',12);
elseif strcmp(parameter_x,'fsup')
    text(10^5,100,txt,'FontWeight', 'Bold','FontSize',12);
elseif strcmp(parameter_x,'fsoma')
    text(0.5,100,txt,'FontWeight', 'Bold','FontSize',12);
elseif strcmp(parameter_x,'fc')
    text(10^14,100,txt,'FontWeight', 'Bold','FontSize',12); 
end
title('Main cluster')
set(gcf,'position',[x0,y0,width,height]);
% ylim([50,180]);
grid on



% add error bars even to this plot
% check where these regions are in the brain

%% features extraction

%% zscore GM medians
medians_rsoma_GM_scored = nanzscore(medians_rsoma_GM_subjs);
medians_fsoma_GM_scored = nanzscore(medians_fsoma_GM_subjs);
medians_fsup_GM_scored = nanzscore(medians_fsup_GM_subjs);
medians_fc_GM_scored = nanzscore(medians_fc_GM_subjs);
means_pve_0_dwi_GM_scored = nanzscore(means_pve_0_dwi_GM_subjs);
means_pve_2_dwi_GM_scored = nanzscore(means_pve_2_dwi_GM_subjs);
medians_CMRO2_GM_scored = nanzscore(medians_CMRO2_GM_subjs);

%% prepare data for feature extraction

%across regions 
% WARNING: (take vector after NaNs removal)
X = cat(1,medians_rsoma_scored,medians_fsup_scored,medians_fc_scored,means_pve_0_dwi_scored,means_pve_2_dwi_scored);
%
%medians_rsoma_scored,medians_fsoma_scored,
%using all variables, the derived metrics have zero lambda value.
y = medians_energy_scored;

%across subjects
X_GM = cat(1,medians_rsoma_GM_scored,medians_fsoma_GM_scored,medians_fsup_GM_scored,medians_fc_GM_scored,means_pve_0_dwi_GM_scored,means_pve_2_dwi_GM_scored);
y_GM = medians_CMRO2_GM_scored;

X = X';
y = y';

X_GM = X_GM';
y_GM = y_GM';




%% feature extraction using linear model regularization



lambda_acrossregions = lasso(X,y,"Alpha",0.5);

features_acrossregions = [median(lambda_acrossregions(1,:)),median(lambda_acrossregions(2,:)),median(lambda_acrossregions(3,:)),median(lambda_acrossregions(4,:))]

lambda_acrosssubjs = lasso(X_GM,y_GM,"Alpha",0.5);

features_acrosssubjs = [median(lambda_acrosssubjs(1,:)),median(lambda_acrosssubjs(2,:)),median(lambda_acrosssubjs(3,:)),median(lambda_acrosssubjs(4,:)),median(lambda_acrosssubjs(5,:)),median(lambda_acrosssubjs(6,:))]


%% feature extraction using Random Forest

OOB_error=[];
for ntrees = 1:100
    Mdl = TreeBagger(ntrees,X,y,Method='regression',OOBPredictorImportance='on');
    OOB_error(end+1)=median(oobError(Mdl));
    disp(ntrees)
end

figure,
plot(1:numel(OOB_error),OOB_error)
title('across regions')


OOB_error=[];
for ntrees = 1:400
    Mdl = TreeBagger(ntrees,X_GM,y_GM,Method='regression',OOBPredictorImportance='on');
    OOB_error(end+1)=median(oobError(Mdl));
    dip(ntrees)
end

figure,
plot(1:numel(OOB_error),OOB_error)
title('across subjects')

%% test the RF model
dimensions = size(X);
obs = dimensions(1);

X_train = X(1:obs/2,:);
y_train = y(1:obs/2,:);
y_test = y(obs/2+1:dimensions,:);
X_test = X(obs/2+1:dimensions,:);

Mdl = TreeBagger(4000,X_train,y_train,Method='regression',OOBPredictorImportance='on',MinLeafSize=1,NumPredictorsToSample=2,MaxNumSplits=100);

y_pred = predict(Mdl,X_test);

figure,
scatter(y_test,y_pred)
hold on
plot(-3:4,-3:4)
xlabel('test')
ylabel('predicted')

%ho la sensazione che il modello fallisca perché sia troppo semplice
%infatti quando si cerca di tunare i parametri per evitare overfitting
%la nuovola di punti diventa più orizzontale.

%%
%example

rng default % For reproducibility
X = randn(100,5);
weights = [0;2;0;-3;0]; % Only two nonzero coefficients
y = X*weights + randn(100,1)*0.1; % Small added noise
B = lasso(X,y);

figure,
hist(B(1,:))

figure,
hist(B(2,:))

figure,
hist(B(3,:))

figure,
hist(B(4,:))

figure,
hist(B(5,:))

%you can take the median of the lambda values for each feature.

features = [median(B(1,:)),median(B(2,:)),median(B(3,:)),median(B(4,:)),median(B(5,:))]
