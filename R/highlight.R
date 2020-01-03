#' Text highlighter
#'
#' @param text A text to be printed with highlighted words.
#' @param dict A data.frame with columns "word" and "colour".
#' @param id A vector of ids which are displayed as headlines.
#' @param case_insensitive Should search for feature be case insensitive?
#' @param output Choose output format.
#' @param return Should the code be returned as an object.
#'
#' @export
#'
#' @examples
#' text <- c("This is a good test with some bad words",
#'           "bad is red and good is green")
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
                      output = c("html", "tex", "ggplot", "plot"),
                      return = FALSE) {

  args <- as.list(match.call()[-1])

  args$output <- NULL

  switch(
    output[1],
    "html"   = do.call("hightlight_html", args),
    "tex"    = do.call("hightlight_tex", args),
    "ggplot" = do.call("hightlight_plot", args),
    "plot"   = do.call("hightlight_plot", args),
    stop("Choose a valid output option.")
  )

}

#' @rdname highlight
#' @export
hightlight_html <- function(text,
                            dict,
                            id = NULL,
                            case_insensitive = TRUE,
                            return = FALSE) {

  if (isTRUE(!"highlight_dict" %in% class(dict))) {
    dict <- as_dict(dict)
  }

  if (isTRUE(is.null(id))) id <- seq_along(text)

  opts <- stringi::stri_opts_regex(
    case_insensitive = case_insensitive
  )

  # strike_out
  replacements <- make_replacement(
    before = "<strike>",
    variable = dict$strike_out,
    x = "$1",
    after = "</strike>"
  )

  # italic
  replacements <- make_replacement(
    before = "<em>",
    variable = dict$italic,
    x = replacements,
    after = "</em>"
  )

  # bold
  replacements <- make_replacement(
    before = "<strong>",
    variable = dict$bold,
    x = replacements,
    after = "</strong>"
  )

  # txt_colour
  replacements <- make_replacement(
    before = "<span style='color:",
    variable = dict$txt_colour,
    mid = "'>",
    x = replacements,
    after = "</span>"
  )

  # bg_colour
  replacements <- make_replacement(
    before = "<span style='background-color: ",
    variable = dict$bg_colour,
    mid = "'>",
    x = replacements,
    after = "</span>"
  )


  out <- stringi::stri_replace_all_regex(
    text,
    paste0("(", dict$feature, ")"),
    replacements,
    vectorize_all = FALSE,
    opts_regex = opts
  )

  out <- c(rbind(paste0("<strong>", id, ":</strong>\n<p>"),
                 out,
                 "\n</p>\n"))

  if (interactive()) {

    tmpf <- paste0(tempfile(), ".html")
    writeLines(out, tmpf)

    if (Sys.getenv("RSTUDIO") == "1") {
      rstudioapi::viewer(tmpf)
    } else {
      utils::browseURL(paste0("file://", tmpf))
    }

  } else {

    cat(out)

  }

  if (return) {

    return(out)

  }
}


#' @rdname highlight
#' @export
hightlight_tex <- function(text,
                           dict,
                           id = NULL,
                           case_insensitive = TRUE,
                           return = FALSE) {

  if (isTRUE(!"highlight_dict" %in% class(dict))) {
    dict <- as_dict(dict)
  }

  dict$bg_colour <- tolatexrgb(dict$bg_colour)
  dict$txt_colour <- tolatexrgb(dict$txt_colour)

  if (isTRUE(is.null(id))) id <- seq_along(text)

  opts <- stringi::stri_opts_regex(
    case_insensitive = case_insensitive
  )

  # italic
  replacements <- make_replacement(
    before = "\\\\textit{",
    variable = dict$italic,
    x = "$1",
    after = "}"
  )

  # bold
  replacements <- make_replacement(
    before = "\\\\textbf{",
    variable = dict$bold,
    x = replacements,
    after = "}"
  )

  # bg_colour
  replacements <- make_replacement(
    before = "\\\\definecolor{temp}{rgb}{",
    variable = dict$bg_colour,
    mid = "}\\\\sethlcolor{temp}\\\\hl{",
    x = replacements,
    after = "}"
  )

  # strike_out
  # Can't be combined with highlight in soul. Still looking
  # for solution
  if (!any(nchar(dict$bg_colour) > 0)) {
    replacements <- make_replacement(
      before = "\\\\st{",
      variable = dict$strike_out,
      x = replacements,
      after = "}"
    )
  } else if (interactive()) {
    warning("strike_out and background colours conflict in",
            " the LaTeX soul package which is why strike_out",
            " is ignored when any background colour is set.")
  }

  # txt_colour
  replacements <- make_replacement(
    before = "\\\\textcolor[rgb]{",
    variable = dict$txt_colour,
    mid = "}{",
    x = replacements,
    after = "}"
  )

  out <- stringi::stri_replace_all_regex(
    text,
    paste0("(", dict$feature, ")"),
    replacements,
    vectorize_all = FALSE,
    opts_regex = opts
  )

  out <- c(rbind(paste0("\\textbf{", id, "} \\par"),
                 out,
                 "\\par"))


  if (return) {
    return(out)
  } else {
    cat(out)
  }

}


#' @rdname highlight
#' @export
hightlight_plot <- function(text,
                            dict,
                            id = NULL,
                            case_insensitive = TRUE,
                            return = FALSE) {
  stop("Coming soon...")
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


#' Internal function to make the replacement patterns
#'
#' @param x The feature to include in the replacement.
#' @param variable A character or logical variable. Character variables are
#'   placed between 'before' and 'mid'.
#' @param before,mid,after Strings placed before and after x or between variable
#'   and x ('mid').
#'
#' @noRd
make_replacement <- function(before, variable, mid, x, after) {

  if (is.character(variable)) {
    test <- nchar(variable) > 0
  } else if (is.logical(variable)) {
    test <- variable
    variable <- NULL
  }

  if (missing(mid)) {
    mid <- NULL
  }

  ifelse(
    test,
    paste0(before, variable, mid, x, after),
    x
  )
}


#' Convert colours to Latex RGB specification
#'
#' @param cols Either one or multiple colour names, hexadecimal strings or
#'   integer values.
#'
#' @importFrom grDevices col2rgb rgb
#' @noRd
tolatexrgb <- function(cols) {
  not_emtpy <- nchar(cols) > 0
  temp <- grDevices::col2rgb(cols[not_emtpy]) / 255
  temp <- apply(temp, MARGIN = 2, FUN = paste0, collapse = ",")
  cols[not_emtpy] <- temp
  return(cols)
}
