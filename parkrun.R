
library(ggplot2)
library(ggvoronoi)   
library(mapproj)
library(dplyr)  
library(sf)          #spatial polygons, for read_rds etc.
library(stringr)


parkruns <- read.csv("http://www.rhoff.org.uk/Full_5k_parkrun_List.csv", sep = ",")  #download from website of Roderick Hoffman
parkrun <- parkruns[parkruns$Country.Name == "Netherlands",]

NLD <- readRDS("gadm36_NLD_1_sp.rds")
NLD_fixed <- subset(NLD, !NLD$NAME_1  %in% c("Zeeuwse meren", "IJsselmeer"))
outl <- raster::aggregate(NLD)

## Adding unofficial parkruns (not in the dowloaded list early January 2024)

parkrun_zuiderpark <- c("eventname" = "Zuiderpark, Hoogeveen", "Longitude" = 6.4835483, "Latitude" = 52.7109916, "Status" = "Planned")
parkrun_enschede <- c("eventname" = "Enschede", "Longitude" = 6.836273, "Latitude" = 52.2206737, "Status" = "Planned")

parkrun2 <- data.frame(rbind(parkrun_zuiderpark, parkrun_enschede))
parkrun2$Longitude <- as.numeric(parkrun2$Longitude)
parkrun2$Latitude <- as.numeric(parkrun2$Latitude)
parkrun <- bind_rows(parkrun, parkrun2)
## end unofficial 

pr1caption <- str_flatten(str_c(c("Voronoi plot (box indicates the nearest parkrun) of ",
                                  nrow(parkrun[parkrun$Status == "Open",]), 
                                  " parkruns in The Netherlands,\n plus the ",
                                  nrow(parkrun[parkrun$Status == "Planned",]), " plan(ned) runs in blue.", sep="")))
#pr1caption

pr1 <- ggplot(NLD_fixed) +
  geom_polygon(
    aes(x = long, y = lat, group = group),
    color = "white",
    linewidth = .2,                                                           # color is the lines of the region
    fill = "orange"
  ) +                                                                         # fill is the fill of every polygon
  stat_voronoi(
    data = parkrun,
    aes(x = Longitude, y = Latitude),
    geom = "path",
    outline = outl,
    color = "black",
    linewidth = .5
  ) +
  geom_point(                                            # official parkruns
    data = parkrun[parkrun$Status=="Open",],
    aes(x = Longitude, y = Latitude),                    # legend values in aes
    colour = "black",
    shape = 21,
    stroke= 1.5,
    fill = "transparent"
  ) +
  geom_point(                                            # unofficial parkruns
    data = parkrun[parkrun$Status=="Planned",],
    aes(x = Longitude, y = Latitude),                    # legend values in aes
    colour = "blue",
    shape = 21,
    stroke= 1.5,
    fill = "transparent"
  ) +
 coord_map() +
 theme_void() +
 labs(caption = pr1caption)

pr1

filename <- paste("pakruns_NL_", format(Sys.time(), "%Y%m%d-%H%M"), ".png", sep = "")
ggsave(filename, height = 800, dpi = 100, units = "px", bg="white")
  

## Only the parkruns (official and unoffical), without country border

ggplot(parkrun) +
  geom_point(aes(x=Longitude, y=Latitude)) +
  stat_voronoi(
    aes(x = Longitude, y = Latitude),
    geom = "path",
    color = "black",
    linewidth = .5) +
  coord_map() 

ggsave("noborder.png", height = 800, dpi = 100, units = "px", bg="white")


