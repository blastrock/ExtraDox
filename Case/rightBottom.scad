include <common.scad>

module part_rightBottomCase() {
  difference() {
    union() {
      base();
      forHoles(rightHolePositions)
        screwGuide();
    }
    forHoles(rightHolePositions) {
      screwHole();
      nutHole();
    }

    translate([rightResetPosition[0], rightResetPosition[1]])
      cylinder(20, r=1, center=true);

    translate([rightUsbPosition[0], rightUsbPosition[1], boardHeight])
      rotate(-90, [1, 0, 0])
        usbcHole();
  }
}

part_rightBottomCase();
