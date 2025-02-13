#' Make a request to the INDRA API
#' @keywords internal
make_indra_request <- function(endpoint, payload) {
  response <- httr::POST(
    url = paste0("https://discovery.indra.bio/api/", endpoint),
    body = jsonlite::toJSON(payload, auto_unbox = TRUE),
    httr::content_type_json()
  )

  if (httr::http_error(response)) {
    stop(
      sprintf(
        "API request failed [%s]: %s",
        httr::status_code(response),
        httr::content(response, "text")
      )
    )
  }

  result <- httr::content(response, "text", encoding = "UTF-8")
  jsonlite::fromJSON(result)
}

#' Perform discrete gene set enrichment analysis using INDRA
#'
#' @param genes List of gene identifiers (HGNC symbols or identifiers)
#' @param method Statistical method to apply)
#' @param alpha Significance level
#' @param keep_insignificant Whether to retain insignificant results
#' @param minimum_evidence_count Minimum number of evidence for inclusion
#' @param minimum_belief Minimum belief score for filtering
#' @param indra_path_analysis Whether to perform INDRA pathway analysis
#' @param background_genes List of background genes
#' @return A list containing results per analysis type as data frames
#' @export
indra_discrete_gsea <- function(
  genes,
  method = "fdr_bh",
  alpha = 0.05,
  keep_insignificant = FALSE,
  minimum_evidence_count = 1,
  minimum_belief = 0,
  indra_path_analysis = FALSE,
  background_genes = NULL
) {
  payload <- list(
    gene_list = genes,
    method = method,
    alpha = alpha,
    keep_insignificant = keep_insignificant,
    minimum_evidence_count = minimum_evidence_count,
    minimum_belief = minimum_belief,
    indra_path_analysis = indra_path_analysis,
    background_gene_list = if (is.null(background_genes)) list() else background_genes
  )

  make_indra_request("discrete_analysis", payload)
}

#' Perform signed analysis using reverse causal reasoning
#' @param positive_genes List of positive gene identifiers
#' @param negative_genes List of negative gene identifiers
#' @inheritParams indra_discrete_gsea
#' @export
indra_signed_analysis <- function(
  positive_genes,
  negative_genes,
  alpha = 0.05,
  keep_insignificant = FALSE,
  minimum_evidence_count = 2,
  minimum_belief = 0
) {
  payload <- list(
    positive_genes = positive_genes,
    negative_genes = negative_genes,
    alpha = alpha,
    keep_insignificant = keep_insignificant,
    minimum_evidence_count = minimum_evidence_count,
    minimum_belief = minimum_belief
  )

  make_indra_request("signed_analysis", payload)
}

#' Perform ranked gene set analysis
#' @param gene_names Vector of gene names
#' @param log_fold_change Vector of log fold changes
#' @param species Species ('rat', 'mouse', or 'human')
#' @param permutations Number of permutations
#' @param source Analysis type ('go', 'reactome', 'wikipathways', 'phenotype', 'indra-upstream', 'indra-downstream')
#' @inheritParams indra_discrete_gsea
#' @export
indra_ranked_analysis <- function(
  gene_names,
  log_fold_change,
  species = c("rat", "mouse", "human"),
  permutations = 100,
  source = c("go", "reactome", "wikipathways", "phenotype", "indra-upstream", "indra-downstream"),
  alpha = 0.05,
  keep_insignificant = FALSE,
  minimum_evidence_count = 2,
  minimum_belief = 0
) {
  species <- match.arg(species)
  source <- match.arg(source)
  payload <- list(
    gene_names = gene_names,
    log_fold_change = log_fold_change,
    species = species,
    permutations = permutations,
    source = source,
    alpha = alpha,
    keep_insignificant = keep_insignificant,
    minimum_evidence_count = minimum_evidence_count,
    minimum_belief = minimum_belief
  )

  make_indra_request("ranked_analysis", payload)
}
