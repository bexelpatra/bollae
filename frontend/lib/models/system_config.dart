class SystemConfig {
  final String? noticeTitle;
  final String? noticeContent;
  final String? popupContent;
  final bool isDangerMode;

  SystemConfig({
    this.noticeTitle,
    this.noticeContent,
    this.popupContent,
    required this.isDangerMode,
  });

  factory SystemConfig.fromJson(Map<String, dynamic> json) {
    return SystemConfig(
      noticeTitle: json['noticeTitle'],
      noticeContent: json['noticeContent'],
      popupContent: json['popupContent'],
      isDangerMode: json['isDangerMode'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noticeTitle': noticeTitle,
      'noticeContent': noticeContent,
      'popupContent': popupContent,
      'isDangerMode': isDangerMode,
    };
  }
}
