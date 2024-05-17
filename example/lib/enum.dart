enum PrintSize {
  medium, //normal size text
  bold, //only bold text
  boldMedium, //bold with medium
  boldLarge, //bold with large
  extraLarge //extra large
}

enum PrintAlign {
  left, //ESC_ALIGN_LEFT
  center, //ESC_ALIGN_CENTER
  right, //ESC_ALIGN_RIGHT
}

extension PS on PrintSize {
  int get val {
    switch (this) {
      case PrintSize.medium:
        return 0;
      case PrintSize.bold:
        return 1;
      case PrintSize.boldMedium:
        return 2;
      case PrintSize.boldLarge:
        return 3;
      case PrintSize.extraLarge:
        return 4;
      default:
        return 0;
    }
  }
}

extension PA on PrintAlign {
  int get val {
    switch (this) {
      case PrintAlign.left:
        return 0;
      case PrintAlign.center:
        return 1;
      case PrintAlign.right:
        return 2;
      default:
        return 0;
    }
  }
}
