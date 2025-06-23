import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wControlSectionListUseCase(UseCaseComposer c) {
  c.overview
    ..minimumSize(width: 300, height: 300)
    ..withoutPadding();
  return (context) {
    return WControlSectionList(
      onReorder: (oldIndex, newIndex) {},
      onToggleVisibility: (index) {},
      sections: [
        for (var i = 0; i < 3; i++)
          ControlSection(
            id: 'section_$i',
            title: Text('Section $i'),
            visible: true,
            children: [
              const SizedBox(height: 100),
            ],
          ),
      ],
    );
  };
}
