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
ffmpeg -i in.mov -vcodec h264 -acodec aac output7.mp4
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
- Start scrolled to top at overview
- Scroll down and back up
- Click on "Slider" use case in overview
- Scroll down in tree
- Click on "Switch" use case in tree
- Click on "TextField" use case in tree
- Collapse "Fidget Spinner" folder
- Click on "Pages" Folder
- Click on Overview button
- Type "Buton" with one "t" into the search to showcase fuzzy search
- Visit Home page and show "Recently Visited" and "Recently Added"

### Knobs
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
- Make right panel smaller until controls break to spacious layout
- Scroll slightly down
- Select knob preset "Enabled, false"
- Select knob preset "Enabled, null"
- Select knob preset "Disabled, true"
- Go to knob preset overview
- Select "Enabled, true"

### Constraints
- Click on "RelaxationCard"
- Adjust right panel larger until controls revert to compact layout
- Collapse knobs section and expand constraints section
- Change width via ruler back and forth and end at a size larger than 400
- Set the min width via text field to 200
- Move min constraints on both axes
- Move max constraints on both axes
- Move size (both min and max) on both axes
- End at size larger than the screen
- Zoom out

### Accessibility
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

### Theme, Background

### Customize Werkbank
- TODO:
 - Resize panels
 - Reorder sections
 - Collapse sections
- Switch to Werkbank to dark theme
