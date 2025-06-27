This is a file that records our workflow and storyboard of creating images and videos for the documentation in case we need to recreate them in the future.

## General setup
- Set application content to a known size by replacing the `runApp` with
```dart
runApp(
  const Center(
    child: SizedBox(
      width: 1280,
      height: 720,
      child: ExampleWerkbankApp(),
    ),
  ),
);
```
- Scale the right panel as small as it can be without breaking entries into the spacious layout.
- Scale the left panel as large as it can be such that the overview has three columns.
  - Leave a little wiggle room so that the right panel can be easily resized without affecting the overview. 
- Convert
```
ffmpeg -i in.mov -vcodec h264 -acodec aac output.mp4
ffmpeg -i in.mov -vf "scale=960:540:force_original_aspect_ratio=decrease" -pix_fmt rgb8 -r 10 output.gif
```

## Readme

### Preparations
- Have Constraints section collapsed at top and knobs below
- Configue tab is initially selected
- Order in settings
  - Theming
  - Background
  - Accessiblity
  - Debugging (Collapsed)
  - Localization
  - Werkbank theme
  - Collapsed: Ordering, Hot Reload Effect, Page Transition

### Storyboard
- Go to settings
- Switch through all themes and end at dark
- Change background to checkerboard
- Move text scale factor
- Go to home page and scroll down slowly

### Use Cases
- Prepare
  - Go to Inspect tab
    - Sort sections:
      - Description
      - Tags
      - External Links
      - Color Picker
      - Semantics Inspector
- Start scrolled to top at overview
- Scroll down and back up
- Click on "Slider" use case in overview
- Scroll down in tree
- Click on "Switch" use case in tree
- Click on "TextField" use case in tree
- Collapse "Fidget Spinner" folder
- Click on "Pages" Folder
- Click on "Profile Page" use case
- Click on Overview button
- Type "butn" into the search to showcase fuzzy search
- Visit Home page and show "Recently Visited" and "Recently Added"

### Knobs
- Prepare
  - Go to Configure tab
    - Collapse Constraints but leave at top
- Start on slider use case
- Change slider value on slider
- Change slider value in knobs
- Toggle enabled off and on
- Enable divisions
- Zoom into division dots and move slider.
- Switch to checkbox use case
- Zoom into checkbox
- Set "Enabled" knob to false
- Set "Tristate" to true
- Set "Value" to null
- Make right panel a little larger and then smaller until controls break to spacious layout
- Scroll slightly down
- Select knob preset "Enabled, false"
- Select knob preset "Enabled, null"
- Select knob preset "Disabled, true"
- Go to knob preset overview
- Select "Enabled, true"

### Constraints
- Prepare
  - Go to Configure tab
    - Collapse Knobs
- Start on "RelaxationCard"
- Change width via ruler back and forth and end at a size larger than 400
- Set the min width via text field to 200
- Move min constraints on both axes
- Move max constraints on both axes
- Move size (both min and max) on both axes
- End at size larger than the screen
- Zoom out
- Go to "Profile Page"
- Switch through presets and zoom out when necessary
  - Swap width and height after second preset

### Accessibility
- Prepare
  - Go to Inspect tab
    - Move Semantics Inspector to top
- Start on "MainPage"
- Switch through tabs ending at profile
- Go to inspect tab
- Set semantics mode to "Overlay"
- Switch to fidgets page
- Search for a slider ("<No Label>") in the tree
- Scroll down to "Active semantics node"
- Move slider
- Scroll back up and switch to inspection
- Scroll down to "Active semantics node"
- Switch selection between multiple nodes
- Disable semantics inspector
- Go to overview and scroll down
- Go to settings and scroll to "Accessibility"
- Play around with settings

### Theme, Background and Localization
- Prepare
  - Go to Settings tab
- Start on Overview
- Switch through themes and revert to initial
- Switch through backgrounds in order:
  - "Black"
  - "Checkerboard"
  - Back to "Use Case Default"
- Go to "DatePickerDialog" via overview
- Switch Locale to "de" and then back to "en"

### Customize Werkbank
- Prepare
  - Go to Settings tab
- Start in Overview
- Resize Right Panel such that the layout switches
- Resize Left Panel and temporarily collapse it entirely
- Go to focus mode and back
- Toggle Werkbank theme to dark
- Move Werkbank theme to top
- Collapse Accessibility
- Go to home page and scroll to shortcuts
