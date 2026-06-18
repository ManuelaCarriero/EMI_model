%% This programme analyze median regional values computed through the compute_medians.m code

%the analysis is CMRO2 vs one microstructural parameter at a time between 
%rsoma, fsoma, fsup and fs
%accordingly to which microstructural parameter has been chosen in
%compute_medians

%select path ALL data are
root_path = '/media/nas_rete/Work_manuela';%'/home/c25078236/Desktop';

%CMRO2 vs the microstructural parameter chosen for medians across subjs
type = 'cortical';


%% load data

% load('/media/nas_rete/Work_manuela/EMI_model-main/EMI_data/WAND/computed_medians_and_PVEmeans_withoutfsmasking_withnvoxels_removingzerosfromcmro2regions_andfromGM.mat')

% load('/media/nas_rete/Work_manuela/EMI_model-main/EMI_data/WAND/CORRECTEDRIGHTDWIREGIONSANDNDWIVOXELScomputed_medians_and_PVEmeans_withoutfsmasking_withnvoxels_removingzerosfromcmro2regions_andfromGM.mat')
% load('/media/nas_rete/Work_manuela/EMI_model-main/EMI_data/WAND/CORRECTEDRIGHTDWIREGIONS_medians_CMRO2_GM_subjs.mat')

% load('/media/nas_rete/Work_manuela/EMI_model-main/EMI_data/WAND/CORRECTEDRIGHTDWIREGIONSANDNDWIVOXELScomputed_medians_and_PVEmeans_withoutfsmasking_withnvoxels_NOTremovingzerosfromcmro2regions_andfromGM.mat')

% load(strcat(path,'/saved_workspace/programmi/computed_data.mat'))
% load(strcat(path,'/saved_workspace/programmi/data/selected_computed_with_wholeGMcorticalmedians.mat'))
load(strcat(root_path,'/EMI_model-main/EMI_data/WAND/260617/selected_medians.mat'))
labels_final_original = labels_final;

%% select parameters to be analyzed
%choose the parameter to be analyzed

micro_parameter = 'fc';
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

%% select only cortical regions or subcortical regions

if strcmp(type,'cortical')
    label=1;
elseif strcmp(type,'subcortical')
    label=0;
end

cortical_regions = load(strcat(root_path,'/WAND_data/AAL_cortical_labels.txt'));
cortical_regions_logical = ismember(labels_final,cortical_regions); %in this way, 0 are subcortical and 1 are cortical regions.

%%

medians_func=medians_func(:,cortical_regions_logical==label);
medians_dwi=medians_dwi(:,cortical_regions_logical==label);

%pve 

means_pve_0_dwi=means_pve_0_dwi(:,cortical_regions_logical==label);
means_pve_1_dwi=means_pve_1_dwi(:,cortical_regions_logical==label);
means_pve_2_dwi=means_pve_2_dwi(:,cortical_regions_logical==label);

means_pve_0_func=means_pve_0_func(:,cortical_regions_logical==label);
means_pve_1_func=means_pve_1_func(:,cortical_regions_logical==label);
means_pve_2_func=means_pve_2_func(:,cortical_regions_logical==label);







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

disp('median across subjects computed')



%% run this section to save names of labels in the variables

if strcmp(micro_parameter,'Rsoma')
    unit_of_measure_dwi='(\mum)';
    micro_parameter_name = 'R_{soma}';
    micro_parameter_reg_coeff = '\alpha_1';
elseif strcmp(micro_parameter,'fsoma')
    unit_of_measure_dwi='';
    micro_parameter_name = 'f_{soma}';
    micro_parameter_reg_coeff = '\beta_1';
elseif strcmp(micro_parameter,'fsup')
    unit_of_measure_dwi='(mm^{-1})';
    micro_parameter_name = 'SAD';
    micro_parameter_reg_coeff = '\gamma_1';
elseif strcmp(micro_parameter,'fc')
    unit_of_measure_dwi='(mm^{-3})';
    micro_parameter_name = 'ND';
    micro_parameter_reg_coeff = '\delta_1';
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

labels_final(idx)=[];

disp('medians across subjects equal to NaN removed')



%% GLM considering PVE_WM and PVE_CSF as covariates

%to use this, you should remove NaNs to everyone
% medians_dwi_scored = zscore(medians_micro_parameter_vec);
% medians_pve_0_dwi_scored = zscore(medians_pve_0_dwi_vec);
% medians_pve_2_dwi_scored = zscore(medians_pve_2_dwi_vec);
% medians_energy_dwi_scored = zscore(medians_energy_vec);
%medians_micro_parameter_vec = medians_fc;
% cd('/home/c25078236/Desktop/programmes/250902')

disp('Computing Generalized Linear Model across regions (medians between subjs)')

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

%trasform zscored y variable back to original units

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
%s=plot(medians_micro_parameter_vec,cmro2_regressed,'.',MarkerSize=25);
s = errorbar(medians_micro_parameter_vec, cmro2_regressed, SE_energy, SE_energy, SE_micro_parameter, SE_micro_parameter,'.','MarkerSize',22);


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

set(get(gca, 'XAxis'), 'FontWeight', 'bold','FontSize',14);
set(get(gca, 'YAxis'), 'FontWeight', 'bold','FontSize',14);
set(gca,'box','off')

xlabel(strcat(micro_parameter_name,unit_of_measure_dwi),'FontSize',19,'FontWeight','bold','FontName','Calibri');
ylabel(strcat('CMRO_2',unit_of_measure_energy),'FontSize',19,'FontWeight','bold','FontName','Calibri');
title(strcat('CMRO_2 vs',micro_parameter_name),'FontSize',19,'FontWeight','bold','FontName','Calibri')
s.Color='b';

x0=50;
y0=50;
width=500;%550;
height=500;%450;
 
if p(2)<0.05 && p(2)>0.01    
    txt = {strcat('r = ',corr_coef_str,'*')};
elseif p(2)<0.01 && p(2)>0.001   
    txt = {strcat('r = ',corr_coef_str,'**')};
elseif p(2)<0.001
    txt = {strcat('r = ',corr_coef_str,'***')};
elseif p(2)>0.05
        txt = {strcat('r = ',corr_coef_str,'')};
end
if strcmp(micro_parameter,'Rsoma')
    text(9,100,txt,'FontWeight', 'Bold','FontSize',18);
elseif strcmp(micro_parameter,'fsoma')
    text(0.35,100,txt,'FontWeight', 'Bold','FontSize',18);
elseif strcmp(micro_parameter,'fsup')
    text(100,100,txt,'FontWeight', 'Bold','FontSize',18);
elseif strcmp(micro_parameter,'fc')
    text(10^5,100,txt,'FontWeight', 'Bold','FontSize',18);
end

set(gcf,'position',[x0,y0,width,height]);
ylim([40,200]);
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


%% GLM for each subject and correlation regressing out PVE effects

disp('Computing GLM for each subject')

pvalue_microparameter_subjs=[];
estimate_microparameter_subjs=[];
corr_for_each_subjs_regout_pves=[];

% choose to plot either the distribution or the scatterplots

% figure,
for i = 1:n_subjs
    medians_dwi_subj=medians_dwi(i,:);
    medians_func_subj=medians_func(i,:);
    means_pve_0_subj=means_pve_0_dwi(i,:);
    means_pve_2_subj=means_pve_2_dwi(i,:);
    %%%%%%%%

    %find nans
    idx_dwi_nans = find(isnan(medians_dwi_subj));
    idx_func_nans = find(isnan(medians_func_subj));
    idx_means_pve_0_nans = find(isnan(means_pve_0_subj));
    idx_means_pve_2_nans = find(isnan(means_pve_2_subj));
    idx_tot = unique(cat(2,idx_dwi_nans,idx_func_nans,idx_means_pve_0_nans,idx_means_pve_2_nans));
    %remove nans
    medians_dwi_subj(idx_tot)=[];
    medians_func_subj(idx_tot)=[];
    means_pve_0_subj(idx_tot)=[];
    means_pve_2_subj(idx_tot)=[];

    % plot of the distribution for each subject
    % h=hist(medians_dwi_subj)
    % xlabel(micro_parameter,'FontWeight','bold')
    % ylabel('Counts (# of regions)','FontWeight','bold')
    % hold on
    % grid on

    %%%%%%%
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

    % %scatterplots plot
    % 
    % cmro2_regressed = cmro2_without_pves.*nanstd(medians_func_subj)+nanmean(medians_func_subj);
    % 
    % y=cmro2_regressed';
    % x=medians_dwi_subj;
    % idx_nan_y=find(isnan(y));
    % idx_nan_x=find(isnan(x));
    % idx_nan = unique(cat(2,idx_nan_y,idx_nan_x));
    % y(idx_nan)=[];
    % x(idx_nan)=[];
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
    % s=subplot(5,6,i)   
    % plot(medians_dwi_subj, cmro2_regressed,'.')
    % hold on
    % plot(x_sorted,y_fit_sorted,'--','LineWidth',3,'Color',"#000000");
    % xlabel('f_s','FontWeight','bold');
    % ylabel(strcat('CMRO_2'),'FontWeight','bold');
    % title(strcat('subj-',num2str(i)))
    % grid on
end
% Error using statrobustfit (line 21)
% Not enough points to perform robust estimation.
%so you must put robustots off

% figure, 
% s=histogram(pvalue_microparameter_subjs,'FaceAlpha',1,'BinWidth',0.07);
% s.FaceColor="b";
% xlabel('p-values','FontWeight','bold','FontSize',15);
% ylabel('Counts (# subjects)','FontWeight','bold','FontSize',15);
% title('pvalues')
% ylim([0,14]);
% xline(0,'--','LineWidth',3);
% grid on

%regression coefficient distribution

figure, 
s=histogram(estimate_microparameter_subjs,'FaceAlpha',1,'BinWidth',0.07);
s.FaceColor="b";

set(get(gca, 'XAxis'), 'FontWeight', 'bold','FontSize',14);
set(get(gca, 'YAxis'), 'FontWeight', 'bold','FontSize',14);
set(gca,'box','off')
width=450;%550;
height=400;%450;

xlabel(strcat('regression coefficient estimate,',micro_parameter_reg_coeff),'FontSize',16,'FontWeight','bold','FontName','Calibri');
ylabel('Counts (# subjects)','FontSize',19,'FontWeight','bold','FontName','Calibri');
title(strcat(energy_parameter, 'vs',micro_parameter_name),'FontSize',19,'FontWeight','bold','FontName','Calibri')
ylim([0,10]);
xlim([-0.7,0.7])

xline(0,'--','LineWidth',3);
set(gcf,'position',[x0,y0,width,height]);

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

disp('Regression coefficients distribution (ttest)')
[h,p]=ttest(estimate_microparameter_subjs)%1 rejects the null hypothesis that the mean is equal to 0.

median_estimate = median(estimate_microparameter_subjs)
mean_estimate = mean(estimate_microparameter_subjs)
std_estimate = std(estimate_microparameter_subjs)

% % save variable for the diff analysis
% if strcmp(micro_parameter,'Rsoma')   
%     estimate_microparameter_subjs_rsoma=estimate_microparameter_subjs;
% elseif strcmp(micro_parameter,'fsoma')
%     estimate_microparameter_subjs_fsoma=estimate_microparameter_subjs;
% elseif strcmp(micro_parameter,'fsup')
%     estimate_microparameter_subjs_fsup=estimate_microparameter_subjs;
% elseif strcmp(micro_parameter,'fc')
%     estimate_microparameter_subjs_fc=estimate_microparameter_subjs;
% end

% median_pvalue = median(pvalue_microparameter_subjs);
% std_pvalue = std(pvalue_microparameter_subjs);
% 
% mean_with_subjs_corr=nanmean(corr_for_each_subjs_regout_pves);%with fsup we could have NaNs
% [h,p,ci,stats]=ttest(atanh(corr_for_each_subjs_regout_pves));
% 
% mean_corr = num2str(round(mean_with_subjs_corr,2));

% correlation distribution

% figure, 
% s=histogram(corr_for_each_subjs_regout_pves,'FaceAlpha',1,'BinWidth',0.07);
% s.FaceColor="b";
% xlabel('correlation coefficient, r','FontWeight','bold','FontSize',15);
% ylabel('Counts (# subjects)','FontWeight','bold','FontSize',15);
% ylim([0,8]);
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
% title(strcat(energy_parameter, 'vs',micro_parameter));
% text(0.1,7,txt, 'FontWeight', 'bold','FontSize',15);
% grid on