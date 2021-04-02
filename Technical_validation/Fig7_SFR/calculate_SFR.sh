# Initialize input folders, create and set output folders
main_folder=$(pwd) # Path to folder where the output SFR files are written
data_folder=/home/rjp/1_OVGU/0_MRI_Data/1_Old_protocol/proj-5ddfa986936ca339b1c5f455 # Path to folder with BL data

for i in $data_folder/sub-ALB1; do

	subj=${i: -4}
	echo $subj

	mkdir $main_folder/SFR/${subj}

	# Create mask
	dwi2mask ${i}/*dwi.tag-clean*/dwi.nii.gz -fslgrad ${i}/*dwi.tag-clean*/dwi.bvecs ${i}/*dwi.tag-clean*/dwi.bvals $main_folder/SFR/${subj}/${subj}_mask.nii.gz

	# Estimate SFR
	dwi2response tournier -lmax 6 ${i}/*dwi.tag-clean*/dwi.nii.gz -fslgrad ${i}/*dwi.tag-clean*/dwi.bvecs ${i}/*dwi.tag-clean*/dwi.bvals $main_folder/SFR/${subj}_SFR.txt -voxels $main_folder/SFR/${subj}/${subj}_voxels.nii.gz -mask $main_folder/SFR/${subj}/${subj}_mask.nii.gz -force
	
	
done


