# -*- coding: utf-8 -*-
"""
Created on Thu Jun 18 14:57:49 2026

@author: Nicola
"""

import imageio
import scipy.ndimage as ndi
import scipy.stats
import nibabel as nib
import numpy as np
import matplotlib.pyplot as plt

import nilearn
from nilearn import plotting
import matplotlib.ticker as ticker

"""
img_1 = nib.load('median_cmro2.nii.gz')
img_2 = nib.load('MNI152_T1_2mm_brain.nii.gz')
# Quick plot to check data
plotting.plot_img(img_1, title='MRI NIfTI Map')
plotting.plot_img(img_2, title='MRI NIfTI Map')
plotting.show()

# Detailed orthographic view
#plotting.plot_ortho_cutout(img, title='Ortho View')
#plotting.show()
"""


# Load nifti
# nii = nib.load('MNI152_T1_2mm_brain.nii.gz')
# data_t1 = nii.get_fdata()

nii = nib.load('median_cmro2.nii.gz')
data_cmro2 = nii.get_fdata()

nii = nib.load('median_fsoma.nii.gz')
data_fsoma = nii.get_fdata()

nii = nib.load('median_fsup.nii.gz')
data_fsup = nii.get_fdata()
data_fsup[np.isnan(data_fsup)]=0

nii = nib.load('median_fc.nii.gz')
data_fc = nii.get_fdata()
data_fc[np.isnan(data_fc)]=0

nii = nib.load('median_Rsoma.nii.gz')
data_rsoma = nii.get_fdata()
data_rsoma[np.isnan(data_rsoma)]=0

'''
# Select a slice (e.g., in the middle of the 3rd dimension)
slice_idx = data.shape[2] // 2
plt.imshow(np.rot90(data[:, slice_idx, :]), cmap='gray')
plt.title(f'Axial Slice {slice_idx}')
plt.axis('off')
plt.show()
'''

def fmt_fsup(x, pos):
    a, b = '{:.1e}'.format(x).split('e')
    b = int(b)
    if b==0:
        return '0'
    else:
        return r'${} \cdot 10^{{{}}}$'.format(a, b)
    
def fmt(x, pos):
    a, b = '{:.0e}'.format(x).split('e')
    b = int(b)
    if b==0:
        return '0'
    else:
        return r'${} \cdot 10^{{{}}}$'.format(a, b)





fig, axis = plt.subplots(nrows=3, ncols=5, figsize=(37,15))

slice_idx = data_cmro2.shape[2] // 2

#ax00=axis[0,0].imshow(np.rot90(data_t1[:, :, slice_idx]), cmap='gray')
#axis[0,0].axes.xaxis.set_ticks([])
#axis[0,0].axes.yaxis.set_ticks([])
#axis[1,0].imshow(np.rot90(data_t1[slice_idx, :, :]), cmap='gray')
#axis[1,0].axes.xaxis.set_ticks([])
#axis[1,0].axes.yaxis.set_ticks([])
#axis[2,0].imshow(np.rot90(data_t1[:, slice_idx, :]), cmap='gray')
#axis[2,0].axes.xaxis.set_ticks([])
#axis[2,0].axes.yaxis.set_ticks([])
#axis[0,0].axes.set_title('T1w',{'fontsize': 'large',
# 'fontweight' : 'bold',
# 'verticalalignment': 'baseline',
# 'horizontalalignment': 'center'})
#cbar=fig.colorbar(ax00,ax=axis[:,0], orientation='vertical', shrink=0.5,fraction=.1,format=ticker.FuncFormatter(fmt))

# Source - https://stackoverflow.com/a/35728847
# Posted by GWW, modified by community. See post 'Timeline' for change history
# Retrieved 2026-02-15, License - CC BY-SA 3.0

#cbar.ax.set_yticklabels(['{:e}'.format(x) for x in cbar.ax.yaxis.get_ticklabels()], fontsize=16, weight='bold')
#for l in cbar.ax.yaxis.get_ticklabels():
#    l.set_weight("bold")
#    l.set_fontsize(16)
#    '{:e}'.format(l)

ax00=axis[0,0].imshow(np.rot90(data_cmro2[:, :, slice_idx]), cmap='jet',vmin=0,vmax=200)
axis[0,0].axes.xaxis.set_ticks([])
axis[0,0].axes.yaxis.set_ticks([])
axis[1,0].imshow(np.rot90(data_cmro2[slice_idx, :, :]), cmap='jet')
axis[1,0].axes.xaxis.set_ticks([])
axis[1,0].axes.yaxis.set_ticks([])
axis[2,0].imshow(np.rot90(data_cmro2[:, slice_idx, :]), cmap='jet')
axis[2,0].axes.xaxis.set_ticks([])
axis[2,0].axes.yaxis.set_ticks([])
# axis[0,0].axes.set_title(r'CMRO$_{\rm \bf{2}}$',{'fontsize': 'large',
#  'fontweight' : 'bold',
#  'verticalalignment': 'baseline',
#  'horizontalalignment': 'center'})
cbar=fig.colorbar(ax00,ax=axis[:,0], orientation='vertical',fraction=.05)#, shrink=0.5
#ax01.figure.tick_params(labelsize=18)
#cbar.set_label('\mu mol/100g/min',rotation=270,fontweight='bold',loc='top')#LABELLLLL
#cbar.ax.xaxis.set_tick_params(pad=100)
#cbar.ax.set_yticklabels(['{:3}'.format(x) for x in cbar.ax.yaxis.get_ticklabels()], fontsize=16, weight='bold')
for l in cbar.ax.yaxis.get_ticklabels():
 #   l.set_weight("bold")
    l.set_fontsize(20)
    #'{:e}'.format(l)

ax01=axis[0,1].imshow(np.rot90(data_rsoma[:, :, slice_idx]), cmap='jet',vmin=4,vmax=10)
axis[0,1].axes.xaxis.set_ticks([])
axis[0,1].axes.yaxis.set_ticks([])
axis[1,1].imshow(np.rot90(data_rsoma[slice_idx, :, :]), cmap='jet',vmin=4,vmax=10)
axis[1,1].axes.xaxis.set_ticks([])
axis[1,1].axes.yaxis.set_ticks([])
axis[2,1].imshow(np.rot90(data_rsoma[:, slice_idx, :]), cmap='jet',vmin=4,vmax=10)
axis[2,1].axes.xaxis.set_ticks([])
axis[2,1].axes.yaxis.set_ticks([])
# axis[0,1].axes.set_title(r'SAD',{'fontsize': 'large',
#  'fontweight' : 'bold',
#  'verticalalignment': 'baseline',
#  'horizontalalignment': 'center'})
cbar=fig.colorbar(ax01,ax=axis[:,1], orientation='vertical',fraction=.05)#,format=ticker.FuncFormatter(fmt), shrink=0.5
for l in cbar.ax.yaxis.get_ticklabels():
  #  l.set_weight("bold")
    l.set_fontsize(20)


ax02=axis[0,2].imshow(np.rot90(data_fsoma[:, :, slice_idx]), cmap='jet')
axis[0,2].axes.xaxis.set_ticks([])
axis[0,2].axes.yaxis.set_ticks([])
axis[1,2].imshow(np.rot90(data_fsoma[slice_idx, :, :]), cmap='jet')
axis[1,2].axes.xaxis.set_ticks([])
axis[1,2].axes.yaxis.set_ticks([])
axis[2,2].imshow(np.rot90(data_fsoma[:, slice_idx, :]), cmap='jet')
axis[2,2].axes.xaxis.set_ticks([])
axis[2,2].axes.yaxis.set_ticks([])
# axis[0,2].axes.set_title(r'NAD',{'fontsize': 'large',
#  'fontweight' : 'bold',
#  'verticalalignment': 'baseline',
#  'horizontalalignment': 'center'})
cbar=fig.colorbar(ax02,ax=axis[:,2], orientation='vertical',fraction=.05)#,format=ticker.FuncFormatter(fmt), shrink=0.5
for l in cbar.ax.yaxis.get_ticklabels():
  #  l.set_weight("bold")
    l.set_fontsize(20)


ax03=axis[0,3].imshow(np.rot90(data_fsup[:, :, slice_idx]), cmap='jet')
axis[0,3].axes.xaxis.set_ticks([])
axis[0,3].axes.yaxis.set_ticks([])
axis[1,3].imshow(np.rot90(data_fsup[slice_idx, :, :]), cmap='jet')
axis[1,3].axes.xaxis.set_ticks([])
axis[1,3].axes.yaxis.set_ticks([])
axis[2,3].imshow(np.rot90(data_fsup[:, slice_idx, :]), cmap='jet')
axis[2,3].axes.xaxis.set_ticks([])
axis[2,3].axes.yaxis.set_ticks([])
# axis[0,3].axes.set_title(r'r$_{\rm \bf{s}}$',{'fontsize': 'large',
#  'fontweight' : 'bold',
#  'verticalalignment': 'baseline',
#  'horizontalalignment': 'center'})
cbar=fig.colorbar(ax03,ax=axis[:,3], orientation='vertical',fraction=.05,format=ticker.FuncFormatter(fmt_fsup))#,format=ticker.FuncFormatter(fmt)
for l in cbar.ax.yaxis.get_ticklabels():
  #  l.set_weight("bold")
    l.set_fontsize(19)


ax04=axis[0,4].imshow(np.rot90(data_fc[:, :, slice_idx]), cmap='jet',vmin=0*10**(14),vmax=5*10**(5))
axis[0,4].axes.xaxis.set_ticks([])
axis[0,4].axes.yaxis.set_ticks([])
axis[1,4].imshow(np.rot90(data_fc[slice_idx, :, :]), cmap='jet',vmin=0*10**(14),vmax=5*10**(5))
axis[1,4].axes.xaxis.set_ticks([])
axis[1,4].axes.yaxis.set_ticks([])
axis[2,4].imshow(np.rot90(data_fc[:, slice_idx, :]), cmap='jet',vmin=0*10**(14),vmax=5*10**(5))
axis[2,4].axes.xaxis.set_ticks([])
axis[2,4].axes.yaxis.set_ticks([])
# axis[0,4].axes.set_title(r'f$_{\rm \bf{s}}$',{'fontsize': 'large',
#  'fontweight' : 'bold',
#  'verticalalignment': 'baseline',
#  'horizontalalignment': 'center'})
cbar=fig.colorbar(ax04,ax=axis[:,4], orientation='vertical',fraction=.05,format=ticker.FuncFormatter(fmt))#,format=ticker.FuncFormatter(fmt) , shrink=0.5
for l in cbar.ax.yaxis.get_ticklabels():
  #  l.set_weight("bold")
    l.set_fontsize(19)


plt.show()
fig.savefig("all_MRIparametric_maps_withoutT1.svg",format="svg")

#%%


# Plot orthographic slices (x, y, z) with a customized colormap and threshold
display = plotting.plot_stat_map(
    stat_map_img="median_cmro2.nii.gz",
    bg_img="MNI152_T1_2mm_brain.nii.gz", # Optional, uses MNI152 if None
    threshold=None, # Set to your desired minimum value to hide noise
    cmap="viridis", # A good default for continuous parametric maps
    display_mode="ortho",
    colorbar=False
)

#%%
plt.rcParams.update({'font.weight':'bold'})

fig=plotting.plot_img("median_cmro2.nii.gz",black_bg=True,colorbar=True,cmap='inferno',cbar_tick_format=ticker.FuncFormatter(fmt),draw_cross=False,cut_coords= [5, -26, 35],title="$CMRO_{2}$")
fig.savefig("CMRO2.svg",dpi=600)
# display.title(size=26)

fig=plotting.plot_img("median_Rsoma.nii.gz",black_bg=True,colorbar=True,cmap='nipy_spectral',draw_cross=False,cut_coords= [5, -26, 35],vmin=6,vmax=10,title="$R_{soma}$")
fig.savefig("Rsoma.svg",dpi=600)

fig=plotting.plot_img("median_fsoma.nii.gz",black_bg=True,colorbar=True,cmap='gnuplot',draw_cross=False,cut_coords= [5, -26, 35],title='$f_{soma}$')
fig.savefig("fsoma.svg",dpi=600)

fig=plotting.plot_img("median_fsup.nii.gz",black_bg=True,colorbar=True,cmap='gnuplot2',cbar_tick_format=ticker.FuncFormatter(fmt),draw_cross=False,cut_coords= [5, -26, 35],vmax=210,title='SAD')
fig.savefig("SAD.svg",dpi=600)

fig=plotting.plot_img("median_fc.nii.gz",black_bg=True,colorbar=True,cmap='cubehelix',cbar_tick_format=ticker.FuncFormatter(fmt),draw_cross=False,cut_coords= [5, -26, 35],vmin=2*10**4,vmax=0.2*10**6,title='ND')
fig.savefig("ND.svg",dpi=600)

#%%

plotting.plot_stat_map("median_cmro2.nii.gz",display_mode='z')

plotting.plot_prob_atlas("median_cmro2.nii.gz")

#%%
import pylab as pl
import numpy as np

plt.style.use('dark_background')

a = np.array([[0,1]])
fig=pl.figure(figsize=(1.5, 9))
img = pl.imshow(a, cmap="nipy_spectral")
pl.gca().set_visible(False)
cax = pl.axes([0.1, 0.2, 0.8, 0.6])
cbar=pl.colorbar(orientation="vertical", cax=cax)
cbar.set_ticks([])
fig.savefig("nipyspectral_colorbar.svg",dpi=600)