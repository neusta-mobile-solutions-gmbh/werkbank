import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/src/pages/_internal/page_background.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class UseCasePage extends StatelessWidget {
  const UseCasePage({
    required this.navState,
    super.key,
  });

  final ViewUseCaseNavState navState;

  @override
  Widget build(BuildContext context) {
    final descriptor = navState.descriptor;
    return PageBackground(
      child: DebugDisplayFilter(
        child: UseCaseEnvironmentProvider(
          environment: UseCaseEnvironment.regular,
          child: DescriptorProvider(
            descriptor: descriptor,
            child: CurrentUseCaseControllerByManagerProvider(
              child: UseCaseCompositionByControllerProvider(
                child: _InitialMutationLoader(
                  initialMutation: navState.initialMutation,
                  child: AddonLayerBuilder(
                    layer: AddonLayer.useCaseOverlay,
                    child: UseCaseApp(
                      appConfig: WerkbankAppInfo.appConfigOf(context),
                      child: const AddonLayerBuilder(
                        layer: AddonLayer.useCase,
                        child: UseCaseLayout(
                          child: AddonLayerBuilder(
                            layer: AddonLayer.useCaseFitted,
                            child: UseCaseWidgetDisplay(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// TODO(lzuttermeister): Can we improve this approach?
class _InitialMutationLoader extends StatefulWidget {
  const _InitialMutationLoader({
    required this.initialMutation,
    required this.child,
  });

  final UseCaseStateMutation? initialMutation;
  final Widget child;

  @override
  State<_InitialMutationLoader> createState() => _InitialMutationLoaderState();
}

class _InitialMutationLoaderState extends State<_InitialMutationLoader> {
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final initialMutation = widget.initialMutation;
    if (!isInitialized && initialMutation != null) {
      UseCaseCompositionProvider.compositionOf(context).mutate(initialMutation);
    }
    isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
