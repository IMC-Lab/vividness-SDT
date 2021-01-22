# choose stimuli
library(dplyr)
library(tidyr)

norms <- read.csv('normed_data/picture_perfect_norms.csv')
stimlist_all <- norms %>% select(-ends_with('clipart')) %>% 
  mutate(filepath = list.files(path = 'full_alpha', pattern='.png')) %>%
  arrange(desc(familiarity_photo), desc(image_agreement_photo)) %>% 
  filter(name_agreement_photo > 50) 

# make encoding files 
pseudorandomTrials <- function (length=25, repetitions=3) {
  trials <- rep(c('imagine', 'perceive'), each=length)
  while (max(rle(trials)$lengths) > repetitions)
    trials <- sample(trials)
  return(trials)
}

set.seed(42)

make_encodingFiles <- function (n_subs=4) {
  for (sub in 1:n_subs) {
    stim_file <- stimlist_all %>% 
      select(item, filepath) %>% 
      sample_frac(0.96, replace=F) %>% 
      mutate(trial_type=c(pseudorandomTrials(), pseudorandomTrials(), pseudorandomTrials(), pseudorandomTrials()),
             block=rep(c(1, 2, 3, 4), each=50))
    if (sub <= n_subs/2) {
      stim_file <- stim_file %>% 
        mutate(condition = 'full_alpha',
               filepath = paste0('full_alpha/', filepath))
    } else {
      stim_file <- stim_file %>%
        mutate(condition = 'reduced_alpha',
               filepath = paste0('reduced_alpha/', filepath))
    }
    write.csv(stim_file, file = paste0('stim_files/s', as.character(sub), '_encoding.csv'), row.names = F) 
  }
}

make_encodingFiles(50)
