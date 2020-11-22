import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap


def show_boundries(boundries):
    fig, ax = plt.subplots(1, figsize=(12, 8))

    for i, res in enumerate(["h"]):
        m = Basemap(
            projection="gnom",
            lat_0=boundries[0][0][1],
            lon_0=boundries[0][0][0],
            width=90000,
            height=120000,
            resolution=res,
            ax=ax,
        )
        m.fillcontinents(color="#FFDDCC", lake_color="#DDEEFF")
        m.drawmapboundary(fill_color="#DDEEFF")
        m.drawcoastlines()
        ax.set_title("resolution='{0}'".format(res))

    for boundry in boundries:
        for coordinate in boundry:
            x, y = m(coordinate[0], coordinate[1])
            plt.plot(x, y, "ok", markersize=5)

    plt.show()

