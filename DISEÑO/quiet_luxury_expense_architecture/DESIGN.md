---
name: Quiet Luxury Expense Architecture
colors:
  surface: '#faf9f7'
  surface-dim: '#dadad8'
  surface-bright: '#faf9f7'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f3f1'
  surface-container: '#efeeec'
  surface-container-high: '#e9e8e6'
  surface-container-highest: '#e3e2e0'
  on-surface: '#1a1c1b'
  on-surface-variant: '#46474a'
  inverse-surface: '#2f3130'
  inverse-on-surface: '#f1f1ef'
  outline: '#76777b'
  outline-variant: '#c7c6cb'
  surface-tint: '#5e5e62'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1a1b1f'
  on-primary-container: '#848387'
  inverse-primary: '#c7c6ca'
  secondary: '#5b5e65'
  on-secondary: '#ffffff'
  secondary-container: '#e0e2ea'
  on-secondary-container: '#61646b'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#181c21'
  on-tertiary-container: '#81848a'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e3e2e6'
  primary-fixed-dim: '#c7c6ca'
  on-primary-fixed: '#1a1b1f'
  on-primary-fixed-variant: '#46464a'
  secondary-fixed: '#e0e2ea'
  secondary-fixed-dim: '#c4c6cd'
  on-secondary-fixed: '#191c21'
  on-secondary-fixed-variant: '#44474d'
  tertiary-fixed: '#e0e2e9'
  tertiary-fixed-dim: '#c4c6cd'
  on-tertiary-fixed: '#181c21'
  on-tertiary-fixed-variant: '#44474c'
  background: '#faf9f7'
  on-background: '#1a1c1b'
  surface-variant: '#e3e2e0'
typography:
  display-lg:
    fontFamily: Newsreader
    fontSize: 44px
    fontWeight: '400'
    lineHeight: 52px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Newsreader
    fontSize: 32px
    fontWeight: '400'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Newsreader
    fontSize: 32px
    fontWeight: '400'
    lineHeight: 40px
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: Newsreader
    fontSize: 26px
    fontWeight: '400'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Newsreader
    fontSize: 24px
    fontWeight: '400'
    lineHeight: 32px
  headline-sm:
    fontFamily: Newsreader
    fontSize: 20px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
    letterSpacing: -0.01em
  body-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.04em
  label-sm:
    fontFamily: Manrope
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.08em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 1.25rem
  gutter-lg: 2rem
  margin: 1.25rem
  margin-lg: 3rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style
The design system embodies the ethos of understated wealth and deliberate restraint: a quiet luxury aesthetic engineered for high-intent personal finance management. The brand rejects loud gamification, aggressive saturation, and visual noise in favor of serene editorial clarity, architectural precision, and tactility.

Targeted at design-literate individuals, executives, and modern collectors who value discretion, the interface conveys absolute fiscal calm, high precision, and composure. The emotional takeaway is agency and tranquility—transforming daily ledger entries into an intentional, elevated ritual.

The visual style blends disciplined **Minimalism** with bespoke **Editorial Layouts**:
- Generous, intentional negative space that frames monetary figures as bespoke data points.
- Hairline structural dividers that evoke fine stationery and premium ledger paper.
- Tactile softness balanced against high-contrast, black-ink accents for definitive financial hierarchy.

## Colors
The palette evokes archival cotton paper, honed slate, and rich carbon ink. The tonal ecosystem relies on nuanced off-whites and delicate slate gradients rather than pure synthetic grays or harsh digital blacks.

- **Primary (`#16171A`)**: Deep Obsidian Ink. Used for primary typography, dominant metrics, critical action buttons, and active micro-states. Provides commanding, high-contrast legibility.
- **Secondary (`#4A4D53`)**: Muted Slate. Handles secondary analytical text, supporting financial tags, axis metadata, and inactive UI architecture.
- **Tertiary (`#8A8D93`)**: Silver Cashmere. Reserved for structural hairline strokes, inactive progress tracks, and placeholder guidance.
- **Neutral (`#F9F8F6`)**: Warm Alabaster. The foundational canvas tone, offering an organic warmth that prevents clinical coldness.

Surface layering utilizes a subtle spectrum of off-white paper tones:
- **Surface Canvas**: `#F9F8F6`
- **Surface Raised / Card**: `#FFFFFF`
- **Surface Depressed / Input Wells**: `#F2EFEA`
- **Hairline Borders**: `#E5E2DC` (subtle structural separation)
- **High-Contrast Positive Accent**: `#2D4F3E` (deep cypress green for positive delta/inflows, used with extreme restraint)
- **High-Contrast Expense Accent**: `#782E2E` (cordovan wine for outflows and budget thresholds, avoiding aggressive alert reds)

## Typography
Typography creates an editorial dialogue between traditional finance authority and contemporary technological clarity:

- **Editorial Display (`Newsreader`)**: Leveraged for high-level aggregated totals, primary portfolio valuations, section titling, and temporal markers (e.g., month/year). It evokes physical broadsheet financial prints and heritage private banks. Tabular numbers are enabled for monetary values to align decimal places seamlessly.
- **Instrument Body & Data (`Manrope`)**: A clean, balanced geometric sans-serif tuned for maximum legibility within complex transaction rosters, micro-charts, balance metadata, and user input fields.

### Style Directives
- **Case Selection**: `label-sm` and `label-md` are explicitly set in uppercase tracking (`+0.04em` to `+0.08em`) when applied to category metadata, currency symbols, and analytical headers.
- **Tabular Figures**: All numerical figures displayed inside tables, ledger rows, and dynamic totalizers must enforce tabular lining figures (`font-variant-numeric: tabular-nums`) to prevent horizontal jitter during updates.

## Layout & Spacing
The layout strategy utilizes an architectural fixed-column grid bounded by generous, calming external margins:

- **Mobile Viewports (<768px)**: 4-column fluid layout with `1.25rem` outer canvas margins and `1.25rem` column gutters. All touch targets strictly maintain a minimum tap dimension of `44x44px` regardless of the component's visual boundary.
- **Tablet / Small Desktop (768px - 1199px)**: 8-column layout capped at an inner container width of 720px for singular dashboard feeds, retaining editorial reading density.
- **Large Desktop (>=1200px)**: 12-column layout with a maximum container threshold of 1080px. Split into asymmetric modules: 7 columns for live analytical charting and ledger drilldowns, 5 columns for persistent balance summaries, category allocations, and rapid transaction entry.

Spacing relies on a strict base-4 cadence, favoring open vertical air (`space-xl`) between distinct thematic groups over visible borders wherever feasible.

## Elevation & Depth
In alignment with the quiet luxury motif, the design system rejects artificial drop shadows, fuzzy blurs, and neon glows. Depth is articulated purely through tonal calibration, surface layering, and micro-thin delineation:

- **Flat Architecture**: The canvas sits at `#F9F8F6`. Cards and elevated ledger modules rest on `#FFFFFF`. The depth differential between the canvas and interactive cards is perceived through contrast rather than projection.
- **Hairline Framing**: Structural separation uses deliberate, 1px solid hairline borders in `#E5E2DC`. Cards and elevated trays do not float; they are crisply bound into the layout grid like architectural partitions.
- **Subtle Surface Indentation**: Inputs, search wells, and historical segmented bars utilize an indented tone (`#F2EFEA`), visually receding behind the primary card face.
- **Overlays & Drawers**: When bottom sheets or full-screen expense editors appear on mobile devices, they are backed by a translucent mask (`rgba(22, 23, 26, 0.25)`) featuring an unblurred, sharp entry transition.

## Shapes
Geometry is disciplined and tailored. Elements do not use hyper-rounded or bubbly aesthetics; instead, they feature gentle, tailored corner radii that convey structure, stability, and poise.

- **Level 1 (Soft)**: Base component radius is `0.25rem` (`4px`) for inputs, buttons, chips, and small transaction pills. 
- **Large Containers (`rounded-lg`)**: Primary cards, financial charts, and aggregate containers use `0.5rem` (`8px`).
- **Overlays (`rounded-xl`)**: Top corners of mobile sheets and modals scale up to `0.75rem` (`12px`).
- **Circular Utilities**: Segmented indicators, account avatars, and radio selectors use a pure circular profile (`9999px`) to contrast cleanly with rectangular modules.

## Components

### Buttons & Actions
- **Primary Button**: Solid Obsidian Ink (`#16171A`) fill, pure white crisp typography (`label-lg`), with a `4px` corner radius. Interactive state transitions to an obsidian tint with zero lift or shadow expansion.
- **Secondary / Ghost Button**: Hairline border (`1px solid #E5E2DC`), pure transparent surface, slate text (`#4A4D53`). On hover/press, surface tints to `#F2EFEA`.
- **Destructive Action**: Muted cordovan text (`#782E2E`) over transparent surface; never saturated signal red.

### Transaction Ledger & Lists
- **List Rows**: Minimalist rows separated by a horizontal `1px solid #E5E2DC` rule. Zero card nesting inside transaction feeds.
- **Row Anatomy**: Left side displays the merchant or payee in `body-md` bold with the spending category beneath in `body-sm` (`#8A8D93`). Right side displays the monetary amount right-aligned in `Manrope` tabular figures, using `#16171A` for expenses and `#2D4F3E` for deposits.
- **Touch Target**: The complete row area retains a 56px minimum vertical height to ensure frictionless thumb navigation.

### Financial Data Visualization
- **Line & Trend Graphs**: Single-pixel paths rendered in Obsidian (`#16171A`) over Warm Alabaster (`#F9F8F6`). Fill gradients are prohibited; use clean, unshaded Cartesian territory.
- **Breakdown Bars**: Category allocations are represented as a unified horizontal strip partitioned by 1.5px vertical paper-colored gaps. Each category is distinguished through a monochromatic scale ranging from `#16171A` down to `#D5D2CC`.

### Input Fields & Selectors
- **Input Wells**: `#F2EFEA` background with no baseline border in resting state. When active, shifts to `#FFFFFF` bound by a crisp 1px `#16171A` outline.
- **Amount Input**: Ultra-prominent editorial display scale (`display-lg`) using `Newsreader`. Currency symbol rests at an unweighted, secondary slate tone to keep focus on numeric entry.

### Cards & Metrics
- **Balance Card**: Clean `#FFFFFF` surface with an exact `1px solid #E5E2DC` wrapper. Houses the primary portfolio balance in `Newsreader` (`headline-lg`) flanked by period delta indicators rendered in `label-sm` monospace-tracked caps.

### Chips & Category Filters
- **Resting**: Compact containers with a `4px` corner radius, `#F2EFEA` fill, and `#4A4D53` text.
- **Active / Selected**: Inverted styling with solid `#16171A` fill and crisp `#FFFFFF` text.