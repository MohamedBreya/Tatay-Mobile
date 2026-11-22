# Tatay Transportation: أبليكيشن المسافر (Flutter)

أبليكيشن Android للمسافر: التسجيل والـ OTP، رحلات الأسبوع، الحجز والدفع بصورة التحويل، قايمة الانتظار، الركوب بالـ QR، الإشعارات، وحسابي. الـ 9 شاشات اللي في `03_Tech_Spec_2_API_Screens.md`، على عقد الـ API في `../Backend/api/openapi.yaml`.

القواعد اللي الكود ماشي عليها في [AGENTS.md](AGENTS.md).

## التشغيل

```bash
flutter pub get
flutter run                                   # على الـ Mock (الافتراضي)، من غير باك
flutter run --dart-define=USE_MOCK=false      # على الباك المحلي http://10.0.2.2:8080/api/v1
```

| المتغير (`--dart-define`) | الافتراضي | الغرض |
| --- | --- | --- |
| `USE_MOCK` | `true` | كل الـ Features تشتغل على `MockDataSource` |
| `API_BASE_URL` | `http://10.0.2.2:8080/api/v1` | عنوان الباك (الـ Emulator بيشوف الجهاز على `10.0.2.2`) |
| `PUSH_ENABLED` | `false` | تشغيل FCM. محتاج `android/app/google-services.json` |
| `MOCK_SCENARIO` | `normal` | `empty` أو `error` أو `slow` علشان تجرب حالات الشاشات |

### بيانات الـ Mock

- `demo@tatay.app` أو `01012345678` بكلمة سر `password123` (متفعل، وعنده حجوزات بكل الحالات).
- `new@tatay.app` بكلمة سر `password123` (مش متفعل، بيروح لشاشة الـ OTP).
- كود الـ OTP دايمًا `123456`.
- الـ QR: `TATAY-VEH-1` (عربية رحلة النهارده) و`TATAY-VEH-2` (عربية تانية، علشان `WRONG_VEHICLE`).
- بعد رفع صورة التحويل، الـ Mock بيأكد الدفع بعد 20 ثانية ويبعت إشعار N1.

### الإشعارات (FCM)

1. اعمل مشروع Firebase وضيف أبليكيشن Android بالـ package `com.tatay.transport`.
2. حط `google-services.json` في `android/app/`. الـ Gradle plugin بيتفعل لوحده لما الملف يبقى موجود.
3. شغّل بـ `--dart-define=PUSH_ENABLED=true`.

من غير FCM، كل الإشعارات بتوصل برضه في شاشة الإشعارات (`GET /notifications`).

## الاختبارات

```bash
flutter analyze
flutter test
```

- **الشبكة:** Refresh واحد بس لما كذا طلب يرجعوا 401 مع بعض، والـ Idempotency-Key نفسه في كل إعادة محاولة لنفس الضغطة، وتحويل كل كود خطأ.
- **الـ Cubits:** الحجز، والدفع والعداد، وعرض الانتظار، والـ Scan.
- **الـ Mock كـ Backend:** تناسق الكراسي والحجوزات والانتظار، وقواعد الـ Scan (T3 وT8).
- **الأبليكيشن كله:** بالعربي (RTL): دخول، ثم رحلات، ثم حجز، ثم شاشة الدفع.

## الشكل

```
lib/
├── app/            الـ MaterialApp، والـ Providers العامة، وتأثيرات تغيير الجلسة
├── core/
│   ├── config/     متغيرات الـ dart-define
│   ├── di/         get_it: المكان الوحيد اللي بيختار Mock ولا Remote
│   ├── mock/       باك وهمي في الذاكرة بنفس شكل الـ JSON بتاع العقد
│   ├── network/    Dio، الـ Refresh، الـ Idempotency، الـ ApiFailure (sealed)، Result
│   ├── router/     go_router وتوجيه الجلسة
│   ├── utils/      app_colors، app_styles، الثيم، التنسيق بتوقيت القاهرة
│   └── widgets/    Widgets مشتركة
├── features/<feature>/
│   ├── data/       models، datasources (abstract + remote Retrofit + mock)، repositories
│   └── presentation/ screens، cubits، widgets/<section>/
└── generated/      LocaleKeys (متولد)
```

- **الـ Features:** auth، config، trips، bookings، payment، waitlist، boarding، notifications، account، home.
- **الحالات:** كل حالة Cubit معمولة sealed class.
- **الفلوس:** بالقرش زي ما بتيجي، والقسمة على 100 للعرض بس.
- **الأوقات:** بتتحول من UTC لتوقيت القاهرة، بنظام 12 ساعة.
- **العدادات:** عداد الدفع وعداد عرض الانتظار بيبدأوا من `seconds_left` اللي جاي من السيرفر، وبيتحدثوا لما الأبليكيشن يرجع من الخلفية.

## النصوص والترجمة

بعد أي تعديل في `assets/translations/{ar,en}.json`:

```bash
./localization_generator.sh      # Linux/macOS
localization_generator.bat       # Windows
```

الأبليكيشن ماشي بلغة الجهاز: الإنجليزي لو الجهاز إنجليزي، والعربي في أي حالة تانية.

## ملاحظات

- `compileSdk = 37`، لأن `flutter_local_notifications` و`androidx.core 1.19` محتاجينه. الـ `targetSdk` على افتراضي Flutter.
- `firebase_messaging` 17 بيعتبر `getToken()` قديم (deprecated)، بس الباك بيبعت بـ Firebase Admin على الـ Registration token، فاحنا لسه بنستخدمه. السبب مكتوب في الكود.
