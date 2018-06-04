l <- list.files("/mnt/hgfs/danhovelson/analysis/tmb/tmp",full.names = TRUE,pattern = "data_tbl")
if (FALSE) {
  for (i in 1:length(l)) {
    print(paste0("i = ",i))
    if (i == 1) {
      master_mut <- read_tsv(l[i])
    } else {
      tmut <- read_tsv(l[i])
      master_mut <- rbind(master_mut,tmut)
    }
  }
}

# write out master experiment mut count & rate table
#write_tsv(master_mut,"/mnt/hgfs/danhovelson/analysis/tmb/20180601.tcga.wes_vs_panel.mut_count_rates.txt")
#master_mut <- read_tsv("/mnt/hgfs/danhovelson/analysis/tmb/20180601.tcga.wes_vs_panel.mut_count_rates.txt")
if (FALSE) {
  # create shell df for any sample/panel/iter/vfthresh combo that had 0 variants
  usettings <- unique(master_mut[,c("panel_size","iter_num","vfthresh")])
  usamps <- unique(master_mut$bcr_patient_barcode)
  for(i in 1:length(usamps)) {
    #i=1
    if (i == 1) {
      shelldf <- usettings
      shelldf$bcr_patient_barcode = usamps[i]
    } else {
      print(i)
      tmpshelldf <- usettings
      tmpshelldf$bcr_patient_barcode = usamps[i]
      shelldf <- rbind(shelldf,tmpshelldf)
    }
  }
}
#write_tsv(shelldf,"/mnt/hgfs/danhovelson/analysis/tmb/20180601.tcga.wes_vs_panel.shell_dataframe.txt")
#shelldf <- read_tsv("/mnt/hgfs/danhovelson/analysis/tmb/20180601.tcga.wes_vs_panel.shell_dataframe.txt")

# ensure all experimental combinations have values
if (FALSE) {
  #shelldf %>%
#  left_join(master_mut,by=c("bcr_patient_barcode","vfthresh","panel_size","iter_num")) -> full_wshell
#write_tsv(full_wshell,"/mnt/hgfs/danhovelson/analysis/tmb/20180601.tcga.wes_vs_panel.mut_count_rates.wZeros.txt")
tshelldf <- read_tsv("/mnt/hgfs/danhovelson/analysis/tmb/20180601.tcga.wes_vs_panel.mut_count_rates.wZeros.txt") %>%
  #mutate(panel_muts = ifelse(is.na(panel_muts),0,panel_muts),
  #       panel_muts_mb = ifelse(is.na(panel_muts_mb),0,panel_muts_mb)) %>%
  unique() %>%
  group_by(bcr_patient_barcode,panel_size,vfthresh) %>%
  summarise(panel_count = median(panel_muts),
            panel_rate = median(panel_muts_mb),
            panel_rate_sd=sd(panel_muts_mb,na.rm=TRUE)) -> master_mut_sum

  write_tsv(master_mut_sum,"/mnt/hgfs/danhovelson/analysis/tmb/20180601.tcga.wes_vs_panel.mut_count_rates.summarized.txt")
}
#master_mut_sum <- read_tsv("/mnt/hgfs/danhovelson/analysis/tmb/20180601.tcga.wes_vs_panel.mut_count_rates.summarized.txt")