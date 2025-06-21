echo "jobName,repetition,sortType,size,time,partition" > all_results.csv
cat ../results/results*.csv >> all_results.csv
Rscript	gen_plots.R
