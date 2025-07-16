import 'dart:io';
import 'package:io/io.dart';
import 'package:path/path.dart' as path;

// ignore_for_file: avoid_print

void main() async {
  verifyToolInstalled('inkscape');
  verifyToolInstalled('svgcleaner');

  final currentDir = Directory.current;
  final iconsRawDir = Directory(path.join(currentDir.path, 'icons_raw'));
  final iconsDir = Directory(path.join(currentDir.path, 'icons'));

  if (iconsDir.existsSync()) {
    iconsDir.deleteSync(recursive: true);
  }

  await copyPath(iconsRawDir.path, iconsDir.path);

  print('Renaming SVG files...');
  final svgFiles = iconsDir.listSync().whereType<File>().where(
    (file) => path.extension(file.path) == '.svg',
  );
  final svgFilesAfterRename = <File>[];

  for (final file in svgFiles) {
    final filename = path.basename(file.path);
    if (filename.startsWith('Icon=')) {
      final newPath = path.join(
        path.dirname(file.path),
        filename.replaceFirst('Icon=', ''),
      );
      svgFilesAfterRename.add(await file.rename(newPath));
    }
  }

  print('Converting paths in inkscape...');
  for (final file in svgFilesAfterRename) {
    await Process.run(
      'inkscape',
      [
        '--actions=select-all:all;object-stroke-to-path;path-union',
        '--export-filename=${file.path}',
        file.path,
      ],
    );
  }

  print('Cleaning up SVG files...');
  for (final file in svgFilesAfterRename) {
    await Process.run('svgcleaner', [file.path, file.path]);
  }

  print('Generating icon font...');
  await Process.run(
    'fvm',
    ['dart', 'run', 'icon_font_generator:generator'],
    runInShell: true,
  );

  if (iconsDir.existsSync()) {
    iconsDir.deleteSync(recursive: true);
  }

  print('Done.');
}

Future<void> verifyToolInstalled(
  String executable, [
  List<String> args = const ['--help'],
]) async {
  try {
    final result = await Process.run(
      executable,
      args,
      stdoutEncoding: null,
      stderrEncoding: null,
    );
    if (result.exitCode != 0) {
      throw ProcessException(executable, args);
    }
  } on ProcessException {
    print('$executable is not installed. Please install it first.');
    exit(1);
  }
}
