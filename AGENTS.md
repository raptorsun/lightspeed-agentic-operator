# OpenShift Lightspeed Agentic Operator - Development Guide for AI

## Risk Levels

When creating Jira tickets for this repo, assign a risk level in the description.

| Level | Customer Impact | Review Requirements | Automation |
|-------|----------------|---------------------|------------|
| Risk 1 | Very little impact if change goes wrong | No human code review required | Fully automated implementation |
| Risk 2 | Medium impact if change causes problems | 1 human reviewer required | Automated implementation with human review gate |
| Risk 3 | Major impact — risk of losing customers if a bug is introduced | 2+ human reviewers required | Human-driven implementation |

### Classification Examples

| Change Type | Risk Level |
|-------------|------------|
| Dependency version bump | 1 |
| Metadata-only changes | 1 |
| Controller logic changes | 2 |
| CRD schema changes | 3 |
| RBAC/permissions changes | 3 |

### Jira Description Format

Include this section in every ticket description:

```
## Risk Level

Risk {1|2|3} — {one-line impact summary}
Rationale: {why this classification, referencing the rubric}
```
