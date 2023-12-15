import 'dart:convert';

JoinTeam joinTeamFromJson(String str) => JoinTeam.fromJson(json.decode(str));

String joinTeamToJson(JoinTeam data) => json.encode(data.toJson());

class JoinTeam {
  String teamCode;
  // String domainName;

  JoinTeam({
    required this.teamCode,
    // required this.domainName,
  });

  factory JoinTeam.fromJson(Map<String, dynamic> json) => JoinTeam(
    teamCode: json["teamCode"],
    // domainName: json["domainName"],
  );

  Map<String, dynamic> toJson() => {
    "teamCode": teamCode,
    // "domainName": domainName,
  };
}