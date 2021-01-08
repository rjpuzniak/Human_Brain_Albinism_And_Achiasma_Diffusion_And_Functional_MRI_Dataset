#!/bin/bash
bl login

project_id=5ddfa986936ca339b1c5f455

albinism='X X X X X X' 

# Extract runs
: <<'END'
for i in $albinism; do

	# Untar the file
	tar -xvf ${i}*2533.tar

	# Change privelleges
	sudo chmod -R 777 ${i}_????

	# Create subfolder for the extracted runs
	cd ${i}_????
	mkdir Extracted_runs

	# Extract data from DICOMS using dcm2niix
	for j in */series*run?; do

		dcm2niix -b y -ba y -z y -o Extracted_runs/ ${j}

	done

	cd ..


done

END


# Upload retinotopic data
MD='X X X X'
BL='ALB1 ALB7 ALB8 ALB9'

MD_list=($MD)
BL_list=($BL)

# Upload the data to BL
for i in $(seq 0 3); do
	
	subj_MD=${MD_list[i]}
	subj_BL=${BL_list[i]}

	cd ${subj_MD}_????/Extracted_runs

	# Right visual field
	runs_r='4 7 8'

	for j in $runs_r; do

		bl dataset upload \
		--bold fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.nii.gz \
		--meta fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.json \
		--project $project_id \
		--datatype neuro/func/task \
		--datatype_tag 'raw' \
		--datatype_tag 'retinotopy' \
		--subject $subj_BL \
		--desc 'BOLD response to right visual hemifield stimulation' \
		--tag 'albinism' \
		--tag 'right_VF' \
		--tag 'run-'$j


	done

	# Left visual field
	runs_r='5 6 9'

	for j in $runs_r; do

		bl dataset upload \
		--bold fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.nii.gz \
		--meta fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.json \
		--project $project_id \
		--datatype neuro/func/task \
		--datatype_tag 'raw' \
		--datatype_tag 'retinotopy' \
		--subject $subj_BL \
		--desc 'BOLD response to left visual hemifield stimulation' \
		--tag 'albinism' \
		--tag 'left_VF' \
		--tag 'run-'$j


	done

	cd ../..

done


	

MD_list='X'
BL_list='ALB5'

# Upload the data to BL
for i in $MD_list; do
	
	subj_MD=$MD_list
	subj_BL=$BL_list

	cd ${subj_MD}_????/Extracted_runs

	# Right visual field
	runs_r='4 7 8'

	for j in $runs_r; do

		bl dataset upload \
		--bold fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.nii.gz \
		--meta fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.json \
		--project $project_id \
		--datatype neuro/func/task \
		--datatype_tag 'raw' \
		--datatype_tag 'retinotopy' \
		--subject $subj_BL \
		--desc 'BOLD response to right visual hemifield stimulation' \
		--tag 'albinism' \
		--tag 'right_VF' \
		--tag 'run-'$j 


	done

	# Left visual field
	runs_r='5 9'

	for j in $runs_r; do

		bl dataset upload \
		--bold fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.nii.gz \
		--meta fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.json \
		--project $project_id \
		--datatype neuro/func/task \
		--datatype_tag 'raw' \
		--datatype_tag 'retinotopy' \
		--subject $subj_BL \
		--desc 'BOLD response to left visual hemifield stimulation' \
		--tag 'albinism' \
		--tag 'left_VF' \
		--tag 'run-'$j


	done

	cd ../..

done



MD_list='X'
BL_list='ALB6'

# Upload the data to BL
for i in $MD_list; do
	
	subj_MD=$MD_list
	subj_BL=$BL_list

	cd ${subj_MD}_????/Extracted_runs

	# Right visual field
	runs_r='1 4 5'

	for j in $runs_r; do

		bl dataset upload \
		--bold fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.nii.gz \
		--meta fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.json \
		--project $project_id \
		--datatype neuro/func/task \
		--datatype_tag 'raw' \
		--datatype_tag 'retinotopy' \
		--subject $subj_BL \
		--desc 'BOLD response to right visual hemifield stimulation' \
		--tag 'albinism' \
		--tag 'right_VF' \
		--tag 'run-'$j


	done

	# Left visual field
	runs_r='2 3 6'

	for j in $runs_r; do

		bl dataset upload \
		--bold fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.nii.gz \
		--meta fMRI_SMS2_2.5iso_54sl_TR1.5_run${j}.json \
		--project $project_id \
		--datatype neuro/func/task \
		--datatype_tag 'raw' \
		--datatype_tag 'retinotopy' \
		--subject $subj_BL \
		--desc 'BOLD response to left visual hemifield stimulation' \
		--tag 'albinism' \
		--tag 'left_VF' \
		--tag 'run-'$j 


	done
	
	cd ../..


done


: <<'END'
END
