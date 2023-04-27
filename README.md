# Conflict-Mapping-with-Satellite-Data

This repository contains downloaded data from UNOSAT and Sentinel-2 satellites for use in a future machine learning project to automatically identify building destruction in the Syrian city of Raqqa after the American Coalition bombing in 2017.It contains:

**R Scripts**

-   Load and Reshape R: Converts UNOSAT geospatial data to dataframe and changes format

-   Exploratory Data Analysis UNOSAT: Performs basic exploratory data analysis on the UNOSAT data

-   Interactive Raqqa Map: Plots interactive map of destruction of Raqqa using UNOSAT data by destruction type

-   Interactive Map by building: Plots interactive map of destruction of Raqqa using UNOSAT data by building type

-   Reverse Geocoding Geographical Locations: Attempts to use GeoCage API to get more information about damage sites

-   Animated Satellite Imagery: Creates animated GIFF of destruction of Raqqa by stitching together downloaded satellite images

-   Download Sentinel Satellite Data: Custom R function to easily download imagery from the Sentinel Hub API (together with POST body request)

    **Visualisations**

-   raqqa2: Animated GIF made from downloaded satellite images showing damage to Raqqa

-   UNOSAT interactive map: Interactive map of UNOSAT damage showing the types of buildings damaged

    The **Sentinel 2A** and **Sentinel 2LC** libraries contain the downloaded satellite imagery
