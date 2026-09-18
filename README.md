# EMI_model
This repository stores processing codes for the brain energy consumption vs microstructure project.

## HOW TO USE
git clone https://github.com/ManuelaCarriero/EMI_model/tree/main or download the repository.

## main parts

You must run programmes in the following order:

1. **compute_medians.m**: this programme computes medians of parametric maps and means of PVEs maps; it needs as INPUTS: PVE maps in dwi and functional spaces; atlas in dwi and functional spaces; CMRO2 parametric maps; all SANDI parametric maps; MSE SANDI parametric map.
2. **select_medians.m**: this programme selects medians whose labels are survived between functional and diffusion spaces and among subjects. Run this programme after the compute_medians.m run.
3. **analyze_medians.m**: this programme makes all the statistical analysis, so it is divided in the following parts:
   * Analysis across regions:
       1. it computes the medians across subjects and removes the regions whose resulting values is nan;
       2. Computes GLM corrected for CSF and WM PVEs, with samples as the medias across subjects;
       3. GLM for each subject;
   * Analysis across subjects
       1. for each region: it computes the brain correlation map (i.e. correlation value for each brain region);
       2. GLM considering GM medians of each subject as samples.
4. **analyze_subset_of_medians.m**: this programme does the same job of analyze_medians.m, but applied only to cortical or subcortical regions.
5. **analyze_medians_partII.m**: this programme makes the analysis to investigate the relationships between soma density parameters.
6. **collocate_medians**.
7. **plot_MRI_maps.py**.
