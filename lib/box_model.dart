enum BoxType { dot, hline, vline, box }

class LineModel {
  int index;
  BoxType boxType;
  bool marked = false;
  int player = 0;
  LineModel(this.index, this.boxType);
}

class BoxModel {
  int index;
  int player = 0;
  BoxType boxType;
  bool marked = false;
  bool top = false;
  bool bottom = false;
  bool left = false;
  bool right = false;
  int count = 0;

  BoxModel(this.index, this.boxType);
}
