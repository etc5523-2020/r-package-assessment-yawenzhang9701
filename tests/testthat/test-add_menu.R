test_that("add_menu()", {
  expect_equal(add_menu("Map", "Map", "map-marked-alt"),
               shinydashboard::menuItem("Map", tabName = "Map", icon = icon("map-marked-alt")))

  expect_error(add_menu("Map","map-marked-alt"))
})

