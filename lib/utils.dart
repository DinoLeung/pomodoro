String getDisplayTime(Duration time) {
  int minutes = time.inMinutes;
  int seconds = (time.inSeconds - (time.inMinutes * 60));
  return '${minutes}:${seconds.toString().padLeft(2, '0')}';
}
