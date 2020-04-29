import math
from matplotlib.ticker import AutoMinorLocator
from matplotlib import rc
# def get_color_list():
#     colors = []
#     colors.append("#5B9BD5") # blue
#     colors.append("#ED7D31") # orange
#     colors.append("#70AD47") # green
#     colors.append("#FFC000") # brown
#     colors.append("#800080") # purple
#     colors.append("#FF0266") # red
#     colors.append("#F08080") # pink
#     colors.append("#59B8CC") # light blue
#     colors.append("#E59400") # dark orange
#     colors.append("#DAA520") # dark yellow
#     return colors

def get_default_colors(index):
    colors = []
    colors.append((0.266, 0.447, 0.768))
    colors.append((0.929, 0.490, 0.192))
    colors.append("#651854")
    colors.append("#ce2b37")
    colors.append("#008000")
    # colors.append((1.000, 0.752, 0.000))
    # colors.append((0.356, 0.607, 0.835))
    # colors.append((0.439, 0.678, 0.278))
    colors.append((0.149, 0.266, 0.470))
    colors.append((0.619, 0.282, 0.054))
    # colors.append((0.647, 0.647, 0.647))
    return colors[index % len(colors)]

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

def get_default_linestyle(index):
    lines = []
    lines.append('-')
    lines.append('-')
    lines.append('-')
    lines.append('--')
    lines.append('-.')
    lines.append(':')
    lines.append('dashdot')
    lines.append('--')
    lines.append('-')
    return lines[index]


class LineData:
    def __init__(self, data, linelabel, **kwargs):
        self.data = data
        self.linelabel = linelabel
        self.ysecondary = False
        self.errorbar = None
        self.datatype = "line"
        self.xticks = None
        for key, value in kwargs.items():
            if key == "ysecondary":
                self.ysecondary = value
            if key == "errorbar":
                self.errorbar = value

class LineChart:
    def plot(self, datalines, xformat, yformat, ax):
        # set x axis
        # print([float(v) for v in xformat.tick_label])
        # xvalue = [int(v) for v in xformat.tick_label]
        # ax.set_xticks(range(0, len(xformat.tick_label)))
        # ax.set_xticklabels(xformat.tick_label)
        xvalue = None
        if xformat.min_value != xformat.max_value:
            ax.set_xlim(xformat.min_value, xformat.max_value)

        if xformat.scale == "log":
            xvalue = [int(v) for v in xformat.tick_label]
            ax.set_xscale('log')
        elif xformat.scale == "log2":
            xvalue = [int(v) for v in xformat.tick_label]
            ax.set_xscale('log', basex=2)
        elif xformat.tick_label != None:
            xvalue = range(0, len(xformat.tick_label))
            ax.set_xticks(xvalue)
            ax.set_xticklabels(xformat.tick_label, fontsize = xformat.font_size)

        if xformat.minorticks_on == True:
            ax.xaxis.set_minor_locator(AutoMinorLocator())

        for tick in ax.get_xticklabels():
            tick.set_rotation(xformat.rotation)
        if xformat.minorticks_on == True:
            ax.xaxis.set_minor_locator(AutoMinorLocator())
        if xformat.grid_on == True:
            ax.xaxis.grid(which = 'major', linestyle = '--', linewidth = self.grid_linewidth, dashes = self.grid_dashes)
        # if xformat.minorticks_on == True:
        #     ax.tick_params(axis = 'x', which = 'minor', bottom = False, top = False)
        if xformat.label_on == True:
            ax.set_xlabel(xformat.axis_label, fontsize = xformat.font_size)

        # set y axis
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
        ax.tick_params(axis='y', which='major', labelsize = yformat.font_size)

        for i in range(0, len(datalines)):
            color = get_default_colors(self.linecnt)
            if datalines[i].xticks != None:
                xvalue = datalines[i].xticks
            self.legends.append(ax.plot(xvalue, datalines[i].data, linestyle = get_default_linestyle(self.linecnt), label = datalines[i].linelabel, marker = get_default_markers(self.linecnt), linewidth = self.linewidth, markersize = self.markersize, color = color)[0])
            
            if datalines[i].errorbar != None:
                ax.errorbar(xvalue, datalines[i].data, yerr = datalines[i].errorbar, fmt = "none", ecolor = color, elinewidth = self.linewidth, capsize = self.capsize, capthick = self.errorbar_capthick)
            self.linecnt += 1
        return self.legends

    def __init__(self):
        # init line style
        self.linecnt = 0
        self.linewidth = 0.6
        self.capsize = 1
        self.errorbar_capthick = 0.3
        self.markersize = 7.0
        self.grid_linewidth = 0.2
        self.grid_dashes = (0.5, 0.5)
        self.legends = []


    