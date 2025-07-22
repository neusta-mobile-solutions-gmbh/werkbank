import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';

mixin SubpackLogger {
  final console = Console();
  final logger = Logger(
    level: SubpackUtils.isVerbose ? Level.verbose : Level.info,
    theme: LogTheme(),
  );
  String defaultIndentation = '  ';

  final _oscHyperlink = RegExp(
    r'\x1B\]8;;.*?(?:\x07|\x1B\\)(.*?)(?:\x1B\]8;;(?:\x07|\x1B\\))',
  );

  String? _customInfoStyle(String? message) {
    return lightGray.wrap(message);
  }

  String? _customWarningStyle(String? message) {
    return lightYellow.wrap(message);
  }

  String? _customErrorStyle(String? message) {
    return red.wrap(message);
  }

  String? _customSuccessStyle(String? message) {
    return green.wrap(styleBold.wrap(message));
  }

  String? _customFinishStyle(String? message) {
    return backgroundWhite.wrap(styleBold.wrap(black.wrap(message)));
  }

  String? _customAttentionStyle(String? message) {
    return styleBold.wrap(red.wrap(message));
  }

  String? _customVerboseStyle(String? message) {
    return darkGray.wrap(message);
  }

  String? _customVerboseWarningStyle(String? message) {
    return yellow.wrap(message);
  }

  String _stripOsc(String input) {
    return input.replaceAllMapped(_oscHyperlink, (match) => match[1]!);
  }

  int _getSymbolsWidth(String text) {
    final strippedText = _stripOsc(text);
    return strippedText.runes.fold(
      0,
      (width, rune) => width + (rune < 128 ? 1 : 2),
    );
  }

  /// Formats a single line of text with indentation and wraps it if necessary.
  ///
  /// The function:
  /// - Prepends a configurable indentation based on the `level`.
  /// - Wraps the line across multiple lines if it exceeds the current terminal width.
  /// - Attempts to wrap cleanly at word boundaries.
  ///
  /// Returns:
  /// A list of indented strings representing wrapped lines.
  List<String> _indent(String line, int level) {
    final indentation = defaultIndentation * level;
    final indentationLength = indentation.length;
    final windowWidth = console.windowWidth;

    if (_getSymbolsWidth(line) + indentationLength <= windowWidth) {
      return [indentation + line];
    }

    final words = line.split(' ');

    final lines = <String>[];
    while (words.isNotEmpty) {
      final line = StringBuffer()..write(indentation);
      int currentWidth = indentationLength;

      while (words.isNotEmpty) {
        final word = words.first;
        final wordWidth = _getSymbolsWidth(word);
        // Space width should be 0 if we're at the start of the line.
        final spaceWidth = currentWidth > indentationLength ? 1 : 0;

        if (currentWidth + spaceWidth + wordWidth > windowWidth) {
          if (currentWidth == indentationLength) {
            // The word is too long even to fit on a new line — force it in
            line.write(word);
            words.removeAt(0);
          }
          break;
        }

        if (spaceWidth > 0) line.write(' ');
        line.write(word);

        currentWidth += spaceWidth + wordWidth;
        words.removeAt(0);
      }

      lines.add(line.toString());
    }
    return lines;
  }

  void _log(
    String message, {
    String? Function(String?)? style,
    int indentation = 0,
    int skipIndentations = 0,
    bool verbose = false,
  }) {
    final inputLines = message.split('\n');
    final outputLines = <String>[];
    int skipped = 0;

    for (final line in inputLines) {
      // We intentionally check lines == '' because .isEmpty
      // won't work on lines containing instructions like \n
      // even though they seem to be empty
      if (indentation > 0 && skipped >= skipIndentations && line != '') {
        outputLines.addAll(_indent(line, indentation));
      } else {
        // automatically skipping "empty" lines
        if (line == '') {
        } else {
          skipped++;
        }
        outputLines.add(line);
      }
    }

    for (final line in outputLines) {
      if (verbose) {
        logger.detail(line, style: style);
      } else {
        logger.info(line, style: style);
      }
    }
  }

  void logInfo(String message) {
    _log(message, style: _customInfoStyle);
  }

  void logWarning(String message) {
    _log(message, style: _customWarningStyle);
  }

  void logError(String message) {
    _log(
      message,
      style: _customErrorStyle,
      indentation: 1,
      skipIndentations: 1,
    );
  }

  void logSuccess(String message) {
    _log(message, style: _customSuccessStyle);
  }

  void logFinish(String message) {
    _log(message, style: _customFinishStyle);
  }

  void logAttention(String message) {
    _log(message, style: _customAttentionStyle);
  }

  void logVerbose(String message) {
    _log(message, style: _customVerboseStyle, verbose: true);
  }

  void logVerboseWarning(String message) {
    _log(message, style: _customVerboseWarningStyle, verbose: true);
  }
}
