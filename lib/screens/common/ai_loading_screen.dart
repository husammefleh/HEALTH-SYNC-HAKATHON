import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/analysis_models.dart';
import '../../services/analysis/analysis_coordinator.dart';
import '../../services/api/ai_api_service.dart';
import '../../services/api/api_exception.dart';
import '../../services/api/hedera_writer_service.dart';
import '../../state/app_state.dart';

class AiAnalysisRequest<T extends AnalysisResultBase> {
  const AiAnalysisRequest({
    required this.loadingTitle,
    required this.perform,
    required this.onResult,
    this.loadingDescription,
    this.icon,
    this.onError,
  });

  final String loadingTitle;
  final String? loadingDescription;
  final IconData? icon;
  final Future<T> Function(
    AnalysisCoordinator coordinator,
    AppState appState,
  ) perform;
  final Widget Function(BuildContext context, T result) onResult;
  final void Function(BuildContext context, Object error)? onError;
}

class AiLoadingScreen<T extends AnalysisResultBase> extends StatefulWidget {
  const AiLoadingScreen({super.key, required this.request});

  final AiAnalysisRequest<T> request;

  static Route<R> route<R extends AnalysisResultBase>(
    AiAnalysisRequest<R> request,
  ) {
    return MaterialPageRoute(
      builder: (_) => AiLoadingScreen<R>(request: request),
    );
  }

  @override
  State<AiLoadingScreen<T>> createState() => _AiLoadingScreenState<T>();
}

class _AiLoadingScreenState<T extends AnalysisResultBase>
    extends State<AiLoadingScreen<T>> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnalysis());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startAnalysis() async {
    if (_hasStarted || !mounted) return;
    _hasStarted = true;

    final appState = context.read<AppState>();
    final coordinator = AnalysisCoordinator(
      aiApi: context.read<AiApiService>(),
      hederaWriter: context.read<HederaWriterService>(),
      appState: appState,
    );

    try {
      final result = await widget.request.perform(coordinator, appState);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => widget.request.onResult(context, result),
        ),
      );
    } catch (error, stackTrace) {
      if (!mounted) return;
      widget.request.onError?.call(context, error);
      final message = _formatErrorMessage(error);
      debugPrint('AI analysis failed: $error\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  String _formatErrorMessage(Object error) {
    if (error is ApiException) return error.message;
    if (error is StateError) return error.message;
    return 'We could not complete the analysis. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: _animation,
                child: Icon(
                  widget.request.icon ?? Icons.auto_awesome,
                  color: primary,
                  size: 72,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.request.loadingTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.request.loadingDescription != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.request.loadingDescription!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
