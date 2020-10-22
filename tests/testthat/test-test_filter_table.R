test_that("filter_table()", {
  expect_equal(filter_table(df, "Canada", "confirmed", "2020-01-23", "2020-02-23"),
               df %>%
                 filter(country == "Canada",
                        type == "confirmed",
                        date >= lubridate::ymd("2020-01-23"),
                        date <= lubridate::ymd("2020-02-23")) %>%
                 mutate(Date = as.Date(date)) %>%
                 rename("Amount" = cases) %>%
                 rename("Type" = type))

  expect_error(filter_table(df, "China"))
  expect_error(filter_table(df, "confirmed"))
  expect_error(filter_table(df, "2020-01-23"))
})
