---
name: frontend-skill
description: Design or implement visually directed marketing sites, branded landing pages, and product interfaces where art direction and visual hierarchy are primary requirements. Use for greenfield UI work or an explicitly requested visual redesign. Preserve existing design systems and product conventions when extending an established interface. Do not invoke for routine frontend maintenance, accessibility-only fixes, or game UI unless the user explicitly requests broader art direction.
---

# Frontend Skill

Create frontend experiences that feel deliberate, coherent, and appropriate to their product. Use strong composition, hierarchy, typography, imagery, and motion when they serve the brief; do not optimize for visual novelty at the expense of usability, accessibility, performance, or established product conventions.

## Authority and Precedence

Treat this skill's visual guidance as defaults, not as authority over the project.

For aesthetic and implementation choices, apply requirements in this order:

1. The user's explicit brief, constraints, and requested scope.
2. Existing repository architecture, design-system tokens, brand guidance, components, and interaction conventions.
3. Established product behavior and functional requirements.
4. Surface-specific guidance in this skill.
5. General aesthetic defaults in this skill.

Accessibility, semantic correctness, responsive behavior, and safety are baseline quality requirements throughout that ordering. Do not replace an existing visual language merely to match this skill's preferred aesthetic. For an established product, extend the current system unless the user explicitly requests a redesign.

## Surface Classification

Before designing, classify the requested surface:

- **Branded landing or campaign page:** persuasion, identity, narrative, and a clear action.
- **Product application or operational workspace:** orientation, status, decision-making, and task completion.
- **Editorial or content-led website:** reading, navigation, content hierarchy, and comprehension.
- **Prototype or demonstration:** focused communication of a concept or interaction with an explicit fidelity target.
- **Existing product extension:** a coherent addition to an established design and interaction system.
- **Game interface:** only when the user explicitly requests broader art direction; genre, platform, HUD, input, and existing game-art conventions take precedence over this skill's product-UI defaults.

Surface-specific guidance overrides general aesthetic defaults. Do not put a marketing hero on an operational workspace or force a utility application into a poster-like composition.

## Working Model

Before building, establish:

- **Visual thesis:** one sentence describing the intended mood, material, and hierarchy.
- **Content or information plan:** what each section or region must communicate or enable.
- **Interaction candidates:** optional motion or transition ideas, each with a functional or narrative purpose.
- **Constraint inventory:** existing design system, framework, approved assets, accessibility needs, performance limits, supported viewports, and localization requirements.

Each section or workspace region should have one primary responsibility and one dominant takeaway or action. Do not implement an interaction merely because it appeared in the initial thesis; remove it if it does not improve orientation, feedback, continuity, or narrative understanding.

## Repository Reconnaissance

Before editing an existing project:

- inspect the framework, route structure, dependencies, styling approach, tokens, fonts, icons, and reusable components;
- identify existing layout, breakpoint, spacing, state, and accessibility conventions;
- inspect representative neighboring screens before inventing new patterns;
- reuse approved assets and components where practical;
- preserve component APIs and established behavior unless the request requires changing them;
- keep changes proportional to the requested surface.

Do not introduce a new visual language, font, color system, icon family, animation library, or component vocabulary for a single feature without a clear, authorized reason.

## Shared Visual Defaults

Use these as greenfield defaults, not universal rules:

- Start with composition and information hierarchy, not component count.
- Use whitespace, alignment, scale, cropping, and contrast before adding decorative chrome.
- Keep the visual system restrained: few type roles, a controlled palette, and consistent spacing.
- Avoid cosmetic containers around content that works as plain layout.
- Give each region one dominant visual idea.
- Make primary actions visually clear without making every action prominent.
- Keep decorative shadows, borders, gradients, and icons subordinate to structure.

### Cards

Avoid cards that merely wrap ordinary layout. Use a card when it represents a meaningful repeated entity, selection target, draggable object, interaction boundary, or independently actionable group. If a panel can become plain layout without losing grouping or behavior, remove the card treatment.

### Typography and Color

- Existing typography and color tokens take precedence.
- For a new visual system, start with no more than two typefaces and one primary accent unless the brief justifies more.
- Do not add external fonts without authorization; use appropriate fallbacks and verify language coverage.
- Accent-color limits do not include semantic error, warning, success, information, focus, chart, or data-series colors.
- Never communicate state through color alone.

## Branded Landing Pages

A useful default sequence is:

1. Hero: identity, promise, primary action, and an optional dominant visual.
2. Support: one concrete feature, offer, or proof point.
3. Detail: workflow, product depth, atmosphere, or story.
4. Final action: convert, start, visit, subscribe, or contact.

Hero guidance:

- Prefer one coherent composition over a collage of unrelated UI devices.
- Use full bleed only when it fits the brief and available assets.
- On a requested full-bleed page, let the hero run edge-to-edge while constraining the inner text and action column.
- Keep the headline readable at a glance and the text column stable across responsive crops.
- Avoid hero cards, stat strips, logo clouds, pill collections, or floating dashboards unless they provide necessary evidence or interaction.
- Ensure text over imagery maintains sufficient contrast at every supported crop.
- Preserve a clear primary action.

A hero image should add narrative value without becoming the only carrier of meaning. The page's identity, purpose, and primary action must remain understandable if an image fails to load or cannot be perceived.

## Product Applications and Operational Workspaces

Default to utility, clarity, and dense but readable information:

- start with the working surface rather than a marketing hero;
- prioritize orientation, status, freshness, scope, and action;
- organize around the primary workspace, navigation, and only the secondary context users need;
- use calm surface hierarchy, clear typography, and restrained chrome;
- preserve established interaction and data-display patterns;
- use semantic colors and data-visualization colors as required by the domain.

Avoid dashboard-card mosaics, borders around every region, decorative gradients behind routine work, competing action colors, and ornamental icons that do not improve scanning.

Utility headings should identify the area or action directly, such as "Plan status", "Selected KPIs", "Top segments", or "Last sync". If a section does not help someone operate, monitor, understand, or decide, remove it.

## Editorial and Content-Led Websites

Optimize for reading and navigation rather than poster-like impact:

- use a readable measure and resilient typographic hierarchy;
- make section structure clear through headings, spacing, and navigation;
- support figures, captions, citations, and related content when relevant;
- keep long-form content scannable without fragmenting every paragraph into a visual device;
- ensure decorative treatment does not compete with the content.

## Imagery and Assets

Use imagery when it adds product, editorial, narrative, or brand value. Do not require imagery for utility products, text-led experiences, or projects without suitable assets.

Prefer, in order:

1. Existing approved project assets.
2. User-provided assets.
3. Explicitly authorized, appropriately licensed external assets.
4. Generated assets only when the user authorizes generation and their use fits the project.

Do not download, generate, or add external imagery without authorization. Do not use assets with embedded signage, logos, text, or visual clutter that conflicts with the interface unless that content is intentional and approved.

For images:

- provide useful alternative text for informative images and empty alternative text for decorative images;
- use responsive dimensions and formats appropriate to the project;
- set dimensions or aspect ratios to prevent layout shift;
- lazy-load below-the-fold media when appropriate;
- do not delay the primary above-the-fold image through indiscriminate lazy loading;
- verify focal points and text contrast across responsive crops.

## Copy and Factual Grounding

Write in product language, not design commentary or prompt language.

- Let headings carry meaning and keep supporting copy concise when the subject permits.
- Avoid repetition between sections.
- Ground product claims, metrics, testimonials, pricing, availability, and feature statements in repository evidence or user-provided facts.
- Do not invent proof points, capabilities, customers, or operational status.
- Preserve legal text, safety information, required disclosures, accessibility instructions, error guidance, and operational context.
- For product UI, prioritize orientation, state, scope, freshness, and action over aspiration or mood.

Delete copy only when meaning and required context remain intact.

## Motion

Motion is optional. For visually led work, consider up to two or three motion patterns and implement only those that improve feedback, continuity, orientation, affordance, or narrative understanding.

Useful candidates include:

- a restrained entrance sequence that establishes hierarchy;
- a shared-layout or state transition that preserves continuity;
- a hover, focus, reveal, drawer, or modal transition that clarifies affordance;
- scroll-linked storytelling only when the narrative genuinely depends on progression.

Motion requirements:

- respect `prefers-reduced-motion` and provide a reduced or static experience;
- do not make motion the only way to perceive state or content;
- preserve keyboard focus and reading position during transitions;
- prefer transform and opacity where practical;
- avoid continuous or scroll-linked motion that causes discomfort, jank, or excessive work;
- pause or disable nonessential continuous animation;
- keep timing and easing consistent with the existing product.

Use the project's existing motion system. Use Framer Motion only when it is already installed or the user authorizes adding it. Do not add a dependency for effects that CSS can express clearly and accessibly.

## Accessibility Baseline

Use semantic HTML and preserve native behavior wherever possible. Meet the repository's accessibility standard; when none is stated, target WCAG 2.2 AA as a practical baseline.

Check that:

- landmarks and heading levels form a meaningful structure;
- controls have accessible names and appropriate native semantics;
- forms have labels, instructions, and associated error messages;
- all functionality is keyboard operable with a visible focus indicator;
- focus order follows the visual and logical order;
- hover-only information has a keyboard and touch-accessible alternative;
- color contrast remains sufficient in every responsive state and image crop;
- status is not communicated by color alone;
- dynamic state changes are announced when necessary;
- touch targets are comfortably operable;
- content works with large text, zoom, and reflow;
- reduced-motion users receive a complete experience.

Automated checks support but do not replace keyboard and visual review.

## Responsive and Viewport Behavior

Design for content resilience, not a single screenshot.

- Test representative mobile, tablet, and desktop widths.
- Include mobile landscape, long content, localization expansion, and large-text or zoomed layouts.
- Account for dynamic browser chrome, safe-area insets, on-screen keyboards, and sticky-header offsets.
- Prevent horizontal overflow unless a component, such as a data table, intentionally owns it.
- Do not force initial content to fit by clipping it, shrinking text below readable sizes, or disabling normal scrolling.

For viewport-height layouts, use a safe fallback before dynamic units:

```css
.hero {
  min-height: 100vh;
  min-height: 100dvh;
}
```

If persistent UI consumes space, account for it without hiding content. Overlay headers only when contrast, focus, safe areas, and content flow remain reliable.

## Functional State Coverage

A polished interface must handle applicable operational states, not only the ideal screenshot:

- loading and progressive loading;
- empty and first-use states;
- validation and runtime errors;
- offline or unavailable dependencies;
- disabled and permission-restricted states;
- partial or stale data;
- success and confirmation;
- long labels, long values, and translated copy;
- missing or failed media;
- keyboard focus and mobile overflow.

Keep recovery actions and next steps clear. Do not conceal important states to preserve visual simplicity.

## Performance

- Avoid oversized hero media and unnecessary font or icon payloads.
- Prevent layout shift by reserving media and dynamic-content space.
- Keep the primary content and action available without waiting for ornamental assets.
- Avoid expensive continuous scroll handlers and excessive layered effects.
- Keep animation smooth on supported mobile devices and lower-powered hardware.
- Preserve interaction responsiveness; decorative effects must not delay input or navigation.
- Follow repository performance budgets and asset pipelines when they exist.

## Implementation Boundaries

- Preserve the existing stack unless the user requests a migration.
- Do not rewrite unrelated components for visual consistency.
- Do not add fonts, image services, animation libraries, icon packages, or other dependencies without authorization.
- Do not alter public component APIs or product behavior solely for aesthetic convenience.
- Prefer the smallest coherent change that fulfills the requested design.
- Keep generated or exploratory assets out of the repository unless they are approved deliverables.

## Validation Workflow

Before finishing, perform the checks relevant to the project and requested scope:

1. Run repository formatting, linting, type checking, tests, and build commands.
2. Review representative desktop, tablet, and mobile viewports.
3. Test mobile landscape and large-text or zoom behavior.
4. Navigate the interface by keyboard and inspect focus visibility and order.
5. Test reduced-motion mode.
6. Exercise loading, empty, error, disabled, long-content, and missing-media states where applicable.
7. Verify text-over-image contrast across responsive crops.
8. Confirm all claims and assets are grounded and authorized.
9. Check the browser console and relevant network failures.
10. Review obvious layout shift, oversized assets, interaction delay, and animation jank.

Browser automation may support validation, but it remains subordinate to this skill's design and implementation responsibilities.

## Reject These Failures

- Replacing an established product language with an unrelated fashionable style.
- Generic SaaS card grids used as the primary composition.
- Marketing heroes added to operational workspaces.
- Imagery that is the only carrier of meaning.
- Busy imagery behind text or unverified responsive contrast.
- Strong visual treatment with no clear action or task path.
- Motion added for recordings rather than user understanding.
- Interfaces that ignore reduced-motion, keyboard, focus, zoom, or error states.
- Fabricated metrics, testimonials, capabilities, or proof points.
- Unauthorized external assets, fonts, or dependencies.
- Visual polish that breaks loading, long content, localization, or mobile behavior.

## Final Checks

- Does the result fit the user's brief and the existing product?
- Is the surface type unmistakable from its information and interaction priorities?
- Can someone understand the page or workspace by scanning its structure?
- Does each region have a clear responsibility?
- Are cards and decorative containers semantically justified?
- Does imagery add value without carrying essential meaning alone?
- Does motion improve feedback, continuity, or atmosphere, and is reduced motion complete?
- Are required functional states represented?
- Is the interface accessible, responsive, performant, and source-grounded?
- Were unrelated architecture, dependencies, and components left untouched?
