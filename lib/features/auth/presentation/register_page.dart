import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/async_list_view.dart';
import 'auth_providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _user = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if ([_first, _last, _user, _email, _pass]
        .any((c) => c.text.trim().isEmpty)) {
      setState(() => _error = 'Remplis tous les champs.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).register(
            firstName: _first.text.trim(),
            lastName: _last.text.trim(),
            username: _user.text.trim(),
            email: _email.text.trim(),
            password: _pass.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Compte créé (simulé par DummyJSON). Connecte-toi avec emilys / emilyspass.')));
      Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _field(TextEditingController c, String label,
          {bool obscure = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
            controller: c,
            obscureText: obscure,
            decoration: InputDecoration(labelText: label)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Inscription')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(children: [
            _field(_first, 'Prénom'),
            _field(_last, 'Nom'),
            _field(_user, 'Nom d\'utilisateur'),
            _field(_email, 'Email'),
            _field(_pass, 'Mot de passe', obscure: true),
            if (_error != null)
              Text(_error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 12),
            FilledButton(
                onPressed: _loading ? null : _submit,
                child: const Text('S\'inscrire')),
          ]),
        ),
      );
}
