# Test Generation

Follow [`command-contract.md`](command-contract.md) for the browser session lifecycle used while generating actions.

Playwright CLI actions may emit corresponding Playwright TypeScript snippets that can be adapted into test files.

> Generated actions are a draft, not a production-ready test. Review destinations, data, selectors, side effects, assertions, and cleanup before adding generated code to the repository.

## Safety Rules

- Explore local, preview, staging, or dedicated test environments when possible.
- Use synthetic fixture data.
- Never place real passwords, tokens, payment information, or personal data in CLI arguments or generated source.
- Do not generate tests from irreversible production actions.
- Preserve the repository's existing test conventions, fixtures, package manager, and authentication helpers.

## Example Workflow

```bash
playwright-cli -s=test-gen open http://localhost:3000/search
playwright-cli -s=test-gen snapshot
# Snapshot output identifies a search textbox and submit button.
playwright-cli -s=test-gen fill e1 "synthetic query"
playwright-cli -s=test-gen click e2
playwright-cli -s=test-gen close
```

The emitted actions can be adapted into a test:

```typescript
import { test, expect } from '@playwright/test';

test('shows results for a search query', async ({ page }) => {
  await page.goto('/search');
  await page.getByRole('textbox', { name: 'Search' }).fill('synthetic query');
  await page.getByRole('button', { name: 'Search' }).click();

  await expect(page.getByRole('heading', { name: 'Results' })).toBeVisible();
});
```

## Authentication

Prefer the repository's existing authentication fixture or setup project. If credentials are required, load them through the repository's approved secret mechanism and fail clearly when they are absent:

```typescript
const email = process.env.E2E_USER_EMAIL;
const password = process.env.E2E_USER_PASSWORD;

if (!email || !password) {
  throw new Error('E2E test credentials are not configured');
}
```

Do not copy resolved secret values into tests, snapshots, traces, videos, or user-facing output.

## Review Checklist

Before keeping generated code:

1. Replace transient refs and fragile CSS selectors with semantic locators where possible.
2. Add assertions for the behavior under test; generated actions alone do not verify success.
3. Remove exploratory or unrelated actions.
4. Replace captured user data with deterministic fixtures.
5. Confirm the test cannot affect production or a real account.
6. Add setup and cleanup for state created by the test.
7. Run the narrow test, then the repository's relevant test suite.

## Semantic Locators

Prefer locators based on accessible roles and names:

```typescript
await page.getByRole('button', { name: 'Submit' }).click();
```

Use CSS selectors only when the application exposes no stable semantic locator and the repository has no preferred test identifier.

## Assertions

Generated actions usually need explicit assertions:

```typescript
await page.getByRole('button', { name: 'Submit' }).click();
await expect(page.getByText('Saved')).toBeVisible();
```

Choose observable assertions tied to the user's requested behavior rather than implementation details.
