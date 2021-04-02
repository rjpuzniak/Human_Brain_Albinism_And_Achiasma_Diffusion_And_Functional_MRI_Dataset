### Diffusion- and T1-weighted data 

This folder contains file related to offline preprocessing and uploading DW and T1w files. The contents are, specifically:
- `1_Upload_raw_DW_T1w` - uploading raw DW and T1w data. Please not that prior to uploading, T1w data was anonymized by removal of facial features with `mri_deface` script.
- `2_Apply_GNC` - application of gradient nonlinearity distortions correction to post-eddy DW images. This step generally requires [gradunwarp package](https://github.com/Washington-University/gradunwarp) and a file with Legendre coefficients in spherical harmonics for respective gradient coil, specific to scanner (provided in this folder as `coeff.grad`).
- `3_Align_DW_to_T1w` - alignment of DW image to T1w (which also incorporates respective transformation of b-vectors, using the [code from Human Connectome Project repository](https://github.com/Washington-University/HCPpipelines/blob/master/global/scripts/Rotate_bvecs.sh))
- `4_Upload_unwarped_aligned_DW` - re-uploads DW, subjected to correction of gradient nonlinearity distortions and alignement to T1w space.
- `coeff.grad` - a file with Legendre coefficients in spherical harmonics for  gradient coil used in the data acquisition, which is required for correction of gradient nonlinearity distortions.

