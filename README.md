[![Build Status](https://travis-ci.org/grattaninstitute/Assessing-2016-Super-tax-reforms.svg?branch=master)](https://travis-ci.org/grattaninstitute/Assessing-2016-Super-tax-reforms)

## Better-targeting-super-breaks-WP
### Assessing the 2016 Budget reforms 

<p style="text-align: right;">Version 1.2.0</p>

by John Daley and Brendan Coates

Winding back superannuation tax breaks is an acid test of our political system, and should be one of the first items of business in the current Parliament.

The Federal Government’s plan to restrict superannuation tax breaks would create a fairer superannuation system more aligned to its purpose of providing income to supplement the Age Pension.

The plan would not only trim overly generous super tax breaks enjoyed by the top 20 per cent of income earners – people wealthy enough to be comfortable in retirement and unlikely to qualify for the Age Pension – it would save about $800 million a year.

The Government’s proposals would affect about 4 per cent of superannuants, almost all with enough income and assets to prevent them from ever qualifying for a part Age Pension.

Claims that the proposed changes would be retrospective are incorrect. Many reforms affect investments made in the past, and no-one suggests they are retrospective. The changes will simply affect taxes paid on future super earnings, and entitlements to make future contributions to super.

Alternative proposals by the Australian Labor Party, which broadly supports the Coalition’s reforms, would save more than $2 billion a year. Many of these alternatives would further align superannuation with its core purpose.

There is broad agreement between the Government’s proposals and the ALP’s policy. If the Government concedes on some of the details to get a deal with the ALP in the Senate, it will probably improve the budget position.

The Government’s considered position is built on principle, supported by the electorate, and our main parties largely agree on both ends and means. In these circumstances, a failure to get reform would signal there is little hope for either budget repair or wider economic reform.

While the superannuation proposals are an important step in the right direction, they are only a step. Even with these reforms, super tax breaks will still overwhelmingly flow to high-income earners. And the long-term cost will remain unsustainable. Further changes will be needed in future.

## Reproducing the document
The document was written as a knitr document (R + LaTeX). You will need an up-to-date installation of R and LaTeX to reproduce the document. Once both are successfully installed, run the following script in a terminal / on the command line:

```
Rscript -e "knitr::knit('Assessing-the-2016-super-tax-reforms.Rnw')"
pdflatex -draftmode Assessing-the-2016-super-tax-reforms.tex
biber Assessing-the-2016-super-tax-reforms
pdflatex -draftmode Assessing-the-2016-super-tax-reforms.tex
pdflatex -interaction=batchmode Assessing-the-2016-super-tax-reforms.tex
```

The first line should generate an error message if required R packages are not installed on your computer. The relevant error message should contain a line of R code to run to install such packages. The script relies on the `grattan` and `taxstats` packages. 






