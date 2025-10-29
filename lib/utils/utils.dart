class Responsive {
  static int gridCountForWidth(double width) {
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    if (width >= 600) return 2;
    return 1;
  }
}
