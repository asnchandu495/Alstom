// To parse this JSON data, do
//
//     final customPayload = customPayloadFromJson(jsonString);

import 'dart:convert';

class CustomPayload {
  CustomPayload(
      {this.richContent,
      this.outputValue,
      this.layoutType,
      this.contentTitle,
      this.name});

  List<List<RichContent>>? richContent;
  int? outputValue;
  int? layoutType;
  String? name;
  String? contentTitle;

  factory CustomPayload.fromRawJson(String str) =>
      CustomPayload.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomPayload.fromJson(Map<String, dynamic> json) => CustomPayload(
        richContent: json["richContent"] == null
            ? null
            : List<List<RichContent>>.from(json["richContent"].map((x) =>
                List<RichContent>.from(x.map((x) => RichContent.fromJson(x))))),
        outputValue: json["outputValue"],
        layoutType: json["layoutType"],
        name: json["name"],
        contentTitle: json["contentTitle"],
      );

  Map<String, dynamic> toJson() => {
        "richContent": richContent == null
            ? null
            : List<dynamic>.from(richContent!
                .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "outputValue": outputValue == null ? null : outputValue,
        "layoutType": layoutType == null ? null : layoutType,
        "contentTitle": contentTitle == null ? null : contentTitle,
      };
}

class RichContent {
  RichContent({
    this.title,
    this.subtitle,
    this.type,
    this.options,
  });

  String? title;
  String? subtitle;
  String? type;
  Options? options;

  factory RichContent.fromRawJson(String str) =>
      RichContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RichContent.fromJson(Map<String, dynamic> json) => RichContent(
        title: json["title"] == null ? null : json["title"],
        subtitle: json["subtitle"] == null ? null : json["subtitle"],
        type: json["type"] == null ? null : json["type"],
        options:
            json["options"] == null ? null : Options.fromJson(json["options"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "subtitle": subtitle == null ? null : subtitle,
        "type": type == null ? null : type,
        "options": options == null ? null : options!.toJson(),
      };
}

class Options {
  Options(
      {this.subType,
      this.days,
      this.months,
      this.weeks,
      this.values,
      this.feet,
      this.inch,
      this.posfix});

  String? subType;
  String? posfix;
  List<int>? days;
  List<int>? months;
  List<int>? weeks;
  List<int>? feet;
  List<int>? inch;
  List<String>? values;

  factory Options.fromRawJson(String str) => Options.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Options.fromJson(Map<String, dynamic> json) => Options(
      subType: json["subType"] == null ? null : json["subType"],
      days: json["days"] == null
          ? null
          : List<int>.from(json["days"].map((x) => x)),
      months: json["months"] == null
          ? null
          : List<int>.from(json["months"].map((x) => x)),
      weeks: json["weeks"] == null
          ? null
          : List<int>.from(json["weeks"].map((x) => x)),
      values: json["values"] == null
          ? null
          : List<String>.from(json["values"].map((x) => x)),
      feet: json["feet"] == null
          ? null
          : List<int>.from(json["feet"].map((x) => x)),
      inch: json["inch"] == null
          ? null
          : List<int>.from(json["inch"].map((x) => x)),
      posfix: json["posfix"] == null ? null : json["posfix"]);

  Map<String, dynamic> toJson() => {
        "subType": subType == null ? null : subType,
        "days": days == null ? null : List<dynamic>.from(days!.map((x) => x)),
        "months":
            months == null ? null : List<dynamic>.from(months!.map((x) => x)),
        "weeks":
            weeks == null ? null : List<dynamic>.from(weeks!.map((x) => x)),
        "values":
            values == null ? null : List<dynamic>.from(values!.map((x) => x)),
      };
}
