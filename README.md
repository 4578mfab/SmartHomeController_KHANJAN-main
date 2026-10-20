# KHANJAN IoT Home

اپلیکیشن اندروید اختصاصی برای کنترل رله‌های ESP32 و نمایش دما از طریق MQTT.

## ویژگی‌ها

- صفحه اسپلش ۴ ثانیه‌ای با لوگوی خانه هوشمند + متن **KHANJAN** و **IOT HOME**
- ۵ کلید کنترل رله (قابل افزایش/کاهش از تنظیمات)
- نمایش دمای محیط
- اتصال MQTT کاملاً قابل تنظیم (Broker، پورت، یوزر، پسورد، Client ID)
- تنظیم Topic فرمان و وضعیت برای هر کلید
- تنظیم Topic دما
- ۳ تم رنگی روشن و شاد: Fresh Mint، Soft Sky، Warm Peach
- ذخیره تنظیمات به صورت دائمی

## پیش‌نیازها

- Flutter SDK نسخه ۳ یا بالاتر
- Android Studio یا VS Code با افزونه Flutter
- حساب GitHub

## نصب و اجرا

```bash
git clone https://github.com/YOUR_USERNAME/khanjan_iot_home.git
cd khanjan_iot_home
flutter pub get
flutter run
```

## ساخت APK برای انتشار

```bash
flutter build apk --release
```

فایل خروجی در مسیر زیر ساخته می‌شود:

```
build/app/outputs/flutter-apk/app-release.apk
```

## ساختار پروژه

```
lib/
  main.dart
  models/
    app_settings.dart
    relay_config.dart
  services/
    mqtt_service.dart
    settings_service.dart
  theme/
    app_themes.dart
  screens/
    splash_screen.dart
    home_screen.dart
    settings_screen.dart
  widgets/
    temperature_card.dart
    relay_switch.dart
```

## تنظیمات MQTT پیشنهادی برای ESP32

- Broker: هر Broker عمومی یا خصوصی (مثلاً broker.hivemq.com)
- Topic فرمان کلید ۱: `home/relay1/set`  ← پیام `ON` یا `OFF`
- Topic وضعیت کلید ۱: `home/relay1/state`
- Topic دما: `home/temperature`  ← عدد دما به صورت رشته

## مجوز

MIT License – آزاد برای استفاده شخصی و تجاری.
