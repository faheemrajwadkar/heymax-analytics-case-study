# REFLECTIONS

### 1. When would you not use an AI agent for a data task? 
I would avoid using AI agents for tasks requiring **100% mathematical precision** or the handling of **unmasked sensitive data**. 

* **Complex Reporting:** Calculating critical financial KPIs, regulatory compliance metrics, or tax logic. If an agent misinterprets a complex SQL join or a specific business edge case in a 500-line CTE, it could hallucinate and produce an incorrect report. This is extremely risky, especially in the fintech sector. 
* **PII Data Handling:** I would also block agents from tasks requiring raw PII access. While LLMs are great at summarizing, the risk of sensitive data being exposed anywhere during the workflow would be a compliance nightmare compared to the automation benefits.

---

### 2. How do you evaluate the quality of LLM-generated outputs in a data context? What does a good eval look like vs. a bad one?
Quality evaluation must be **outcome-oriented** (did it solve the problem?) rather than **opinion-oriented** (did the user like it?).

* **A Good Eval:** In our AI Agent Design, a good eval would mean tracking the **"Edit Approval Rate"**—the percentage of AI-generated descriptions accepted by a Senior Engineer without modification. Or the **"PR Lead Time"**. If the agent reduces time to merge a PR by 40%, it has provided measurable value.
* **A Bad Eval:** Relying solely on a **"Thumbs Up/Down"** or a **5-star rating system** from developers is a prime example. These are subjective, prone to situational or vibe based biases, and don't actually verify if the documentation is technically accurate or helpful for downstream stakeholders.

---

### 3. If the documentation agent shipped and started producing subtly wrong descriptions at scale, how would you catch it before it caused harm downstream?
The primary line of defense is the **"Human-in-the-Loop Design"**. No documentation should be merged into the master branch without a human peer review. To scale this without creating a bottleneck, I would implement an **Ensemble Peer Review** system:
* **Logic:** Use two different models (e.g. GPT and Gemini models) to generate the same description independently. 
* **Detection:** Run a semantic similarity check between the two outputs. If the outputs differ by more than 10%, the system triggers a high-priority flag, preventing any auto-commits and forcing a manual audit. This catches subtle logic shifts that a single model might miss.

---

### 4. What is one AI-native capability you wish existed in the modern data stack today?
I wish for an **AI-Native CI/CD Pipeline Solution**. 
Currently, setting up the CI/CD architecture between dbt, GitHub, Data Warehouses, Databases, and orchestrators like n8n or Airflow is a manual, error-prone and repetitive process. An AI native stack would be aware of the little quirks of each system, and quickly help set up these pipelines irrespective of what tools we are using. This would help reduce the time setting up infrastructure and allows engineers to rather focus on modeling logic and data pipeline health.
