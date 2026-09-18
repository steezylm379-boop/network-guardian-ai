# Network Guardian AI — Phase 3 implementation report

Checkpoint: **v1.3.0+5**

Phase 3 moves Network Guardian from a scanner/device-intelligence utility into a grounded network assistant while keeping the product local-first and commercially defensible.

## Flagship additions

### Ask Your Network
The new Guardian tab accepts natural-language questions and answers from the actual local snapshot instead of generic model knowledge. Supported grounded intents include:

- What is connected right now?
- Which devices are unknown?
- Who was first seen recently?
- Which devices are offline?
- Are there camera/NVR-like profiles?
- What changed recently / yesterday?
- What is this named device or IP?
- What is my router/gateway?
- Why is the network slow?
- Is the network secure? (returns an explicit Phase 3 limitation rather than a fake security verdict)
- Which device uses the most bandwidth? (explicitly refused because Phase 3 has no bandwidth telemetry)

Assistant answers include inspectable evidence records and grounding strength. Conversation history is stored locally per network.

### AI Network Doctor
The Doctor combines:

- configured gateway presence;
- measured gateway reachability, latency and packet loss;
- Android `NET_CAPABILITY_VALIDATED` Internet state;
- configured DNS-server visibility;
- device-scan freshness;
- ownership-review state.

The root-cause summary differentiates a dead/degraded local Wi-Fi/router path from a condition where the gateway is healthy but Android has no validated Internet path. It does not claim to measure bandwidth.

### Guardian Insights
The dashboard assistant derives concise local insights for:

- devices still marked Unknown;
- devices first seen in the previous 24 hours;
- gateway missing from the last completed scan;
- contradictory identity evidence;
- repeated online/offline changes across recorded scans;
- camera/NVR profiles.

These are review signals, not malware verdicts.

## Enterprise architecture

`EnterpriseAiGateway` isolates future generative-model narration from the telemetry engine. `HttpEnterpriseAiGateway` only accepts HTTPS and expects a token supplied by an external authentication layer. No vendor API secret is embedded in the app.

`AiPrivacyPolicy` redacts by default:

- SSID/network name;
- raw IP addresses;
- MAC addresses;
- friendly/user device names.

The sanitized context retains only the minimum useful classification/health facts unless the deploying organization deliberately changes policy.

## Persistence

Drift schema v3 adds:

- `guardian_conversations`
- `guardian_messages`
- `diagnostic_runs`

Migration is additive and retains existing Phase 1/2 scanner and intelligence data.

## Verification

Per the agreed workflow, automated verification was deferred until Phase 3 implementation finished. This source has received a static source audit only inside ChatGPT's container. It has **not** yet been regenerated/analyzed/tested/built as v1.3.0+5.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\verify_phase3.ps1
```

That performs build_runner generation, Flutter analysis, Flutter tests, Android JVM tests and a debug APK build.

An Android emulator can then validate UI/navigation/database flows. Real LAN discovery remains separately unverified without physical Android hardware.
