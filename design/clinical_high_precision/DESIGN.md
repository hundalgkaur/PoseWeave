---
name: Clinical High-Precision
colors:
  surface: '#111316'
  surface-dim: '#111316'
  surface-bright: '#37393d'
  surface-container-lowest: '#0c0e11'
  surface-container-low: '#1a1c1f'
  surface-container: '#1e2023'
  surface-container-high: '#282a2d'
  surface-container-highest: '#333538'
  on-surface: '#e2e2e6'
  on-surface-variant: '#bbc9cf'
  inverse-surface: '#e2e2e6'
  inverse-on-surface: '#2f3034'
  outline: '#859399'
  outline-variant: '#3c494e'
  surface-tint: '#47d6ff'
  primary: '#a5e7ff'
  on-primary: '#003543'
  primary-container: '#00d2ff'
  on-primary-container: '#00566a'
  inverse-primary: '#00677f'
  secondary: '#b4cad6'
  on-secondary: '#1e333c'
  secondary-container: '#374c56'
  on-secondary-container: '#a6bcc7'
  tertiary: '#dcdddd'
  on-tertiary: '#2f3131'
  tertiary-container: '#c0c1c1'
  on-tertiary-container: '#4d4f4f'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#b6ebff'
  primary-fixed-dim: '#47d6ff'
  on-primary-fixed: '#001f28'
  on-primary-fixed-variant: '#004e60'
  secondary-fixed: '#cfe6f2'
  secondary-fixed-dim: '#b4cad6'
  on-secondary-fixed: '#071e27'
  on-secondary-fixed-variant: '#354a53'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c6c7'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#111316'
  on-background: '#e2e2e6'
  surface-variant: '#333538'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
  data-lg:
    fontFamily: JetBrains Mono
    fontSize: 20px
    fontWeight: '500'
    lineHeight: '1.2'
  data-md:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: '1.2'
    letterSpacing: 0.02em
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '700'
    lineHeight: '1'
    letterSpacing: 0.08em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 4px
  gutter: 16px
  margin: 24px
  container-padding: 12px
---

## Brand & Style

The design system is engineered for high-stakes medical diagnostic environments where cognitive load management and absolute legibility are paramount. The brand personality is authoritative, sterile, and hyper-functional, evoking the reliability of surgical-grade hardware. It transitions away from speculative aesthetics toward a "Precision Light" philosophy—utilizing sharp interfaces, high-contrast data visualization, and intentional information architecture.

The target audience includes clinicians, lab technicians, and diagnostic specialists who require a tool that feels less like a software application and more like a calibrated medical instrument. The visual style is **Corporate / Modern** with a technical edge, characterized by:
- **Surgical Clarity:** Eliminating visual noise and "glow" in favor of crisp, 1px borders.
- **Data-First Hierarchy:** Prioritizing clinical metrics through high-contrast typography.
- **Instrumental Tactility:** Layouts that mimic physical control consoles with rigorous grouping.

## Colors

The palette is optimized for low-light clinical environments to reduce eye strain during extended diagnostic sessions. 

- **Primary (Clinical Blue):** Used strictly for active states, critical focus points, and interactive data threads. It provides a "high-precision" signal against the dark background.
- **Secondary (Slate Grey):** Used for structural elements, inactive borders, and secondary metadata to provide a calm, grounded framework.
- **Tertiary (Lab White):** Reserved for primary data readouts and critical alphanumeric values to ensure maximum contrast and "glanceability."
- **Functional Grays:** A spectrum of dark neutrals (based on #121417) defines the surface hierarchy, separating background canvas from control pods.

## Typography

This design system utilizes a dual-font approach to separate interface navigation from clinical data analysis.

- **Inter** is the primary UI face, chosen for its exceptional legibility and neutral tone in menus, settings, and descriptive text.
- **JetBrains Mono** is utilized for all "Data Readouts." The monospaced nature ensures that fluctuating metrics do not cause visual layout shifts, and clinical values (like heart rate or chemical concentrations) remain perfectly aligned in tables.
- **Hierarchy Rule:** Use `label-caps` for all table headers and axis labels to create a distinct visual "bracket" around data sets.

## Layout & Spacing

The layout philosophy follows a **Fixed Grid** model to simulate a hardware-embedded screen. It utilizes a 12-column system on desktop and a 4-column system on mobile devices.

- **Metric Grouping:** Content is organized into "Pods"—modular units that contain related data. Pods are separated by 16px gutters.
- **High Density:** Padding is kept tight (12px within containers) to maximize the amount of information visible without scrolling.
- **Alignment:** All elements must align to a 4px baseline grid to maintain the "surgical precision" look. Icons and labels should always be vertically centered within their respective pods.

## Elevation & Depth

This design system avoids soft ambient shadows to prevent a "floated" or "cloud-like" appearance. Instead, depth is communicated through **Low-contrast Outlines** and **Tonal Layers**.

- **Surface Levels:** The base canvas is the darkest value. Active Pods or Modals use a slightly lighter grey to appear "raised."
- **Precision Outlines:** Elements are defined by 1px solid borders (#455A64). Active or focused states switch the border color to Clinical Blue (#00D2FF).
- **Z-Index:** Depth is flat. Only critical alerts or overlays use a "Backdrop Blur" (12px) to dim the background data, ensuring the user remains focused on the immediate task.

## Shapes

The shape language is "Soft-Technical." By using a consistent 0.25rem (4px) corner radius, the UI mimics the high-quality industrial design of medical equipment casings—avoiding the aggressive sharpness of brutalism while remaining far more professional and "fitted" than consumer-grade rounded apps.

- **Standard Radius:** 4px for all buttons, inputs, and containers.
- **Interactive Elements:** Use the same radius consistently; avoid pill shapes for buttons to maintain a structured, grid-aligned appearance.

## Components

### Buttons & Controls
Buttons use a 1px solid border with center-aligned typography. The "Primary" action button is filled with Clinical Blue and uses black text for maximum contrast. Secondary buttons use a Slate Grey outline.

### Metric Chips
Data tags or status chips should be rectangular with the 4px radius. Status colors are strictly enforced:
- **Normal:** Clinical Blue outline.
- **Warning:** Amber (Caution).
- **Critical:** High-contrast Red (Emergency).

### Input Fields
Inputs are dark-filled with a 1px Slate Grey bottom border in their default state, turning into a full 1px Clinical Blue frame when active. Use JetBrains Mono for the input text.

### Data Pods (Cards)
The foundational unit of the design system. Pods must have a clear `label-caps` header at the top-left and a 1px border. No shadows. If a pod is "Streaming" (real-time data), add a 2px Primary Blue bar to the left edge.

### Iconography
Icons must be "Line Style" (2px stroke) using standardized medical symbols. Avoid decorative or illustrative icons; every symbol must serve a functional, recognizable diagnostic purpose.