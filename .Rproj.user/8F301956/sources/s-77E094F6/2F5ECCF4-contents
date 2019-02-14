#' Text highlighter
#'
#' @param text A text to be printed with highlighted words.
#' @param dict A data.frame with columns "word" and "colour".
#' @param id A vector of ids which are displayed as headlines.
#' @param case_insensitive Should search for feature be case insensitive?
#' @param output Choose output format.
#'
#' @export
#'
#' @examples
#' text <- c("This is a good test with some bad words", "bad is red and good is green")
#' df <- data.frame(
#'   feature = c("good", "bad"),
#'   bg_colour = c("green", "red"),
#'   txt_colour = c("grey", "blue"),
#'   bold = TRUE,
#'   italic = TRUE,
#'   strike_out = TRUE,
#'   stringsAsFactors = FALSE
#' )
#' mydict <- as_dict(df)
#' highlight(text, mydict)
#'
highlight <- function(text,
                      dict,
                      id = NULL,
                      case_insensitive = TRUE,
                      output = c("html", "tex")) {
  if (isTRUE(output[1] == "tex")) {
    stop("Coming soon...")
  }
  if (isTRUE(!"highlight_dict" %in% class(dict))) {
    dict <- as_dict(dict)
  }

  if (isTRUE(is.null(id))) id <- seq_along(text)

  temp <- NULL

  for (i in seq_along(text)) {

    temp <- c(temp, paste0("<strong>", id[i], ":</strong>\n<p>"))

    # bg_colour
    for (j in seq_along(id)) {
      text[i] <- stringi::stri_replace_all_fixed(
        str = text[i],
        pattern = dict$feature[j],
        replacement = paste0("<span style='background-color: ",
                             dict$bg_colour[j], "'>",
                             dict$feature[j], "</span>"),
        opts_fixed = stringi::stri_opts_fixed(case_insensitive = case_insensitive)
      )
    }

    # txt_colour
    for (j in seq_along(id)) {
      if (dict$txt_colour[j] != "black") {
        text[i] <- stringi::stri_replace_all_fixed(
          str = text[i],
          pattern = dict$feature[j],
          replacement = paste0(" <font color='",
                               dict$txt_colour[j], "'>",
                               dict$feature[j], "</font>"),
          opts_fixed = stringi::stri_opts_fixed(case_insensitive = case_insensitive)
        )
      }
    }

    # bold
    for (j in seq_along(id)) {
      if (dict$bold[j]) {
        text[i] <- stringi::stri_replace_all_fixed(
          str = text[i],
          pattern = dict$feature[j],
          replacement = paste0("<strong>", dict$feature[j], "</strong>"),
          opts_fixed = stringi::stri_opts_fixed(case_insensitive = case_insensitive)
        )
      }
    }

    # italic
    for (j in seq_along(id)) {
      if (dict$italic[j]) {
        text[i] <- stringi::stri_replace_all_fixed(
          str = text[i],
          pattern = dict$feature[j],
          replacement = paste0("<em>", dict$feature[j], "</em>"),
          opts_fixed = stringi::stri_opts_fixed(case_insensitive = case_insensitive)
        )
      }
    }

    # strike_out
    for (j in seq_along(id)) {
      if (dict$strike_out[j]) {
        text[i] <- stringi::stri_replace_all_fixed(
          str = text[i],
          pattern = dict$feature[j],
          replacement = paste0("<strike>", dict$feature[j], "</strike>"),
          opts_fixed = stringi::stri_opts_fixed(case_insensitive = case_insensitive)
        )
      }
    }

    temp <- c(temp, paste0(text[i]))
    temp <- c(temp, paste0("\n</p>\n"))

  }
  if (interactive()) {

    tmpf <- paste0(tempfile(), ".html")
    writeLines(temp, tmpf)

    if (Sys.getenv("RSTUDIO") == "1") {
      rstudioapi::viewer(tmpf)
    } else {
      utils::browseURL(paste0("file://", tmpf))
    }

  } else {

    cat(temp)

  }
}


#' Construct dictionary
#'
#' Construct a dictionary which controls the highlighting of text.
#'
#' @param x A data.frame with columns of switches to determine text
#'   highlighting. Not all columns need to be present.
#' @param feature Name of column that contains the words of terms to highlight.
#' @param bg_colour Name of column that controls the background colour for a
#'   feature
#' @param txt_colour Name of column that controls the text colour for a feature.
#' @param bold Name of column that controls if a feature is printed with bold
#'   font.
#' @param italic Name of column that controls if a feature is printed with
#'   italic font.
#' @param strike_out Name of column that controls if a feature is printed
#'   struck out.
#'
#' @details The columns "bold", "italic" and "strike_out" need to contain
#'   logical values (i.e. TRUE/FALSE)
#'
#' @importFrom tibble tibble
#' @export
#'
#' @examples
#' df <- data.frame(
#'   feature = c("good", "bad"),
#'   bg_colour = c("green", "red"),
#'   txt_colour = c("grey", "blue"),
#'   bold = TRUE,
#'   italic = TRUE,
#'   strike_out = TRUE,
#'   stringsAsFactors = FALSE
#' )
#' mydict <- as_dict(df)
as_dict <- function(x,
                    feature = "feature",
                    bg_colour = "bg_colour",
                    txt_colour = "txt_colour",
                    bold = "bold",
                    italic = "italic",
                    strike_out = "strike_out") {
  if (isTRUE(!"data.frame" %in% class(x))) {
    stop("x must be a data.frame.")
  }
  if (isTRUE(!feature %in% names(x))) {
    stop("No feature column was found in x.")
  }
  if (isTRUE(!bg_colour %in% names(x))) {
    x$bg_colour <- ""
  }
  if (isTRUE(!txt_colour %in% names(x))) {
    x$txt_colour <- ""
  }
  if (isTRUE(!bold %in% names(x))) {
    x$bold <- FALSE
  }
  if (isTRUE(!italic %in% names(x))) {
    x$italic <- FALSE
  }
  if (isTRUE(!strike_out %in% names(x))) {
    x$strike_out <- FALSE
  }
  out <- tibble::tibble(
    feature = x[[feature]],
    bg_colour = x[[bg_colour]],
    txt_colour = x[[txt_colour]],
    bold = x[[bold]],
    italic = x[[italic]],
    strike_out = x[[strike_out]]
  )
  class(out) <- c(class(out), "highlight_dict")
  return(out)
}
