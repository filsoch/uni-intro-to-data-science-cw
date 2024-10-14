### Introduction
This repository contains code for my university coursework project from Intro to Data Science module. This coursework project focused on the impact of socioeconomic factors on all-cause mortality in England. The IMD was used to measure
deprivation across different areas in England, accounting for factors like income, employment, education, health, and living conditions.
- The **Charts** folder contains charts and tables that I've used in my coursework
- Regression model summary statistics (such as R^2 values, AIC, coefficients, etc.) are contained in multiple_regression_summary.txt and simple_regression_summary.txt text files
- This repo **DOES NOT** contain the written part of my coursework, just the code and charts/tables.
- Below I give a brief summary of the written part of the coursework

## Coursework Summary

### Literature Review
Previous studies have established the relationship between socioeconomic status and health outcomes. The coursework cited research showing that people in deprived areas have a higher risk of premature death,
poor clinical outcomes, and a greater prevalence of illnesses. The literature review also highlighted that although socioeconomic factors influence overall mortality, their impact varies depending on specific diseases.
The lack of healthcare access, poor living conditions, and low education levels are commonly cited as contributors to higher mortality risks in academic literature.

### Research Questions
The study aimed to answer two primary research questions:

RQ1: What factors influence health deprivation in England?

RQ2: What are the best predictors of higher all-cause mortality for people living in England?

### Methodology
The study is based on secondary data analysis of the 2019 IMD dataset, which categorizes deprivation into seven domains (e.g., income, employment, health) across 32,844 areas in England. The key variable of interest is the Health Deprivation and Disability (HDD) score, which reflects an area's overall health deprivation.

Steps in Analysis:
- Comparative Analysis: Comparison between the 100 most and least health-deprived areas based on IMD domains.
- Correlation Analysis: Conducted to identify which variables are most correlated with the HDD score. Variables with a correlation coefficient below 0.3 were removed.
- Simple and Multiple Linear Regression: Used to predict health deprivation using the most correlated variables.
### Results and Discussion
- Comparative Analysis: Showed that areas with high health deprivation also exhibited high income and employment deprivation. Interestingly, barriers to housing and living environment factors did not show a strong correlation with health deprivation.

- Correlation Analysis: Revealed that the Employment Deprivation score had the highest correlation with health deprivation, followed closely by the overall IMD score.

- Simple Linear Regression: A model using only the Employment Deprivation score explained approximately 70% of the variance in the Health Deprivation and Disability score.

- Multiple Linear Regression: By including 15 independent variables, the model's explanatory power increased to approximately 85% as measured by the model's R^2 values. Income and employment factors had the most significant impact on health deprivation.

### Conclusion
The study concluded that income and employment are the strongest predictors of health deprivation in England, confirming previous research findings. However, it also noted the absence of a strong correlation with factors such as the living environment, which contradicts some prior studies.

### Limitations
The analysis had several limitations:

Data Limitation: Only the 2019 IMD dataset was used. Including data from other years or regions could have improved the robustness of the results.
High Collinearity: The high correlation among predictor variables could affect the reliability of the regression models.
Use of Secondary Data: The study was based entirely on secondary data, which limited its scope. A longitudinal study involving participants could provide more detailed insights into mortality risks.
Code Implementation
The coursework outlines steps in data analysis using R, including:

Data Preprocessing: Preparing the IMD dataset by selecting relevant variables.
Correlation Analysis: Creating a correlation matrix and filtering variables.
Linear Regression Modeling: Developing simple and multiple linear regression models, evaluating them using metrics such as R² and SSE, and interpreting the coefficients.
The findings demonstrate the importance of socioeconomic factors, particularly employment, in influencing health outcomes. Overall, the coursework provides insights into using data analysis for understanding the social determinants of health and guides future research into effective public health interventions.
