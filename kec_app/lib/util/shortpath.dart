
String shortenImagePath(String imagePath) {
  if (imagePath.length <= 20) {
    return imagePath;
  } else {
    final fileName = imagePath.split('/').last;
    final shortenedPath = '.../${fileName.substring(0, 29)}...';
    return shortenedPath;
  }
}

String shortenImageUpdate(String imagePath) {
  if (imagePath.length <= 20) {
    return imagePath;
  } else {
    final fileName = imagePath.split('/').last;
    final shortenedPath = '.../${fileName.substring(15, 33)}...';
    return shortenedPath;
  }
}

String shortenPdfUpdate(String imagePath) {
  if (imagePath.length <= 20) {
    return imagePath;
  } else {
    final fileName = imagePath.split('/').last;
    final shortenedPath = '.../${fileName.substring(15, 33)}...';
    return shortenedPath;
  }
}