import pythonflow as pf
import seaborn as sns
import pandas as pd
import matplotlib.gridspec as grid_spec
import matplotlib.pyplot as plt
from subprocess import run
import sys
import itertools as it

start = 0 #(750 + 1.708513e9)
xlim = None #(54, 55.5)

def plot_latency(ax, df):
    #df = df[df['error'] == '']
    df['submitted'] = df['start_ns'] / 1e9
    df['response'] = df['end_ns'] / 1e9
    df['latency'] = (df['response'] - df['submitted']) * 1e3

    df['submitted_n'] = df['submitted'] - start

    sns.histplot(df,
                 x="submitted_n",
                 y="latency",
                 binwidth=(0.1, 20),
                 ax=ax)

    ax.set_xlabel("")
    if xlim is not None:
        ax.set_xlim(*xlim)
    ax.set_ylabel("Client Latency (ms)")
    ax.set_ylim(0,1000)

def plot_bw(bax, bw):
    bw['bw'] = bw['bw'] / 1e6 # Mega
    bw['bw'] = bw['bw'] * 8 # Bytes to bits
    bw['time'] = bw['time'] - (start)

    print(bw)

    hosts = set()
    for dir in bw['direction'].unique():
        if dir != 'total':
            hosts.add(dir.split(':')[0])
            hosts.add(dir.split(':')[1])

    print(hosts)

    #sns.lineplot(
    #        data = bw,
    #        ax=bax,
    #        x = "time",
    #        y = "bw",
    #        hue = "direction",
    #        #hue_order = hue_order,
    #        linewidth=1,
    #        legend=False,
    #        errorbar=None,
    #        )

    norm_host_map = {
            f"{h1}:{h2}" : (f"{h1}:{h2}" if h1< h2 else f"{h2}:{h1}") for h1,h2 in it.product(hosts, hosts)
            }

    def apply_map(d):
        if d in norm_host_map:
            return norm_host_map[d]
        else: 
            return d
    #hue_order = [f"{h1}:{h2}" for h1,h2 in it.product(hosts, hosts) if h1 < h2]

    inter_host_lh = [
        f"{h1}:{h2}" for h1,h2 in it.product(hosts, hosts) if h1 < h2
    ]
    bw_lh = bw.loc[bw['direction'].apply(lambda d: d in inter_host_lh), :].copy()
    bw_lh['direction_map'] = bw_lh['direction'].apply(apply_map)

    print(bw_lh)

    inter_host_hl = [
        f"{h1}:{h2}" for h1,h2 in it.product(hosts, hosts) if h1 > h2
    ]
    bw_hl = bw.loc[bw['direction'].apply(lambda d: d in inter_host_hl), :].copy()
    bw_hl['bw'] = bw_hl['bw'].mul(-1)
    bw_hl['direction_map'] = bw['direction'].apply(apply_map)

    print(bw_hl)

    # cluster bandwidth
    sns.lineplot(
            data = bw_lh,
            ax=bax,
            x = "time",
            y = "bw",
            hue = "direction_map",
    #        hue_order = hue_order,
            linewidth=1,
            legend=False,
            errorbar=None,
            )
    sns.lineplot(
            data = bw_hl,
            ax=bax,
            x = "time",
            y = "bw",
            hue = "direction_map",
    #        hue_order = hue_order,
            linewidth=1,
            legend=False,
            errorbar=None,
            )
    bax.set_xlabel("Time (s)")
    bax.set_ylabel("Host to Host (Mb/s)")
    bax.set(yscale="linear")

with pf.Graph() as graph:
    print(sys.argv)

    figurepath = sys.argv[1]
    result_file = sys.argv[2]
    pcap_files = sys.argv[3:]

    res = pd.read_csv(result_file, float_precision="high")
    bw = pd.concat([pd.read_csv(f, float_precision="high") for f in pcap_files], ignore_index=True)

    fig = plt.figure()
    gs = grid_spec.GridSpec(2, 1, figure=fig)
    gs = grid_spec.GridSpec(2, 1, figure=fig)
    lax = fig.add_subplot(gs[0,0])
    bax = fig.add_subplot(gs[1,0], sharex=lax)

    plot_latency(lax, res)
    plot_bw(bax, bw)

    run(f"mkdir -p {figurepath}", shell=True).check_returncode()
    fig.savefig(f"{figurepath}/fault-anatonomy-all.png")
    fig.savefig(f"{figurepath}/fault-anatonomy-all.pdf")
    #fig.savefig(f"{figurepath}/fault-anatonomy-all.svg")
    print(f"Saved to file {figurepath}")
