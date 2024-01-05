# Voronoi diagram of parkruns in The Netherlands
A voronoi plot or diagram is helpful to visualise the nearest parkrun in The Netherlands.

It uses the parkruns as mentioned on the website of Roderick Hoffman and uses only the ones which are located in The Netherlands.
Country border and the borders of the provices are available via the [GADM](https://gadm.org/download_country.html) project. A version with the used resultion is also copied in the files.

Voronoi plots are created with the R package ggvoronoi which is available [here](https://github.com/garretrc/ggvoronoi). Due to some recent issues this is currently not available from CRAN but that will hopefully be resolved soon.

The plots look like this for Netherlands with the currently (January 2024) known parkruns : <br>
![NL](/images/pakruns_NL_20240105-2103.png)

This is the version without country border because some questions in a prakrunn statistics forum arose whether the lines are correctly positioned:<br>
![plot without border](/images/noborder.png)


