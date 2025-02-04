import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:lotti/blocs/sync/sync_config_cubit.dart';
import 'package:lotti/blocs/sync/sync_config_state.dart';
import 'package:lotti/pages/settings/sync/tutorial_utils.dart';
import 'package:lotti/utils/platform.dart';
import 'package:lotti/widgets/sync/qr_widget.dart';
import 'package:lottie/lottie.dart';

class SyncAssistantQrCodeSlide extends StatelessWidget {
  const SyncAssistantQrCodeSlide(
    this.page,
    this.pageCount,
    this.notifier, {
    super.key,
  });

  final int page;
  final int pageCount;
  final ValueNotifier<double> notifier;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncConfigCubit, SyncConfigState>(
      builder: (context, SyncConfigState state) {
        return SlidingPage(
          page: page,
          notifier: notifier,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SyncAssistantHeaderWidget(
                index: page,
                pageCount: pageCount,
              ),
              state.maybeWhen(
                configured: (_, __) => Align(
                  alignment: Alignment.topRight,
                  child: SlidingContainer(
                    offset: 250,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 80),
                      width: textBodyWidth(context),
                      child: Lottie.asset(
                        'assets/lottiefiles/6650-sparkles-burst.json',
                        width: 160,
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isMobile ? 250 : 0),
                  child: const SlidingContainer(
                    child: EncryptionQrWidget(),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
