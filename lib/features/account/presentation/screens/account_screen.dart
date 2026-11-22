import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/loading_view.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/presentation/cubits/session_cubit.dart';
import '../../../auth/presentation/cubits/session_state.dart';
import '../../../config/presentation/cubits/config_cubit.dart';
import '../../../config/presentation/cubits/config_state.dart';
import '../widgets/profile/account_actions_card.dart';
import '../widgets/profile/profile_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final config = context.watch<ConfigCubit>().state;
    final supportPhone = config is ConfigLoaded ? config.config.supportPhone : null;
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.account_title.tr())),
      body: switch (session) {
        SessionAuthenticated(:final user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProfileCard(user: user),
            const SizedBox(height: 12),
            AccountActionsCard(supportPhone: supportPhone),
          ],
        ),
        _ => const LoadingView(),
      },
    );
  }
}
