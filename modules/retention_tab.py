import streamlit as st
import pandas as pd
import plotly.express as px
import duckdb

def render_retention_dashboard():
    st.sidebar.header("Retention Filters")
    cohort_months = st.sidebar.slider("Lookback (Months)", 3, 24, 12, key="cohort_slider")

    try:
        df = pd.read_csv('modules/data_retention.csv')

        if not df.empty:
            # Apply Filter
            df['signup_month'] = pd.to_datetime(df['signup_month'])
            max_month = df['signup_month'].max()
            cutoff_date = max_month - pd.DateOffset(months=cohort_months)
            df = df[df['signup_month'] > cutoff_date]
            
            # Pivot & Calculate %
            pivot = df.pivot(index='signup_month', columns='months_since_signup', values='active_users')
            pivot.index = pd.to_datetime(pivot.index)
            retention = pivot.divide(pivot.iloc[:, 0], axis=0)

            # Heatmap
            fig = px.imshow(
                retention,
                text_auto='.1%',
                color_continuous_scale='Blues',
                labels=dict(x="Months Since Signup", y="Cohort", color="Retention %"),
                y=retention.index.strftime('%Y-%m'),
                title="User Retention Heatmap"
            )
            st.plotly_chart(fig, use_container_width=True)
            
            with st.expander("Show Raw Cohort Counts"):
                st.dataframe(pivot)
        else:
            st.info("No cohort data available for this range.")

    except Exception as e:
        st.error(f"Retention Tab Error: {e}")
