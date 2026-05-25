import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/settings_bloc.dart';
import 'package:poseweave/presentation/widgets/api_key_field.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// BYOK settings: store / test / clear the user's Anthropic API key, with a
/// privacy note. The key is kept encrypted on-device only.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (_) => getIt<SettingsBloc>()..add(const SettingsEvent.load()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  final TextEditingController _key = TextEditingController();

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (BuildContext context, SettingsState state) {
            if (state.message != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message!)));
            }
          },
          builder: (BuildContext context, SettingsState state) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'AI RECOMMENDATIONS',
                            style: AppTheme.labelCaps(),
                          ),
                          const Spacer(),
                          _StatusChip(configured: state.hasKey),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ApiKeyField(controller: _key),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primaryContainer,
                                foregroundColor: AppColors.onPrimary,
                              ),
                              onPressed:
                                  state.busy
                                      ? null
                                      : () => context.read<SettingsBloc>().add(
                                        SettingsEvent.saveKey(_key.text.trim()),
                                      ),
                              child:
                                  state.busy
                                      ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text('Test & Save'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed:
                                () => context.read<SettingsBloc>().add(
                                  const SettingsEvent.clearKey(),
                                ),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No key? Create one at console.anthropic.com',
                        style: AppTheme.mono(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('PRIVACY', style: AppTheme.labelCaps()),
                      const SizedBox(height: 8),
                      Text(
                        'Your key is stored encrypted on this device only. It is '
                        'never sent to PoseWeave servers — only directly to '
                        'api.anthropic.com when you request recommendations.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.configured});
  final bool configured;

  @override
  Widget build(BuildContext context) {
    final Color c = configured ? AppColors.success : AppColors.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.circle, size: 8, color: c),
        const SizedBox(width: 6),
        Text(
          configured ? 'Configured' : 'Not set',
          style: AppTheme.mono(fontSize: 11, color: c),
        ),
      ],
    );
  }
}
