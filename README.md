# 📈 User Growth & Lifecycle Analytics (dbt + DuckDB)

This project implements a production-grade **Modern Data Stack** to analyze user growth and lifecycle transitions for HeyMax's travel rewards platform. It uses a **Growth Accounting Framework** to categorize users into mutually exclusive cohorts (`New`, `Retained`, `Resurrected`, and `Churned`) across **daily**, **weekly**, and **monthly** grains.


## 🛠️ Tech Stack
* **Transformation:** dbt-core (v1.11.x)
* **Database:** DuckDB (In-process OLAP)
* **Orchestration:** Apache Airflow (DAG-based scheduling)
* **CI/CD:** GitHub Actions (Automated testing & deployment)
* **Documentation:** Hosted via GitHub Pages [LINK]

---

## 🏗️ Project Architecture
The warehouse follows a modular, three-layer Medallion-style architecture:

1.  **Staging (`stg_`):** Atomic, cleaning version of raw events_stream .csv file ingested.
2.  **Intermediate (`inter_`):** Cascading user-date table for growth accounting, periodic growth metrics calculations.
3.  **Marts (`fct_`, `dim_`):** The final, stakeholder-facing layer.
    * `dim_users`: Dimension table capturing the latest user attributes (gender).
    * `fct_events`: Event level table for exploratory analysis and stakeholder deep dives.
    * `fct_growth_metrics`: The core source of truth for growth accounting.

---

## 📊 Growth Accounting Logic
The core metric in this project follows the **Growth Accounting Identity**:
> **Total Active Users = New + Retained + Resurrected**

| Cohort | Definition |
| :--- | :--- |
| **New** | Users whose first-ever activity occurred in the current period. |
| **Retained** | Users active in the current period who were also active in the *previous* period. |
| **Resurrected** | Users active in the current period who were *inactive* in the previous period but active historically. |
| **Churned** | Users active in the previous period who are *inactive* in the current period. |

---

## ✅ Data Quality & Governance
To ensure reliability, the project employs several safety gates:

* **Data Contracts:** Enforced on all `dim` and `fct` models to prevent downstream errors in BI tools.
* **Relationship Tests:** Validates referential integrity between Fact and Dimension tables.
* **Reconciliation Tests:** A custom singular test (tagged `reconciliation`) ensures that the sum of growth cohorts matches the total unique active users in the raw event logs.
* **CI/CD & Data Governance:**
   1. **Slim CI (Pull Requests):** Validates changes in an isolated `CI` environment. By comparing the PR against the production `manifest.json`, the pipeline executes only the modified models and their downstream dependencies (`+state:modified+`).
   2. **Prod Updates (Merge):** Upon merging to `main`, the pipeline synchronizes the Production environment and archives a new manifest to serve as the baseline for future PRs.
   3. **Automated Hygiene:** A post-deployment cleanup process triggers a custom dbt macro to purge temporary `CI` and `dev` schemas, ensuring a zero-footprint warehouse.

---

## 🚀 How to Run
1.  **Clone the repo:** `git clone <repo-url>`
2.  **Spin up a Python environment:** `python -m venv heymax`
3.  **Activate environment:** `source heymax/bin/activate`
4.  **Install dependencies:** `pip install -r requirements.txt`
5.  **Ingest Data:** `python scripts/load_data.py`
6.  **Build & Test:**  
    ```bash
    dbt build --exclude tag:post_build_tests    # Run all models, snapshots, and tests (except those that depend on multiple models).
    dbt test --select tag:post_build_tests      # Run reconciliatory tests that depend on multiple models to verify model accuracy.
    ```
8.  **View Documentation:**
    ```bash
    dbt docs generate
    dbt docs serve --port 8080
    ```

## 💡 Technical Decisions & Trade-offs

### High-Integrity Reconciliation
**Decision:** Implementation of a reconciliation test, specifically designed to run at the end of pipeline.  
**Reasoning:** To prevent "Metric Drift", I built a custom test that validates the Growth Accounting Metrics against raw event logs. This ensures 100% data trust for downstream stakeholders.

### Schema Strategy: Medallion Architecture
**Decision:** Not using `ephemeral` materialization for Intermediate models.  
**Reasoning:** While that is generally preferred to keep the warehouse clean of helper tables, here materialized models made sense due to population of user activity across different grains (days, weeks, months) and it's use downstream to generate the growth metrics model. 

---

## 🔮 Future State: AI Agentic Systems
For the strategy behind scaling this documentation using LLMs and an "Agentic" workflow, please refer to the:
👉 **[AI Agentic Systems Design Document](./agent-design.md)**
