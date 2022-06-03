import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lotti/theme.dart';

class DashboardsAppBar extends StatelessWidget with PreferredSizeWidget {
  const DashboardsAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: AppColors.headerBgColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          Text(
            localizations.navTabTitleInsights,
            style: appBarTextStyle,
          ),
          IconButton(
            padding: const EdgeInsets.all(4),
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.entryTextColor,
            onPressed: () {
              context.router.pushNamed('/settings/dashboards/');
            },
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}