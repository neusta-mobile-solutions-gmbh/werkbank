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
    - The only the exact identifier name should be linked.
      - For example `[Addon](../werkbank/Addon-class.html)s` instead of `[Addons](../werkbank/Addon-class.html)`. 
  - If the reference is the primary part of a code segment, *do* use inline code formatting.
    - For example do ``[`c.description(...)`](..werkbank/DescriptionComposerExtension/description.html)``
- When having a code block that represents the content of a file, add a comment of the form `// ---- path/to/file.dart ---- //` in the first line.
- The markdown-boxes such as `> [!CAUTION]`, `> [!TIP]`, etc. should only be used for important information.
  - For example do not use `> [!NOTE]` for an unimportant side note that is less relevant than the main content.
- Topics should not explain function parameters, return values, etc. in detail. This is what the code documentation is for.
  Giving an example and mentioning the core concepts may be sufficient.
- Topics have a table of contents at the top.
