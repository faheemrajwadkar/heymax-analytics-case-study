import streamlit as st
from modules.growth_tab import render_growth_dashboard
from modules.retention_tab import render_retention_dashboard
from modules.engagement_tab import render_engagement_dashboard

st.set_page_config(page_title="Heymax Analytics", layout="wide")

# --- 1. Sidebar Navigation ---
st.sidebar.title("🧭 Navigation")
page = st.sidebar.radio("Go to", ["Growth Accounting", "Cohort Retention Analysis", "User Engagement Lifecycle"])

st.sidebar.markdown("---")

# --- 2. Page Router ---
if page == "Growth Accounting":
    st.title("📈 Growth Accounting")
    render_growth_dashboard()

elif page == "Cohort Retention Analysis":
    st.title("🎯 Cohort Retention Analysis")
    render_retention_dashboard()

elif page == "User Engagement Lifecycle":
    st.title("⚡ User Engagement Lifecycle")
    render_engagement_dashboard()