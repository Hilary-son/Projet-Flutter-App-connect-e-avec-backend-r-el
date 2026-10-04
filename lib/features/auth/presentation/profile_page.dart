import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/async_list_view.dart';
import 'auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    Future<void> reload() async {
      await ref.refresh(profileProvider.future);
    }

    return profile.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(message: errorText(e), onRetry: reload),
      data: (r) => ListView(padding: const EdgeInsets.all(24), children: [
        if (r.fromCache) const OfflineChip(),
        const SizedBox(height: 16),
        Center(child: networkImage(r.data.image, size: 96)),
        const SizedBox(height: 16),
        Center(
            child: Text('${r.data.firstName} ${r.data.lastName}',
                style: Theme.of(context).textTheme.headlineSmall)),
        Center(child: Text('@${r.data.username}')),
        Center(child: Text(r.data.email)),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          icon: const Icon(Icons.logout),
          label: const Text('Se déconnecter'),
        ),
      ]),
    );
  }
}
