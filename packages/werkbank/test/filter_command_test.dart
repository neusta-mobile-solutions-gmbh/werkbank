import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/src/_internal/src/filter/src/filter_command.dart';

void _expectInvalidFor(String searchQuery, FilterCommand command) {
  expect(command.searchQuery, equals(searchQuery));
  expect(command.field, isNull);
  expect(command.percise, isFalse);
  expect(command.patternInvalid, isTrue);
}

void main() {
  group('FilterCommand', () {
    group('Basic search queries', () {
      test('should handle simple word search (fuzzy)', () {
        final command = FilterCommand(searchQuery: 'test');

        expect(command.searchQuery, equals('test'));
        expect(command.field, isNull);
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle empty search query', () {
        final command = FilterCommand(searchQuery: '');

        expect(command.searchQuery, equals(''));
        expect(command.field, isNull);
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle multi-word search without quotes (fuzzy)', () {
        final command = FilterCommand(searchQuery: 'hello world');

        expect(command.searchQuery, equals('hello world'));
        expect(command.field, isNull);
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });
    });

    group('Precise search with quotes', () {
      test('should handle precise search with double quotes', () {
        final command = FilterCommand(searchQuery: '"exact phrase"');

        expect(command.searchQuery, equals('exact phrase'));
        expect(command.field, isNull);
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle single word in quotes', () {
        final command = FilterCommand(searchQuery: '"test"');

        expect(command.searchQuery, equals('test'));
        expect(command.field, isNull);
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle empty quotes', () {
        final command = FilterCommand(searchQuery: '""');

        expect(command.searchQuery, equals(''));
        expect(command.field, isNull);
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });

      test('should mark unmatched opening quote as valid', () {
        // While writing the query, the user has not closed the quote
        // and it dont want this to be marked as invalid.
        final command = FilterCommand(searchQuery: 'field:"unclosed');

        expect(command.searchQuery, equals('unclosed'));
        expect(command.field, equals('field'));
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });
    });

    group('Field-specific search', () {
      test('should handle field search without quotes (fuzzy)', () {
        final command = FilterCommand(searchQuery: 'tag:flutter');

        expect(command.searchQuery, equals('flutter'));
        expect(command.field, equals('tag'));
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle field search with quotes (precise)', () {
        final command = FilterCommand(searchQuery: 'desc:"flutter widget"');

        expect(command.searchQuery, equals('flutter widget'));
        expect(command.field, equals('desc'));
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle field search with empty value', () {
        final command = FilterCommand(searchQuery: 'tag:');

        expect(command.searchQuery, equals(''));
        expect(command.field, equals('tag'));
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle field search with empty quoted value', () {
        final command = FilterCommand(searchQuery: 'category:""');

        expect(command.searchQuery, equals(''));
        expect(command.field, equals('category'));
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle field names with special characters', () {
        final command = FilterCommand(searchQuery: 'field_name:value');

        expect(command.searchQuery, equals('value'));
        expect(command.field, equals('field_name'));
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });
    });

    group('Invalid patterns', () {
      test('should mark multiple colons as invalid', () {
        final command = FilterCommand(searchQuery: 'tag:test:invalid');

        _expectInvalidFor('tag:test:invalid', command);
      });

      test('should mark more than two quotes as invalid', () {
        final command = FilterCommand(searchQuery: '"test" "another"');

        _expectInvalidFor('"test" "another"', command);
      });

      test('should mark three quotes as invalid', () {
        final command = FilterCommand(searchQuery: '"test"extra"');

        _expectInvalidFor('"test"extra"', command);
      });

      test('should mark wrong symbol order as invalid', () {
        final command = FilterCommand(searchQuery: '"test":field');

        _expectInvalidFor('"test":field', command);
      });

      test('should mark invalid quote positions as invalid', () {
        final command = FilterCommand(searchQuery: 'field:test"invalid');

        _expectInvalidFor('field:test"invalid', command);
      });

      test('should mark text after closing quote as invalid', () {
        final command = FilterCommand(searchQuery: 'field:"test"extra');

        _expectInvalidFor('field:"test"extra', command);
      });
    });

    group('Edge cases', () {
      test('should handle single colon', () {
        final command = FilterCommand(searchQuery: ':');

        expect(command.searchQuery, equals(''));
        expect(command.field, equals(''));
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle single quote as valid', () {
        // This is the case when the user starts writing a query
        // and wants it to be persice,
        final command = FilterCommand(searchQuery: '"');

        expect(command.searchQuery, equals(''));
        expect(command.field, isNull);
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });

      test('should not handle field with colon in quoted value', () {
        final command = FilterCommand(searchQuery: 'url:"https://example.com"');
        // While this would be cool, it is not supported, since i dont want this
        // to be even more complex.

        _expectInvalidFor('url:"https://example.com"', command);
      });

      test('should handle quotes in non-field search as invalid', () {
        final command = FilterCommand(searchQuery: 'say "hello world"');

        _expectInvalidFor('say "hello world"', command);
      });

      test('should handle special characters in search query', () {
        final command = FilterCommand(searchQuery: r'test@#$%^&*()');

        expect(command.searchQuery, equals(r'test@#$%^&*()'));
        expect(command.field, isNull);
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle unicode characters', () {
        final command = FilterCommand(searchQuery: 'üöäß');

        expect(command.searchQuery, equals('üöäß'));
        expect(command.field, isNull);
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle unicode in field search', () {
        final command = FilterCommand(
          searchQuery: 'beschreibung:"Schöne Übung"',
        );

        expect(command.searchQuery, equals('Schöne Übung'));
        expect(command.field, equals('beschreibung'));
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });
    });

    group('Real-world examples', () {
      test('should handle typical tag search', () {
        final command = FilterCommand(searchQuery: 'tag:flutter');

        expect(command.searchQuery, equals('flutter'));
        expect(command.field, equals('tag'));
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle typical description search', () {
        final command = FilterCommand(searchQuery: 'desc:"custom widget"');

        expect(command.searchQuery, equals('custom widget'));
        expect(command.field, equals('desc'));
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle typical title search', () {
        final command = FilterCommand(searchQuery: 'title:button');

        expect(command.searchQuery, equals('button'));
        expect(command.field, equals('title'));
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle typical category search', () {
        final command = FilterCommand(searchQuery: 'category:"User Interface"');

        expect(command.searchQuery, equals('User Interface'));
        expect(command.field, equals('category'));
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });
    });

    group('Complex scenarios', () {
      test('should handle whitespace around quotes', () {
        final command = FilterCommand(searchQuery: ' "test" ');

        _expectInvalidFor(' "test" ', command);
      });

      test('should handle field with spaces before colon', () {
        final command = FilterCommand(searchQuery: 'tag :value');

        expect(command.searchQuery, equals('value'));
        expect(command.field, equals('tag '));
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle nested quotes in field value', () {
        final command = FilterCommand(
          searchQuery: r'content:"He said \"hello\""',
        );

        _expectInvalidFor(r'content:"He said \"hello\""', command);
      });

      test('should handle mixed case field names', () {
        final command = FilterCommand(searchQuery: 'CamelCase:value');

        expect(command.searchQuery, equals('value'));
        expect(command.field, equals('CamelCase'));
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle numeric field names', () {
        final command = FilterCommand(searchQuery: 'field123:test');

        expect(command.searchQuery, equals('test'));
        expect(command.field, equals('field123'));
        expect(command.percise, isFalse);
        expect(command.patternInvalid, isFalse);
      });

      test('should handle empty string in quotes with field', () {
        final command = FilterCommand(searchQuery: 'status:""');

        expect(command.searchQuery, equals(''));
        expect(command.field, equals('status'));
        expect(command.percise, isTrue);
        expect(command.patternInvalid, isFalse);
      });
    });
  });
}
