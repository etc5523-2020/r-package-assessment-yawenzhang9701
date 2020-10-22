test_that("test_slider_date", {
  function_input <- slider_date("dateInput", "Date:", df$date)

  original_input <- sliderInput("dateInput", "Date:",
                                # min = as.Date("2020-01-22", "%Y-%m-%d"),
                                min = min(df$date),
                                # max = as.Date("2020-10-07", "%Y-%m-%d"),
                                max = max(df$date),
                                value = c(min(df$date), max(df$date)))

  expect_equal(function_input, original_input)

  expect_error(slider_date("dateInput", "Date:"))
  expect_error(slider_date("dateInput", df$date))
})
