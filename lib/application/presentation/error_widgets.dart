import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class RetryButton extends StatelessWidget {
  const RetryButton({super.key, required this.error, required this.onRetry});

  final dynamic error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              //imeplement text based on error type
              error.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            MaterialButton(
              onPressed: onRetry,
              color: MyColors.color772DFF,
              child: Text(
                'Retry',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoData extends StatelessWidget {
  const NoData({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('No data available.', style: Theme.of(context).textTheme.labelMedium),
          ),
          MaterialButton(
            onPressed: onRetry,
            color: MyColors.color772DFF,
            child: Text(
              'Retry',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
