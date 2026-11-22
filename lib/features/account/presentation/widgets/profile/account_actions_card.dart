import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/utils/support_caller.dart';
import '../../../../../core/widgets/confirm_dialog.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../auth/presentation/cubits/session_cubit.dart';

/// Change password, call the admin, log out.
class AccountActionsCard extends StatelessWidget {
  const AccountActionsCard({super.key, this.supportPhone});

  final String? supportPhone;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lock_reset_rounded, color: AppColors.primary),
            title: Text(LocaleKeys.account_change_password.tr(), style: AppStyles.body),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoutes.changePassword),
          ),
          if (supportPhone != null && supportPhone!.isNotEmpty) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.support_agent_rounded, color: AppColors.primary),
              title: Text(LocaleKeys.account_support.tr(), style: AppStyles.body),
              subtitle: Text(supportPhone!, style: AppStyles.caption, textDirection: TextDirection.ltr),
              trailing: TextButton(
                onPressed: () => SupportCaller.call(supportPhone!),
                child: Text(LocaleKeys.account_call.tr()),
              ),
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
            title: Text(LocaleKeys.account_logout.tr(), style: AppStyles.body.copyWith(color: AppColors.danger)),
            onTap: () async {
              final ok = await ConfirmDialog.show(
                context,
                message: LocaleKeys.account_logout_confirm.tr(),
                confirmLabel: LocaleKeys.account_logout.tr(),
              );
              if (ok && context.mounted) await context.read<SessionCubit>().logout();
            },
          ),
        ],
      ),
    );
  }
}
