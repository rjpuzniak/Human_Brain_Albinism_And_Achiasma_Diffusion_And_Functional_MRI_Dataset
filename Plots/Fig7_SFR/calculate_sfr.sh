# Initialize input folders, create and set output folders
main_folder=/home/rjp/1_OVGU/3_Data_publication/2_SFR
data_folder=/home/rjp/1_OVGU/3_Data_publication/Clean_data

mkdir $main_folder/SFR/tmp -p

for i in $data_folder/sub*; do

	subj=${i:51:5}
	echo $subj

	mkdir $main_folder/SFR/${subj}

	# Create mask
	#dwi2mask ${i}/*/dwi.nii.gz -fslgrad ${i}/*/dwi.bvecs ${i}/*/dwi.bvals $main_folder/SFR/${subj}/${subj}_mask.nii.gz

	# Estimate SFR
	dwi2response tournier -lmax 6 ${i}/*/dwi.nii.gz -fslgrad ${i}/*/dwi.bvecs ${i}/*/dwi.bvals $main_folder/SFR/${subj}_SFR.txt -voxels $main_folder/SFR/${subj}/${subj}_voxels.nii.gz -mask $main_folder/SFR/${subj}/${subj}_mask.nii.gz -force
	
	
done


