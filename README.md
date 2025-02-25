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
#> [1] "go"               "indra-downstream" "indra-upstream"   "phenotype"       
#> [5] "reactome"         "wikipathways"
```

For example, all entities that are predicted to affect the query genes
upstream are stored in the `indra-upstream` element:

``` r
head(res[["indra-upstream"]], n = 10)
```

| curie           |      mlp |      mlq | name               | p       | q       |
|:----------------|---------:|---------:|:-------------------|:--------|:--------|
| hgnc:5438       | 37.27190 | 32.58177 | IFNG               | 5.3e-38 | 2.6e-33 |
| mesh:D007239    | 33.69205 | 29.30295 | Infections         | 2e-34   | 5e-30   |
| fplx:Interferon | 31.71050 | 27.49749 | Interferon         | 1.9e-32 | 3.2e-28 |
| fplx:IFNA       | 29.18266 | 25.09459 | IFNA               | 6.6e-30 | 8e-26   |
| hgnc:11892      | 29.05399 | 25.06283 | TNF                | 8.8e-30 | 8.7e-26 |
| chebi:16412     | 27.98291 | 24.07094 | lipopolysaccharide | 1e-28   | 8.5e-25 |
| hgnc:5434       | 25.78337 | 21.93834 | IFNB1              | 1.6e-26 | 1.2e-22 |
| hgnc:6018       | 23.76897 | 19.98193 | IL6                | 1.7e-24 | 1e-20   |
| fplx:Protease   | 23.22356 | 19.48767 | Protease           | 6e-24   | 3.3e-20 |
| hgnc:11362      | 19.87229 | 16.18216 | STAT1              | 1.3e-20 | 6.6e-17 |

These results are acquired by running overrepresentation analysis using
Fisher’s exact test and correcting for multiple comparisons using the
Benjamini-Hochberg (FDR) method with α = 0.05 on genes causally upstream
by one step from all entities in the INDRA database. Analysis was
performed using all human genes as the background set.
