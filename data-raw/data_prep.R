
# this is not the right idea, unfort

shpFiles <- load_shape_files( )

use_data(shpFiles, overwrite = TRUE)


basemap <- create_basemap()

use_data(basemap, overwrite = TRUE)


gauge_data <- load_gauge_data( )

use_data(gauge_data, overwrite = TRUE)

bins <- seq(from = 0,
            to = 4, 
            by = 1
)

cols <- c("#CCFFFF", 
          "#FFEF00",
          "#FFB300",
          "#EB1F08",
          "#8D1002"
)
pal <- colorBin(cols, 
                domain = shpFiles[['nowcast_polygons_5km']]$drisk, 
                bins = bins, 
                na.color = "transparent")

leaf_reefs <- mapFun(layerNames = c('nowcast_polygons_5km', 
                                    'one_month_forecast_polygons_5km',
                                    'two_month_forecast_polygons_5km',
                                    'three_month_forecast_polygons_5km',
                                    'polygons_GBRMPA_zoning',
                                    'polygons_management_zoning'),
                     groupNames = c('Nowcast',
                                    'One month forecast',
                                    'Two month forecast',
                                    'Three month forecast',
                                    'GBRMPA nowcast',
                                    'Management area nowcast'))


use_data(leaf_reefs, overwrite = TRUE)


