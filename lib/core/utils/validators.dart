import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';

/// Client-side checks that mirror the contract, so the form blocks obvious mistakes
/// before a round trip. The server stays the source of truth.
abstract final class Validators {
  static final _phone = RegExp(r'^01[0-9]{9}$');
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _otp = RegExp(r'^[0-9]{6}$');

  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? LocaleKeys.errors_required.tr() : null;

  static String? name(String? value) =>
      required(value) ?? (value!.trim().length < 2 ? LocaleKeys.errors_name_short.tr() : null);

  static String? phone(String? value) =>
      required(value) ?? (_phone.hasMatch(value!.trim()) ? null : LocaleKeys.errors_invalid_phone.tr());

  static String? email(String? value) =>
      required(value) ?? (_email.hasMatch(value!.trim()) ? null : LocaleKeys.errors_invalid_email.tr());

  /// Login accepts an email or an Egyptian mobile number.
  static String? identifier(String? value) {
    final error = required(value);
    if (error != null) return error;
    final v = value!.trim();
    return v.contains('@') ? email(v) : phone(v);
  }

  static String? password(String? value) =>
      required(value) ?? (value!.length < 8 ? LocaleKeys.errors_password_short.tr() : null);

  static String? otp(String? value) =>
      required(value) ?? (_otp.hasMatch(value!.trim()) ? null : LocaleKeys.errors_otp_format.tr());

  static String? Function(String?) matches(String Function() other) =>
      (value) => required(value) ?? (value != other() ? LocaleKeys.errors_passwords_mismatch.tr() : null);
}
