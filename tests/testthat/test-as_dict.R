context("Test Package")

text <- c("This is a good test with some bad words",
          "bad is red and good is green")
df <- data.frame(
   feature = c("good", "bad"),
   bg_colour = c("green", "red"),
   stringsAsFactors = FALSE
)


test_that("Class is right", {
  expect_equal("highlight_dict" %in% class(as_dict(df)), TRUE)
})


test_that("Dimensions are right", {
  expect_equal(dim(as_dict(df)), c(2, 6))
})


# writeLines(
#    highlight(text, as_dict(df),
#              output = "html",
#              return = TRUE),
#    "../files/bg_colour.html",
#    useBytes = TRUE
# )
test_that("highlighting works", {
   expect_equal(
      {
         temp <- tempfile()
         writeLines(
            highlight(text, as_dict(df),
                      output = "html",
                      return = TRUE),
            temp,
            useBytes = TRUE
         )
         readLines(temp)
      },
      readLines("../files/bg_colour.html")
   )
})
