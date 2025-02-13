data("covid_related_genes")

test_that("discrete queries work", {
  res <- indra_discrete_gsea(covid_related_genes)
  expect_type(res, "list")
  expect_s3_class(res$go, "data.frame")
  expect_s3_class(res$reactome, "data.frame")
  expect_s3_class(res$wikipathways, "data.frame")
  expect_s3_class(res$phenotype, "data.frame")
  expect_contains(
    res$reactome$name,
    c(
      "Immune System",
      "SARS-CoV Infections",
      "SARS-CoV-2 Infection",
      "Disease"
    )
  )
  expect_contains(
    res$wikipathways$name,
    c(
      "Mitochondrial immune response to SARS CoV 2",
      "Ebola virus infection in host",
      "SARS CoV 2 innate immunity evasion and cell specific immune response"
    )
  )
  expect_contains(
    res$phenotype$name,
    c(
      "Abnormality of immune system physiology",
      "Abnormality of the immune system",
      "Unusual infection"
    )
  )
  expect_contains(
    res$go$name,
    c(
      "interspecies interaction between organisms",
      "immune system process",
      "regulation of cytokine production"
    )
  )
})
