## Scripts

- **WARNING: All the scripts here should be run from the main directory.**
- [filter_data.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/filter_data.R) is used for filter the businesses and corresponding reviews with "**pizza**" in `category` of business data.
- [attributes_analysis.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/attributes_analysis.R) is used for attribute analysis. [filter_data.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/filter_data.R) would be `source` in this script.
- [CHTC/](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/CHTC) is a directory containing scripts to run on CHTC. [sentimentr.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/CHTC/sentimentr.R) will output `.csv` files in [type](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/type).
- [score.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/score.R) calculates the scores for each `type` and `key_word` based on `.csv` files in [type](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/type), outputting [score.csv](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/score.csv)
- [ShinyApp/](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/ShinyApp) contains scripts for generating a Shiny App for this project.