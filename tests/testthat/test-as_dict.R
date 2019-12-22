context("Test Dictionary function")

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
