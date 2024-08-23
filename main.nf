process FILTER_BCF_INTO_BIN_FILES_VIA_HMMIBDRS {
	publishDir "${params.outdir}/bcf_bin_files/"
	input: tuple val(grp), path(bcf), path(bcf_filter_config), /*samplelist*/ path("input/monoclonal_samples.txt")
	output: tuple val(grp), path("*bcf_bin_file*.bin"), emit: bcf_bin
	output: tuple val(grp), path("*.samples"), emit: sample_lst
	script:
	if (params.test)
	"""
	mv input/monoclonal_samples.txt input/monoclonal_samples_all.txt
	head -300 input/monoclonal_samples_all.txt > input/monoclonal_samples.txt
	hmmibd-rs --data-file1 ${bcf} --from-bcf --output ${grp}_bcf_bin_file  --bcf-to-bin-file-by-chromosome --bcf-filter-config ${bcf_filter_config}
	"""
	else
	"""
	hmmibd-rs --data-file1 ${bcf} --from-bcf --output ${grp}_bcf_bin_file  --bcf-to-bin-file-by-chromosome --bcf-filter-config ${bcf_filter_config}
	"""
	stub:
	"""
	touch ${grp}_bcf_bin_file_Pf3D7_0{1..9}_v3.bin  ${grp}_bcf_bin_file_Pf3D7_1{0..4}_v3.bin		
	touch ${grp}.samples
	"""
}

process CALL_HMMIBDRS {
	publishDir "${params.outdir}/hmmibdrs_out/"
	input: tuple val(grp), val(chrname), path(bcf_bin)
	output: tuple val(grp), val(chrname), path("*.hmm.txt"), emit: seg
	output: tuple val(grp), val(chrname), path("*.hmm_fract.txt"), optional: true, emit: fract
	script:
	"""
	hmmibd-rs --from-bin --data-file1 ${bcf_bin} --suppress-frac --filt-min-seg-cm 2.0 --filt-ibd-only --num-threads ${task.cpus} --par-mode 1 --output ${grp}_${chrname}
		
	"""
	stub:
	"""
	touch ${grp}_${chrname}.hmm.txt ${grp}_${chrname}.hmm_fract.txt
	"""
}

process CALC_COVERAGE {
	publishDir "${params.outdir}/ibdcov/"
	input: tuple val(grp),  path("hmmibdseg/*.hmm.txt"), path(samples)
	output: tuple val(grp), path("*_ibdcov.csv")
	script:
	"""
	genomeutils generate-by-name -n pf3d7-const15k --to-toml mygenome.toml
	ibdutils coverage -g mygenome.toml -s ${samples} -f hmmibd -i hmmibdseg --min-cm 2.0 \
	--prevent-flatten -o ${grp}_ibdcov.csv
	"""
	stub:
	"""
	touch  ${grp}_ibdcov.csv		
	"""

	
}

workflow{
	ch_input =  Channel.of([
		"Pf7", 
		file("${projectDir}/input/Pf7_filt.bcf", checkIfExists:true), 
		file("${projectDir}/input/bcf_filter_config.toml", checkIfExists:true),
		file("${projectDir}/input/monoclonal_samples.txt", checkIfExists:true),
	])

	ch_input | FILTER_BCF_INTO_BIN_FILES_VIA_HMMIBDRS 

	ch_input_call_hmmibd =  FILTER_BCF_INTO_BIN_FILES_VIA_HMMIBDRS.out.bcf_bin.flatMap{ grp, bcf_lst -> 
		bcf_lst.collect{bcf_bin -> 
			def chrname = bcf_bin.getBaseName().replaceAll(/^.*bcf_bin_file_/, '')
			[grp, chrname, bcf_bin]
		}
	}

	ch_input_call_hmmibd | CALL_HMMIBDRS	

	ch_input_calc_coverage =  CALL_HMMIBDRS.out.seg.map{grp, chrname, hmm_seg -> 
		[grp, hmm_seg]}.groupTuple( by:0
	). combine(
		FILTER_BCF_INTO_BIN_FILES_VIA_HMMIBDRS.out.sample_lst, by: 0
	) // [grp, hmm_seg_lst, samples]

	ch_input_calc_coverage |  CALC_COVERAGE
}

