---
name: Cyber-Kinetic Precision
colors:
  surface: '#0d1516'
  surface-dim: '#0d1516'
  surface-bright: '#333a3c'
  surface-container-lowest: '#080f11'
  surface-container-low: '#151d1e'
  surface-container: '#192122'
  surface-container-high: '#242b2d'
  surface-container-highest: '#2e3638'
  on-surface: '#dce4e5'
  on-surface-variant: '#bac9cc'
  inverse-surface: '#dce4e5'
  inverse-on-surface: '#2a3233'
  outline: '#849396'
  outline-variant: '#3b494c'
  surface-tint: '#00daf3'
  primary: '#c3f5ff'
  on-primary: '#00363d'
  primary-container: '#00e5ff'
  on-primary-container: '#00626e'
  inverse-primary: '#006875'
  secondary: '#c7c6c6'
  on-secondary: '#2f3131'
  secondary-container: '#484949'
  on-secondary-container: '#b8b8b8'
  tertiary: '#ffeac0'
  on-tertiary: '#3e2e00'
  tertiary-container: '#fec931'
  on-tertiary-container: '#6f5500'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#9cf0ff'
  primary-fixed-dim: '#00daf3'
  on-primary-fixed: '#001f24'
  on-primary-fixed-variant: '#004f58'
  secondary-fixed: '#e3e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1a1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#ffdf96'
  tertiary-fixed-dim: '#f3bf26'
  on-tertiary-fixed: '#251a00'
  on-tertiary-fixed-variant: '#594400'
  background: '#0d1516'
  on-background: '#dce4e5'
  surface-variant: '#2e3638'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '600'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.2'
  metric-xl:
    fontFamily: JetBrains Mono
    fontSize: 32px
    fontWeight: '500'
    lineHeight: '1.0'
    letterSpacing: -0.05em
  metric-sm:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: '1.0'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '700'
    lineHeight: '1.0'
    letterSpacing: 0.1em
  headline-md-mobile:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: '1.2'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  gutter: 16px
  margin-mobile: 20px
  margin-desktop: 40px
  container-max: 1200px
---

## Brand & Style
The design system embodies the high-performance intersection of human biomechanics and advanced computing. The brand personality is clinical, futuristic, and empowering, positioning the app as a "scientific instrument" rather than a casual fitness tracker.

The visual style is **Dark Neo-Glassmorphism**. It leverages deep obsidian voids contrasted against hyper-bright "Electric Cyan" data overlays. The interface should feel like a heads-up display (HUD) found in professional-grade sports labs or near-future tech. Key characteristics include:
- **Depth through Translucency:** Multiple layers of dark glass create a sense of focused hierarchy.
- **Precision Aesthetics:** Hairline borders and monospaced data points evoke a sense of calibrated accuracy.
- **Atmospheric Glow:** Selective use of neon bloom to highlight active tracking states and critical bio-feedback.

## Colors
The palette is rooted in a pure black foundation to maximize the luminosity of the accent colors. 

- **Primary (Electric Cyan):** Reserved for active pose skeletons, data highlights, and primary CTAs. It should carry a subtle glow (box-shadow) to simulate light emission.
- **Surface (Glass):** Used for all container elements. Must implement a `backdrop-filter: blur(20px)` to maintain legibility over moving video feeds.
- **Semantic Colors:** Neon Green, Amber, and Coral Red are used exclusively for bio-feedback (e.g., "Joint Aligned," "Improper Form," "Injury Risk").
- **Texture:** Apply a 2% grain/noise overlay to the background obsidian to prevent digital banding and add a tactile, film-like quality.

## Typography
Typography is split between **Inter** for structural communication and **JetBrains Mono** for data-heavy metrics.

- **Inter:** Used for all UI chrome, headings, and instructional text. It provides a clean, modern accessibility that balances the technical nature of the app.
- **JetBrains Mono:** Used for all live sensor data, coordinates, timestamps, and performance percentages. The monospaced nature ensures that numbers don't jump horizontally during rapid data updates.
- **Scaling:** Use `label-caps` for all secondary metadata or technical labels. Headlines should remain tight in line-height to maintain a compact, "instrument panel" feel.

## Layout & Spacing
The layout follows a **Fluid Grid** model with high internal density, mimicking a cockpit or technical dashboard.

- **Grid:** 12-column layout for desktop; 4-column for mobile.
- **Rhythm:** An 8px base unit drives all padding and margins to maintain a structured, mathematical alignment.
- **Margins:** Large outer safe areas (20px-40px) ensure the UI does not interfere with the edges of the camera viewport during pose detection.
- **Density:** Elements should be tightly grouped within glass containers to maximize the visible area of the camera feed (the "canvas").

## Elevation & Depth
Depth is created through "Tonal Stacking" and backdrop blurs rather than traditional shadows.

- **Level 0 (Background):** Deep Obsidian (#0A0A0A) with noise texture.
- **Level 1 (Panels):** Semi-transparent glass with a 1px border (#1E1E1E).
- **Level 2 (Active Elements):** Primary Cyan elements with a 0px blur, 8px spread outer glow (bloom).
- **Interactive States:** On hover or active tracking, increase the transparency of the glass (darken it) and brighten the border weight to 1.5px.

## Shapes
The shape language is "Soft-Tech." The 8px (0.5rem) roundedness provides enough curvature to feel modern and premium while maintaining the structural integrity of a professional tool.

- **Standard Elements:** 8px radius (Buttons, Cards, Input Fields).
- **Small Elements:** 4px radius (Chips, Tooltips).
- **Metrics/Live Feed:** Use 0px (Sharp) corners for the actual camera viewport to distinguish the "real world" from the "interface."

## Components
- **Glass Cards:** Must feature a `linear-gradient(135deg, rgba(255,255,255,0.05) 0%, rgba(255,255,255,0) 100%)` overlay to simulate a light catch on the "glass" surface.
- **Primary Buttons:** Solid Electric Cyan with black text for maximum contrast. Include a `box-shadow: 0 0 15px rgba(0, 229, 255, 0.4)` for a neon effect.
- **Segmented Controls:** Housed in a dark glass pill, the active state is a secondary grey-glass highlight with white text.
- **Live Metrics:** Displayed in JetBrains Mono inside mini-glass containers. Use "sparklines" (mini-graphs) in Electric Cyan to show pose stability over time.
- **HUD Overlays:** 1px borders surrounding the camera feed corners to reinforce the "scanning" metaphor.
- **Inputs:** Ghost-style with 1px borders. Focus state triggers the primary color border and a subtle inner glow.