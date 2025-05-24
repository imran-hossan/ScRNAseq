# script for manipulating gene expression data (GSE251810)
setwd("D:/R programing/Scripts") # set working directory

# load libraries
library(tidyverse)
library(dplyr)
library(GEOquery)

# read in the data
data <- read.delim("D:/R programing/GSE251810_2_genes_fpkm_expression.txt")
dim(data) # check how many rows and columns

# get the matadata
gse <- getGEO(GEO = 'GSE251810', GSEMatrix = TRUE)
metadata <- pData(phenoData(gse[[1]])) # extract phenotypic data such as conditions, sampleID etc.
head(metadata)
view(metadata)

metadata.modified <- metadata %>%
  select(1,10,11) %>% #select the columns
  mutate(title = gsub("MC38 tumors, ", "", title)) %>% # remove MC38 tumors from tcolumn 1
  rename(tissue = characteristics_ch1) %>% # rename the column to tisuue 10
  mutate(tissue = gsub("tissue: ", "", tissue)) %>% # remove tissue: from colimn 10
  mutate(tissue = str_replace(tissue, "MC38 tumors subscutaneously inoculated in C57BL/6 mice", "MC38 tumors")) %>% # remove from column 10
  rename(treatment = characteristics_ch1.1) %>% # rename the column 11
  mutate(treatment = gsub("treatment: ", "", treatment)) # remove treatment: from column 11


# reshaping gse dataset
data.long <- data %>%
  select(6,16,17,18,19,20,21) %>% # select columns from data object
  rename(gene = gene_name, 
         `GB-treated-1` = FPKM.GB_1,
         `GB-treated-2` = FPKM.GB_2,
         `GB-treated-3` = FPKM.GB_3,
         `PBS-treated-1` = FPKM.PBS_1,
         `PBS-treated-2` = FPKM.PBS_2,
         `PBS-treated-3` = FPKM.PBS_3,) %>% # rename the columns to match metadata.modified
  gather(key = 'samples', value = 'FPKM', -gene) # convert to long form 


# join dataframes = data.long + metadata.modified

data.joined <- data.long %>% 
  left_join(., metadata.modified, by = c("samples" = "title")) # join by common in both 






