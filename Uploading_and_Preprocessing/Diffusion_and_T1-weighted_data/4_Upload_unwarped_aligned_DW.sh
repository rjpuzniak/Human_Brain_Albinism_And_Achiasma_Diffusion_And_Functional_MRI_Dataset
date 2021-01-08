#!/bin/bash
bl login

project_id=5ddfa986936ca339b1c5f455

subjects='CHP1 ACH1 CON1 CON2 CON3 CON4 CON5 CON6 CON7 CON8 ALB1 ALB2 ALB3 ALB4 ALB5 ALB6 ALB7 ALB8 ALB9'

core_data= # path to folder with BL data e.g. /path/to/folder/proj-5ddfa986936ca339b1c5f455

for i in $subjects; do
	echo $i

	# Find the matching group
 	if [ ${i::-1} = 'ACH' ]; then
		group='achiasma'
	elif [ ${i::-1} = 'CON' ]; then
		group='control'
	elif [ ${i::-1} = 'ALB' ]; then
		group='albinism'
	elif [ ${i::-1} = 'CHP' ]; then
		group='chiasma_hypoplasia'
	fi

 	if [ ${i::-1} = 'ACH' ]; then
		Group='Achiasma'
	elif [ ${i::-1} = 'CON' ]; then
		Group='Control'
	elif [ ${i::-1} = 'ALB' ]; then
		Group='Albinism'
	elif [ ${i::-1} = 'CHP' ]; then
		Group='Chiasma_hypoplasia'	
	fi

	echo $group

	# Adjust comment
	mrconvert -set_property comments $group $core_data/sub-${i}/dwi_unwarped_aligned_resized.nii.gz $core_data/sub-${i}/dwi_unwarped_aligned_resized_comment.nii.gz

	dwi=$core_data/sub-${i}/dwi_unwarped_aligned_resized_comment.nii.gz
	bvecs=$core_data/sub-${i}/bvecs_aligned.bvecs
	bvals=$core_data/sub-${i}/dt-neuro-dwi*/dwi.bvals
	#json=$core_data/sub-${i}/dt-neuro-dwi*/_info.json

	# Upload corrected version
	bl dataset upload \
	--dwi $dwi \
	--bvecs $bvecs \
	--bvals $bvals \
	--project $project_id \
	--datatype neuro/dwi \
	--datatype_tag 'clean' \
	--datatype_tag 'AC-PC aligned' \
	--subject $i \
 	--tag $group \
	--desc $Group', fully preprocessed DW series  with mrtrix3-preproc BL app (online), corrected for gradient nonlinearity distortions (using gradunwarp tool; offline) and aligned to T1w image (using epi_reg and flirt commands; offline).'
	
	
done


: <<'END'
END
