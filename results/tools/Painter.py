import sys
import numpy as np
import matplotlib.pyplot as pyplot
from LineChart import LineChart
from LineChart import LineData
from BarChart import BarChart
from BarChart import BarData


def clean_head_tail_line(strline):
    while strline != "" and (strline[0] == "\t" or strline[0] == " "):
        strline = strline[1:]

    while strline != "" and (strline[-1] == "\n" or strline[-1] == "\t" or strline[-1] == " "):
        strline = strline[:-1]
    return strline

def get_default_fontsize():
    return 6.5

def cm2in(cm):
    return cm / 2.54

class AxisFormat:
    def __init__(self, **kargs):
        # label : "string" | ""
        self.axis_label = ""
        # scale : "log" | "linear"
        self.scale = "linear"

        # ylim low boundary
        self.min_value = 0.0
        # ylim low boundary
        self.max_value = 0.0

        self.tick_label = None
        self.font_size = 14
        self.ticks_font_size = 8
        self.rotation = 0
        self.label_on = True

        self.minorticks_on = False
        self.grid_on = True

        self.tick_style = None

        for key, value in kargs.items():
            if key == "rotation":
                self.rotation = value
            elif key == "minorticks_on":
                self.minorticks_on = value
            elif key == "grid_on":
                self.grid_on = value
            elif key == "tick_num":
                self.tick_num = value
            elif key == "tick_label":
                self.tick_label = tick_label
            elif key == "min_value":
                self.min_value = value
            elif key == "max_value":
                self.max_value = value
            elif key == "label_on":
                self.label_on = value
        return

class Painter:
    def __init__(self, inputfile, outputfile, **kargs):
        self.figsize = (5.7, 3.5)
        self.figure = pyplot.figure(figsize=self.figsize, dpi = 160, facecolor = 'w', edgecolor = 'k')
        self.ax = pyplot.gca()
        self.paint_funcs = {}
        self.legend_ncol = 2
        self.legend_linewidth = 0.0
        self.legend_fontsize = 1.8 * get_default_fontsize()
        self.setup_paint_funcs()
        self.outputfile = outputfile
        self.ysecline = None
        self.chart = None
        self.next = None
        self.legends = []
        self.title = None
        self.legend_on = True
        self.loc = None
        self.shadow = False
        self.xformat = AxisFormat(minorticks_on=False)
        self.yformat = AxisFormat(minorticks_on=True)
        self.yformat_sec= None
        self.delimiter = "\t"
        for key, value in kargs.items():
            if key == "delimiter":
                self.delimiter = value

        self.parse_inputfile(inputfile)
    def set_xrotation(self):
        self.xformat.rotation = int(clean_head_tail_line(self.file.readline()))
    def set_xtick(self):
        self.xformat.tick_label = clean_head_tail_line(self.file.readline()).split(self.delimiter)
    def set_xtick_each(self):
        index = len(self.data) - 1 
        self.data[index].xticks = [float(x) for x in clean_head_tail_line(self.file.readline()).split(self.delimiter)]

    def set_xlabel(self):
        self.xformat.axis_label = clean_head_tail_line(self.file.readline())
    def set_ylabel(self):
        self.yformat.axis_label = clean_head_tail_line(self.file.readline())
    def set_ylim(self):
        ylim = [float(y) for y in clean_head_tail_line(self.file.readline()).split(self.delimiter)]
        self.yformat.min_value = ylim[0]
        self.yformat.max_value = ylim[1]

    def set_xlim(self):
        xlim = [float(x) for x in clean_head_tail_line(self.file.readline()).split(self.delimiter)]
        self.xformat.min_value = xlim[0]
        self.xformat.max_value = xlim[1]

    def assign_title(self):
        self.title = clean_head_tail_line(self.file.readline())
    def assign_position(self):
        # x, y, index
        pos = [int(n) for n in clean_head_tail_line(self.file.readline()).split(self.delimiter)]
        if pos[0] != 1 or pos[1] != 1:
            pyplot.subplot(pos[0], pos[1], pos[2])
        self.ax = pyplot.gca()

    def set_figsize(self):
        self.figsize = (float(v) for v in clean_head_tail_line(self.file.readline()).split(self.delimiter))
        self.figure.set_size_inches(self.figsize)

    def set_legend_ncol(self):
        self.legend_ncol = int(clean_head_tail_line(self.file.readline()))

    def create_chart(self):
        self.chart_type = clean_head_tail_line(self.file.readline())
        if self.chart_type == "LineChart" and self.chart == None:
            self.chart = LineChart()
        elif self.chart_type == "BarChart" and self.chart == None:
            self.xformat.grid_on = False
            self.chart = BarChart()

    def reset_style(self):
        reset_style = clean_head_tail_line(self.file.readline())
        if reset_style == "True" or reset_style == "true" or reset_style == "1":
            self.chart.reset_style = True

    def add_line(self):
        linelabel = clean_head_tail_line(self.file.readline())
        # print(linelabel)
        data = [float(x) for x in clean_head_tail_line(self.file.readline()).split(self.delimiter)]
        # print(data)
        line = LineData(data, linelabel)
        self.data.append(line)

    def add_bar(self):
        barlabel = [clean_head_tail_line(self.file.readline())]
        data = [[float(x) for x in clean_head_tail_line(self.file.readline()).split(self.delimiter)]]
        bar = BarData(data, barlabel)
        self.data.append(bar)

    def add_stackbar(self):
        barlabel = []
        data = []
        num_stack = int(clean_head_tail_line(self.file.readline()))
        for i in range(0, num_stack):
            barlabel.append(clean_head_tail_line(self.file.readline()))
            data.append([float(x) for x in clean_head_tail_line(self.file.readline()).split(self.delimiter)])
        staskbar = BarData(data, barlabel)
        self.data.append(staskbar)

    def add_secline(self):
        if self.yformat_sec == None:
            self.yformat_sec = AxisFormat()
        linelabel = clean_head_tail_line(self.file.readline())
        data = [float(x) for x in clean_head_tail_line(self.file.readline()).split(self.delimiter)]
        line = LineData(data, linelabel, ysecondary = True)
        self.data.append(line)

    def add_secbar(self):
        if self.yformat_sec == None:
            self.yformat_sec = AxisFormat()
        barlabel = [clean_head_tail_line(self.file.readline())]
        data = [[float(x) for x in clean_head_tail_line(self.file.readline()).split(self.delimiter)]]
        bar = BarData(data, barlabel, ysecondary = True)
        self.data.append(bar)

    def set_legend_loc(self):
        loc = clean_head_tail_line(self.file.readline())
        if loc == "top":
            self.loc = "lower left"
            self.bbox_to_anchor = (-0.02, 1.01)
        elif loc == "right":
            self.loc = "center left"
            self.bbox_to_anchor = (1.04, 0.5)
        elif loc == "lower right":
            self.loc = "lower left"
            self.bbox_to_anchor = (1.04, 0)
        elif loc == "upper right":
            self.loc = "upper left"
            self.bbox_to_anchor = (1.02, 1)
        elif loc == "bottom right":
            self.loc = "center"
            self.bbox_to_anchor = (1.04, -0.3)

    def set_barwidth(self):
        if self.chart == None:
            self.xformat.grid_on = False
            self.chart = BarChart()
        self.chart.barwidth = float(clean_head_tail_line(self.file.readline()))
    def set_yseclabel(self):
        if self.yformat_sec == None:
            self.yformat_sec = AxisFormat()
        self.yformat_sec.axis_label = clean_head_tail_line(self.file.readline())
    def set_yseclim(self):
        if self.yformat_sec == None:
            self.yformat_sec = AxisFormat()
        ylim = [float(y) for y in clean_head_tail_line(self.file.readline()).split(self.delimiter)]
        self.yformat_sec.min_value = ylim[0]
        self.yformat_sec.max_value = ylim[1]

    def set_ysecline(self):
        self.ysecline = clean_head_tail_line(self.file.readline())
    def set_next(self):
        self.next = clean_head_tail_line(self.file.readline())
    def set_yscale(self):
        self.yformat.scale = clean_head_tail_line(self.file.readline())
    def set_xscale(self):
        self.xformat.scale = clean_head_tail_line(self.file.readline())

    def set_legend_shadow(self):
        shadow = clean_head_tail_line(self.file.readline())
        if shadow == "True" or shadow == "true" or shadow == "1":
            self.shadow = True
            
    def set_legend_on(self):
        legend_on = clean_head_tail_line(self.file.readline())
        if legend_on == "False" or legend_on == "false" or legend_on == "0":
            self.legend_on = False

    def set_legend_linewidth(self):
        self.legend_linewidth = float(clean_head_tail_line(self.file.readline()))

    def set_legend_fontsize(self):
        self.legend_fontsize = float(clean_head_tail_line(self.file.readline()))
    
    def set_linewidth(self):
        if self.chart == None:
            self.chart = LineChart()
        self.chart.linewidth = float(clean_head_tail_line(self.file.readline()))

    def set_linecnt(self):
        if self.chart == None:
            self.chart = LineChart()
        self.chart.linecnt = int(clean_head_tail_line(self.file.readline()))

    def set_legend_anchor(self):
        self.bbox_to_anchor = tuple([float(x) for x in clean_head_tail_line(self.file.readline()).split(self.delimiter)])

    def set_barcnt(self):
        if self.chart == None:
            self.chart = BarChart()
        self.chart.barcnt = int(clean_head_tail_line(self.file.readline()))

    def set_errorbar(self):
        index = len(self.data) - 1 
        self.data[index].errorbar = [float(x) for x in clean_head_tail_line(self.file.readline()).split(self.delimiter)]
    
    def set_barxticks(self):
        index = len(self.data) - 1
        self.data[index].tick_label = clean_head_tail_line(self.file.readline()).split(self.delimiter)

    def set_xticks_font_size(self):
        self.xformat.ticks_font_size = float(clean_head_tail_line(self.file.readline()))

    def set_marker_size(self):
        self.chart.marker_size = float(clean_head_tail_line(self.file.readline()))

    def set_font_size(self):
        self.yformat.font_size = self.xformat.font_size = float(clean_head_tail_line(self.file.readline()))

    def set_ytick_style(self):
        self.yformat.tick_style = clean_head_tail_line(self.file.readline())

    def setup_paint_funcs(self):
        self.paint_funcs["xticks"] = self.set_xtick
        self.paint_funcs["xticks_each"] = self.set_xtick_each
        self.paint_funcs["xlabel"] = self.set_xlabel
        self.paint_funcs["xscale"] = self.set_xscale
        self.paint_funcs["ylabel"] = self.set_ylabel
        self.paint_funcs["yscale"] = self.set_yscale
        self.paint_funcs["title"] = self.assign_title
        self.paint_funcs["ylim"] = self.set_ylim
        self.paint_funcs["xlim"] = self.set_xlim

        self.paint_funcs["xrotation"] = self.set_xrotation
        self.paint_funcs["xticks_font_size"] = self.set_xticks_font_size
        self.paint_funcs["font_size"] = self.set_font_size
        self.paint_funcs["marker_size"] = self.set_marker_size

        self.paint_funcs["linewidth"] = self.set_linewidth
        self.paint_funcs["linecnt"] = self.set_linecnt
        self.paint_funcs["secline"] = self.add_secline

        self.paint_funcs["bar"] = self.add_bar
        self.paint_funcs["barwidth"] = self.set_barwidth
        self.paint_funcs["bar_xticks"] = self.set_barxticks
        self.paint_funcs["stackbar"] = self.add_stackbar
        self.paint_funcs["barcnt"] = self.set_barcnt
        self.paint_funcs["secbar"] = self.add_secbar
        self.paint_funcs["yseclabel"] = self.set_yseclabel
        self.paint_funcs["yseclim"] = self.set_yseclim
        self.paint_funcs["reset_style"] = self.reset_style
        self.paint_funcs["ytick_style"] = self.set_ytick_style

        self.paint_funcs["errorbar"] = self.set_errorbar

        self.paint_funcs["line"] = self.add_line
        self.paint_funcs["chart"] = self.create_chart
        self.paint_funcs["legend_ncol"] = self.set_legend_ncol
        self.paint_funcs["legend_loc"] = self.set_legend_loc
        self.paint_funcs["legend_on"] = self.set_legend_on
        self.paint_funcs["legend_shadow"] = self.set_legend_shadow
        self.paint_funcs["legend_linewidth"] = self.set_legend_linewidth
        self.paint_funcs["legend_anchor"] = self.set_legend_anchor
        self.paint_funcs["legend_fontsize"] = self.set_legend_fontsize

        self.paint_funcs["position"] = self.assign_position
        self.paint_funcs["figsize"] = self.set_figsize

        self.paint_funcs["ysecline"] = self.set_ysecline
        self.paint_funcs["next"] = self.set_next

    def show_legends(self, legends, ax):
        labels = [lgd.get_label() for lgd in legends]
        if self.loc != None:
            ax.legend(legends, labels, loc=self.loc, bbox_to_anchor=self.bbox_to_anchor, fancybox=True, fontsize = self.legend_fontsize, ncol = self.legend_ncol, framealpha=1, shadow = self.shadow).get_frame().set_linewidth(self.legend_linewidth)
        else:
            ax.legend(legends, labels, loc='best', fancybox=True, fontsize = self.legend_fontsize, ncol = self.legend_ncol, framealpha=1, shadow = self.shadow).get_frame().set_linewidth(self.legend_linewidth)

    def parse_inputfile(self, inputfile):
        filename = inputfile
        while True:
            # initialize
            self.data = []
            self.errorbar = []
            self.file = open(filename, "r")
            while True:
                command = clean_head_tail_line(self.file.readline())
                if command != "":
                    self.paint_funcs[command]()
                else:
                    break

            # plot figure
            if self.title != None:
                self.ax.set_title(self.title)
            if self.yformat_sec != None:
                self.legends = self.legends + self.chart.plot(self.data, self.xformat, self.yformat, self.ax, yformat_sec = self.yformat_sec)
            else:
                self.legends = self.legends + self.chart.plot(self.data, self.xformat, self.yformat, self.ax)
        
            # release obj
            self.file.close()
            if self.ysecline != None:
                filename = self.ysecline
                del self.yformat
                del self.chart
                self.ax = self.ax.twinx()
                self.yformat = AxisFormat(minorticks_on=True)
                self.ysecline = None
                self.title = None
                self.yformat_sec = None
                self.chart = None
                continue

            if self.next != None:
                filename = self.next
                del self.xformat
                del self.yformat
                del self.chart
                self.xformat = AxisFormat(minorticks_on=False)
                self.yformat = AxisFormat(minorticks_on=True)
                if self.legend_on == True:
                    self.show_legends(self.legends, self.ax)
                self.legends = []
                self.next = None
                self.chart = None
                self.title = None
                self.yformat_sec = None
                self.legend_on = True
            else:
                break
        if self.legend_on == True:
            self.show_legends(self.legends, self.ax)

    def print_figure(self):
        pyplot.savefig(self.outputfile + ".pdf", bbox_inches='tight', pad_inches = cm2in(0.1), dpi = 160, transparent = True)
        pyplot.close(self.figure)


def help():
    print("Usage: python3 Painter.py inputfile [outputfile]")

if __name__ == "__main__":
    if sys.argv[1] == "help" or sys.argv[1] == "--help":
        help()
    else:
        # must have 3 parameters
        assert len(sys.argv) >= 2
        if len(sys.argv) == 2:
            painter = Painter(sys.argv[1], sys.argv[1].split(".")[0])
        else:
            painter = Painter(sys.argv[1], sys.argv[2])
        painter.print_figure()
