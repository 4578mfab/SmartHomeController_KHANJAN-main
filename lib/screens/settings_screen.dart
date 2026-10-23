import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/app_settings.dart';
import '../models/relay_config.dart';
import '../theme/app_themes.dart';

class SettingsScreen extends StatefulWidget {
  final AppSettings initialSettings;

  const SettingsScreen({super.key, required this.initialSettings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _settings;
  final _formKey = GlobalKey<FormState>();

  final _brokerCtrl = TextEditingController();
  final _portCtrl = TextEditingController();
  final _clientIdCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _tempTopicCtrl = TextEditingController();
  final _espStatusCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _settings = AppSettings.fromJson(widget.initialSettings.toJson());
    _brokerCtrl.text = _settings.broker;
    _portCtrl.text = _settings.port.toString();
    _clientIdCtrl.text = _settings.clientId;
    _userCtrl.text = _settings.username;
    _passCtrl.text = _settings.password;
    _tempTopicCtrl.text = _settings.temperatureTopic;
    _espStatusCtrl.text = _settings.espStatusTopic;
  }

  @override
  void dispose() {
    _brokerCtrl.dispose();
    _portCtrl.dispose();
    _clientIdCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    _tempTopicCtrl.dispose();
    _espStatusCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _settings.broker = _brokerCtrl.text.trim();
    _settings.port = int.tryParse(_portCtrl.text.trim()) ?? 1883;
    _settings.clientId = _clientIdCtrl.text.trim();
    _settings.username = _userCtrl.text.trim();
    _settings.password = _passCtrl.text;
    _settings.temperatureTopic = _tempTopicCtrl.text.trim();
    _settings.espStatusTopic = _espStatusCtrl.text.trim();
    Navigator.pop(context, _settings);
  }

  void _addRelay() {
    setState(() {
      final n = _settings.relays.length + 1;
      _settings.relays.add(RelayConfig(
        id: const Uuid().v4(),
        name: 'کلید $n',
        commandTopic: 'home/relay$n/set',
        stateTopic: 'home/relay$n/state',
      ));
    });
  }

  void _editRelay(int index) {
    final r = _settings.relays[index];
    final nameCtrl = TextEditingController(text: r.name);
    final cmdCtrl = TextEditingController(text: r.commandTopic);
    final stateCtrl = TextEditingController(text: r.stateTopic);
    final onCtrl = TextEditingController(text: r.onPayload);
    final offCtrl = TextEditingController(text: r.offPayload);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('ویرایش کلید'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'نام وسیله'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cmdCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Topic فرمان (Set)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: stateCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Topic وضعیت (State)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: onCtrl,
                  decoration:
                      const InputDecoration(labelText: 'پیام روشن (ON)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: offCtrl,
                  decoration:
                      const InputDecoration(labelText: 'پیام خاموش (OFF)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('لغو'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _settings.relays[index] = r.copyWith(
                    name: nameCtrl.text.trim(),
                    commandTopic: cmdCtrl.text.trim(),
                    stateTopic: stateCtrl.text.trim(),
                    onPayload: onCtrl.text.trim(),
                    offPayload: offCtrl.text.trim(),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('ذخیره'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRelay(int index) {
    setState(() => _settings.relays.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.themes[_settings.themeIndex.clamp(0, AppThemes.themes.length - 1)];
    final materialTheme = AppThemes.buildTheme(theme);

    return Theme(
      data: materialTheme,
      child: Scaffold(
        backgroundColor: theme.background,
        appBar: AppBar(
          title: const Text('تنظیمات'),
          actions: [
            TextButton(
              onPressed: _save,
              child: Text(
                'ذخیره',
                style: TextStyle(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionTitle('رنگ‌بندی برنامه', theme),
              _card(theme, [
                Text('برای تغییر رنگ پس‌زمینه و دکمه‌ها یکی از رنگ‌ها را انتخاب کن.', style: TextStyle(color: theme.text.withOpacity(0.72), fontSize: 13)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 14,
                  runSpacing: 12,
                  children: List.generate(AppThemes.themes.length, (i) {
                    final option = AppThemes.themes[i];
                    final selected = i == _settings.themeIndex;
                    return InkWell(
                      onTap: () => setState(() => _settings.themeIndex = i),
                      customBorder: const CircleBorder(),
                      child: Tooltip(
                        message: option.subtitle,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: option.primary,
                            border: Border.all(color: selected ? theme.text : theme.card, width: selected ? 3 : 1),
                            boxShadow: [BoxShadow(color: option.primary.withOpacity(0.22), blurRadius: 5, offset: const Offset(0, 2))],
                          ),
                          child: selected ? const Icon(Icons.check, color: Colors.white, size: 19) : null,
                        ),
                      ),
                    );
                  }),
                ),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('اتصال MQTT', theme),
              _card(theme, [
                TextFormField(
                  controller: _brokerCtrl,
                  decoration: const InputDecoration(labelText: 'آدرس Broker'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'الزامی' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _portCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'پورت'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('استفاده از WebSocket'),
                  subtitle: const Text(
                    'برای HiveMQ پورت 8000 را بگذارید و این گزینه را روشن کنید',
                  ),
                  value: _settings.useWebSocket,
                  activeColor: theme.primary,
                  onChanged: (v) => setState(() => _settings.useWebSocket = v),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _clientIdCtrl,
                  decoration: const InputDecoration(labelText: 'Client ID'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _userCtrl,
                  decoration: const InputDecoration(
                      labelText: 'نام کاربری (اختیاری)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'رمز عبور (اختیاری)'),
                ),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('دما و وضعیت ESP32', theme),
              _card(theme, [
                TextFormField(
                  controller: _tempTopicCtrl,
                  decoration: const InputDecoration(labelText: 'Topic دما'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _espStatusCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Topic وضعیت ESP32 (LWT)',
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              Row(
                children: [
                  _sectionTitle('کلیدها / رله‌ها', theme),
                  const Spacer(),
                  IconButton(
                    onPressed: _addRelay,
                    icon: Icon(Icons.add_circle, color: theme.primary),
                    tooltip: 'افزودن کلید',
                  ),
                ],
              ),
              ...List.generate(_settings.relays.length, (i) {
                final r = _settings.relays[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      r.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.text,
                      ),
                    ),
                    subtitle: Text(
                      r.commandTopic,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.text.withOpacity(0.6),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              Icon(Icons.edit, color: theme.primary, size: 20),
                          onPressed: () => _editRelay(i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 20),
                          onPressed: () => _deleteRelay(i),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('ذخیره و بازگشت'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, AppThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: theme.text,
        ),
      ),
    );
  }

  Widget _card(AppThemeData theme, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
