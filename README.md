# Conjoint Analysis of News Consumption in the United States 📊

## Overview 📖

This repository contains the analysis of conjoint survey data, focusing on the determinants of news consumption following the U.S. Supreme Court's decision to overturn *Roe v. Wade*. The analysis explores how factors like outlet headline framing, endorser partisanship, endorser gender, and endorser religiosity influence the likelihood of a news article being chosen by respondents. The results are presented through various statistical models and visualizations.

---

## Folder Structure 🗂️

- **`data/`**: Contains raw and processed data files used in the analysis. This includes datasets necessary for running the analysis.
- **`outputs/`**: Stores the results from the analysis, including regression tables and visualizations.
- **`scripts/`**: Contains the Stata and R scripts used for running the analysis and generating outputs.

---

## Contents 📚

### `data/`
- **`data.csv`**: The cleaned dataset containing the survey responses used for the conjoint analysis.

### `outputs/`
- **`newschoice.txt`, `PartyID1.txt`, `PartyID2.txt`, etc.**: Text files containing the coefficient and standard error results from the Stata regression models, used as input for visualizations.
- **`Table_1.rtf`, `Table_2.rtf`, etc.**: RTF files containing the regression tables for various models, formatted for easy inclusion in reports.
- **Figures**: Plots generated from the R script, saved as PDFs showing the effect of each variable on the likelihood of article selection.

### `scripts/`
- **`estimates.do`**: Stata script that estimates models, generates statistical outputs, and exports results for different subgroups (partisanship, religiosity, gender, etc.).
- **`plots.R`**: R script that generates visualizations of the results using `ggplot2`, including figures for the overall analysis and by subgroups (partisanship, religiosity, gender).

---

## Getting Started 🚀

To reproduce or modify the analysis, follow these steps:

### 1. Prerequisites 🛠️

You will need the following software and packages:
- **Stata** for running the `estimates.do` script.
- **R** (with the `ggplot2` and `ggthemes` libraries) for generating plots using `plots.R`.

You can install the required R libraries by running:

```R
install.packages("ggplot2")
install.packages("ggthemes")
```

### 2. Running the Analysis ▶️

#### Stata Analysis (`estimates.do`)

1. Load your data file (`conjoint_data.dta`) into Stata.
2. Run the `estimates.do` script. This will:
   - Clean and encode the relevant categorical variables.
   - Estimate the regression models for the overall sample, as well as for subgroups based on party affiliation, religiosity, and gender.
   - Export the results to text files (`newschoice.txt`, `PartyID1.txt`, `PartyID2.txt`, etc.) for further analysis in R.

#### R Plots (`plots.R`)

1. After running the Stata analysis, load the exported text files into R.
2. Run the `plots.R` script. This will:
   - Load the regression results.
   - Generate and save visualizations comparing the effect of each variable on the likelihood of article selection, across different subgroups.
   - Output the plots as PDF files (e.g., `Fig1.pdf`, `Fig2.pdf`, etc.).

### 3. Output 📈

- **Figures**: The figures will show the change in the probability of selecting an article, with 95% confidence intervals, for different levels of each factor (e.g., outlet headline, endorser partisanship).
- **Tables**: Regression output tables will be generated for different subgroups (Democrats, Republicans, Religious, Not Religious, Male, Female) and saved as RTF files for easy inclusion in reports.

### 4. Customization ⚙️

You can modify the scripts as needed:
- Change the independent variables or add new factors in the Stata regression models.
- Modify the grouping variables in the R plot scripts to focus on different subgroups of the data.
- Adjust plot aesthetics in `ggplot2` by modifying the `p` object in the `plots.R` script.

---

## Results 📊

The results of the conjoint analysis can be used to understand:
- The impact of political partisanship and religious affiliation on news consumption behavior.
- How gender and religious views influence the perceived credibility or preference for news outlets.
- The overall framing effect of different headlines on the likelihood of article selection.

---

## License 📝

This project is licensed under the [MIT License](LICENSE).

---

## Contact 💬
If you have questions, feel free to contact me at [tdjwalsh@hotmail.com](mailto:tdjwalsh@hotmail.com).
