import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cached_fetcher.dart';
import '../error/failures.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.wifi_off, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Réessayer')),
          ]),
        ),
      );
}

class OfflineChip extends StatelessWidget {
  const OfflineChip({super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: Colors.orange.shade100,
        padding: const EdgeInsets.all(8),
        child: const Text('Données hors-ligne (cache)',
            textAlign: TextAlign.center),
      );
}

String errorText(Object e) =>
    e is Failure ? e.message : 'Une erreur inattendue est survenue.';

class AsyncListView<T> extends StatelessWidget {
  const AsyncListView({
    super.key,
    required this.value,
    required this.onRefresh,
    required this.itemBuilder,
  });
  final AsyncValue<DataResult<List<T>>> value;
  final Future<void> Function() onRefresh;
  final Widget Function(BuildContext, T) itemBuilder;

  @override
  Widget build(BuildContext context) => value.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(message: errorText(e), onRetry: onRefresh),
        data: (result) {
          final offset = result.fromCache ? 1 : 0;
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: result.data.length + offset,
              itemBuilder: (ctx, i) {
                if (offset == 1 && i == 0) return const OfflineChip();
                return itemBuilder(ctx, result.data[i - offset]);
              },
            ),
          );
        },
      );
}

Widget networkImage(String url, {double size = 56}) => ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => SizedBox(
              width: size,
              height: size,
              child: const Icon(Icons.image_not_supported))),
    );
