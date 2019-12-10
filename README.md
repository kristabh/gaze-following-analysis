# gaze-following
Data and processing scripts for the multi-lab infant gaze following project. 

**Abstract**

Determining the meanings of words requires language learners to attend to what other people say. However, it behooves a young language learner to simultaneously attend to what other people do, for example, following the direction of their eye gaze. Sensitivity to cues such as eye gaze might be particularly important for bilingual infants, as they encounter less consistency between words and objects than monolinguals, and do not always have access to the same word learning heuristics (e.g. mutual exclusivity). We tested the hypothesis that bilingual experience would lead to a more pronounced ability to follow another’s gaze. We used the gaze-following paradigm developed by Senju and Csibra (2008) to test a total of 93 6–9 month-old and 229 12–15 month-old monolingual and bilingual infants, in 11 labs located in 8 countries. 

**Analytic pipeline**

1. Labs collected data via automatic eye trackers and hand-coded video data. Eyetracking data were processed using the gazepath R package.  All raw eyetracking data and preprocesing scripts are available [here](https://drive.google.com/drive/folders/1QyshbUhPxBuzjTTetkJzhCJGcQerq6CA?usp=sharing)
2. Processed eyetracking data were then transferred to the processed_data folder in this repository.  Handcoded looking data are in data_raw-handcoded. Participant data are in data_participants.
3. Data were imported (01_read_and_merge.Rmd), validated (02_variable_validation.Rmd), cleaned by implementing planned exclusions (03_exclusion.Rmd), and analyzed (04_confirmatory_analysis.Rmd)
4. The final analysis of record is reported in /paper/gaze-following-paper.Rmd
