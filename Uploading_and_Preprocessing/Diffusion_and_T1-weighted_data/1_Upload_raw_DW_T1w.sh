#!/bin/bash
bl login

project_id=5ddfa986936ca339b1c5f455

hypoplasia=(X)
achiasma=(X)
albinism=(X X X X X X X X X)
controls=(X X X X X X X X)

core_data_folder=/home/auguser2016/dMRI_DATA/RAW_DATA

: <<'END'
END

# Chiasma hypoplasia

for i in ${!hypoplasia[@]}; do

	subj_MD="${hypoplasia[$i]}"
	subj_BL=CHP$((i+1))

	temp=/home/auguser2016/Projects/02_Scientific_Data/CAADI/Data_Upload/$subj_BL
	mkdir $temp

	subj_data_folder=$core_data_folder/$subj_MD\_????/s*/

	### 1st DWI series (AP) ###

	# Convert from DICOM	
	dcm2niix -b y -ba y -z y -o $temp $subj_data_folder/*ep*AP 

	# Find the file name
	dw=$(basename $temp/*.nii.gz)
	bvecs=$(basename $temp/*.bvec)
	bvals=$(basename $temp/*.bval)
	json=$(basename $temp/*.json)

	# Upload
	bl dataset upload \
	--dwi $temp/$dw \
	--bvecs $temp/$bvecs \
	--bvals $temp/$bvals \
	--meta $temp/$json \
	--project $project_id \
	--datatype neuro/dwi \
	--datatype_tag 'raw' \
	--datatype_tag 'AP' \
	--subject $subj_BL \
	--desc 'Chiasma hypoplasia, raw DW series acquired with Anterior-Posterior (AP) phase encoding direction (PED), b-value=1600 and 128 directions equally intersected with 10 b0 images' \
	--tag 'chiasma_hypoplasia'

	rm $temp/$dw
	rm $temp/$bvecs
	rm $temp/$bvals
	rm $temp/$json

	### 2nd DWI series (PA) ###
	
	# Convert from DICOM	
	dcm2niix -b y -ba y -z y -o $temp $subj_data_folder/*ep*PA

	# Find the file name
	dw=$(basename $temp/*.nii.gz)
	bvecs=$(basename $temp/*.bvec)
	bvals=$(basename $temp/*.bval)
	json=$(basename $temp/*.json)	

	# Upload
	bl dataset upload \
	--dwi $temp/$dw \
	--bvecs $temp/$bvecs \
	--bvals $temp/$bvals \
	--meta $temp/$json \
	--project $project_id \
	--datatype neuro/dwi \
	--datatype_tag 'raw' \
	--datatype_tag 'PA' \
	--subject $subj_BL \
	--desc 'Chiasma hypoplasia, raw DW series acquired with Posterior-Anterior (PA) phase encoding direction (PED), b-value=1600 and 128 directions equally intersected with 10 b0 images' \
	--tag 'chiasma_hypoplasia'

	rm $temp/$dw
	rm $temp/$bvecs
	rm $temp/$bvals
	rm $temp/$json

	### T1w Image ###

	# Rename file and remove personal information
	cp /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_MD\_t1_acpc_anonim.nii.gz /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz
	mrconvert /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz -set_property comments $subj_BL /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz
	
	# Upload
	bl dataset upload \
	--t1 /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz \
	--project $project_id \
	--datatype neuro/anat/t1w \
	--datatype_tag 'AC-PC aligned' \
	--subject $subj_BL \
	--desc 'Chiasma hypoplasia, T1-weighted image with removed facial features and aligned to anterior commissure - posterior commissure (AC-PC) plane' \
	--tag 'chiasma hypoplasia'

	rm /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz	
	rm /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz	

	rm $temp

done


# Achiasma

for i in ${!achiasma[@]}; do

	subj_MD="${achiasma[$i]}"
	subj_BL=ACH$((i+1))

	temp=/home/auguser2016/Projects/02_Scientific_Data/CAADI/Data_Upload/$subj_BL
	mkdir $temp

	subj_data_folder=$core_data_folder/$subj_MD\_????/s*/

	### 1st DWI series (AP) ###

	# Convert from DICOM	
	dcm2niix -b y -ba y -z y -o $temp $subj_data_folder/*ep*AP 

	# Find the file name
	dw=$(basename $temp/*.nii.gz)
	bvecs=$(basename $temp/*.bvec)
	bvals=$(basename $temp/*.bval)
	json=$(basename $temp/*.json)

	# Upload
	bl dataset upload \
	--dwi $temp/$dw \
	--bvecs $temp/$bvecs \
	--bvals $temp/$bvals \
	--meta $temp/$json \
	--project $project_id \
	--datatype neuro/dwi \
	--datatype_tag 'raw' \
	--datatype_tag 'AP' \
	--subject $subj_BL \
	--desc 'Achiasma, raw DW series acquired with Anterior-Posterior (AP) phase encoding direction (PED), b-value=1600 and 128 directions equally intersected with 10 b0 images' \
	--tag 'achiasma'

	rm $temp/$dw
	rm $temp/$bvecs
	rm $temp/$bvals
	rm $temp/$json

	### 2nd DWI series (PA) ###
	
	# Convert from DICOM	
	dcm2niix -b y -ba y -z y -o $temp $subj_data_folder/*ep*PA

	# Find the file name
	dw=$(basename $temp/*.nii.gz)
	bvecs=$(basename $temp/*.bvec)
	bvals=$(basename $temp/*.bval)
	json=$(basename $temp/*.json)	

	# Upload
	bl dataset upload \
	--dwi $temp/$dw \
	--bvecs $temp/$bvecs \
	--bvals $temp/$bvals \
	--meta $temp/$json \
	--project $project_id \
	--datatype neuro/dwi \
	--datatype_tag 'raw' \
	--datatype_tag 'PA' \
	--subject $subj_BL \
	--desc 'Achiasma, raw DW series acquired with Posterior-Anterior (PA) phase encoding direction (PED), b-value=1600 and 128 directions equally intersected with 10 b0 images' \
	--tag 'achiasma'

	rm $temp/$dw
	rm $temp/$bvecs
	rm $temp/$bvals
	rm $temp/$json

	### T1w Image ###

	# Rename file and remove personal information
	cp /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_MD\_t1_acpc_anonim.nii.gz /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz
	mrconvert /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz -set_property comments $subj_BL /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz
	
	# Upload
	bl dataset upload \
	--t1 /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz \
	--project $project_id \
	--datatype neuro/anat/t1w \
	--datatype_tag 'AC-PC aligned' \
	--subject $subj_BL \
	--desc 'Achiasma, T1-weighted image with removed facial features and aligned to anterior commissure - posterior commissure (AC-PC) plane' \
	--tag 'achiasma'

	rm /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz	
	rm /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz	

	rm $temp

done

# Albinism

for i in ${!albinism[@]}; do

	subj_MD="${albinism[$i]}"
	subj_BL=ALB$((i+1))

	temp=/home/auguser2016/Projects/02_Scientific_Data/CAADI/Data_Upload/$subj_BL
	mkdir $temp

	subj_data_folder=$core_data_folder/$subj_MD\_????/s*/

	### 1st DWI series (AP) ###

	# Convert from DICOM	
	dcm2niix -b y -ba y -z y -o $temp $subj_data_folder/*ep*AP 

	# Find the file name
	dw=$(basename $temp/*.nii.gz)
	bvecs=$(basename $temp/*.bvec)
	bvals=$(basename $temp/*.bval)
	json=$(basename $temp/*.json)

	# Upload
	bl dataset upload \
	--dwi $temp/$dw \
	--bvecs $temp/$bvecs \
	--bvals $temp/$bvals \
	--meta $temp/$json \
	--project $project_id \
	--datatype neuro/dwi \
	--datatype_tag 'raw' \
	--datatype_tag 'AP' \
	--subject $subj_BL \
	--desc 'Albinism, raw DW series acquired with Anterior-Posterior (AP) phase encoding direction (PED), b-value=1600 and 128 directions equally intersected with 10 b0 images' \
	--tag 'albinism'

	rm $temp/$dw
	rm $temp/$bvecs
	rm $temp/$bvals
	rm $temp/$json

	### 2nd DWI series (PA) ###
	
	# Convert from DICOM	
	dcm2niix -b y -ba y -z y -o $temp $subj_data_folder/*ep*PA

	# Find the file name
	dw=$(basename $temp/*.nii.gz)
	bvecs=$(basename $temp/*.bvec)
	bvals=$(basename $temp/*.bval)	
	json=$(basename $temp/*.json)

	# Upload
	bl dataset upload \
	--dwi $temp/$dw \
	--bvecs $temp/$bvecs \
	--bvals $temp/$bvals \
	--meta $temp/$json \
	--project $project_id \
	--datatype neuro/dwi \
	--datatype_tag 'raw' \
	--datatype_tag 'PA' \
	--subject $subj_BL \
	--desc 'Albinism, raw DW series acquired with Posterior-Anterior (PA) phase encoding direction (PED), b-value=1600 and 128 directions equally intersected with 10 b0 images' \
	--tag 'albinism'

	rm $temp/$dw
	rm $temp/$bvecs
	rm $temp/$bvals
	rm $temp/$json

	### T1w Image ###

	# Rename file and remove personal information
	cp /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_MD\_t1_acpc_anonim.nii.gz /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz
	mrconvert /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz -set_property comments $subj_BL /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz
	
	# Upload
	bl dataset upload \
	--t1 /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz \
	--project $project_id \
	--datatype neuro/anat/t1w \
	--datatype_tag 'AC-PC aligned' \
	--subject $subj_BL \
	--desc 'Albinism, T1-weighted image with removed facial features and aligned to anterior commissure - posterior commissure (AC-PC) plane' \
	--tag 'albinism'

	rm /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz	
	rm /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz	

	rm $temp

done



# Controls

for i in ${!controls[@]}; do

	subj_MD="${controls[$i]}"
	subj_BL=CON$((i+1))

	temp=/home/auguser2016/Projects/02_Scientific_Data/CAADI/Data_Upload/$subj_BL
	mkdir $temp

	subj_data_folder=$core_data_folder/$subj_MD\_????/s*/

	### 1st DWI series (AP) ###

	# Convert from DICOM	
	dcm2niix -b y -ba y -z y -o $temp $subj_data_folder/*ep*AP 

	# Find the file name
	dw=$(basename $temp/*.nii.gz)
	bvecs=$(basename $temp/*.bvec)
	bvals=$(basename $temp/*.bval)
	json=$(basename $temp/*.json)

	# Upload
	bl dataset upload \
	--dwi $temp/$dw \
	--bvecs $temp/$bvecs \
	--bvals $temp/$bvals \
	--meta $temp/$json \
	--project $project_id \
	--datatype neuro/dwi \
	--datatype_tag 'raw' \
	--datatype_tag 'AP' \
	--subject $subj_BL \
	--desc 'Control, raw DW series acquired with Anterior-Posterior (AP) phase encoding direction (PED), b-value=1600 and 128 directions equally intersected with 10 b0 images' \
	--tag 'control'

	rm $temp/$dw
	rm $temp/$bvecs
	rm $temp/$bvals
	rm $temp/$json

	### 2nd DWI series (PA) ###
	
	# Convert from DICOM	
	dcm2niix -b y -ba y -z y -o $temp $subj_data_folder/*ep*PA

	# Find the file name
	dw=$(basename $temp/*.nii.gz)
	bvecs=$(basename $temp/*.bvec)
	bvals=$(basename $temp/*.bval)
	json=$(basename $temp/*.json)
		
	# Upload
	bl dataset upload \
	--dwi $temp/$dw \
	--bvecs $temp/$bvecs \
	--bvals $temp/$bvals \
	--meta $temp/$json \
	--project $project_id \
	--datatype neuro/dwi \
	--datatype_tag 'raw' \
	--datatype_tag 'PA' \
	--subject $subj_BL \
	--desc 'Control, raw DW series acquired with Posterior-Anterior (PA) phase encoding direction (PED), b-value=1600 and 128 directions equally intersected with 10 b0 images' \
	--tag 'control'

	rm $temp/$dw
	rm $temp/$bvecs
	rm $temp/$bvals
	rm $temp/$json

	### T1w Image ###

	# Rename file and remove personal information
	cp /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_MD\_t1_acpc_anonim.nii.gz /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz
	mrconvert /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz -set_property comments $subj_BL /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz
	
	# Upload
	bl dataset upload \
	--t1 /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz \
	--project $project_id \
	--datatype neuro/anat/t1w \
	--datatype_tag 'AC-PC aligned' \
	--subject $subj_BL \
	--desc 'Control, T1-weighted image with removed facial features and aligned to anterior commissure - posterior commissure (AC-PC) plane' \
	--tag 'control'

	rm /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym_tmp.nii.gz	
	rm /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/Anatomies_ACPC_Aligned_Anonymized_mri_deface/$subj_BL\_t1_acpc_anonym.nii.gz	

	rm $temp

done



: <<'END'
END
