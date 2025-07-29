# Documentation

> [!CAUTION]
> This documentation is under construction and therefore very minimal.

This document describes guidelines on how to write documentation for Werkbank.

## Topics

As a base, we follow the best practices described in Google's [Technical Writing Course](https://developers.google.com/tech-writing).

We impose some additional guidelines on top of that:
- Verbs in titles should use gerund (-ing) form.
  - For example, use "Getting Started" instead of "Get Started".
- Topics do not start with a `#` header. Dart adds the topic name automatically.
- The Documentation should not mention any classes, etc. that are not publicly exposed.
- When referencing a class, method, etc., make it a link to the API documentation.
  - If the reference is purely its identifier name, do *not* use inline code formatting.
    - For example do `[WerkbankApp](../werkbank/WerkbankApp-class.html)`
  - If the reference is the primary part of a code segment, *do* use inline code formatting.
    - For example do ``[`c.description(...)`](..werkbank/DescriptionComposerExtension/description.html)``
- When having a code block that represents the content of a file, add a comment of the form `// ---- path/to/file.dart ---- //` in the first line.
- The markdown-boxes such as `> [!CAUTION]`, `> [!TIP]`, etc. should only be used for important information.
  - For example do not use `> [!NOTE]` for an unimportant side note that is less relevant than the main content.

