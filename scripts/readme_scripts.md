## Scripts

- **WARNING: All the scripts here should be run from the main directory.**
- [filter_data.R](scripts/filter_data.R) is used for filter the businesses and corresponding reviews with "**pizza**" in `category` of business data.
- [attributes_analysis.R](scripts/attributes_analysis.R) is used for attribute analysis. [filter_data.R](scripts/filter_data.R) would be `source` in this script.
- [CHTC/](scripts/CHTC) is a directory containing scripts to run on CHTC. [sentimentr.R](scripts/CHTC/sentimentr.R) will output `.csv` files in [type](data/type).
- [score.R](scripts/score.R) calculates the scores for each `type` and `key_word` based on `.csv` files in [type](data/type), outputting [score.csv](data/score.csv)
- [ShinyApp/](scripts/ShinyApp) contains scripts for generating a Shiny App for this project.