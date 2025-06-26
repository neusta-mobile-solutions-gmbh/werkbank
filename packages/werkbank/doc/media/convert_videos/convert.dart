import 'dart:io';
import 'package:path/path.dart' as p;

// ignore_for_file: avoid_print, avoid_slow_async_io, lines_longer_than_80_chars

/// Generates the ffmpeg command for video conversion
String command(String input, String output) =>
    // 'ffmpeg -i $input -vf "scale=960:540:force_original_aspect_ratio=decrease" -pix_fmt rgb8 -r 10 $output';
    'ffmpeg -i $input -vcodec h264 -acodec aac $output';

String extension = 'mp4';

void main() async {
  // Get the current directory
  final currentDir = Directory(p.dirname(Platform.script.path));

  // Create "out" directory if it doesn't exist
  final outDir = Directory(p.join(currentDir.path, 'out'));
  if (!await outDir.exists()) {
    await outDir.create();
    print('Created output directory: ${outDir.path}');
  }

  // Find all .mov files in current directory
  final entities = await currentDir.list().toList();
  final movFiles = entities
      .whereType<File>()
      .where((file) => p.extension(file.path).toLowerCase() == '.mov')
      .toList();

  if (movFiles.isEmpty) {
    print('No .mov files found in the current directory.');
    return;
  }

  print('Found ${movFiles.length} .mov files to convert:');

  // Convert each file
  for (final movFile in movFiles) {
    final fileName = p.basename(movFile.path);
    final baseName = p.basenameWithoutExtension(fileName);
    final outputPath = p.join(outDir.path, '$baseName.$extension');
    final outFile = File(outputPath);
    if (await outFile.exists()) {
      print('Output file already exists: $outputPath');
      continue; // Skip if output file already exists
    }

    print('Converting: $fileName -> $baseName.$extension');

    try {
      final cmd = command('"${movFile.path}"', '"$outputPath"');
      print('Executing: $cmd');

      final result = await Process.run('sh', ['-c', cmd]);

      if (result.exitCode != 0) {
        print('Error: ${result.stderr}');
      } else {
        print('Successfully converted $fileName');
      }
    } catch (e) {
      print('Exception while converting $fileName: $e');
    }
  }

  print('Conversion process complete.');
}
