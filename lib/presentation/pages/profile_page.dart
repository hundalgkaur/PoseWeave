import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/api_config.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/profile_cubit.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Cloud profile: shows the signed-in user's aggregate stats from the backend.
/// When no backend URL is configured, explains the offline-first stance.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) {
        final ProfileCubit cubit = getIt<ProfileCubit>();
        if (ApiConfig.isConfigured) cubit.load();
        return cubit;
      },
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              ApiConfig.isConfigured
                  ? const _CloudStats()
                  : _notConfigured(context),
        ),
      ),
    );
  }

  Widget _notConfigured(BuildContext context) {
    return Center(
      child: GlassPanel(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cloud_off,
              color: AppColors.onSurfaceVariant,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'Cloud sync isn’t configured',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'PoseWeave is offline-first. Build with '
              '--dart-define=POSEWEAVE_API=<url> to enable profiles, history, '
              'and the leaderboard.',
              textAlign: TextAlign.center,
              style: AppTheme.mono(
                color: AppColors.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloudStats extends StatelessWidget {
  const _CloudStats();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (BuildContext context, ProfileState state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryContainer,
              ),
            ),
          );
        }
        if (state is ProfileError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: AppTheme.mono(color: AppColors.error),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.read<ProfileCubit>().load(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        final Map<String, dynamic> s = (state as ProfileLoaded).summary;
        return ListView(
          children: <Widget>[
            _stat('Total sessions', '${s['totalSessions'] ?? 0}'),
            _stat('Total reps', '${s['totalReps'] ?? 0}'),
            _stat('Streak (days)', '${s['streakDays'] ?? 0}'),
            _stat(
              'Avg form',
              s['avgFormScore'] == null
                  ? '—'
                  : (s['avgFormScore'] as num).toStringAsFixed(1),
            ),
            _stat('Favourite', '${s['favouriteExercise'] ?? '—'}'),
          ],
        );
      },
    );
  }

  Widget _stat(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: GlassPanel(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: AppTheme.mono(color: AppColors.onSurfaceVariant)),
          Text(
            value,
            style: AppTheme.mono(
              color: AppColors.primary,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
