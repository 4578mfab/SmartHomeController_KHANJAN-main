class RelayConfig {
  final String id;
  String name;
  String commandTopic;
  String stateTopic;
  String onPayload;
  String offPayload;
  bool isOn;

  RelayConfig({
    required this.id,
    required this.name,
    required this.commandTopic,
    required this.stateTopic,
    this.onPayload = 'ON',
    this.offPayload = 'OFF',
    this.isOn = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'commandTopic': commandTopic,
        'stateTopic': stateTopic,
        'onPayload': onPayload,
        'offPayload': offPayload,
        'isOn': isOn,
      };

  factory RelayConfig.fromJson(Map<String, dynamic> json) => RelayConfig(
        id: json['id'] as String,
        name: json['name'] as String,
        commandTopic: json['commandTopic'] as String,
        stateTopic: json['stateTopic'] as String,
        onPayload: json['onPayload'] as String? ?? 'ON',
        offPayload: json['offPayload'] as String? ?? 'OFF',
        isOn: json['isOn'] as bool? ?? false,
      );

  RelayConfig copyWith({
    String? name,
    String? commandTopic,
    String? stateTopic,
    String? onPayload,
    String? offPayload,
    bool? isOn,
  }) {
    return RelayConfig(
      id: id,
      name: name ?? this.name,
      commandTopic: commandTopic ?? this.commandTopic,
      stateTopic: stateTopic ?? this.stateTopic,
      onPayload: onPayload ?? this.onPayload,
      offPayload: offPayload ?? this.offPayload,
      isOn: isOn ?? this.isOn,
    );
  }
}
