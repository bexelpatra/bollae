class Schedule {
  final int id;
  final int userId;
  final String storeName;
  final String representativeName;
  final String phoneNumber;
  final DateTime scheduleDate;
  final String scheduleTime;
  final int paxCount;
  final String purpose;
  final String? note;
  final String status;

  Schedule({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.representativeName,
    required this.phoneNumber,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.paxCount,
    required this.purpose,
    this.note,
    required this.status,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      userId: json['userId'],
      storeName: json['storeName'],
      representativeName: json['representativeName'],
      phoneNumber: json['phoneNumber'],
      scheduleDate: DateTime.parse(json['scheduleDate']),
      scheduleTime: json['scheduleTime'],
      paxCount: json['paxCount'],
      purpose: json['purpose'],
      note: json['note'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleDate': scheduleDate.toIso8601String().split('T')[0],
      'scheduleTime': scheduleTime,
      'paxCount': paxCount,
      'purpose': purpose,
      'note': note,
    };
  }

  bool get isRequested => status == 'REQUESTED';
  bool get isApproved => status == 'APPROVED';
  bool get isCanceled => status == 'CANCELED';
}
