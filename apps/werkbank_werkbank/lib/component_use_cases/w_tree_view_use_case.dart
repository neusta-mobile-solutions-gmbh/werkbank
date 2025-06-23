import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wTreeViewUseCase(UseCaseComposer c) {
  return (context) {
    return SingleChildScrollView(
      child: WTreeView(
        treeNodes: [
          WTreeNode(
            key: const ValueKey(1),
            title: const Text('Root'),
            leading: const Icon(
              WerkbankIcons.folderSimple,
              size: 16,
            ),
            children: [
              WTreeNode(
                key: const ValueKey(2),
                title: const Text('Branch 1'),
                leading: const Icon(
                  WerkbankIcons.bookOpen,
                  size: 16,
                ),
                body: WTextArea(text: 'Foo Bar Baz'),
                children: [
                  WTreeNode(
                    key: const ValueKey(3),
                    title: const Text('Leaf 1'),
                    body: WChip(onPressed: () {}, label: const Text('Chip')),
                    leading: const Icon(
                      WerkbankIcons.bookmarkSimple,
                      size: 16,
                    ),
                  ),
                  WTreeNode(
                    key: const ValueKey(4),
                    title: const Text('Branch 1.1'),
                    leading: const Icon(
                      WerkbankIcons.bookOpen,
                      size: 16,
                    ),
                    children: [
                      WTreeNode(
                        key: const ValueKey(5),
                        title: const Text('Branch 1.1.1'),
                        leading: const Icon(
                          WerkbankIcons.bookOpen,
                          size: 16,
                        ),
                        children: [
                          WTreeNode(
                            key: const ValueKey(6),
                            title: const Text('Leaf 1.1.1.1'),
                            leading: const Icon(
                              WerkbankIcons.bookmarkSimple,
                              size: 16,
                            ),
                          ),
                          WTreeNode(
                            key: const ValueKey(7),
                            title: const Text('Leaf 1.1.1.2'),
                            leading: const Icon(
                              WerkbankIcons.bookmarkSimple,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      WTreeNode(
                        key: const ValueKey(8),
                        title: const Text('Leaf 2.2'),
                        leading: const Icon(
                          WerkbankIcons.bookmarkSimple,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              WTreeNode(
                key: const ValueKey(9),
                title: const Text('Branch 2'),
                leading: const Icon(
                  WerkbankIcons.bookOpen,
                  size: 16,
                ),
                children: [
                  WTreeNode(
                    key: const ValueKey(10),
                    title: const Text('Leaf 2.1'),
                    leading: const Icon(
                      WerkbankIcons.bookmarkSimple,
                      size: 16,
                    ),
                  ),
                  WTreeNode(
                    key: const ValueKey(11),
                    title: const Text('Leaf 2.2'),
                    leading: const Icon(
                      WerkbankIcons.bookmarkSimple,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          WTreeNode(
            key: const ValueKey(12),
            title: const Text('Root 2'),
            leading: const Icon(
              WerkbankIcons.folderSimple,
              size: 16,
            ),
            children: [
              WTreeNode(
                key: const ValueKey(13),
                title: const Text('Branch 1'),
                leading: const Icon(
                  WerkbankIcons.bookOpen,
                  size: 16,
                ),
                children: [
                  WTreeNode(
                    key: const ValueKey(14),
                    title: const Text('Leaf 1'),
                    leading: const Icon(
                      WerkbankIcons.bookmarkSimple,
                      size: 16,
                    ),
                  ),
                  WTreeNode(
                    key: const ValueKey(15),
                    title: const Text('Branch 1.1'),
                    leading: const Icon(
                      WerkbankIcons.bookOpen,
                      size: 16,
                    ),
                    children: [
                      WTreeNode(
                        key: const ValueKey(16),
                        title: const Text('Branch 1.1.1'),
                        leading: const Icon(
                          WerkbankIcons.bookOpen,
                          size: 16,
                        ),
                        children: [
                          WTreeNode(
                            key: const ValueKey(17),
                            title: const Text('Leaf 1.1.1.1'),
                            leading: const Icon(
                              WerkbankIcons.bookmarkSimple,
                              size: 16,
                            ),
                          ),
                          WTreeNode(
                            key: const ValueKey(18),
                            title: const Text('Leaf 1.1.1.2'),
                            leading: const Icon(
                              WerkbankIcons.bookmarkSimple,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      WTreeNode(
                        key: const ValueKey(19),
                        title: const Text('Leaf 2.2'),
                        leading: const Icon(
                          WerkbankIcons.bookmarkSimple,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              WTreeNode(
                key: const ValueKey(20),
                title: const Text('Branch 2'),
                leading: const Icon(
                  WerkbankIcons.bookOpen,
                  size: 16,
                ),
                children: [
                  WTreeNode(
                    key: const ValueKey(21),
                    title: const Text('Leaf 2.1'),
                    leading: const Icon(
                      WerkbankIcons.bookmarkSimple,
                      size: 16,
                    ),
                  ),
                  WTreeNode(
                    key: const ValueKey(22),
                    title: const Text('Leaf 2.2'),
                    leading: const Icon(
                      WerkbankIcons.bookmarkSimple,
                      size: 16,
                    ),
                  ),
                ],
              ),
              WTreeNode(
                key: UniqueKey(),
                title: const Text('Deep Branch 3'),
                leading: const Icon(
                  WerkbankIcons.bookOpen,
                  size: 16,
                ),
                children: [
                  WTreeNode(
                    key: UniqueKey(),
                    title: const Text('Deep'),
                    leading: const Icon(
                      WerkbankIcons.bookmarkSimple,
                      size: 16,
                    ),
                    children: [
                      WTreeNode(
                        key: UniqueKey(),
                        title: const Text('Deep'),
                        leading: const Icon(
                          WerkbankIcons.bookmarkSimple,
                          size: 16,
                        ),
                        children: [
                          WTreeNode(
                            key: UniqueKey(),
                            title: const Text('Deep'),
                            leading: const Icon(
                              WerkbankIcons.bookmarkSimple,
                              size: 16,
                            ),
                            children: [
                              WTreeNode(
                                key: UniqueKey(),
                                title: const Text('Deep'),
                                leading: const Icon(
                                  WerkbankIcons.bookmarkSimple,
                                  size: 16,
                                ),
                                children: [
                                  WTreeNode(
                                    key: UniqueKey(),
                                    title: const Text('Deep'),
                                    leading: const Icon(
                                      WerkbankIcons.bookmarkSimple,
                                      size: 16,
                                    ),
                                    children: [
                                      WTreeNode(
                                        key: UniqueKey(),
                                        title: const Text('Deep'),
                                        leading: const Icon(
                                          WerkbankIcons.bookmarkSimple,
                                          size: 16,
                                        ),
                                        children: [
                                          WTreeNode(
                                            key: UniqueKey(),
                                            title: const Text('Deep'),
                                            leading: const Icon(
                                              WerkbankIcons.bookmarkSimple,
                                              size: 16,
                                            ),
                                            children: [
                                              WTreeNode(
                                                key: UniqueKey(),
                                                title: const Text('Deep'),
                                                leading: const Icon(
                                                  WerkbankIcons.bookmarkSimple,
                                                  size: 16,
                                                ),
                                                children: [
                                                  WTreeNode(
                                                    key: UniqueKey(),
                                                    title: const Text('Deep'),
                                                    leading: const Icon(
                                                      WerkbankIcons
                                                          .bookmarkSimple,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  };
}
