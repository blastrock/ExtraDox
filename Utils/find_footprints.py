import sexpdata


def find_decl(data, name, cb):
    if isinstance(data, list):
        if data[0] == sexpdata.Symbol(name):
            return cb(data)
        else:
            for e in data:
                r = find_decl(e, name, cb)
                if r:
                    return r
    else:
        return None


def find_one(data, needle, all=False):
    global origin
    if all:
        maybecomma = ","
    else:
        maybecomma = ""
    if isinstance(data, list):
        if data[0] == sexpdata.Symbol("footprint") and data[1] == needle:
            position = find_decl(
                data,
                "at",
                lambda e: (
                    e[1] - origin[0],
                    -(e[2] - origin[1]),
                ),
            )
            print("[%.3f, %.3f]%s" % (position[0], position[1], maybecomma))
        else:
            for e in data:
                find_one(e, needle, all)


def find_switches(data):
    global origin
    if isinstance(data, list):
        if data[0] == sexpdata.Symbol("footprint") and (
            data[1] == "additional-footprints:KailhHotswapChoc1"
            or data[1] == "additional-footprints:KailhHotswapChoc15"
            or data[1] == "additional-footprints:KailhHotswapChoc2"
        ):
            position = find_decl(
                data,
                "at",
                lambda e: (
                    e[1] - origin[0],
                    -(e[2] - origin[1]),
                    e[3] if 3 < len(e) else 0,
                ),
            )
            print("  [%.3f, %.3f, %.3f]," % (position[0], position[1], position[2]))
        else:
            for e in data:
                find_switches(e)


def find_holes(data):
    global origin
    if isinstance(data, list):
        if (
            data[0] == sexpdata.Symbol("footprint")
            and data[1] == "additional-footprints:MountingHole4.318"
        ):
            position = find_decl(
                data,
                "at",
                lambda e: (
                    e[1] - origin[0],
                    -(e[2] - origin[1]),
                ),
            )
            print("  [%.3f, %.3f]," % (position[0], position[1]))
        else:
            for e in data:
                find_holes(e)


with open("../PCB/Right/ExtraDox-Right.kicad_pcb", "r") as f:
    data = sexpdata.load(f)
    origin = find_decl(data, "grid_origin", lambda e: (e[1], e[2]))

print("rightSwitchPositions = [")
find_switches(data)
print("];\n")

print("rightHolePositions = [")
find_holes(data)
print("];\n")

print("rightUsbPosition = ")
find_one(data, "additional-footprints:HRS_CX90M-16P")
print(";\n")

print("rightResetPosition = ")
find_one(data, "additional-footprints:TS-1087S")
print(";\n")

print("rightJackPosition = ")
find_one(data, "additional-footprints:TRRS-PJ-320A")
print(";\n")

print("rightLedPositions = [")
find_one(data, "Diode_SMD:D_0603_1608Metric", True)
print("];\n")

with open("../PCB/Left/ExtraDox-Left.kicad_pcb", "r") as f:
    data = sexpdata.load(f)
    origin = find_decl(data, "grid_origin", lambda e: (e[1], e[2]))

print("leftSwitchPositions = [")
find_switches(data)
print("];\n")

print("leftHolePositions = [")
find_holes(data)
print("];\n")

print("leftJackPosition = ")
find_one(data, "additional-footprints:TRRS-PJ-320A")
print(";\n")
