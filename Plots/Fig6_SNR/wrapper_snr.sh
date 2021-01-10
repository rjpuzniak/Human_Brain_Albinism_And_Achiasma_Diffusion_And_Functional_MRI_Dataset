data=/home/rjp/1_OVGU/3_Data_publication/Clean_data

list='CON_1 CON_2 CON_3 CON_4 CON_5 CON_6 CON_7 CON_8 ALB_1 ALB_2 ALB_3 ALB_4 ALB_5 ALB_6 ALB_7 ALB_8 ALB_9 ACH_1 ACH_2 '

cur_path=$(pwd)

for i in $list; do

	subj=${i}

	cd $data/sub-${subj}/dt-neuro-dwi*/
	path=$(pwd)

	dwi=$path/dwi.nii.gz
	bvecs=$path/dwi.bvecs
	bvals=$path/dwi.bvals
	oc_mask=/home/rjp/3_Github/Optic_Chiasm/Data/4_Manual_targets/OVGU_manual_original/${subj}_wm_in_chiasm.nii.gz

	cd $cur_path

	python snr_in_oc.py "$dwi" "$bvals" "$bvecs" $oc_mask $subj

done 



