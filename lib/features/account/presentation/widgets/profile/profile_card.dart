import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/info_row.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../auth/data/models/user_model.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primaryLight,
            child: Text(user.name.characters.first, style: AppStyles.headline.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(height: 8),
          Text(user.name, style: AppStyles.title),
          const Divider(height: 24),
          InfoRow(icon: Icons.phone_android_rounded, label: LocaleKeys.account_phone.tr(), value: user.phone),
          InfoRow(icon: Icons.alternate_email_rounded, label: LocaleKeys.account_email.tr(), value: user.email),
        ],
      ),
    );
  }
}
