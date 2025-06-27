import 'dart:io';
import 'package:path/path.dart' as p;

// ignore_for_file: avoid_print, avoid_slow_async_io, lines_longer_than_80_chars

/// Generates the ffmpeg command for video conversion
(String, String) command(String input, String output) {
  // return (
  //   'ffmpeg -i $input -vf "scale=960:540:force_original_aspect_ratio=decrease" -pix_fmt rgb8 -r 10 $output',
  //   'gif',
  // );
  // return (
  //   'ffmpeg -i $input -vcodec h264 -acodec aac $output',
  //   'mp4',
  // );
  // return (
  //   'ffmpeg -i $input -vcodec libwebp -lossless 0  -compression_level 4 -loop 0 -an -vf fps=fps=30 $output',
  //   'webp',
  // );
  // Better than gif and similar size
  // return (
  //   'ffmpeg -i $input -vcodec libwebp -lossless 0 -loop 0 -an -vf fps=fps=10 -s 960:540 $output',
  //   'webp',
  // );
  return (
    'ffmpeg -i $input -vcodec libwebp -quality 50 -lossless 0 -loop 0 -an -vf fps=fps=10 -s 1280:720 $output',
    'webp',
  );
}

String extension = 'webp';

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

    final extension = command('', '').$2;
    final outputPath = p.join(outDir.path, '$baseName.$extension');
    // Hacky to call "command" twice but whatever :)
    final cmd = command('"${movFile.path}"', '"$outputPath"').$1;
    final outFile = File(outputPath);
    if (await outFile.exists()) {
      print('Output file already exists: $outputPath');
      continue; // Skip if output file already exists
    }

    print('Converting: $fileName -> $baseName.$extension');

    try {
      print('Executing: $cmd');

      final result = await Process.run('sh', ['-c', cmd]);

      if (result.exitCode != 0) {
        print('Error: ${result.stderr}');
      } else {
        print('Successfully converted $fileName');
        print(result.stdout);
      }
    } catch (e) {
      print('Exception while converting $fileName: $e');
    }
  }

  print('Conversion process complete.');
}
