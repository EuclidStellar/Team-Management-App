// ignore: file_names
class Team {
  final bool success;
  final TeamDetails teamDetails;

  Team({required this.success, required this.teamDetails});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      success: json['success'],
      teamDetails: TeamDetails.fromJson(json['team']),
    );
  }
}

class TeamDetails {
  final String leaderEmail;
  final String teamName;
  final List<DomainDetails> domains;
  final String teamCode;
  final int numberOfMembers;
  final String id;
  final String createdAt;
  final String updatedAt;

  TeamDetails({
    required this.leaderEmail,
    required this.teamName,
    required this.domains,
    required this.teamCode,
    required this.numberOfMembers,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeamDetails.fromJson(Map<String, dynamic> json) {
    return TeamDetails(
      leaderEmail: json['leaderEmail'],
      teamName: json['teamName'],
      domains: List<DomainDetails>.from(json['domains'].map((domain) => DomainDetails.fromJson(domain))),
      teamCode: json['teamCode'],
      numberOfMembers: json['numberOfMembers'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class DomainDetails {
  final String name;
  final List<String> members;
  final String id;

  DomainDetails({required this.name, required this.members, required this.id});

  factory DomainDetails.fromJson(Map<String, dynamic> json) {
    return DomainDetails(
      name: json['name'],
      members: List<String>.from(json['members']),
      id: json['_id'],
    );
  }
}
