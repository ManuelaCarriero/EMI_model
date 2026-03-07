%% This programme analyze median regional values computed through the compute_medians.m code

%the analysis is CMRO2 vs one microstructural parameter at a time between 
%rsoma, fsoma, fsup and fs
%accordingly to which microstructural parameter has been chosen in
%compute_medians

%%

load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_medians_and_PVEmeans.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/V_atlas_glass.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_GMmedians.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/computed_GMPVEmeans.mat')
load('/home/c25078236/Desktop/saved_workspace/results_cubric/with_mse/251124/medians_CMRO2_GM_subjs.mat')

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
