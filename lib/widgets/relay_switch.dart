import 'package:flutter/material.dart';
import '../models/relay_config.dart';
import '../theme/app_themes.dart';

class RelaySwitchTile extends StatelessWidget {
  final RelayConfig relay;
  final AppThemeData theme;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const RelaySwitchTile({
    super.key,
    required this.relay,
    required this.theme,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: relay.isOn ? theme.primary.withOpacity(0.15) : theme.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.power_settings_new,
              color: relay.isOn ? Colors.green : Colors.red,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              relay.name,
              style: TextStyle(
                color: theme.text,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: relay.isOn,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
