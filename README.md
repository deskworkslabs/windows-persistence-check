# Windows Persistence Quick-Check

A tiny **read-only** Windows script that dumps the registry and startup
locations where malware — and unwanted *"Your browser is managed by your
organization"* policy junk — most often hide. It changes nothing on your
machine; it just writes a plain-text report you can read or send to
someone who can.

If your PC suddenly says it's "managed by your organization" but you don't
work for one, or you just want a fast sanity check for auto-start malware,
this gives you the answer in about ten seconds.

---

## How to run

1. Download `check-persistence.cmd`.
2. Right-click it → **Run as administrator**.
3. It creates `persistence-report-YYYY-MM-DD.txt` in the same folder.
4. Open that file, or share it with someone technical.

**It only reads.** No registry key is written, deleted, or modified.

---

## What it checks, and how to read it

### 1. Startup (Run keys)
Every line should be a program you recognise from a real vendor
(Microsoft, your laptop maker, your antivirus, apps you installed).

🚩 **Suspicious:** random letter names, anything launching from
`AppData\Local\Temp`, `\Downloads`, or a path with gibberish in it.

### 2. Winlogon — the classic hijack spot
Two values matter:

| Value | Should be |
|-------|-----------|
| `Shell` | `explorer.exe` |
| `Userinit` | `C:\Windows\system32\userinit.exe,` (trailing comma is normal) |

🚩 **Suspicious:** anything else appended after `explorer.exe` or
`userinit.exe,` — that's a known malware trick.

### 3. Image File Execution Options (IFEO)
A long list. Almost every entry will be `MitigationOptions`,
`CFGOptions`, `DisableExceptionChainValidation`, `MaxLoaderThreads`, or
`UseFilter` — these are **normal** Windows security/performance settings.

🚩 **The one red flag:** a **`Debugger`** value. Malware uses it to make
a safe program (e.g. Task Manager) silently launch something else. If you
see `Debugger` pointing at anything, investigate it.

### 4. Browser policies — the "managed by organization" cause
`ERROR: The system was unable to find the specified registry key or
value` here is **good news** — it means no policy is locking your browser.

🚩 **If you see values here** (like `PasswordManagerEnabled`,
`DnsOverHttpsMode`, extension force-install lists) and you never set them,
a "cleaner"/"optimizer" tool or adware probably added them. Those live
under `HKLM\Software\Policies\...` and can be removed with
`reg delete` (back up first, and know what you're removing).

### 5. Startup folders
Shortcuts dropped here also auto-start. You should recognise everything.

### 6. Scheduled tasks
Non-Microsoft tasks only. Review anything that runs from `AppData`,
`Temp`, or has a random name.

---

## If something looks wrong

Don't delete blindly. A safe next step is **[Autoruns](https://learn.microsoft.com/sysinternals/downloads/autoruns)**
(Microsoft's own free tool): it shows every auto-start point in one
window, can verify each signature, and check each entry against
VirusTotal. Hide Microsoft/Windows entries, turn on the VirusTotal check,
and look at what's left.

For a deep clean, run a **Microsoft Defender Offline scan**
(Windows Security → Virus & threat protection → Scan options).

---

## Why this exists

Most "my browser is managed by my organization" scares aren't malware at
all — they're leftover policy keys from a free "PC cleaner" or "optimizer."
A thirty-second read-only dump tells you whether it's harmless junk or
something worth chasing, without touching your registry.

---

## Licence

MIT — free to use, copy, and share. See [`LICENSE`](LICENSE).

Maintained by **deskworkslabs**. More at
[shoebhakim.com](https://shoebhakim.com).
