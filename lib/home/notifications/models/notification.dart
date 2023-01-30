class Notification {
  late int id;
  late String jobName;
  late int jobId;
  late String subTitle;
  late bool isSeen;
  late int emitterId;

  Notification.fromJson(Map map) {
    id = map['id'];
    jobName = map['adjobs']['title'];
    jobId = map['adjobs']['id'];
    subTitle = map['content'];
    isSeen = map['seen'] == 0 ? false : true;
    emitterId = map['emitter']['id'];
  }
}
