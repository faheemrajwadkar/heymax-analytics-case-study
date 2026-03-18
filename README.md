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

### Option 1: Manual Execution (Development)
1. **Clone the repo:** `git clone <repo-url>`
2. **Setup Environment:**
   ```bash
   python -m venv heymax && source heymax/bin/activate
   pip install -r requirements.txt
   ```
3. **Ingest & Build:** 
   ```bash
   python scripts/load_data.py
   cd dbt/heymax/
   dbt deps
   dbt build --exclude tag:post_build_tests
   dbt test --select tag:post_build_tests
   ```

### Option 2: Orchestrated Execution (Recommended)
This project uses **Astronomer (Astro CLI)** to orchestrate the pipeline via Airflow and Cosmos.

1. **Install Astro CLI:** [Install Instructions](https://www.astronomer.io/docs/astro/cli/install-cli)
2. **Start the Stack:** 
   ```bash
   astro dev start
   ```
3. **Access the Pipeline:**
   * Open **Airflow UI** at `localhost:8080` (User/Pass: `admin`/`admin`).
   * Trigger the `heymax_data_pipeline` DAG.
   * This automatically handles **Ingestion -> Transformation -> Post-Build Testing**.

---

## 💡 Technical Decisions & Trade-offs

### High-Integrity Reconciliation
**Decision:** Implementation of a reconciliation test, specifically designed to run at the end of pipeline.  
**Reasoning:** To prevent "Metric Drift", I built a custom test that validates the Growth Accounting Metrics against raw event logs. This ensures 100% data trust for downstream stakeholders.

### Schema Strategy: Medallion Architecture
**Decision:** Not using `ephemeral` materialization for Intermediate models.  
**Reasoning:** While that is generally preferred to keep the warehouse clean of helper tables, here materialized models made sense due to population of user activity across different grains (days, weeks, months) and it's use downstream to generate the growth metrics model. 

## What more could I have done?

1. **Incremental Modeling:** Given more time, I'd have implemented incremental modeling on all the `fct_*` tables. This is a non-negotiable in large scale databases to keep daily run times in check. 

---

## 🔮 Future State: AI Agentic Systems
For the strategy behind scaling this documentation using LLMs and an "Agentic" workflow, please refer to the:
👉 **[AI Agentic Systems Design Document](./agent-design.md)**
