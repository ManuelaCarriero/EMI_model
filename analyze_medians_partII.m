%% This programme analyzes medians calculated from compute_medians.m

% Differently from analyze_medians.m, this programme considers more than
% one microparameter at a time

%%
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/V_atlas_glass.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_GMmedians.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_GMPVEmeans.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/medians_CMRO2_GM_subjs.mat')

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

disp('medians across subjects equal to NaN removed')

%% GLM vs Rsoma, fsoma and PVEs

cd('/home/c25078236/Desktop/programmes/250902')

disp('Computing Generalized Linear Model')

medians_rsoma_scored = nanzscore(medians_rsoma_subjs_final_spaces_vec);
medians_fsoma_scored = nanzscore(medians_fsoma_subjs_final_spaces_vec);
medians_fsup_scored = nanzscore(medians_fsup_subjs_final_spaces_vec);
medians_fc_scored = nanzscore(medians_fsup_subjs_final_spaces_vec);
medians_energy_scored = nanzscore(medians_energy_vec);

means_pve_0_dwi_scored = nanzscore(means_pve_0_dwi_vec);
means_pve_2_dwi_scored = nanzscore(means_pve_2_dwi_vec);

medians_rsoma_scored_tr = medians_rsoma_scored';
medians_fsoma_scored_tr = medians_fsoma_scored';
medians_fsup_scored_tr = medians_fsup_scored';
medians_fc_scored_tr = medians_fc_scored';
medians_energy_scored_tr = medians_energy_scored';

means_pve_0_dwi_scored_tr = means_pve_0_dwi_scored';
means_pve_2_dwi_scored_tr = means_pve_2_dwi_scored';


%% using table

medians_invertedrsoma_scored_tr = 1./medians_rsoma_scored_tr;
tbl=table(medians_energy_scored_tr,medians_invertedrsoma_scored_tr,medians_rsoma_scored_tr,medians_fsoma_scored_tr,medians_fsup_scored_tr,medians_fc_scored_tr,means_pve_0_dwi_scored_tr,means_pve_2_dwi_scored_tr, 'VariableNames', ...
    {'CMRO2','invertedRsoma','Rsoma','fsoma','fsup','fc','pve_0_dwi','pve_2_dwi'});

%build your model
mdl=fitlm(tbl,'CMRO2 ~ Rsoma + fsoma  + pve_0_dwi + pve_2_dwi','RobustOpts','on')


%% calculate the scale out cmro2 (III method)
% and then rescale back to the original
% it's the method used for the article analysis

coeffs_mat=table2array(mdl.Coefficients);
estimate_pve_0=coeffs_mat(4,1);
estimate_pve_2=coeffs_mat(5,1);
estimate_fsoma = coeffs_mat(3,1);
% estimate_fsup = coeffs_mat(4,1);
%estimate_fc = coeffs_mat(5,1);

%regress out
y_pve_0_dwi = means_pve_0_dwi_scored.*estimate_pve_0;
y_pve_2_dwi = means_pve_2_dwi_scored.*estimate_pve_2;
y_fsoma = medians_fsoma_scored.*estimate_fsoma;
% y_fsup = medians_fsup_scored.*estimate_fsup;
%y_fc = medians_fc_scored.*estimate_fc;

cmro2_regressed_zscored = medians_energy_scored-y_pve_0_dwi-y_pve_2_dwi-y_fsoma;%-y_fsup;%-y_fc;

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

y=cmro2_regressed';
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
%text(10^5,100,txt,'FontWeight', 'Bold','FontSize',12);
%text(10^14,100,txt,'FontWeight', 'Bold','FontSize',12);
set(gcf,'position',[x0,y0,width,height]);
ylim([50,180]);
grid on


%% study of the cellular packaging (see christallography)
parameter_y = 'fsup';
parameter_x = 'Rsoma';

%%
% %build your model

if strcmp(parameter_y,'fsoma') && strcmp(parameter_x,'Rsoma')
 mdl_1=fitlm(tbl,'fsoma ~ Rsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
elseif strcmp(parameter_y,'fsup') && strcmp(parameter_x,'Rsoma')
 mdl_2=fitlm(tbl,'fsup ~ Rsoma + pve_0_dwi + pve_2_dwi','RobustOpts','on')
elseif strcmp(parameter_y,'Rsoma') && strcmp(parameter_x,'fsup')
 mdl_3=fitlm(tbl,'fsoma ~ fsup + pve_0_dwi + pve_2_dwi','RobustOpts','on')
end

 %% calculate the scale out cmro2 (III method)
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

y=parameter_regressed';

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



