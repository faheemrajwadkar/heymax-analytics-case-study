# AI Documentation Agent: Technical Design Doc (v1)

## Part 1: How the Agent Learns
The bot acts like a senior analytics engineer. To do that, we give it three layers of information:
1.  **Global Context:** High-level business definitions (like how we define revenue) stored in a central markdown file.
2.  **Department Context:** Specific logic for departments like Fincrime or Marketing, stored in their own folders.
3.  **Real Examples:** 3-5 good documentation files it can copy to match our style.
4.  **Constraints:** It looks at dbt tests (like `unique`, `accepted_values`) to understand the data's boundaries.

---

## Part 2: The Workflow & Tool Chain
The process follows a strict order to ensure the bot doesn't just guess what the data does.

![alt text](<assets/AI Agent Diagram.png>)

**The Sequence of Events:**
1.  **GitHub PR:** A developer pushes code.
2.  **GitHub Action:** 
    1.  Compares the new dbt `manifest.json` against the production version to find exactly what changed. 
    2.  Fetches paths to `.sql` and `.yml` files, upstream and downstream nodes from `manifest.json`.
    3.  Prunes unnecessary tables where the modified columns are not referred.
3.  **n8n Webhook:** Receives a package containing the SQL and YAML paths, parent table descriptions, and the SQL diff code.
4.  **Data Warehouse (SQL):** It extracts metadata information like *null rate*, *data type*, *range*, etc. (essentially a `pandas.describe()`) from the dev tables. This also takes care of PII masking and compliance adherence.
5.  **LLM API:** We will make use of the **Gemini 3.1 Flash** API to save on training time. The LLM takes that package and writes the YAML descriptions.
6.  **GitHub API:** A script commits those changes back to the PR branch using `[skip ci]` to avoid unnecessary testing costs.

---

## Part 3: The Human Review
Once the bot pushes the docs, the human takes over. 
* **The Check:** The engineer looks at the PR. If it’s good, they merge.
* **The Fix:** If it’s wrong, they tag `@heymax-bot` with a comment. A separate workflow hears this, reads the feedback, adds it to context, and updates the documentation.
* **Circuit Breaker:** If the bot fails (tries to push broken YAML, API timeouts, etc.) more than 3 times, a circuit breaker kills the process so it doesn't mess up the repo.

---

## Failure Modes and Observability
Even a great bot can have a bad day. We focus on three main ways this can fail and how we catch it before it hits the repository.

| Risk | How we detect it | The Alert / Safety Switch |
| :--- | :--- | :--- |
| **Hallucination:** The SQL is too complex and the bot guesses wrong or invents. | A second bot compares the new docs to the old ones. If they are >40% different without a major SQL change, it's flagged. | The bot posts: "I'm unsure about this logic; please double-check." |
| **System Overload:** A massive PR with 100+ columns crashes the workflow or hits API limits. | We monitor how long n8n takes to run. | If a run takes >5 minutes, the table owner gets an alert to check the PR manually. |
| **Context Gaps:** A new Mart folder is created with no ai context file. | The Python script logs a "File Not Found" error for the context path. | The bot pushes the documentation to the PR, but with a warning tag. |

**Tracking & Observability:**
* **Performance Logging:** Each of the n8n runs would be logged to monitor Agent performance and conduct case studies.
* **Cost Monitoring:** For each LLM executions, token usage would also be logged, enabling us track metrics like Cost-per-PR.
* **Observability:** A weekly Slack message to the team summarizing highlights/lowlights and performance metrics. 

---

## The One-Week Build Plan
We aren't building a perfect "AI colleague" in seven days; we're building a reliable assistant that handles the grunt work.

* **In Scope (The Must-Haves):** 
    * The automatic trigger for modified models.
    * A central business context file (`global.md`).
    * A script that commits docs directly to the PR branch.
    * Basic data profiling (null counts and types).
* **Out of Scope (The Nice-to-Haves):** 
    * The `@heymax-bot` feedback listener (humans edit manually for now).
    * Advanced downstream impact checks (checking how a change affects 10 tables away).
    * Adding past corrections to model context.

---

### Part 6: Measuring Success (North Star Metrics)
How do we prove this wasn't just a fun experiment? We track three numbers:

1.  **Edit Approval Rate (Quality):** The percentage of AI-generated descriptions that are merged without a human changing a single word. We are aiming for >65% (2/3rd of time, AI is right).
2.  **PR Lead Time (Efficiency):** Does the time it takes to get a PR from "Open" to "Merged" go down because documentation is already done?
3.  **Bot Silence Rate (Adoption):** How often do developers manually disable the bot for a PR? If they use it, they trust it.

---

\>> No AI System is fool-proof and can cause huge issues downstream if left unattended. Have shared some opinions in the [REFLECTIONS](REFLECTIONS.md) doc.
