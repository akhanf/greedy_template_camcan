
rule tissue_seg:
    input: config['in_preproc_T1w']
    params:
        out_prefix = 'results/preproc/sub-{subject}/fast'
    output: 
        gm = 'results/preproc/sub-{subject}/fast_prob_1.nii.gz',
        wm = 'results/preproc/sub-{subject}/fast_prob_2.nii.gz'
    container: config['singularity']['prepdwi']
    group: 'preproc'
    threads: 1
    resources:
        mem_mb = 8000,
        time = 30
    shell: 'fast -v -o {params.out_prefix}  -p {input}'

rule cp_gm:
    input: 'results/preproc/sub-{subject}/fast_prob_1.nii.gz',
    output: 'results/preproc/sub-{subject}/sub-{subject}_space-T1w_label-GM_probseg.nii.gz'
    group: 'preproc'
    shell: 'cp {input} {output}'

rule cp_wm:
    input: 'results/preproc/sub-{subject}/fast_prob_2.nii.gz',
    output: 'results/preproc/sub-{subject}/sub-{subject}_space-T1w_label-WM_probseg.nii.gz'
    group: 'preproc'
    shell: 'cp {input} {output}'



"""
rule calc_smooth_gm_from_fs:
    input: 
        aseg = config['in_aseg'],
        ribbon = config['in_ribbon']
    params:
        gm_labels = ' '.join([str(lbl) for lbl in config['aseg_gm_labels']]),
        smoothing = '1x1x1mm'
    output: 'results/preproc/sub-{subject}/sub-{subject}_space-T1w_label-GM_probseg.nii.gz'
    container: config['singularity']['itksnap']
    shell: 
        'c3d {input.aseg} -retain-labels {params.gm_labels} -binarize -popas SUBCORT'
        ' {input.ribbon} -binarize -popas CORT '
        ' -push SUBCORT -push CORT -add -binarize '
        ' -smooth {params.smoothing} -o {output}'

rule calc_smooth_wm_from_fs:
    input: config['in_wmparc']
    params:
        smoothing = '1x1x1mm'
    output: 'results/preproc/sub-{subject}/sub-{subject}_space-T1w_label-WM_probseg.nii.gz'
    container: config['singularity']['itksnap']
    shell: 'c3d {input} -binarize -smooth {params.smoothing} -o {output}'

"""
