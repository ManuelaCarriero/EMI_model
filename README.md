# EMI_model
This repository stores processing codes for the brain energy consumption vs microstructure project.

## HOW TO USE
git clone https://github.com/ManuelaCarriero/EMI_model/tree/main or download the repository.

## main "parts of the body of the project"

You must run programmes in the following order:

1. **compute_medians.m**: this programme computes medians of parametric maps and means of PVEs maps;
2. **select_medians.m**: this programme selects medians whose labels are survived between functional and diffusion spaces and among subjects;
3. **analyze_medians.m**: this programme makes all the statistical analysis, so it is divided in the following parts:
   * Analysis across regions:
       1. it computes the medians across subjects and removes the regions whose resulting values is nan;
       2. Computes GLM corrected for CSF and WM PVEs, with samples as the medias across subjects;
       3. GLM for each subject;
   * Analysis across subjects
       1. for each region;
       2. GLM considering GM medians of each subject as samples.
