#!/bin/bash
bl login

project_id=5ddfa986936ca339b1c5f455

chiasma_hypoplasia=(X)
achiasma=(X)
albinism=(X X X X X X X X X)
controls=(X X X X X X X X)

rois_folder=/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA

bl_folder=/home/auguser2016/Projects/02_Scientific_Data/proj-5ddfa986936ca339b1c5f455

uploading_folder=/home/auguser2016/Projects/02_Scientific_Data/QForm_SForm_ROIs

# Chiasma hypoplasia

for i in ${!chiasma_hypoplasia[@]}; do

	subj_MD="${chiasma_hypoplasia[$i]}"
	subj_BL=CHP$((i+1))

	mkdir Tmp/${subj_BL} -p

	### WM mask

	# Copy WM mask
	mrconvert /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/5TTs_ACPC_Aligned_Chiasm_T1_Corrected/$subj_MD\_t1_acpc_5tt_corrected.nii.gz -coord 3 2 Tmp/${subj_BL}/$subj_BL\_mask.nii.gz -set_property comments ${subj_BL}

	# Align the mask to T1w
	flirt -in Tmp/${subj_BL}/$subj_BL\_mask.nii.gz -ref $bl_folder/sub-${subj_BL}/t1w.nii.gz -out Tmp/${subj_BL}/$subj_BL\_mask_aligned.nii.gz

	# Set comments	
	mrconvert Tmp/${subj_BL}/$subj_BL\_mask_aligned.nii.gz -set_property comments ${subj_BL} Tmp/${subj_BL}/$subj_BL\_mask_aligned_commented.nii.gz

	# Upload
	bl dataset upload --mask Tmp/${subj_BL}/$subj_BL\_mask_aligned_commented.nii.gz \
	--project $project_id \
	--datatype neuro/mask \
	--subject $subj_BL \
	--desc 'Chiasma hypoplasia, white matter mask with manually corrected optic chiasm' \
	--tag  'chiasma_hypoplasia'

	# ROIs

	mkdir Tmp/${subj_BL}/tmp/rois -p

	# Copy ROIs
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_el.mif Tmp/${subj_BL}/$subj_BL\_left_OT.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_er.mif Tmp/${subj_BL}/$subj_BL\_right_OT.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_sl.mif Tmp/${subj_BL}/$subj_BL\_left_ON.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_sr.mif Tmp/${subj_BL}/$subj_BL\_right_ON.nii

	# Align ROIs
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_right_OT.nii Tmp/${subj_BL}/$subj_BL\_right_OT_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_left_OT.nii Tmp/${subj_BL}/$subj_BL\_left_OT_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_right_ON.nii Tmp/${subj_BL}/$subj_BL\_right_ON_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_left_ON.nii Tmp/${subj_BL}/$subj_BL\_left_ON_aligned.nii.gz
	
	# Set comments
	mrthreshold Tmp/${subj_BL}/$subj_BL\_left_ON_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_left_ON.nii.gz
	mrthreshold  Tmp/${subj_BL}/$subj_BL\_right_ON_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_right_ON.nii.gz
	mrthreshold  Tmp/${subj_BL}/$subj_BL\_left_OT_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_left_OT.nii.gz
	mrthreshold Tmp/${subj_BL}/$subj_BL\_right_OT_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_right_OT.nii.gz

	# Upload
	bl dataset upload --rois Tmp/${subj_BL}/tmp/rois \
	--project $project_id \
	--datatype neuro/rois \
	--datatype_tag 'aligned' \
	--subject $subj_BL \
	--desc 'Chiasma hypoplasia, set of ROIs covering coronal intersections of optic nerves (ON) and optic tracts (OT)' \
	--tag  'chiasma_hypoplasia' \
	--force

	# Remove the Tmp folder
	rm -r Tmp/${subj_BL}

done


# Achiasma

for i in ${!achiasma[@]}; do

	subj_MD="${achiasma[$i]}"
	subj_BL=ACH$((i+1))

	mkdir Tmp/${subj_BL} -p

	### WM mask

	# Copy WM mask
	mrconvert /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/5TTs_ACPC_Aligned_Chiasm_T1_Corrected/$subj_MD\_t1_acpc_5tt_corrected.nii.gz -coord 3 2 Tmp/${subj_BL}/$subj_BL\_mask.nii.gz -set_property comments ${subj_BL}

	# Align the mask to T1w
	flirt -in Tmp/${subj_BL}/$subj_BL\_mask.nii.gz -ref $bl_folder/sub-${subj_BL}/t1w.nii.gz -out Tmp/${subj_BL}/$subj_BL\_mask_aligned.nii.gz

	# Set comments	
	mrconvert Tmp/${subj_BL}/$subj_BL\_mask_aligned.nii.gz -set_property comments ${subj_BL} Tmp/${subj_BL}/$subj_BL\_mask_aligned_commented.nii.gz

	# Upload
	bl dataset upload --mask Tmp/${subj_BL}/$subj_BL\_mask_aligned_commented.nii.gz \
	--project $project_id \
	--datatype neuro/mask \
	--subject $subj_BL \
	--desc 'Achiasma, white matter mask with manually corrected optic chiasm' \
	--tag  'achiasma'

	# ROIs

	mkdir Tmp/${subj_BL}/tmp/rois -p

	# Copy ROIs
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_el.mif Tmp/${subj_BL}/$subj_BL\_left_OT.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_er.mif Tmp/${subj_BL}/$subj_BL\_right_OT.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_sl.mif Tmp/${subj_BL}/$subj_BL\_left_ON.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_sr.mif Tmp/${subj_BL}/$subj_BL\_right_ON.nii

	# Align ROIs
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_right_OT.nii Tmp/${subj_BL}/$subj_BL\_right_OT_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_left_OT.nii Tmp/${subj_BL}/$subj_BL\_left_OT_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_right_ON.nii Tmp/${subj_BL}/$subj_BL\_right_ON_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_left_ON.nii Tmp/${subj_BL}/$subj_BL\_left_ON_aligned.nii.gz
	
	# Set comments
	mrthreshold Tmp/${subj_BL}/$subj_BL\_left_ON_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_left_ON.nii.gz
	mrthreshold  Tmp/${subj_BL}/$subj_BL\_right_ON_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_right_ON.nii.gz
	mrthreshold  Tmp/${subj_BL}/$subj_BL\_left_OT_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_left_OT.nii.gz
	mrthreshold Tmp/${subj_BL}/$subj_BL\_right_OT_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_right_OT.nii.gz

	# Upload
	bl dataset upload --rois Tmp/${subj_BL}/tmp/rois \
	--project $project_id \
	--datatype neuro/rois \
	--datatype_tag 'aligned' \
	--subject $subj_BL \
	--desc 'Achiasma, set of ROIs covering coronal intersections of optic nerves (ON) and optic tracts (OT)' \
	--tag  'achiasma' \
	--force

	# Remove the Tmp folder
	rm -r Tmp/${subj_BL}

done

# Albinism

for i in ${!albinism[@]}; do

	subj_MD="${albinism[$i]}"
	subj_BL=ALB$((i+1))

	mkdir Tmp/${subj_BL} -p

	### WM mask

	# Copy WM mask
	mrconvert /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/5TTs_ACPC_Aligned_Chiasm_T1_Corrected/$subj_MD\_t1_acpc_5tt_corrected.nii.gz -coord 3 2 Tmp/${subj_BL}/$subj_BL\_mask.nii.gz -set_property comments ${subj_BL}

	# Align the mask to T1w
	flirt -in Tmp/${subj_BL}/$subj_BL\_mask.nii.gz -ref $bl_folder/sub-${subj_BL}/t1w.nii.gz -out Tmp/${subj_BL}/$subj_BL\_mask_aligned.nii.gz

	# Set comments	
	mrconvert Tmp/${subj_BL}/$subj_BL\_mask_aligned.nii.gz -set_property comments ${subj_BL} Tmp/${subj_BL}/$subj_BL\_mask_aligned_commented.nii.gz

	# Upload
	bl dataset upload --mask Tmp/${subj_BL}/$subj_BL\_mask_aligned_commented.nii.gz \
	--project $project_id \
	--datatype neuro/mask \
	--subject $subj_BL \
	--desc 'Albinism, white matter mask with manually corrected optic chiasm' \
	--tag  'albinism'

	# ROIs

	mkdir Tmp/${subj_BL}/tmp/rois -p

	# Copy ROIs
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_el.mif Tmp/${subj_BL}/$subj_BL\_left_OT.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_er.mif Tmp/${subj_BL}/$subj_BL\_right_OT.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_sl.mif Tmp/${subj_BL}/$subj_BL\_left_ON.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_sr.mif Tmp/${subj_BL}/$subj_BL\_right_ON.nii

	# Align ROIs
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_right_OT.nii Tmp/${subj_BL}/$subj_BL\_right_OT_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_left_OT.nii Tmp/${subj_BL}/$subj_BL\_left_OT_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_right_ON.nii Tmp/${subj_BL}/$subj_BL\_right_ON_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_left_ON.nii Tmp/${subj_BL}/$subj_BL\_left_ON_aligned.nii.gz
	
	# Set comments
	mrthreshold Tmp/${subj_BL}/$subj_BL\_left_ON_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_left_ON.nii.gz
	mrthreshold  Tmp/${subj_BL}/$subj_BL\_right_ON_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_right_ON.nii.gz
	mrthreshold  Tmp/${subj_BL}/$subj_BL\_left_OT_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_left_OT.nii.gz
	mrthreshold Tmp/${subj_BL}/$subj_BL\_right_OT_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_right_OT.nii.gz

	# Upload
	bl dataset upload --rois Tmp/${subj_BL}/tmp/rois \
	--project $project_id \
	--datatype neuro/rois \
	--datatype_tag 'aligned' \
	--subject $subj_BL \
	--desc 'Albinism, set of ROIs covering coronal intersections of optic nerves (ON) and optic tracts (OT)' \
	--tag  'albinism' \
	--force

	# Remove the Tmp folder
	rm -r Tmp/${subj_BL}

done

# Controls

for i in ${!controls[@]}; do

	subj_MD="${controls[$i]}"
	subj_BL=CON$((i+1))

	mkdir Tmp/${subj_BL} -p

	### WM mask

	# Copy WM mask
	mrconvert /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/5TTs_ACPC_Aligned_Chiasm_T1_Corrected/$subj_MD\_t1_acpc_5tt_corrected.nii.gz -coord 3 2 Tmp/${subj_BL}/$subj_BL\_mask.nii.gz -set_property comments ${subj_BL}

	# Align the mask to T1w
	flirt -in Tmp/${subj_BL}/$subj_BL\_mask.nii.gz -ref $bl_folder/sub-${subj_BL}/t1w.nii.gz -out Tmp/${subj_BL}/$subj_BL\_mask_aligned.nii.gz

	# Set comments	
	mrconvert Tmp/${subj_BL}/$subj_BL\_mask_aligned.nii.gz -set_property comments ${subj_BL} Tmp/${subj_BL}/$subj_BL\_mask_aligned_commented.nii.gz

	# Upload
	bl dataset upload --mask Tmp/${subj_BL}/$subj_BL\_mask_aligned_commented.nii.gz \
	--project $project_id \
	--datatype neuro/mask \
	--subject $subj_BL \
	--desc 'Control, white matter mask with manually corrected optic chiasm' \
	--tag  'control'

	# ROIs

	mkdir Tmp/${subj_BL}/tmp/rois -p

	# Copy ROIs
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_el.mif Tmp/${subj_BL}/$subj_BL\_left_OT.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_er.mif Tmp/${subj_BL}/$subj_BL\_right_OT.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_sl.mif Tmp/${subj_BL}/$subj_BL\_left_ON.nii
	mrconvert $rois_folder/Optic_Chiasm_ROIs/$subj_MD/$subj_MD\_sr.mif Tmp/${subj_BL}/$subj_BL\_right_ON.nii

	# Align ROIs
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_right_OT.nii Tmp/${subj_BL}/$subj_BL\_right_OT_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_left_OT.nii Tmp/${subj_BL}/$subj_BL\_left_OT_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_right_ON.nii Tmp/${subj_BL}/$subj_BL\_right_ON_aligned.nii.gz
	mrtransform -template $bl_folder/sub-${subj_BL}/t1w.nii.gz Tmp/${subj_BL}/$subj_BL\_left_ON.nii Tmp/${subj_BL}/$subj_BL\_left_ON_aligned.nii.gz
	
	# Set comments
	mrthreshold Tmp/${subj_BL}/$subj_BL\_left_ON_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_left_ON.nii.gz
	mrthreshold  Tmp/${subj_BL}/$subj_BL\_right_ON_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_right_ON.nii.gz
	mrthreshold  Tmp/${subj_BL}/$subj_BL\_left_OT_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_left_OT.nii.gz
	mrthreshold Tmp/${subj_BL}/$subj_BL\_right_OT_aligned.nii.gz - | mrconvert - -set_property comments ${subj_BL} Tmp/${subj_BL}/tmp/rois/$subj_BL\_right_OT.nii.gz

	# Upload
	bl dataset upload --rois Tmp/${subj_BL}/tmp/rois \
	--project $project_id \
	--datatype neuro/rois \
	--datatype_tag 'aligned' \
	--subject $subj_BL \
	--desc 'Control, set of ROIs covering coronal intersections of optic nerves (ON) and optic tracts (OT)' \
	--tag  'control' \
	--force

	# Remove the Tmp folder
	rm -r Tmp/${subj_BL}

done

: <<'END'

END
