#!/usr/bin/env python3

"""
*Script para plotear dos o más columnas
de uno o más archivos en un sólo gráfico.
*La numeración que se considera para las columnas comienza en 1 y no en 0.
*Se ejecuta en el directorio donde están los datos:
plt FILE_1 FILE_2 FILE_3 ...
"""

# General setup
import matplotlib.pyplot as plt

import pandas as pd
import sys
import os.path


# rc Parameters
plt.rc("font", family="serif", size=12)
plt.rcParams["axes.formatter.limits"] = [-2, 5]


# Read
def Read(filename):
    return pd.read_csv(filename, sep=r"\s+", float_precision="high")


# Main
if __name__ == "__main__":
    # Chequeo la cantidad de argumentos que se pasaron
    if len(sys.argv) < 2:
        sys.exit("\n***ERROR: Ingrese al menos el nombre de UN archivo***\n")

    # Columnas
    cols = input("Columnas a plotear [Primero X y luego las Y] = ").split()
    cols = [int(col) - 1 for col in cols]

    if len(cols) < 2:
        sys.exit(
            "\n***ERROR: Ingrese a lo sumo" "una columna para X y otra para Y***\n"
        )

    # Rango
    rango = input("Rango [Enter para rango completo] = ").split()

    if rango and len(rango) > 2:
        sys.exit("\n***ERROR: Ingrese a lo sumo dos valores***\n")

    else:
        min_value = float(rango[0]) if rango else []
        max_value = float(rango[1]) if (rango and len(rango) == 2) else []

    # Axes
    fig, ax = plt.subplots()

    # Markers
    markers = ["|", "x", "s", "p", "o", "^", "*", "d"]

    # Plots
    for i, filename in enumerate(sys.argv[1:]):
        # Read
        if os.path.isfile(filename):
            df = Read(filename)

        else:
            sys.exit("\n***ERROR: El archivo " + filename + " no existe***\n")

        # Rango
        col_x = df.index if cols[0] == -1 else df.iloc[:, cols[0]]

        if min_value != []:

            if max_value != []:

                if max_value <= min_value:
                    sys.exit(
                        "\n***ERROR: El máximo" "no puede ser menor al mínimo***\n"
                    )
                else:
                    df = df[(col_x >= min_value) & (col_x <= max_value)]
                    col_x = col_x[(col_x >= min_value) & (col_x <= max_value)]

            else:
                df = df[col_x >= min_value]
                col_x = col_x[col_x >= min_value]

        # Label
        label = filename[:-4]
        label = "".join([" " if char == "_" else char for char in list(label)])

        # Plot
        for j, col in enumerate(cols[1:]):
            ax.plot(
                col_x,
                df.iloc[:, col],
                marker=markers[(i * len(cols[1:]) + j) % 8],
                markersize=6,
                markeredgewidth=0.5,
                markerfacecolor="None",
                lw=1,
                c="C" + str((i * len(cols[1:]) + j) % 10),
                label=label + " - col " + str(col + 1),
            )

    # Legend, ticks and grid
    ax.legend()
    ax.minorticks_on()
    ax.grid(b=True, which="major", axis="both", color="C7", linestyle="--")

    # Show
    plt.subplots_adjust(left=0.1, right=0.95, bottom=0.1, top=0.95)
    plt.show()
