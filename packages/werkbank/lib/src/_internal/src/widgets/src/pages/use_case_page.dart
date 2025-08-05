import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/filter/filter.dart';
import 'package:werkbank/src/_internal/src/widgets/src/pages/_internal/page_background.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/descriptor_provider.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/use_case_composition/use_case_composition_by_controller_provider.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/use_case_composition/use_case_composition_provider.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/use_case_controller_provider/current_use_case_controller_by_manager_provider.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/use_case_environment_provider.dart';
import 'package:werkbank/src/_internal/src/widgets/src/use_case_app.dart';
import 'package:werkbank/src/_internal/src/widgets/src/use_case_layout.dart';
import 'package:werkbank/src/_internal/src/widgets/src/use_case_widget_display.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/environment/environment.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/widgets/widgets.dart';

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
