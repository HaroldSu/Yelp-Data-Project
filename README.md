# Yelp-Data-Project

## Authors
- Su, Haohao (hsu69@wisc.edu)
- Tang, Runshi (rtang56@wisc.edu)
- Wang, Zijin (zwang2548@wisc.edu)

## Data
- Yelp Data provided in STAT 628
## Goal 
- Provide data-driven analysis on attributes and reviews for business owners. 

## Content: 

### 1.[Data](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data)

- [type](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/type) is a directory containing `.csv` files generating by [sentimentr.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/CHTC/sentimentr.R), with key words as filenames. These file have been grouped by `types`.
- [score.csv](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/score.csv) contains the scores for each `type` and `key_word`, generating by [score.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/score.R) from the `.csv` in [type](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/type) directory.
- [attr_test_result.csv](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/score.csv) contains the output by [attributes_analysis.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/attributes_analysis.R).


### 2.[Code Scripts](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts)

- **WARNING: All the scripts here should be run from the main directory.**
- [filter_data.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/filter_data.R) is used for filter the businesses and corresponding reviews with "**pizza**" in `category` of business data.
- [attributes_analysis.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/attributes_analysis.R) is used for attribute analysis. [filter_data.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/filter_data.R) would be `source` in this script.
- [CHTC/](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/CHTC) is a directory containing scripts to run on CHTC. [sentimentr.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/CHTC/sentimentr.R) will output `.csv` files in [type](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/type).
- [score.R](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/score.R) calculates the scores for each `type` and `key_word` based on `.csv` files in [type](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/type), outputting [score.csv](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/data/score.csv)
- [ShinyApp/](https://github.com/HaroldSu/Yelp-Data-Project/tree/main/scripts/ShinyApp) contains scripts for generating a Shiny App for this project.


### 4. [Summary File](https://github.com/HaroldSu/Yelp-Data-Project/blob/main/summary.pdf)

A four-page file summarizing every effort we make to build up the model. What's more, we give detailed interpretation on how we select the "best" model illustrating the relationship between body fat and some easily measurable factors.


### 5. [README File](https://github.com/HaroldSu/Yelp-Data-Project/blob/main/README.md)

You can always refer to this README file to find the contents of the repository and directions on how to use the code.


# To use the code

Run **git clone https://github.com/HaroldSu/Yelp-Data-Project** in the terminal to clone this repository in the terminal or just click the green "Clone or download" button on the upper right corner to download all the contents as a zipped folder. Unzip the folder, then you can explore the data and excute our codes on your own (keep in mind to always change the working directory to the folder before running the codes) to see how we conducted the analysis. See summary.pdf for details. All codes are in folder scripts. In folder CHTC, there are 2 versions of codes running on CHTC cluster, where one is a for loop on business ID and the other is a for loop on keywords. In folder ShinyApp, there are app related codes.  The plots in the Shiny App are recommanded for further understanding the details of this project.

### [Link to our Shiny App](https://zijinw97.shinyapps.io/ShinyApp/)



