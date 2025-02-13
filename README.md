# indra.gsea

This package provides a simple interface for Gene Set Enrichment
Analysis (GSEA) using the [INDRA Biomedical Discovery
Engine](https://discovery.indra.bio/). The Biomedical Discovery Engine
is built on INDRA CoGEx, a graph database integrating causal relations,
ontological relations, properties, and data, assembled at scale
automatically from the scientific literature and structured sources.

## Installing

The pre-release version of the package can be pulled from GitHub using
the [remotes](https://cran.r-project.org/package=remotes) package:

``` r
# install.packages("remotes")
remotes::install_github("clemenshug/indra.gsea")
```

## Usage

Query genes can be either [HGNC](https://www.genenames.org/) gene
symbols or IDs. The package contains an example set of gene IDs related
to COVID-19 infection.

``` r
library(indra.gsea)

data("covid_related_genes")

head(covid_related_genes)
#> [1] "613"  "1116" "1119" "1697" "7067" "2537"

res <- indra_discrete_gsea(covid_related_genes)
```

The result is a list with the following elements:

``` r
names(res)
#> [1] "go"           "phenotype"    "reactome"     "wikipathways"
```

For example, enriched Reactome pathways can be accessed as follows:

``` r
head(res$reactome, n = 10)
```

| curie | mlp | mlq | name | p | q |
|:------------|-----:|-----:|:------------------------------------|:-----|:-----|
| reactome:R-HSA-168256 | 36.37890 | 32.95944 | Immune System | 4.2e-37 | 1.1e-33 |
| reactome:R-HSA-9679506 | 35.85212 | 32.73369 | SARS-CoV Infections | 1.4e-36 | 1.8e-33 |
| reactome:R-HSA-9694516 | 32.92940 | 29.98706 | SARS-CoV-2 Infection | 1.2e-33 | 1e-30 |
| reactome:R-HSA-1643685 | 32.07391 | 29.25651 | Disease | 8.4e-33 | 5.5e-30 |
| reactome:R-HSA-5663205 | 31.69592 | 28.97543 | Infectious disease | 2e-32 | 1.1e-29 |
| reactome:R-HSA-9824446 | 30.81957 | 28.17826 | Viral Infection Pathways | 1.5e-31 | 6.6e-29 |
| reactome:R-HSA-9705683 | 28.21635 | 25.64199 | SARS-CoV-2-host interactions | 6.1e-29 | 2.3e-26 |
| reactome:R-HSA-9705671 | 25.43664 | 22.92027 | SARS-CoV-2 activates/modulates innate and adaptive immune responses | 3.7e-26 | 1.2e-23 |
| reactome:R-HSA-1280215 | 25.30356 | 22.83834 | Cytokine Signaling in Immune system | 5e-26 | 1.5e-23 |
| reactome:R-HSA-168249 | 18.86643 | 16.44697 | Innate Immune System | 1.4e-19 | 3.6e-17 |
