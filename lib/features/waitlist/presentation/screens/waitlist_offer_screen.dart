import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubits/waitlist_offer_cubit.dart';
import '../cubits/waitlist_offer_state.dart';
import '../widgets/offer/offer_closed_view.dart';
import '../widgets/offer/offer_open_view.dart';

/// Opened from the N10 push or from the trip/waitlist lists.
class WaitlistOfferScreen extends StatelessWidget {
  const WaitlistOfferScreen({super.key, required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WaitlistOfferCubit(sl(), entryId: entryId)..load(),
      child: BlocConsumer<WaitlistOfferCubit, WaitlistOfferState>(
        listener: (context, state) {
          if (state case WaitlistOfferAccepted(:final booking)) {
            context.pushReplacement(AppRoutes.paymentFor(booking.id));
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.waitlist_offer_title.tr())),
          body: switch (state) {
            WaitlistOfferLoading() || WaitlistOfferAccepted() => const LoadingView(),
            WaitlistOfferError(:final failure) => ErrorView(
              failure: failure,
              onRetry: context.read<WaitlistOfferCubit>().load,
            ),
            WaitlistOfferOpen() => OfferOpenView(state: state),
            WaitlistOfferDeclined() => const OfferClosedView(declined: true),
            WaitlistOfferClosed(:final bookingId) => OfferClosedView(declined: false, bookingId: bookingId),
          },
        ),
      ),
    );
  }
}
