use <rightBottom.scad>
use <rightTop.scad>
use <leftBottom.scad>
use <leftTop.scad>
include <common.scad>

part_rightBottomCase();
part_rightTopCase();

%translate([0, 0, boardHeight])
  import("ExtraDox-Right.stl");

translate([-250, 0, 0]) {
  part_leftBottomCase();
  part_leftTopCase();

  %translate([0, 0, boardHeight])
    import("ExtraDox-Left.stl");
}
