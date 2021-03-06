## Adds an Investigation Design Format file for all the batches in an archive.
buildIDF <- function(x, version='0', magetab.version=magetab.version, platform='HumanMethylation450', series='0') 
{ # {{{
  if(is(x, 'MethyLumiSet')) {
    platform = gsub('k$','',gsub('Illumina','',annotation(x)))
  }
  disease = unique(x$diseaseabr)
  stopifnot(length(disease)==1)
  filenm=paste('jhu-usc.edu_',disease,'.',platform,'.1.',magetab.version,'.',series,'.idf.txt',
               sep='')
  sdrfnm=gsub('idf','sdrf',filenm)

  invtitle = paste('TCGA Analysis of DNA Methylation for', disease, 'using Illumina Infinium', platform, 'platform')
  pub.date = paste('Public Release Date', date(), sep="\t")
  protocoln = c('labeling','hybridization','scan')
  protocols = c('labeling','hybridization','image_acquisition')
  protocols = paste('jhu-usc.edu',protocols,platform,'01',sep=':')
  names(protocols) = protocoln

  ## FIXME: break this up properly and/or build it up properly in a loop
  bogosity = c(   
    paste(c('Investigation Title',
            invtitle),
            collapse="\t"),
    '', # chunk separator
    paste(c('Experimental Design',
            'disease_state_design'),
            collapse="\t"),
    paste(c('Experimental Design Term Source REF',
            'MGED Ontology'),
            collapse="\t"),
    paste(c('Experimental Factor Type',
            'disease'),
            collapse="\t"),
    paste(c('Experimental Factor Type Term Source REF',
            'MGED Ontology'),
            collapse="\t"),
    '', # chunk separator
    paste(c('Person Last Name',
            'Laird'),
            collapse="\t"),
    paste(c('Person First Name',
            'Peter'),
            collapse="\t"),
    paste(c('Person Mid Initials',
            'W'),
            collapse="\t"),
    paste(c('Person Email',
            'plaird@usc.edu'),
            collapse="\t"),
    paste(c('Person Phone',
            '323.442.7890'),
            collapse="\t"),
    paste(c('Person Address',
      'USC Epigenome Center, University of Southern California, CA 90033, USA'),            collapse="\t"),
    paste(c('Person Affiliation',
            'University of Southern California'),
            collapse="\t"),
    paste(c('Person Roles',
            'submitter'),
            collapse="\t"),
    '', # chunk separator
    paste(c('Quality Control Types',
            'real_time_PCR_quality_control'),
            collapse="\t"),
    paste(c('Quality Control Types Term Source REF',
            'MGED Ontology'),
            collapse="\t"),
    paste(c('Replicate Type',
            'bioassay_replicate_reduction'),
            collapse="\t"),
    paste('Replicate Type Term Source REF','MGED Ontology',sep="\t"),
    # paste('Date of Experiment ', date(), sep="\t"),
    paste('Public Release Date', date(), sep="\t"),
    paste('Protocol Name', paste(protocols, collapse="\t"), sep="\t"),
    paste('Protocol Type', paste(names(protocols), collapse="\t"), sep="\t"),
    paste(c('Protocol Term Source REF',
            'MGED Ontology',
            'MGED Ontology',
            'MGED Ontology'), 
            collapse="\t"),
    #
    # FIXME: couple this to the SDRF 
    #           
    # protocols = c(protocol1='labeling',
    #               protocol2='hybridization',
    #               protocol3='image_acquisition',
    #               protocol4='feature_extraction',
    #               protocol5='within_bioassay_data_set_function',
    #               protocol6='within_bioassay_data_set_function') 
    #           
    paste(c('Protocol Description',
            paste('Illumina Infinium', platform, 'Labeled Extract'),
            paste('Illumina Infinium', platform, 'Hybridization Protocol'),
            paste('Illumina Infinium', platform, 'Scan Protocol')),
            collapse="\t"),
    'Protocol Parameters',
    '', # chunk separator
    paste(c('SDRF Files', 
            sdrfnm), 
            collapse="\t"),
    paste(c('Term Source Name',
            'MGED Ontology',
            'caArray'),
            collapse="\t"),
    paste(c('Term Source File',
            'http://mged.sourceforge.net/ontologies/MGEDontology.php',
            'http://caarraydb.nci.nih.gov/'),
            collapse="\t"),
    paste(c('Term Source Version',
            '1.3.1.1',
            '2007-01'),
            collapse="\t")
  )

  cat(bogosity, sep="\n", file=filenm)

} # }}}


## FIXME: accomodate differing versions if !is.vector(version) 
##        by expanding scalar to version <- rep(version, 5) and naming them
## Adds Sample and Data Relationship Format file for all batches in an archive.
#buildSDRF <- function(x, old.version='0', new.version='0', platform='HumanMethylation450',lvls=c(1:3))
#{ # {{{

#  if(is(x, 'MethyLumiSet')) { # {{{
#    stopifnot('barcode' %in% varLabels(x))
#    stopifnot('BATCH.ID' %in% varLabels(x))
#    subjects = sampleNames(x) = x$TCGA.ID    
#    platform = gsub('k$','',gsub('Illumina','',annotation(x))) # }}}
#  } else { # {{{
#    stopifnot('barcode' %in% names(x))
#    stopifnot('BATCH.ID' %in% names(x))
#    subjects = rownames(x) = x$TCGA.ID    
#  } # }}}

#  diseases = levels(as.factor(x$diseaseabr))
#  if(length(diseases)!=1) {
#    stop('You have multiple disease abbreviations in this dataset.')
#  } else {
#    disease = diseases[1]
#  }
#  prepreamble =  paste('jhu-usc.edu_',disease,'.',platform,sep='')
#  preamble =  paste(prepreamble,'1',new.version,'0',sep='.')
  # <Domain>_<TumorType>.<Platform>.<ArchiveSerialIndex>.sdrf.txt
#  sdrf.name = paste(preamble, 'sdrf','txt',sep='.') # all one big SDRF file
#  array.ref = paste('Illumina.com','PhysicalArrayDesign',platform, sep=':')
#  protocols = c(protocol1='labeling', # {{{
#                protocol2='hybridization',
#                protocol3='image_acquisition',
#                protocol4='feature_extraction',
#                protocol5='within_bioassay_data_set_function',
#                protocol6='within_bioassay_data_set_function') # }}}
#  protocols = paste('jhu-usc.edu',protocols,platform,'01',sep=':')
#  termsources = c(termsource1='MGED Ontology',
#                  termsource2='caArray')

  ## FIXME: there's got to be a better way of handling all these fields
#  headers = c(extract='Extract Name',                         # TCGA ID  {{{
#              protocol1='Protocol REF',                       # labeling
#              labeled='Labeled Extract Name',                 # TCGA ID
#              label='Label',                                  # Cy3 or Cy5
#              termsource1='Term Source REF',                  # MGED Ontology
#              protocol2='Protocol REF',                       # hybridization
#              hybridization='Hybridization Name',             # barcode
#              arraydesign='Array Design REF',                 # array.ref
#              termsource2='Term Source REF',                  # caArray

              ## Level 1 : IDAT files

#              protocol3='Protocol REF',                       # imaging 
#              protocol4='Protocol REF',                       # extraction
#              name1='Scan Name',                              # TCGA ID
#              datafile1='Array Data File',                    # _(Red|Grn).idat
#              archive1='Comment [TCGA Archive Name]',         # which batch
#              datatype1='Comment [TCGA Data Type]',           # Methylation
#              datalevel1='Comment [TCGA Data Level]',         # Level 1, duh
#              include1='Comment [TCGA Include for Analysis]', # yes

              ## Level 2 : background-corrected M, U

#              protocol5='Protocol REF',                       # bg correction
#              name2='Normalization Name',                     # TCGA ID
#              datafile2='Derived Array Data Matrix File',     # .lvl-2.TCGA.txt
#              archive2='Comment [TCGA Archive Name]',         # which batch
#              datatype2='Comment [TCGA Data Type]',           # Methylation
#              datalevel2='Comment [TCGA Data Level]',         # Level 2, duh
#              include2='Comment [TCGA Include for Analysis]', # yes

              ## Level 3 : masked betas, pvals/symbols, chromosome, coordinate

#              protocol6='Protocol REF',                       # bg correction
#              name3='Normalization Name',                     # TCGA ID
#              datafile3='Derived Array Data Matrix File',     # .lvl-3.TCGA.txt
#              archive3='Comment [TCGA Archive Name]',         # which batch
#              datatype3='Comment [TCGA Data Type]',           # Methylation
#              datalevel3='Comment [TCGA Data Level]',         # Level 3, duh
#              include3='Comment [TCGA Include for Analysis]') # yes }}}

#  elements= c(extract='TCGA.ID.HERE', # {{{
#              protocol1=protocols[1],
#              labeled='TCGA.ID.HERE',
#              label='Cy3 or Cy5',
#              termsource1=termsources[1],
#              protocol2=protocols[2],
#              hybridization='barcode.here',
#              arraydesign=array.ref,
#              termsource2=termsources[2],

              # Level 1
#              protocol3=protocols[3],
#              protocol4=protocols[4],
#              name1='TCGA.ID.HERE',
#              datafile1='barcode_Red.or.Grn.idat',
#              archive1='TCGA.BATCH.ARCHIVENAME',
#              datatype1='DNA Methylation',
#              datalevel1='Level 1',
#              include1='yes',

              # level 2
#              protocol5=protocols[5],
#              name2='TCGA.ID.HERE',
#              datafile2='jhu-usc.edu_blablah-lvl2.TCGA.txt',
#              archive2='TCGA.BATCH.ARCHIVENAME',
#              datatype2='DNA Methylation',
#              datalevel2='Level 2',
#              include2='yes',

              # level 3
#              protocol6=protocols[6],
#              name3='TCGA.ID.HERE',
#              datafile3='jhu-usc.edu_blablah-lvl3.TCGA.txt',
#              archive3='TCGA.BATCH.ARCHIVENAME',
#              datatype3='DNA Methylation',
#              datalevel3='Level 3',
#              include3='yes') # }}}

#  cat(paste(headers, collapse="\t"), "\n", sep='', file=sdrf.name)
#  channels = c(Cy3='Grn',Cy5='Red')
#  for(s in subjects) {  # {{{ add two lines in the SDRF for each subject!
#    elements['extract'] = s
#    elements['labeled'] = s
#    elements['name1'] = s
#    elements['name2'] = s
#    elements['name3'] = s
#    xs = which(x$TCGA.ID == s)
#    b = x$BATCH.ID[ xs ]
#    chip = x$barcode[ xs ]

    # not likely to use these, but just in case...
    #if( !('1' %in% lvls) ) elements['include1'] = 'no'
    #if( !('2' %in% lvls) ) elements['include2'] = 'no'
    #if( !('3' %in% lvls) ) elements['include3'] = 'no'

    # {{{ level 1: IDAT files (2 lines per sample)
    # datafile1 will be two entries: one for Cy5 (red) and one for Cy3 (green)
#    if( !('1' %in% lvls) ) {
#	    elements['archive1'] = paste(prepreamble,'Level_1',b,old.version,'0', sep='.')
#    } else {
#	    elements['archive1'] = paste(prepreamble,'Level_1',b,new.version,'0', sep='.')
#    }
    # }}}

    # {{{ level 2: background-corrected M and U intensities
#    elements['datafile2'] = paste(prepreamble,b,'lvl-2',s,'txt',sep='.')
#    message(paste('Subject',s,'Level 2 data file is ', elements['datafile2']))
#    if( !('2' %in% lvls) ) {
#	    elements['archive2'] = paste(prepreamble,'Level_2',b,old.version,'0', sep='.')
#    } else {
#	    elements['archive2'] = paste(prepreamble,'Level_2',b,new.version,'0', sep='.')
#    }
#    message(paste('Subject',s,'Level 2 data file is in', elements['archive2']))
    # }}}

    # {{{ level 3: SNP10-masked beta value with ECDF pvalue
#    elements['datafile3'] = paste(prepreamble,b,'lvl-3',s,'txt', sep='.')
#    message(paste('Subject',s,'Level 3 data file is ', elements['datafile3']))
#    if( !('3' %in% lvls) ) {
#	    elements['archive3'] = paste(prepreamble,'Level_3',b,old.version,'0', sep='.')
#    } else {
#	    elements['archive3'] = paste(prepreamble,'Level_3',b,new.version,'0', sep='.')
#    }
#    message(paste('Subject',s,'Level 3 data file is in', elements['archive3']))
    # }}}

#    for(ch in names(channels)) { # {{{ each subject has TWO SDRF lines
#      elements['label'] = ch
#      elements['hybridization'] = s # otherwise 
#      elements['datafile1'] = paste(chip,'_',channels[[ch]],'.idat', sep='')
#      cat(paste(elements,collapse="\t"),"\n",sep='',file=sdrf.name,append=T)
#    } # }}}

#  } # }}} 

#} # }}}

buildSDRF <- function(x, old.version='0', new.version='0', magetab.version='0', platform='HumanMethylation450', revision=FALSE, series='0')
{
	sdrf <- SDRF(x, old.version=old.version, new.version=new.version, magetab.version=magetab.version, platform=platform, revision=revision, series=series)
	sdrf.name <- sdrf@sdrf.name
	headers <- sdrf@headers
	cat(paste(headers, collapse="\t"), "\n", sep='', file=sdrf.name)
	sdrf.file <- cbind(getExtract(sdrf), getLevel1(sdrf), getLevel2(sdrf), getLevel3(sdrf))
	write.table(sdrf.file, file=sdrf.name, append=T, quote=F, col.names=F, row.names=F, sep="\t")
}


mageTab <- function(map, old.version='0', new.version='0', base=NULL, magetab.version=NULL, platform='HumanMethylation450', lvls=c(1:3), revision=FALSE, series='0')
{ # {{{
  if(is(map, 'MethyLumiSet')) { # {{{
    x <- map
    platform = gsub('^Illumina', '', gsub('k$','', annotation(x)))
    map <- pData(x)
  } # }}}
  disease = unique(map$diseaseabr)

  ## FIXME: accomodate differing logic for LAML 450k vs. 27k
  if('BATCH.ID' %in% names(map) && length(levels(as.factor(map$BATCH.ID)))==1){
    BID = unique(map$BATCH.ID)
  } else {
    BID = 1 
  }
  stopifnot(length(disease) == 1)
  platform.dir = ifelse(platform=='HumanMethylation450', 'meth450k', 'meth27k')
  if(is.null(magetab.version)){
    magetab.version = new.version
  }
  if(series == '0'){
	  archive.dir = paste(Sys.getenv('HOME'), platform.dir, 'tcga', disease,
	                paste("version", new.version, sep=""), 
	                paste(paste( 'jhu-usc.edu', disease, sep='_'), platform,
		       'mage-tab', BID, magetab.version, series, sep='.'), sep='/')
  } else {
	  archive.dir = paste(Sys.getenv('HOME'), platform.dir, 'tcga', disease,
	                paste(series,'.',"version", new.version, sep=""), 
	                paste(paste( 'jhu-usc.edu', disease, sep='_'), platform,
		       'mage-tab', BID, magetab.version, series, sep='.'), sep='/')
  }
  if(!('BATCH.ID' %in% names(map))) { # {{{
    stopifnot('TCGA.BATCH' %in% names(map))
    map$BATCH.ID = as.numeric(as.factor(map$TCGA.BATCH))
  } # }}}
  oldwd = getwd()
  setwd(archive.dir)
  addDescription(map, platform=platform)
  buildIDF(map, version=new.version, magetab.version=magetab.version, platform=platform, series=series)
  buildSDRF(map, old.version=old.version, new.version=new.version, magetab.version=magetab.version, platform=platform, revision=revision, series=series)
  setwd(oldwd)
} # }}} 

addDescription <- function(x, platform='HumanMethylation450') {
  #{{{
  if(is(x, 'MethyLumiSet')) {
    platform = gsub('k$','',gsub('Illumina','',annotation(x)))
  }
  disease = unique(x$diseaseabr)
  stopifnot(length(disease) == 1)
  Rversion <- sessionInfo()$R.version$version.string
  Rplatform <- paste("Platform", sessionInfo()$platform, sep="-")
  basePkgs <- paste("Base R Packages", paste(sessionInfo()$basePkgs, collapse=", "), sep=" : ")
  attachedPkgs <- paste("Attached R Packages",
			paste(paste(names(sessionInfo()$otherPkgs),
				    unlist(lapply(sessionInfo()$otherPkgs, function(x){x$Version}), use.names=F), sep="-"), collapse=", "), sep=" : ")

  if(platform == 'HumanMethylation450') {
    boilerplate = paste('This data archive contains the Cancer Genome Atlas (TCGA) analysis of DNA methylation profiling using the IIllumina Infinium',platform,'platform. The Infinium platform analyzes up to 482,421 CpG dinucleotides and 3091 CpH dinucleotides, spanning gene-associated elements as well as intergenic regions. DNA samples were received, bisulfite converted and cytosine methylation was evaluated using IIllumina Infinium',platform,'microarrays.')
  } else { 
    boilerplate = paste('This data archive contains the Cancer Genome Atlas (TCGA) analysis of DNA methylation profiling using the IIllumina Infinium',platform,'platform. The Infinium platform analyzes up to 27598 CpG dinucleotides, primarily within 1500bp of putative gene transcription start sites.  DNA samples were received, bisulfite converted and cytosine methylation was evaluated using IIllumina Infinium',platform,'microarrays.')
  }
  sample.desc = paste('This archive contains Infinium DNA methylation data for',
                      disease, 'samples.')

  level.desc = 'The files contained in each data level package are as follows:'

  level.desc = paste(level.desc,
'AUX: Auxilary directory with .csv mappings, .sdf files, and processing logs.',

'LEVEL 1: Level 1 data contain raw IDAT files (two per sample) as produced by the iScan system and as mapped by the SDRF and also in the disease mapping file. These files can be directly processed by the `methylumi` or `minfi` R packages; a comma-separated value (CSV) file in the AUX archive is provided to ease this.',

'LEVEL 2: Level 2 data contain background-corrected methylated (M) and unmethylated (U) summary intensities as extracted by the methylumi package.  Non-detection probabilities (P-values) were computed as the minimum of the two values (one per allele) for the empirical cumulative density function of the negative control probes in the appropriate color channel.  Background correction is performed via normal-exponential deconvolution (currently NOT stratified by probe sequence).', sep="\n\n")

  if(platform == 'HumanMethylation450') {
    level.desc = paste(level.desc,
    'Multiple-batch archives have the intensities in each of the two channels multiplicatively scaled to match a reference sample (sample with R/G ratio closest to 1.0.)', sep=' ')
  }

  level.desc = paste(level.desc, 
'LEVEL 3: Derived summary measures (beta values: M/(M+U) for each interrogated locus) with annotations for gene symbol, chromosome (UCSC hg19, Feb 2009), and CpG/CpH coordinate (UCSC hg19, Feb 2009). Probes having a common SNP (common SNP is a SNP with Minor Allele Frequency > 1% as defined by the UCSC snp135common track) within 10bp of the interrogated CpG site or having 15bp from the interrogated CpG site overlap with a REPEAT element (as defined by RepeatMasker and Tandem Repeat Finder Masks based on UCSC hg19, Feb 2009) are masked as NA across all samples, and probes with a non-detection probability (P-value) greater than 0.05 in a given sample are masked as NA on that chip. Probes that are mapped to multiple sites on hg19 are annotated as NA for chromosome and 0 for CpG/CpH coordinate',sep="\n\n")

  session.desc <- "This archive was created using R (http://www.R-project.org). The package 'EGC.tools' was used to package the data and is available on GitHub (http://github.com/uscepigenomecenter). Information regarding the version of R and the packages that were used to create this package is included below. All of the packages are available from either Bioconductor (http://www.bioconductor.org) or CRAN (http://cran.r-project.org)"

  session.desc <- paste(session.desc, Rversion, Rplatform, basePkgs, attachedPkgs, sep="\n\n")

  cat(boilerplate, sample.desc, level.desc, session.desc, file='DESCRIPTION.txt', sep="\n\n")
} # }}}
