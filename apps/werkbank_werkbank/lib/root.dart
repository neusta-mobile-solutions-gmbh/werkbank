import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/component_use_cases/w_animated_visibility_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_bordered_box_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_button_base_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_chip_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_collapsible_height_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_control_item_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_control_section_list_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_delayed_reveal_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_divider_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_dropdown_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_expanded_indicator_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_icon_button_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_keyboard_button_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_notification_use_cases.dart';
import 'package:werkbank_werkbank/component_use_cases/w_overview_tile_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_path_display_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_project_info_area_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_resizable_panels_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_shortcut_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_slider_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_switch_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_tab_view_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_text_area_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_text_field_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_titled_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_trailing_button_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_tree_item_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_tree_view_use_case.dart';
import 'package:werkbank_werkbank/component_use_cases/w_two_cols_layout_use_case.dart';
import 'package:werkbank_werkbank/feature_use_cases/color_picker_use_case.dart';
import 'package:werkbank_werkbank/feature_use_cases/display_use_case.dart';
import 'package:werkbank_werkbank/feature_use_cases/hot_reload_effect_use_case.dart';
import 'package:werkbank_werkbank/feature_use_cases/knobs_use_case.dart';
import 'package:werkbank_werkbank/feature_use_cases/logo_use_case.dart';
import 'package:werkbank_werkbank/feature_use_cases/notification_use_case.dart';
import 'package:werkbank_werkbank/feature_use_cases/search_use_cases.dart';
import 'package:werkbank_werkbank/feature_use_cases/semantics_use_cases.dart';
import 'package:werkbank_werkbank/feature_use_cases/sizing_use_case.dart';
import 'package:werkbank_werkbank/feature_use_cases/werkbank_logo_use_case.dart';
import 'package:werkbank_werkbank/feature_use_cases/wrapping_use_cases.dart';

WerkbankRoot get root => WerkbankRoot(
  builder: (c) {
    c.background.named('T: Surface');
  },
  children: [
    WerkbankFolder(
      name: 'Components',
      builder: (context) {},
      children: [
        WerkbankUseCase(
          name: 'WSwitch',
          builder: wSwitchUseCase,
        ),
        WerkbankUseCase(
          name: 'WSlider',
          builder: wSliderUseCase,
        ),
        WerkbankUseCase(
          name: 'WBorderedBox',
          builder: wBorderedBoxUseCase,
        ),
        WerkbankUseCase(
          name: 'WChip',
          builder: wChipUseChase,
        ),
        WerkbankUseCase(
          name: 'WButtonBase',
          builder: wButtonBaseUseCase,
        ),
        WerkbankUseCase(
          name: 'WDropdown',
          builder: wDropdownUseCase,
        ),
        WerkbankUseCase(
          name: 'WIconButton',
          builder: wIconButtonUseCase,
        ),
        WerkbankUseCase(
          name: 'WTrailingButton',
          builder: wTrailingButtonUseCase,
        ),
        WerkbankUseCase(
          name: 'WProjectInfoArea',
          builder: wProjectInfoAreaUseCase,
        ),
        WerkbankUseCase(
          name: 'WDelayedReveal',
          builder: wDelayedRevealUseCase,
        ),
        WerkbankUseCase(
          name: 'WDivider',
          builder: wDividerUseCase,
        ),
        WerkbankUseCase(
          name: 'WTabView',
          builder: wTabViewUseCase,
        ),
        WerkbankUseCase(
          name: 'WPathDisplay',
          builder: wPathDisplayUseCase,
        ),
        WerkbankUseCase(
          name: 'WCollapsibleHeight',
          builder: wCollapsibleHeightUseCase,
        ),
        WerkbankUseCase(
          name: 'WResizablePanels',
          builder: wResizablePanelsUseCase,
        ),
        WerkbankUseCase(
          name: 'WTitled',
          builder: wTitledUseCase,
        ),
        WerkbankUseCase(
          name: 'WControlSectionList',
          builder: wControlSectionListUseCase,
        ),
        WerkbankUseCase(
          name: 'WControlItem',
          builder: wControlItemUseCase,
        ),
        textAreaComponent,
        WerkbankUseCase(
          name: 'WAnimatedVisibility',
          builder: wAnimatedVisibilityUseCase,
        ),
        WerkbankUseCase(
          name: 'WExpandedIndicator',
          builder: wExpandedIndicatorUseCase,
        ),
        wNotificationComponent,
        WerkbankComponent(
          name: 'WTreeView',
          useCases: [
            WerkbankUseCase(
              name: 'WTreeView',
              builder: wTreeViewUseCase,
            ),
            WerkbankUseCase(
              name: 'WTreeItem',
              builder: wTreeItemUseCase,
            ),
          ],
        ),
        WerkbankUseCase(
          name: 'WTwoColsLayout',
          builder: wTwoColsLayoutUseCase,
        ),
        WerkbankUseCase(name: 'WTextField', builder: wTextFieldUseCase),
        WerkbankUseCase(
          name: 'WKeyboardButton',
          builder: wKeyboardButtonUseCase,
        ),
        WerkbankUseCase(
          name: 'WShortcut',
          builder: wShortcutUseCase,
        ),
        WerkbankUseCase(
          name: 'WOverviewTile',
          builder: wOverviewTileUseChase,
        ),
      ],
    ),
    WerkbankFolder(
      name: 'Theme',
      builder: (c) {
        c.overview.minimumSize(width: 500);
      },
      children: [
        WerkbankUseCase(
          name: 'Colors',
          builder: colorsUseCaseBuilder(
            builder: (c) {},
            colors: (context) {
              final scheme = context.werkbankColorScheme;
              return {
                'background': scheme.background,
                'backgroundActive': scheme.backgroundActive,
                'chip': scheme.chip,
                'divider': scheme.divider,
                'field': scheme.field,
                'fieldContent': scheme.fieldContent,
                'hoverFocus': scheme.hoverFocus,
                'icon': scheme.icon,
                'logo': scheme.logo,
                'surface': scheme.surface,
                'tabFocus': scheme.tabFocus,
                'tabFocusActive': scheme.tabFocusActive,
                'text': scheme.text,
                'textActive': scheme.textActive,
                'textHighlighted': scheme.textHighlighted,
                'textLight': scheme.textLight,
              };
            },
          ),
        ),
        WerkbankUseCase(
          name: 'Text Styles',
          builder: textStylesUseCaseBuilder(
            builder: (c) {},
            styles: (context) {
              final scheme = context.werkbankTextTheme;
              return {
                'defaultText': scheme.defaultText,
                'headline': scheme.headline,
                'detail': scheme.detail,
                'interaction': scheme.interaction,
                'input': scheme.input,
                'indicator': scheme.indicator,
                'textSmall': scheme.textSmall,
                'textLight': scheme.textLight,
              };
            },
          ),
        ),
        WerkbankUseCase(
          name: 'Icons',
          builder: iconsUseCaseBuilder(
            builder: (c) {},
            icons: (context) {
              return {
                'arrowSquareOut': WerkbankIcons.arrowSquareOut,
                'plusSquare': WerkbankIcons.plusSquare,
                'trashSimple': WerkbankIcons.trashSimple,
                'copy': WerkbankIcons.copy,
                'bookmarkSimple': WerkbankIcons.bookmarkSimple,
                'x': WerkbankIcons.x,
                'caretDown': WerkbankIcons.caretDown,
                'bookOpen': WerkbankIcons.bookOpen,
                'eyeClosed': WerkbankIcons.eyeClosed,
                'empty': WerkbankIcons.empty,
                'githubLogo': WerkbankIcons.githubLogo,
                'eye': WerkbankIcons.eye,
                'pause': WerkbankIcons.pause,
                'squaresFour': WerkbankIcons.squaresFour,
                'linkSimple': WerkbankIcons.linkSimple,
                'circle': WerkbankIcons.circle,
                'dotsThree': WerkbankIcons.dotsThree,
                'appleLogo': WerkbankIcons.appleLogo,
                'dotsSixVertical': WerkbankIcons.dotsSixVertical,
                'figmaLogo': WerkbankIcons.figmaLogo,
                'folderSimple': WerkbankIcons.folderSimple,
                'skipBack': WerkbankIcons.skipBack,
                'plusCircle': WerkbankIcons.plusCircle,
                'pushPin': WerkbankIcons.pushPin,
                'info': WerkbankIcons.info,
                'letter': WerkbankIcons.letter,
                'skipForward': WerkbankIcons.skipForward,
                'play': WerkbankIcons.play,
                'warning': WerkbankIcons.warning,
                'magnifyingGass': WerkbankIcons.magnifyingGass,
              };
            },
          ),
        ),
      ],
    ),
    WerkbankFolder(
      name: 'Features',
      children: [
        WerkbankUseCase(
          name: 'Knobs',
          builder: knobsUseCase,
        ),
        WerkbankUseCase(
          name: 'Display',
          builder: displayUseCase,
        ),
        WerkbankFolder(
          name: 'Sizing',
          children: [
            WerkbankUseCase(
              name: 'Unlimited',
              builder: sizingUseCase,
            ),
            WerkbankUseCase(
              name: 'Limited Min',
              builder: limitedMinUseCase,
            ),
            WerkbankUseCase(
              name: 'Limited Max',
              builder: limitedMaxUseCase,
            ),
            WerkbankUseCase(
              name: 'Limited Min and Max',
              builder: limitedMinAndMaxUseCase,
            ),
          ],
        ),
        WerkbankFolder(
          name: 'Semantics',
          children: [
            WerkbankUseCase(
              name: 'Nested Semantics',
              builder: nestedSemanticsUseCase,
            ),
            WerkbankUseCase(
              name: 'Attributed Strings',
              builder: attributedStringsUseCase,
            ),
            WerkbankUseCase(
              name: 'Material Components',
              builder: materialComponentsUseCase,
            ),
          ],
        ),
        WerkbankUseCase(
          name: 'Hot Reload Effect',
          builder: hotReloadEffectUseCase,
        ),
        WerkbankUseCase(
          name: 'Logo',
          builder: logoUseCase,
        ),
        WerkbankUseCase(
          name: 'Color Picker',
          builder: colorPickerUseCase,
        ),
        WerkbankUseCase(
          name: 'Notification',
          builder: notificationUseCase,
        ),
        WerkbankUseCase(
          name: 'WerkbankLogo',
          builder: werkbankLogoUseCase,
        ),
        searchDemoFolder,
        descriptionSection,
        wrappingFolder,
      ],
    ),
  ],
);

WerkbankChildNode get descriptionSection => WerkbankFolder(
  name: 'Description Folder 1',
  builder: (c) {
    c.description('# folder 1 description');
  },
  children: [
    WerkbankFolder(
      name: 'Description Folder 2',
      builder: (c) {
        c.description('## folder 2 description');
      },
      children: [
        WerkbankComponent(
          name: 'Description Component',
          builder: (c) {
            c.description('### component description');
          },
          useCases: [
            WerkbankUseCase(
              name: 'Description UseCase',
              builder: descriptionUseCase,
            ),
          ],
        ),
      ],
    ),
  ],
);

WidgetBuilder descriptionUseCase(UseCaseComposer c) {
  c.description('description, supporting *markdown.*');
  return (context) {
    return Text(
      'See Inspect-Tab',
      style: context.werkbankTextTheme.detail.copyWith(
        color: context.werkbankColorScheme.text,
      ),
    );
  };
}
