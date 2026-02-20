import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trading Journal')),
      body: Center(
        child: FilledButton.icon(
          onPressed: () => context.push('/trade/new'),
          icon: const Icon(Icons.add_chart),
          label: const Text('Log Manual Trade'),
        ),
      ),
    );
  }
}
