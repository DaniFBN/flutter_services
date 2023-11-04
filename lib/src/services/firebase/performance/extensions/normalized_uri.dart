extension NormalizedUri on Uri {
  String normalized() {
    return '$scheme://$host$path';
  }
}
