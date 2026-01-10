int calculateReadingTime(String content){
  //the regular expression function splits the given string into lists by seperating based on the spaces and the new line character
  final wordCount = content.split(RegExp(r'\s+')).length;

  //speed = distance / time
  //time = speed / distance
  final readingTime = wordCount / 238; //avg human rading time 238 words per minute

  return readingTime.ceil();
}
