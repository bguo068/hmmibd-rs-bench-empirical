import pandas as pd
import numpy as np
import re
import io
from pathlib import Path

import matplotlib.pyplot as plt

fn = "result/ibdcov/Pf7_ibdcov.csv"
df = pd.read_csv(fn)


def get_nsam():
    lst = (
        Path("result/bcf_bin_files/Pf7_bcf_bin_file.samples")
        .read_text()
        .strip()
        .split("\n")
    )
    return len(lst)


def get_pf3d7_chrlen_lst():
    s = """
        640851 947102 1067971 1200490 1343557 1418242 1445207 1472805
        1541735 1687656 2038340 2271494 2925236 3291936
        """
    return [int(i) for i in s.split()]


def get_pf3d7_gwtart():
    x = np.array(get_pf3d7_chrlen_lst())
    cumsum = np.hstack([0, np.cumsum(x)[:-1]])
    return cumsum


def get_i2gwstart():
    return {(i + 1): gwstart for i, gwstart in enumerate(get_pf3d7_gwtart())}


def get_gwcenter():
    x = get_pf3d7_chrlen_lst()
    x = np.array([0] + list(np.cumsum(x)))
    chrom_gwcenters = (x[:-1] + x[1:]) / 2
    return chrom_gwcenters


def get_22gwstart():
    return {
        f"Pf3D7_{(i + 1):02d}_v3": gwstart
        for i, gwstart in enumerate(get_pf3d7_gwtart())
    }


def drg():
    s = """
    ID               Name           Chromosome  Start    End      Comment
    PF3D7_0417200    dhfr           4           748088   749914   drg
    PF3D7_0523000    mdr1           5           957890   962149   drg
    PF3D7_0629500    aat1           6           1213102  1217313  drg
    PF3D7_0709000    crt            7           403222   406317   drg
    PF3D7_0720700    pib7           7           891683   899051   drg
    PF3D7_0810800    dhps           8           548200   550616   drg
    PF3D7_1012700    pph            10          487252   491828   drg
    PF3D7_1036300    mspdbl2        10          1432498  1434786  drg
    PF3D7_1222600    ap2-g*         12          907203   914501   sex
    PF3D7_1318100    fd             13          748387   748971   drg
    PF3D7_1343700    k13            13          1724817  1726997  drg
    PF3D7_1408200    ap2-g2*        14          300725   305833   sex
    PF3D7_1460900.1  arps10         14          2480440  2481916  drg
    """
    # PF3D7_1224000    gch1           12          974372   975541   drg
    # PF3D7_1322700    PF3D7_1322700  13          958219   959175   drg
    # PF3D7_1451200    PF3D7_1451200  14          2094340  2099736  drg
    s = re.sub(r"[ \t]+", ",", s.strip())
    i2gwstart = get_i2gwstart()
    drg = pd.read_csv(io.StringIO(s))
    x = drg.Chromosome.map(i2gwstart) + (drg.Start + drg.End) / 2
    drg["GwCenter"] = x
    return drg


drg = drg()

fig = plt.figure(figsize=(17, 2), constrained_layout=True)
ax = fig.add_subplot(1, 1, 1)
ax.plot(df.GwPos, df.Coverage)
ch_gw_centers = get_gwcenter()
ax.set_xticks(ch_gw_centers)
ax.set_ylabel("IBD cov")
ax.set_xticklabels(range(1, 15))
gsize_bp = sum(get_pf3d7_chrlen_lst())
for x in list(get_pf3d7_gwtart()) + [gsize_bp]:
    ax.axvline(int(x), linestyle="--", alpha=0.5)
# remove space at two sides
ax.set_xlim(0, gsize_bp)
ax_top = ax.twiny()
ax_top.set_xlim(ax.get_xlim())
ax_top.set_xticks(drg["GwCenter"])
ax_top.set_xticklabels(
    drg["Name"], va="bottom", ha="left", rotation=30, rotation_mode="anchor"
)
ax_right = ax.twinx()
ymin, ymax = ax.get_ylim()
nsam = get_nsam()
npair = nsam * (nsam - 1) / 2
ax_right.set_ylim(ymin / npair, ymax / npair)
ax_right.set_ylabel("IBD proportions")
# for gw_center, name in drg[['GwCenter', 'Name']]:
plt.savefig("plot_ibdcov.png", dpi=300)
