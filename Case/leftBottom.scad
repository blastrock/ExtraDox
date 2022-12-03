include <common.scad>

module part_leftBottomCase() {
  difference() {
    union() {
      mirror([1, 0, 0])
        base();
      forHoles(leftHolePositions)
        screwGuide();
    }
    forHoles(leftHolePositions) {
      screwHole();
      nutHole();
    }
  }
}

part_leftBottomCase();
