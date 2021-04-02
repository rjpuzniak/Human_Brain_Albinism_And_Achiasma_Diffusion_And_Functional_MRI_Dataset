![Figure 7. Spherical Harmonics coefficients of Single Fiber Response function.](Fig5c_SFR.jpg)
__Figure 7. Spherical Harmonics coefficients of Single Fiber Response function.__ Values of the zero phase spherical harmonics (SH) coefficients of the Single Fiber Response (SFR) function. The y-axis depicts the value of given term, while the x-axis displays the even orders of SH coefficients (odd are equal to 0). SFR was calculated for a L<sub>max</sub>=6 for a single-shell data. The colors of markers and lines correspond to groups: control (yellow), albinism (magenta), achiasma (violet) and chiasma hypoplasia (blue).

### Reproducing the results
The SFR function was calculated with the `calculate_SFR.sh` script, which uses MRtrix functions `dwi2mask` and `dwi2response` in order to calculate the SFR for L<sub>max</sub>=6. The script's output is written to `SFR` folder and consists of 3 files. Specifically, in exemplary case of participant EXAMPLE1, the script will generate:
- file `SFR/EXAMPLE1_SFR.txt`, which contains the SH coefficients.
- fife `SFR/EXAMPLE1/EXAMPLE1_mask.nii.gz`, which contains a mask output by `dwi2mask` function, used in calculation of SFR from DWI data.
- file `SFR/EXAMPLE1/EXAMPLE1_voxels.nii.gz`, which marks the selection of voxels determined by algorithm to be containing only single fibre population and which were chosen for the purpose of SFR estimation.


