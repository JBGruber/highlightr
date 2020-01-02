context("Test plot highlight function")

text <- c("This is a good test with some bad words",
          "bad is red and good is green")

dict <- as_dict(data.frame(
  feature = c("good", "bad"),
  bg_colour = c("green", "red"),
  bold = TRUE,
  italic = TRUE,
  strike_out = TRUE,
  stringsAsFactors = FALSE
))


test_that("highlighting works", {
  expect_error(highlight(text, dict,
                         output = "plot",
                         return = TRUE),
               "Coming soon...")
  expect_error(highlight(text, dict,
                         output = "ggplot",
                         return = TRUE),
               "Coming soon...")
})
