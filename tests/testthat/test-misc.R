context("Test Dictionary function")

df <- data.frame(
   feature = c("good", "bad"),
   stringsAsFactors = FALSE
)


test_that("Class is right", {
  expect_equal("highlight_dict" %in% class(as_dict(df)), TRUE)
})


test_that("Dimensions are right", {
  expect_equal(dim(as_dict(df)), c(2, 6))
})

test_that("error messages", {
   expect_error(as_dict(as.matrix(df)),
                "x must be a data.frame.")
   expect_error(as_dict(data.frame()),
                "No feature column was found in x.")
   expect_error(highlight(text, dict,
                          output = "test",
                          return = TRUE),
                "Choose a valid output option.")
})
