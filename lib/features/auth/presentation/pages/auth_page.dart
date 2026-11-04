import 'package:flutter/material.dart';

import '../../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

final class AuthPage extends StatefulWidget {
  const AuthPage({required this.controller, super.key});

  final AuthController controller;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

final class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.controller,
    builder: (context, _) {
      final session = widget.controller.session;
      if (session != null) {
        return _SignedInView(
          email: session.email,
          onSignOut: widget.controller.signOut,
        );
      }
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Authentication',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text('Use the demo account below to try the sign-in flow.'),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => Validators.email(value ?? ''),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) => Validators.password(value ?? ''),
                    ),
                    if (widget.controller.errorMessage case final message?) ...[
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: widget.controller.isLoading ? null : _submit,
                        child: widget.controller.isLoading
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Sign in'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Demo: demo@example.com / password123'),
        ],
      );
    },
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.controller.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}

final class _SignedInView extends StatelessWidget {
  const _SignedInView({required this.email, required this.onSignOut});

  final String email;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user_outlined, size: 56),
              const SizedBox(height: 12),
              Text(
                'Authenticated',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(email),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onSignOut,
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
