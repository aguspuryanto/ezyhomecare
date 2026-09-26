---
name: CareHome Digital Identity
colors:
  surface: '#edfdf8'
  surface-dim: '#ceddd9'
  surface-bright: '#edfdf8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#e8f7f3'
  surface-container: '#e2f1ed'
  surface-container-high: '#dcebe7'
  surface-container-highest: '#d7e6e2'
  on-surface: '#111e1c'
  on-surface-variant: '#3e4947'
  inverse-surface: '#263330'
  inverse-on-surface: '#e5f4f0'
  outline: '#6e7a77'
  outline-variant: '#bdc9c6'
  surface-tint: '#006b60'
  primary: '#00685d'
  on-primary: '#ffffff'
  primary-container: '#0c8376'
  on-primary-container: '#f4fffb'
  inverse-primary: '#77d7c8'
  secondary: '#8c4f07'
  on-secondary: '#ffffff'
  secondary-container: '#fdad61'
  on-secondary-container: '#744000'
  tertiary: '#12675e'
  on-tertiary: '#ffffff'
  tertiary-container: '#348077'
  on-tertiary-container: '#f4fffc'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#93f4e4'
  primary-fixed-dim: '#77d7c8'
  on-primary-fixed: '#00201c'
  on-primary-fixed-variant: '#005048'
  secondary-fixed: '#ffdcc0'
  secondary-fixed-dim: '#ffb877'
  on-secondary-fixed: '#2d1600'
  on-secondary-fixed-variant: '#6b3b00'
  tertiary-fixed: '#a6f1e4'
  tertiary-fixed-dim: '#8ad4c9'
  on-tertiary-fixed: '#00201c'
  on-tertiary-fixed-variant: '#005049'
  background: '#edfdf8'
  on-background: '#111e1c'
  surface-variant: '#d7e6e2'
typography:
  display:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  container-margin: 20px
  gutter: 16px
---

## Brand & Style

This design system establishes a high-trust, premium aesthetic for home-service wellness. The visual language balances **Professional Healthcare** with **Warm Wellness** by utilizing a Modern Corporate base infused with tactile, approachable elements.

The design style prioritizes:
- **Clarity and Precision:** Ample whitespace and a rigorous grid to signal professional medical standards.
- **Warmth:** Softened by gentle secondary accents and rounded geometry to reduce "clinical" anxiety.
- **Accessibility:** High legibility and large interactive targets tailored for an adult demographic (30-55).
- **Subtle Depth:** Using soft shadows and layered surfaces to create a sense of physical space and presence.

## Colors

The palette is anchored in **Teal (#16877A)** to evoke health, hygiene, and stability. 

- **Primary Teal:** Used for core brand elements, primary actions, and active states.
- **Primary Dark:** Reserved for hover states and high-emphasis information.
- **Warm Orange:** Applied sparingly as a secondary accent for "Book Now" prompts, ratings, and special offers to provide a welcoming contrast.
- **Functional Neutrals:** A sophisticated range of cool-greys derived from the primary teal hue ensures visual harmony across text and UI borders.
- **Backgrounds:** A very soft off-white teal tint (#F7F9F8) reduces eye strain compared to pure white and reinforces the "clean" atmosphere.

## Typography

The design system utilizes **Plus Jakarta Sans** exclusively. Its modern, geometric construction with slightly rounded terminals provides the perfect bridge between a technical healthcare look and a friendly consumer app.

- **Headlines:** Use Bold (700) or SemiBold (600) weights with tight letter-spacing for a confident, editorial feel.
- **Body:** Standard body text uses a 16px base to ensure readability for the target audience.
- **Labels:** Small caps or medium-weight labels are used for badges and category tags to ensure they remain distinct from body content.

## Layout & Spacing

This design system follows a **12-column fluid grid** for desktop and a **4-column grid** for mobile. 

- **Rhythm:** An 8px linear scale is used for most components, with 4px used for micro-adjustments (like icon-to-label spacing).
- **Margins:** Mobile screens must maintain a minimum 20px "safe area" on the left and right edges.
- **Whitespace:** Use "Generous" spacing principles. Between logical sections (e.g., Service Description and Reviews), a minimum of 40px (5x base) should be applied to prevent visual clutter and signal a premium experience.

## Elevation & Depth

Hierarchy is achieved through **Tonal Layering** and **Soft Ambient Shadows**.

- **Level 0 (Background):** #F7F9F8. Used for the base canvas.
- **Level 1 (Cards/Surfaces):** White (#FFFFFF) with a very soft, diffused shadow (Hex: #16877A at 4% opacity, 12px blur, 4px Y-offset).
- **Level 2 (Hover/Active):** White (#FFFFFF) with a more pronounced shadow (8% opacity, 20px blur, 8px Y-offset) to indicate interactivity.
- **Outlines:** Use 1px solid #E5E9E8 for inactive states or secondary containers where shadows are not appropriate.

## Shapes

The shape language is consistently "Rounded" (Level 2), avoiding sharp clinical corners in favor of approachable, organic forms.

- **Cards & Images:** Use a 16px radius to create a soft, framing effect.
- **Interactive Elements:** Buttons and Inputs use a 12px radius, providing enough roundness to feel modern without appearing "bubbly" or childish.
- **Badges:** A tighter 8px radius is used to maintain structural integrity at small scales.

## Components

### Buttons
- **Primary:** High-contrast Teal (#16877A) background with White text. Min-height: 48px. SemiBold weight.
- **CTA:** For high-conversion moments (Book Now), use the Secondary Orange (#F5A65B).
- **States:** 12px border radius. Hover state uses Primary Dark (#10665D).

### Cards
- **Service/Therapist Cards:** White surface, 16px border radius, 16px padding. Must include a soft shadow and a subtle border (#E5E9E8).
- **Content:** Ensure images within cards also inherit the 16px radius on top corners.

### Input Fields
- **Styling:** 12px border radius, 1px border (#D1D9D7). Min-height: 48px.
- **Focus State:** 2px border in Primary Teal with a subtle outer glow.

### Badges & Chips
- **Trust Badges:** Used for "Certified," "Top Rated," or "Medical Grade." 8px radius, Light Teal background (#E8F3F2) with Primary Teal text.
- **Service Chips:** Rounded-pill shape for category selection.

### Lists
- Use generous vertical spacing (12px between items). 
- Utilize leading icons in Primary Teal to guide the eye through benefit lists or service steps.