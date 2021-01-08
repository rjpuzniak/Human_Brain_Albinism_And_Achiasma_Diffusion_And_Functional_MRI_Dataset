BL_data= # path to folder with BL data e.g. /path/to/folder/proj-5ddfa986936ca339b1c5f455
coeff_file= # path to file with the Legendre coefficients in spherical harmonics for respective gradient coil e.g /path/to/coeff/file/coeff.grad

cur=$(pwd)

cd $BL_data

for i in sub-*; do

	echo $i
	subj=${i:4:5}

	# Dive into target folder
	cd $i/dt-neuro-dwi*/	

	# Extract mean b0	
	dwiextract dwi.nii.gz -fslgrad dwi.bvecs dwi.bvals -bzero - | mrmath - mean mean_b0.nii.gz -axis 3

	# Run gradunwarp on b0
	gradient_unwarp.py mean_b0.nii.gz b0_unwarped.nii.gz siemens -g $coeff_file

	# Apply calculated warp field to all of the volumes
	applywarp -i dwi.nii.gz -o dwi_unwarped.nii.gz -r mean_b0.nii.gz -w fullWarp_abs.nii.gz --abs

	# Back to main folder
	cd ../..

done

cd $cur

