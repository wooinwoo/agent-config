---
name: adversarial-verifier
description: Independently challenge consequential work before completion and require evidence for correctness. Use automatically after non-trivial code, configuration, schema, infrastructure, authentication, authorization, payment, security, migration, deployment, deletion, or other hard-to-reverse changes, and for high-stakes technical decisions or recommendations where an error could cause material cost, data loss, security exposure, or substantial rework. Skip casual conversation, translation, summaries, copy edits, and trivial mechanical changes with an obvious direct check.
---

# Adversarial Verifier

Verify consequential work from an opposing perspective without changing the implementation strategy. Keep the builder focused on the smallest solution; use this skill only as the completion gate.

## Run the review

1. Freeze the candidate result. Extract acceptance criteria from the original request and applicable repository instructions.
2. Collect only primary evidence: the original request, relevant source, current diff or artifact, and fresh test or command output. Never rely on the builder's summary as proof.
3. When subagents are available, delegate a read-only review to a separate reviewer. Give it the evidence, not the builder's conclusions or suspected findings. Do not let the reviewer edit files.
4. When no independent reviewer is available, reread the source and diff from scratch before evaluating it.
5. Attack the result for:
   - missing or misread requirements;
   - regressions and sibling call paths;
   - boundary inputs, error paths, concurrency, and state transitions;
   - authentication, authorization, secrets, privacy, injection, and dependency risk;
   - data loss, rollback, deployment, and operational failure modes;
   - unnecessary complexity or changes outside scope;
   - claims unsupported by fresh evidence.
6. Require each finding to name the evidence, concrete failure scenario, severity, and confidence. Reject speculative findings that cannot show an affected path or requirement.
7. Return findings to the builder. Fix only substantiated issues, then run the smallest relevant check again. Perform at most one focused re-review of changed or high-risk areas.

## Completion gate

Do not claim completion while a substantiated critical or high-severity issue remains. For code or configuration changes, require a fresh relevant test, build, lint, type-check, or targeted reproduction. For decisions and recommendations, verify unstable or high-stakes claims against current primary sources.

Keep the final report compact: findings fixed, checks run, and any material residual risk. If no issue survives verification, say so without inventing one.

## Boundaries

- Treat verification as read-only review; it grants no authority to deploy, delete, message, purchase, or otherwise expand the task.
- Do not run this workflow for low-impact tasks merely to appear thorough.
- Do not create an unbounded review-fix loop.
- Preserve validation, security, accessibility, and data-protection controls even when another skill favors minimal implementation.
