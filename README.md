# 📈 User Growth & Lifecycle Analytics (dbt + DuckDB)

This project implements a Modern Data Stack to analyze user growth and lifecycle transitions for the HeyMax travel rewards platform. It uses a **Growth Accounting Framework** to categorize users into mutually exclusive cohorts (`New`, `Retained`, `Resurrected`, and `Churned`) across daily, weekly, and monthly grains.

## 🛠️ Tech Stack
* **Transformation:** dbt-core (v1.11.x)
* **Database:** DuckDB (In-process OLAP)
* **Orchestration:** Apache Airflow & Cosmos
* **Visualization:** Streamlit (Hosted on Community Cloud)
* **CI/CD:** GitHub Actions (Automated testing & deployment)
* **Documentation:** Hosted via GitHub Pages [LINK]

---

## 🏗️ Project Architecture
The warehouse follows a three-layer Medallion-style architecture:

<p align="center">
  <img src="./assets/HeyMax Data Flow.png" width="1200">
</p>

1.  **Staging (`stg_`):** Cleaning and renaming raw event streams from CSV.
2.  **Intermediate (`inter_`):** Building the spine of user-date activity and calculating state transitions.
3.  **Marts (`fct_`, `dim_`):** The final, stakeholder-facing layer.
    * `dim_users`: Snapshot of user attributes.
    * `fct_events`: Cleaned event log for deep-dive analysis.
    * `fct_growth_metrics`: The primary source of truth for growth accounting.

---

## 📊 Growth Accounting Logic
The core metric follows the **Growth Accounting Identity**:
> **Total Active Users = New + Retained + Resurrected**

| Cohort | Definition |
| :--- | :--- |
| **New** | First-ever activity occurred in the current period. |
| **Retained** | Active in current period AND active in the previous period. |
| **Resurrected** | Active in current period AND inactive in previous period, but active historically. |
| **Churned** | Active in previous period AND inactive in the current period. |  

<p align="center">
  <img src="./assets/Data Model.png" height="600">
</p>

---

## ⚙️ Orchestration & Monitoring

### Pipeline Flow
The project uses **Apache Airflow** (via Astronomer) to manage the end-to-end flow: 
`S3/Local Ingestion` → `DuckDB Load` → `dbt Build` → `Post-Build Tests`.

### Operational Logging
* **Airflow Logs:** Detailed task-level logs are accessible via the Airflow UI for debugging pipeline failures.
* **dbt Execution Tracking:** A custom macro records the start time, end time, and status of every dbt model run into a dedicated `monitoring.run_logs` table. This allows for long-term trend analysis of model performance and data freshness.

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

## 🖥️ Dashboard & Docs
* **Interactive Dashboard:** [Streamlit App](https://heymax-analytics-case-study-faheem-rajwadkar.streamlit.app/)
    * *Note:* For performance and security, the cloud dashboard runs on aggregated CSV exports rather than a direct connection to the full database.
* **DBT Documentation Website:** [LINK](https://faheemrajwadkar.github.io/heymax-analytics-case-study/)

---

## 💡 Technical Decisions & Trade-offs

### High-Integrity Reconciliation
**Decision:** Implementation of a reconciliation test, specifically designed to run at the end of pipeline.  
**Reasoning:** To prevent "Metric Drift", I built a custom test that validates the Growth Accounting Metrics against raw event logs. This ensures 100% data trust for downstream stakeholders.

### Schema Strategy: Medallion Architecture
**Decision:** Not using `ephemeral` materialization for Intermediate models.  
**Reasoning:** While that is generally preferred to keep the warehouse clean of helper tables, here materialized models made sense due to population of user activity across different grains (days, weeks, months) and it's use downstream to generate the growth metrics model. 

---

## 🛠️ What’s next? (Future Improvements)

If I had more time to scale this, these would be the priority:
1. **Incremental Loading:** Currently, the models rebuild entirely. In a real-world scenario with millions of events, switching to incremental materialization is a must to keep run times low.
2. **User Segmentation:** I’d break down the growth metrics by user attributes (e.g., gender, region) to see which cohorts drive the most retention.
3. **Automated Alerts:** Integrating Slack alerts for failed reconciliation tests would move this from a dashboard to an active monitoring system.
4. **Semantic Layer:** Implementing dbt Semantic Layer (Metrics) to allow stakeholders to query these metrics directly from Excel or other BI tools without writing SQL.

---

## 🔌 How to Run

### 🚀 Option 1 - Quick Start
1. **Clone the Repo:** `git clone https://github.com/faheemrajwadkar/heymax-analytics-case-study.git`
2. **Navigate into the project directory:** `cd heymax-analytics-case-study`
3. **Setup dbt:** `chmod +x setup_dbt.sh && ./setup_dbt.sh`
4. **Setup Airflow:** `chmod +x setup_airflow.sh && ./setup_airflow.sh`

### 🛠️ Option 2 - Manual Set Up
#### Part 1: Manual Execution
1. **Clone the repo:** `git clone <repo-url>`
2. **Setup Environment:**
   ```bash
   python -m venv heymax && source heymax/bin/activate
   pip install -r pip_requirements.txt
   ```
3. **Ingest & Build:** 
   ```bash
   cd heymax-analytics-case-study 
   python scripts/load_data.py

   cd dbt/heymax/
   dbt deps
   dbt build --exclude tag:post_build_tests
   dbt test --select tag:post_build_tests
   ```

#### Part 2: Orchestrated Execution
This project uses **Astronomer (Astro CLI)** to orchestrate the pipeline via Airflow and Cosmos.

1. **Install Astro CLI:** [Install Instructions](https://www.astronomer.io/docs/astro/cli/install-cli)
2. **Set up Astro Dev Environment:**
   ```bash
   astro dev init
   cat <<EOF > requirements.txt
   astronomer-cosmos
   dbt-duckdb
   pandas
   plotly
   EOF
   ```
3. **Start the Stack:** 
   ```bash
   astro dev start
   ```
4. **Access the Pipeline:**
   * Open **Airflow UI** at `localhost:8080` (User/Pass: `admin`/`admin`).
   * Trigger the `heymax_data_pipeline` DAG.
   * This automatically handles **Ingestion -> Transformation -> Post-Build Testing**.

---

## 🔮 Future State: AI Agentic Systems
I have also designed a workflow to automate the documentation and metadata management of this stack using LLMs.
👉 **[AI Agentic Systems Design Document](./agent-design.md)**


