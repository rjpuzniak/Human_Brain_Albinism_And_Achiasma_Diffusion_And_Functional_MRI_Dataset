BL_data= # path to folder with BL data e.g. /path/to/folder/proj-5ddfa986936ca339b1c5f455
cur=$(pwd)

cd $BL_data

for i in sub-*; do

	echo $i
	subj=${i:4:4}

	cd ${i}

	# Define paths to images
	dw=dt-neuro-dwi*/dwi_unwarped.nii.gz
	bvecs=dt-neuro-dwi*/dwi.bvecs
	bvals=dt-neuro-dwi*/dwi.bvals
	b0=dt-neuro-dwi*/b0_unwarped.nii.gz
	t1w=dt-neuro-anat*/t1.nii.gz

	# Create input for epi reg
	cp $b0 b0_unwarped.nii.gz
	cp $t1w t1w.nii.gz

	# Create t1 mask	
	bet2 $t1w t1w_brain -m

	# Compute BBR registration
	epi_reg --epi=b0_unwarped --t1=t1w --t1brain=t1w_brain.nii.gz --out=dwi2acpc -v

	# Apply the transform (DW to T1)
	flirt -noresample -interp sinc -sincwidth 7 -sincwindow hanning -verbose 1 -in $dw -ref $t1w -applyxfm -init dwi2acpc.mat -out dwi_unwarped_aligned.nii.gz

	# Resample aligned DW image
	mrresize dwi_unwarped_aligned.nii.gz -voxel 1.5,1.5,1.5 dwi_unwarped_aligned_resized.nii.gz

	# Rotate bvecs
	input=$bvecs
	matrix=dwi2acpc.mat
	output=bvecs_aligned.bvecs

    m11=`avscale ${matrix} | grep Rotation -A 1 | tail -n 1| awk '{print $1}'`
    m12=`avscale ${matrix} | grep Rotation -A 1 | tail -n 1| awk '{print $2}'`
    m13=`avscale ${matrix} | grep Rotation -A 1 | tail -n 1| awk '{print $3}'`
    m21=`avscale ${matrix} | grep Rotation -A 2 | tail -n 1| awk '{print $1}'`
    m22=`avscale ${matrix} | grep Rotation -A 2 | tail -n 1| awk '{print $2}'`
    m23=`avscale ${matrix} | grep Rotation -A 2 | tail -n 1| awk '{print $3}'`
    m31=`avscale ${matrix} | grep Rotation -A 3 | tail -n 1| awk '{print $1}'`
    m32=`avscale ${matrix} | grep Rotation -A 3 | tail -n 1| awk '{print $2}'`
    m33=`avscale ${matrix} | grep Rotation -A 3 | tail -n 1| awk '{print $3}'`

    numbvecs=`cat ${input} | head -1 | tail -1 | wc -w`
    tmpout=${output}$$
    ii=1
    rm -f ${output}
    while [ $ii -le ${numbvecs} ] ; do
        X=`cat ${input} | awk -v x=${ii} '{print $x}' | head -n 1 | tail -n 1 | awk -F"E" 'BEGIN{OFMT="%10.10f"} {print $1 * (10 ^ $2)}' `
        Y=`cat ${input} | awk -v x=${ii} '{print $x}' | head -n 2 | tail -n 1 | awk -F"E" 'BEGIN{OFMT="%10.10f"} {print $1 * (10 ^ $2)}' `
        Z=`cat ${input} | awk -v x=${ii} '{print $x}' | head -n 3 | tail -n 1 | awk -F"E" 'BEGIN{OFMT="%10.10f"} {print $1 * (10 ^ $2)}' `
        rX=`echo "scale=7;  (${m11} * $X) + (${m12} * $Y) + (${m13} * $Z)" | bc -l`
        rY=`echo "scale=7;  (${m21} * $X) + (${m22} * $Y) + (${m23} * $Z)" | bc -l`
        rZ=`echo "scale=7;  (${m31} * $X) + (${m32} * $Y) + (${m33} * $Z)" | bc -l`

        if [ "${ii}" -eq 1 ];then
	    echo $rX > ${output}; 
	    echo $rY >> ${output};
	    echo $rZ >> ${output}
        else
	    cp ${output} ${tmpout}
	    (echo $rX;echo $rY;echo $rZ) | paste ${tmpout} - > ${output}
        fi
    
        let "ii+=1"
    done

    cat ${output} | awk '{for(i=1;i<=NF;i++)printf("%10.6f ",$i);printf("\n")}' > ${output}_
    mv ${output}_ ${output}

    rm -f ${tmpout}	

	cd ..

done

cd $cur

