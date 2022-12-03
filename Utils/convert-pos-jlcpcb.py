import sys


def rename(name):
    noext = name[:-4]
    return f"{noext}-jlcpcb.csv"


def fix_midx(midx):
    if midx[0] == "-":
        return midx[1:]
    else:
        return "-" + midx


def fix_rotation(rot):
    rot = float(rot)
    rot = 180 - rot
    rot = str(rot)
    return rot


with open(sys.argv[1], "r") as f, open(rename(sys.argv[1]), "w") as o:
    i = 0
    for line in f:
        if i == 0:
            o.write("Designator,Val,Package,Mid X,Mid Y,Rotation,Layer\n")
        else:
            fields = line.split(",")
            fields[3] = fix_midx(fields[3])
            fields[5] = fix_rotation(fields[5])

            line = ",".join(fields)
            o.write(line)

        i += 1
