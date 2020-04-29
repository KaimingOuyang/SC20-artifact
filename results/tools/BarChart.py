import math
import numpy as np
from matplotlib.ticker import AutoMinorLocator
from matplotlib.ticker import MaxNLocator

def point_to_inch(point):
    return float(point) / 72.0

def get_default_colors_line(index):
    colors = []
    colors.append("#d11141")
    colors.append((0.266, 0.447, 0.768))
    colors.append((0.929, 0.490, 0.192))
    colors.append((1.000, 0.752, 0.000))
    colors.append((0.149, 0.266, 0.470))
    colors.append((0.619, 0.282, 0.054))
    colors.append((0.647, 0.647, 0.647))
    return colors[index % len(colors)]

def get_default_hatches(index):
    hatches = []
    density = 5
    hatches.append(None)
    hatches.append(None)
    hatches.append("\\\\" * density)
    hatches.append("/////")
    hatches.append("....")
    hatches.append("+++")
    hatches.append("x" * density)

    hatches.append("." * density)
    hatches.append("x" * density)
    hatches.append("\\" * (density + 2))
    hatches.append("/" * (density + 2))
    hatches.append("+" * density)
    hatches.append("-" * (density + 2))
    hatches.append("|" * (density + 2) + "x" * density)
    hatches.append("-" * (density + 2) + "x" * density)
    hatches.append("-" * density + "/" * density)
    hatches.append("-" * density + "\\" * density)
    hatches.append("|" * (density + 2) + "/" * density)
    hatches.append("|" * (density + 2) + "\\" * density)
    hatches.append("x" * density + "+" * density)
    hatches.append("****")
    hatches.append("o")
    hatches.append("O")
    return hatches[index % len(hatches)]

# def get_color_list():
#     colors = []
#     colors.append("#5B9BD5") # blue
#     colors.append("#ED7D31") # orange
#     colors.append("#FFDE03") # yellow
#     colors.append("#70AD47") # green
#     colors.append("#FFC000") # brown
#     colors.append("#800080") # purple
#     colors.append("#FF0266") # red
#     colors.append("#F08080") # pink
#     colors.append("#59B8CC") # light blue
#     colors.append("#E59400") # dark orange
#     colors.append("#DAA520") # dark yellow
#     return colors

def get_default_markers(index):
    markers = []
    markers.append("o")
    markers.append("x")
    markers.append("+")
    markers.append("^")
    markers.append("s")
    markers.append("2")
    markers.append("v")
    markers.append("1")
    markers.append("D")
    markers.append("s")
    markers.append("<")
    markers.append(">")
    markers.append("*")
    markers.append("d")
    return markers[index % len(markers)]

def get_default_colors(index):
    colors = []
    colors.append("#003366")
    colors.append("#E67E22")
    colors.append("#5F005F")
    colors.append("#A2A5C8")
    colors.append("#684D71")
    colors.append("#B2BFCC")

    colors.append((0.929, 0.490, 0.192))
    colors.append((1.000, 0.752, 0.000))
    colors.append((0.356, 0.607, 0.835))
    colors.append((0.439, 0.678, 0.278))
    colors.append((0.619, 0.282, 0.054))
    colors.append((0.647, 0.647, 0.647))
    return colors[index % len(colors)]

def get_default_edgecolors(index):
    edgecolors = []
    edgecolors.append("#003366")
    edgecolors.append("#E67E22")
    edgecolors.append("#8E44AD")
    edgecolors.append("#313566")
    edgecolors.append("#993300")
    edgecolors.append("#474C51")
    edgecolors.append("#D73041")
    edgecolors.append((0.266, 0.447, 0.768))
    edgecolors.append((0.929, 0.490, 0.192))
    edgecolors.append((1.000, 0.752, 0.000))
    edgecolors.append((0.356, 0.607, 0.835))
    edgecolors.append((0.439, 0.678, 0.278))
    edgecolors.append((0.149, 0.266, 0.470))
    edgecolors.append((0.619, 0.282, 0.054))
    edgecolors.append((0.647, 0.647, 0.647))
    return edgecolors[index % len(edgecolors)]

class BarData:
    def __init__(self, data, barlabel, **kwargs):
        self.data = data
        self.barlabel = barlabel
        self.ysecondary = False
        self.errorbar = None
        self.tick_label = None
        self.datatype = "bar"
        for key, value in kwargs.items():
            if key == "ysecondary":
                self.ysecondary = value
            if key == "errorbar":
                self.errorbar = value
class BarChart:
    def __init__(self):
        self.barcnt = 0
        self.grid_linewidth = 0.2
        self.grid_dashes = (0.5, 0.5)
        self.barwidth = 0.4
        self.linewidth = 0.4
        self.sec_linewidth = 1
        self.markersize = 7
        self.yformat_sec = None
        self.secax = None
        self.linecnt = 0
        self.reset_style = False
        self.legends = []
        self.capsize = 2

    def plot(self, databars, xformat, yformat, ax, **kwargs):
        for key, value in kwargs.items():
            if key == "yformat_sec":
                self.yformat_sec = value

        num_bars = 0
        for i in range(0, len(databars)):
            if databars[i].datatype == "bar":
                num_bars += 1

        # set x axis
        major_ticks = []
        minor_ticks = []
        minor_labels = []
        if xformat.tick_label != None:
            major_ticks = np.arange(0, len(xformat.tick_label)) * (num_bars + 1)
            minor_ticks = np.arange(0, len(xformat.tick_label)) * (num_bars + 1) + (1 + num_bars) / 2
            minor_labels = xformat.tick_label
        else:
            major_ticks = np.arange(0, len(databars[0].tick_label)) * (num_bars + 1)
            for i in range(0, len(databars[0].tick_label)):
                for j in range(1, num_bars + 1):
                    minor_ticks.append(i * (num_bars + 1) + j)
                    minor_labels.append(databars[j - 1].tick_label[i])
        ax.set_xticks(major_ticks)
        ax.set_xticks(minor_ticks, minor=True)
        ax.tick_params(axis='x', which='minor', color="w", labelsize=xformat.ticks_font_size)
        ax.tick_params(axis='x', which='major', labelbottom=False, colors="#CCCCCC", labelsize=xformat.ticks_font_size)
        ax.set_xticklabels(minor_labels, minor=True)

        for tick in ax.get_xticklabels(minor=True):
            tick.set_rotation(xformat.rotation)
        if xformat.label_on == True:
            ax.set_xlabel(xformat.axis_label, fontsize = xformat.font_size)

        # set y axis
        ax.tick_params(axis='y', which='major', labelsize=yformat.font_size)
        if yformat.grid_on == True:
            ax.yaxis.grid(which = 'major', linestyle = '--', linewidth = self.grid_linewidth, dashes = self.grid_dashes)
        if yformat.minorticks_on == True:
            ax.yaxis.set_minor_locator(AutoMinorLocator())
        if yformat.scale == "log":
            ax.set_yscale('log')
        elif yformat.scale == "log2":
            ax.set_yscale('log', basey=2)
        if yformat.label_on == True:
            ax.set_ylabel(yformat.axis_label, fontsize = yformat.font_size)
        if yformat.min_value != yformat.max_value:
            ax.set_ylim(yformat.min_value, yformat.max_value)
        if yformat.tick_style != None:
            ax.ticklabel_format(axis='y', style=yformat.tick_style, scilimits=(0,0))

        # ax.yaxis.set_major_locator(MaxNLocator(integer=True))
        
        xtick_sec = None
        if self.yformat_sec != None:
            xtick_sec = np.arange(0, len(major_ticks)) * (num_bars + 1) + (1 + num_bars) / 2
            if self.secax == None:
                self.secax = ax.twinx()
            # if self.yformat_sec.grid_on == True:
            #     self.secax.yaxis.grid(which = 'major', linestyle = '--', linewidth = self.grid_linewidth, dashes = self.grid_dashes)
            if self.yformat_sec.minorticks_on == True:
                self.secax.yaxis.set_minor_locator(AutoMinorLocator())
            if self.yformat_sec.scale == "log":
                self.secax.set_yscale('log')
            if self.yformat_sec.label_on == True:
                self.secax.set_ylabel(self.yformat_sec.axis_label, fontsize = yformat.font_size)
            if self.yformat_sec.min_value != self.yformat_sec.max_value:
                self.secax.set_ylim(self.yformat_sec.min_value, self.yformat_sec.max_value)
            self.secax.tick_params(axis='y', which='major', labelsize=yformat.font_size)

        # show bar at the center of xticks
        if num_bars % 2 == 0:
            shift_base = self.barwidth / 2 + point_to_inch(self.linewidth) / 2.0
        else:
            shift_base = 0
        
        for i in range(0, len(databars)):
            bottom = [0.0 for i in range(0, len(databars[0].data[0]))]
            #shift = (i - int(num_bars / 2)) * (self.barwidth + point_to_inch(self.linewidth) * 3) + shift_base
            if databars[i].ysecondary == True:
                if databars[i].datatype == "line":
                    # print(databars[i].data, "\n", xtick_sec)
                    self.legends.append(self.secax.plot(xtick_sec, databars[i].data, label = databars[i].linelabel, marker = get_default_markers(self.linecnt), linewidth = self.sec_linewidth, markersize = self.markersize, color = get_default_colors_line(self.linecnt))[0])
                    self.linecnt += 1
                else:
                    #print(datalines[i].data)
                    for j in range(0, len(databars[i].data)):
                        ret_lgd = None
                        if j == 0:
                            ret_lgd = self.secax.bar(np.arange(0, len(databars[i].data[j])) * (num_bars + 1) + i + 1, databars[i].data[j], width = self.barwidth, align="center", linewidth = self.linewidth, label = databars[i].barlabel[j], hatch = get_default_hatches(self.barcnt), color = get_default_colors(self.barcnt), edgecolor=get_default_colors(self.barcnt))
                        else:
                            bottom = [bottom[k] + databars[i].data[j - 1][k] for k in range(0, len(databars[i].data[j - 1]))]
                            ret_lgd = self.secax.bar(np.arange(0, len(databars[i].data[j])) * (num_bars + 1) + i + 1, databars[i].data[j], width = self.barwidth, align="center", linewidth = self.linewidth, label = databars[i].barlabel[j], hatch = get_default_hatches(self.barcnt), color = get_default_colors(self.barcnt), edgecolor=get_default_colors(self.barcnt), bottom = bottom)
                        if self.reset_style == True:
                            if i == 0:
                                self.legends.append(ret_lgd)
                        else:
                            self.legends.append(ret_lgd)
                        self.barcnt += 1
            else:
                for j in range(0, len(databars[i].data)):
                    ret_lgd = None
                    #print(databars[i].barlabel[j])
                    if j == 0:
                        ret_lgd = ax.bar(np.arange(0, len(databars[i].data[j])) * (num_bars + 1) + i + 1, databars[i].data[j], width = self.barwidth, align="center", linewidth = self.linewidth, label = databars[i].barlabel[j], hatch = get_default_hatches(self.barcnt), color = get_default_colors(self.barcnt), edgecolor=get_default_edgecolors(self.barcnt), yerr=databars[i].errorbar, capsize=self.capsize)
                    else:
                        bottom = [bottom[k] + databars[i].data[j - 1][k] for k in range(0, len(databars[i].data[j - 1]))]
                        ret_lgd = ax.bar(np.arange(0, len(databars[i].data[j])) * (num_bars + 1) + i + 1, databars[i].data[j], width = self.barwidth, align="center", linewidth = self.linewidth, label = databars[i].barlabel[j], hatch = get_default_hatches(self.barcnt), color = get_default_colors(self.barcnt), edgecolor=get_default_edgecolors(self.barcnt), bottom = bottom, yerr=databars[i].errorbar, capsize=self.capsize)
                    if self.reset_style == True:
                        if i == 0:
                            self.legends.append(ret_lgd)
                    else:
                        self.legends.append(ret_lgd)

                    self.barcnt += 1
            if self.reset_style == True:
                self.barcnt = 0
        return self.legends