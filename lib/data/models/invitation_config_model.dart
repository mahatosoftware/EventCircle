import 'package:flutter/material.dart';

class InvitationConfigModel {
  final String eventId;
  final String templateType;
  final String? title;
  final String? bannerUrl;
  final String? message;
  final DateTime? eventDate;
  final String? venueName;
  final String? venueAddress;
  final String? mapLink;
  final String? dressCode;
  final List<CustomQuestionModel> customQuestions;
  final bool isPublic;
  final bool requireOtp;
  final Map<String, dynamic> themeSettings;

  const InvitationConfigModel({
    required this.eventId,
    this.templateType = 'Wedding',
    this.title,
    this.bannerUrl,
    this.message,
    this.eventDate,
    this.venueName,
    this.venueAddress,
    this.mapLink,
    this.dressCode,
    this.customQuestions = const [],
    this.isPublic = true,
    this.requireOtp = false,
    this.themeSettings = const {},
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'templateType': templateType,
        'title': title,
        'bannerUrl': bannerUrl,
        'message': message,
        'eventDate': eventDate?.toIso8601String(),
        'venueName': venueName,
        'venueAddress': venueAddress,
        'mapLink': mapLink,
        'dressCode': dressCode,
        'customQuestions': customQuestions.map((q) => q.toJson()).toList(),
        'isPublic': isPublic,
        'requireOtp': requireOtp,
        'themeSettings': themeSettings,
      };

  factory InvitationConfigModel.fromJson(Map<String, dynamic> json) {
    return InvitationConfigModel(
      eventId: json['eventId'] as String? ?? '',
      templateType: json['templateType'] as String? ?? 'Wedding',
      title: json['title'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      message: json['message'] as String?,
      eventDate: json['eventDate'] != null ? DateTime.parse(json['eventDate'] as String) : null,
      venueName: json['venueName'] as String?,
      venueAddress: json['venueAddress'] as String?,
      mapLink: json['mapLink'] as String?,
      dressCode: json['dressCode'] as String?,
      customQuestions: (json['customQuestions'] as List<dynamic>?)
              ?.map((q) => CustomQuestionModel.fromJson(q as Map<String, dynamic>))
              .toList() ??
          const [],
      isPublic: json['isPublic'] as bool? ?? true,
      requireOtp: json['requireOtp'] as bool? ?? false,
      themeSettings: json['themeSettings'] as Map<String, dynamic>? ?? const {},
    );
  }
}

class CustomQuestionModel {
  final String id;
  final String question;
  final String type;
  final List<String> options;
  final bool isRequired;

  const CustomQuestionModel({
    required this.id,
    required this.question,
    this.type = 'text',
    this.options = const [],
    this.isRequired = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'type': type,
        'options': options,
        'isRequired': isRequired,
      };

  factory CustomQuestionModel.fromJson(Map<String, dynamic> json) {
    return CustomQuestionModel(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
      options: (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      isRequired: json['isRequired'] as bool? ?? false,
    );
  }
}
